"""
Provides an ldiff function to diff two complete ldif files and
generate the incremental ldif to transform one into the other.

Throughout this module we refer to the "old" ldif file as the one that
contains the state we want to transform from, and the "new" ldif file
as the state we want to transform to.

Example:

If the "old" ldif file contains:

dn: cn=Barbara Jensen, dc=example, dc=com
cn: Barbara Jensen
title: just a woman trying to make it in the world

And the "new" ldif file contains:

dn: cn=Barbara Jensen, dc=example, dc=com
cn: Barbara Jensen
title: fabulousity

We want to generate an incremental ldif file that contains:

dn: cn=Barbara Jensen, dc=example, dc=com
changetype: modify
delete: title
-
add: title
title: fabulosity
-

(Note that the delete and re-add pattern for modification is a tic of
the Python ldif libraries, which this uses under the hood.)

This could be accomplished as follows:

>>> from ldiff import ldiff_to_ldif
>>> old_fil = open('old.ldif', 'rb')
>>> new_fil = open('new.ldif', 'rb')
>>> incremental_fil = open('incremental.ldif', 'wb')
>>> ldiff(old_fil, new_fil, incremental_fil)

After this, incremental.ldif would contain the incremental ldif shown
above.
"""

from collections import namedtuple
from multiprocessing import Queue, Process

from ldif import LDIFParser, LDIFWriter
from ldap import modlist


def dn_prev(dn_one, dn_two):
    """
    Compare dn_one and dn_two by (len(dn), lexical sorting of dn).

    Return True if dn_one is previous to dn_two by this definition.
    """
    len_dn_one = len(dn_one)
    len_dn_two = len(dn_two)

    if len_dn_one == len_dn_two:
        return dn_one < dn_two
    else:
        return len_dn_one < len_dn_two


class NonMatchingDnException(Exception):
    """
    Thrown if a client tries to calc diffs between two entries with
    differing dn's.
    """
    pass


class UnsortedException(Exception):
    """
    Thrown when a process detects that an input ldif is not sorted
    lexically by dn.
    """
    pass


class SortEnforcer(object):
    """
    Utility class to help ldif parsers enforce inputs sorted by ldif.
    """

    def __init__(self):
        self.last_seen = None

    def check_and_update(self, new_value):
        """
        If new_value is lexically previous to the last seen value,
        raise an UnsortedException.

        Otherwise, store new_value as the last seen value.
        """
        if self.last_seen is not None and dn_prev(new_value, self.last_seen):
            raise UnsortedException('Saw %s after %s' %
                                    (new_value, self.last_seen))
        self.last_seen = new_value


# Limit on the size of multiprocessing queues for ldif entries, to
# help manage memory.
LDIF_ENTRIES_QUEUE_SIZE = 100

# Constant token used to mark that an LDIFQueuer has dumped all
# entries from a given ldif into the queue, and no more should be
# expected.
DONE = "DONE"


# The timeout when polling an ldif entry queue for the next entry.
# This intentionally high--it's not here to deal with slow disks, but
# stuck processes and programmer error, so at least we don't hang
# forever.
QUEUE_TIMEOUT_SECS = 30


def _safe_get(ldif_entries):
    """
    Get the next entry from ldif_entries, with a timeout, so we don't
    block forever.

    Will throw a queue.Empty exception upon timeout.
    """
    return ldif_entries.get(timeout=QUEUE_TIMEOUT_SECS)


# Convenience named tuple for entries parsed from an ldif.  The dn
# field contains the distinguished name of the entry (without the
# leading dn:) and entry is a dict of attributes and values falling
# under that dn.
DnEntry = namedtuple('DnEntry', 'dn entry')


def _check_error(dn_entry):
    """
    If dn_entry, which has been pulled from an ldif entry queue, is an
    exception, raise it.

    Otherwise, do nothing.
    """
    if isinstance(dn_entry, Exception):
        raise dn_entry


def _is_done(dn_entry):
    """
    Return True if dn_entry, which has been pulled from an ldif entry
    queue, is the special "done" token, else False.
    """
    # note we have to use == instead of "is", because multiprocessing
    # creates a separate instance of the DONE token.
    return dn_entry == DONE


def _is_valid_dn_entry(dn_entry):
    """
    Return True if dn_entry is a valid dn entry, meaning not an error
    or the special DONE token.

    If dn_entry is an exception, re-raise the exception.
    """
    _check_error(dn_entry)
    return not _is_done(dn_entry)


class LDiffer(LDIFParser):
    """
    LDiffer parses the new ldif file, meanwhile pulling in and lining
    up entries parsed from the old ldif file, to figure out whether
    entries in the new ldif file represent additions or changes, and
    whether there are orphaned entries in the old ldif files that
    represent deletions.

    Note: this class is not intended for use outside this module, as
    it requires a bunch of persnickity setup to get the queues right
    and cleanup afterwards if there are dangling entries in the old
    ldif.  Use the ldiff function directly, which does all these
    things.
    """

    def __init__(self, new_ldif_fil, old_ldif_entries, handler):
        """
        `new_ldif_fil`: the file-like object containg the new ldif
        entries.

        `old_ldif_entries`: a queue from which the old_ldif_entries
        can be pulled in lexical order by dn.

        `handler: an object that can handle the additions, changes,
        and deletions that the LDiffer detects.
        """
        LDIFParser.__init__(self, new_ldif_fil)

        self.old_ldif_entries = old_ldif_entries
        self.handler = handler

        self.sort_enforcer = SortEnforcer()

        self.cur_old_dn_entry = None
        # prime the pump with the first entry from the old ldif.
        self._pull_old_dn_entry()

    def handle(self, dn, entry):
        """
        Handle a single dn and corresponding entry from the new ldif.

        This involves, potentially, marking one or more entries from
        the old ldif as deleted, and marking this entry as a change
        against an existing entry in the old ldif or an added entry.
        """
        self.sort_enforcer.check_and_update(dn)

        # If the current old ldif entry is lexically previous to the
        # current new ldif entry, then there's no corresponding entry
        # in the new ldif, and we should mark the old ldif entry as
        # deleted and pull a new entry from the old ldif queue.
        #
        # We may have to do this multiple times until we catch the old
        # ldif entries up with the new ones.
        while self._is_old_dn_entry_prev(dn):
            self.handler.handle_delete(self.cur_old_dn_entry)
            self._pull_old_dn_entry()

        if self._is_old_dn_entry_same(dn):
            # we rely on the handle_change method in handler to be
            # smart enough to recognize a no-op if the old and new
            # entries are the same.
            self.handler.handle_change(self.cur_old_dn_entry,
                                       DnEntry(dn, entry))
            self._pull_old_dn_entry()
        else: # the old dn is lexically later than the new dn
            self.handler.handle_add(DnEntry(dn, entry))
            # don't pull the next old dn_entry on an add, as the the
            # old stream is already after the new stream lexically,
            # and the cur_old_dn_entry hasn't been handled.

    def _is_old_dn_entry_same(self, dn):
        """
        Return True is the cur_old_dn_entry has the same dn as the
        argument dn, else False.

        Raises an exception if the current entry from the old ldif is
        an error.
        """
        return (self._is_valid_cur_old_dn_entry() and
                self.cur_old_dn_entry.dn == dn)

    def _is_old_dn_entry_prev(self, dn):
        """
        Return True if the cur_old_dn_entry has a dn lexically
        previous to the argument dn, else False.

        Raises an exception if the current entry from the old ldif is
        an error.
        """
        return (self._is_valid_cur_old_dn_entry() and
                dn_prev(self.cur_old_dn_entry.dn, dn))

    def _is_valid_cur_old_dn_entry(self):
        """
        Raise an exception if self.cur_old_dn_entry is an error, and
        return False if it's the special DONE token.

        Otherwise, return True.
        """
        return _is_valid_dn_entry(self.cur_old_dn_entry)

    def _pull_old_dn_entry(self):
        """
        Pull the next dn_entry from the old_ldif_entries queue.

        Acts as a no-op if we've already received the special DONE
        token from the queue.

        Raises an exception if the current entry from the old ldif is
        an error.
        """
        if self._is_valid_cur_old_dn_entry():
            self.cur_old_dn_entry = _safe_get(self.old_ldif_entries)


class LDIFQueuer(LDIFParser):
    """
    A simple LDIFParser that reads entries from an ldif file,
    enforcing that they are lexically sorted by dn, and dumps them
    into a supplied queue.
    """

    def __init__(self, ldif_fil, ldif_entries):
        """
        `ldif_fil`: The file-like object from which to read ldif
        entries.

        `ldif_entries`: the queue into which to dump the entries as
        DnEntry namedtuples.
        """
        LDIFParser.__init__(self, ldif_fil)
        self.ldif_entries = ldif_entries
        self.sort_enforcer = SortEnforcer()

    def handle(self, dn, entry):
        """
        Dump the dn and entry as a DnEntry namedtuple into the queue.

        If this dn represents a broken lexical ordering, dumps an
        UnsortedException into the queue, but continues to process.
        """
        try:
            self.sort_enforcer.check_and_update(dn)
            self.ldif_entries.put(DnEntry(dn, entry))
        except UnsortedException, e:
            self.ldif_entries.put(e)


def _queue_ldif_entries(ldif_fil, ldif_entries):
    """
    Intended for use only by the ldiff function, to allow the entries
    from the old ldif file to be read outside the main process and
    dumped into a queue, where the main LDiffer object can access them
    concurrent with parsing the new ldif file.

    After the entire ldif file has been processed, this dumps a
    special DONE token into the queue and returns.

    On any raised exception, this function dumps the exception into
    the queue and returns.
    """
    try:
        ldif_queuer = LDIFQueuer(ldif_fil, ldif_entries)
        ldif_queuer.parse()
        ldif_entries.put(DONE)
    except Exception, e:
        ldif_entries.put(e)


class DiffWriter(object):
    """
    A moderately intelligent bridge that interprets adds, changes, and
    deletes between two ldif files and writes them as incremental
    ldifs to an output file.

    Not intended for use outside this module.
    """

    def __init__(self, diff_fil):
        """
        `diff_fil`: the file-like object into which the incremental
        ldifs will be written.
        """
        self.writer = LDIFWriter(diff_fil)
        # Unfortunately we have to maintain this separately from the
        # LDIFWriter since the writer appears to offer no way to
        # delete a full dn.  See handle_delete.
        self.diff_fil = diff_fil

    def handle_add(self, dn_entry):
        """
        Write an incremental ldif to add the supplied dn_entry.
        """
        addition = modlist.addModlist(dn_entry.entry)
        self.writer.unparse(dn_entry.dn, addition)

    def handle_change(self, old_dn_entry, new_dn_entry):
        """
        Write an incremental ldif to modify the old entry into the new
        entry.

        If old_dn_entry and new_dn_entry are identical, acts as a
        no-op.

        Raises an exception if the old and new entries don't have the
        same dn.
        """
        if old_dn_entry.dn != new_dn_entry.dn:
            raise NonMatchingDnException("Old and new dn'ss must be the same.")
        changes = modlist.modifyModlist(old_dn_entry.entry, new_dn_entry.entry)
        if changes:
            self.writer.unparse(old_dn_entry.dn, changes)

    def handle_delete(self, dn_entry):
        """
        Write the incremental ldif to delete the dn of the supplied
        entry.
        """
        self.diff_fil.write("dn: %s\n" % dn_entry.dn)
        self.diff_fil.write('changetype: delete\n')
        self.diff_fil.write('\n')


class LdapApplier(object):
    """
    A moderately intelligent bridge that interprets adds, changes, and
    deletes between two ldif files and applies them as ldap changes
    against a live server.

    Not intended for use outside this module.
    """

    def __init__(self, ldap_server):
        """
        `ldap_server`: the server against which to run the changes
        """
        self.ldap_server = ldap_server

    def handle_add(self, dn_entry):
        """
        Write an incremental ldif to add the supplied dn_entry.
        """
        addition = modlist.addModlist(dn_entry.entry)
        self.ldap_server.add_s(dn_entry.dn, addition)

    def handle_change(self, old_dn_entry, new_dn_entry):
        """
        Write an incremental ldif to modify the old entry into the new
        entry.

        If old_dn_entry and new_dn_entry are identical, acts as a
        no-op.

        Raises an exception if the old and new entries don't have the
        same dn.
        """
        if old_dn_entry.dn != new_dn_entry.dn:
            raise NonMatchingDnException("Old and new dn'ss must be the same.")

        changes = modlist.modifyModlist(old_dn_entry.entry, new_dn_entry.entry)
        if changes:
            self.ldap_server.modify_s(old_dn_entry.dn, changes)

    def handle_delete(self, dn_entry):
        """
        Write the incremental ldif to delete the dn of the supplied
        entry.
        """
        self.ldap_server.delete_s(dn_entry.dn)


def ldiff_to_ldif(old_ldif_fil, new_ldif_fil, diff_fil):
    """
    Calculate the difference between the ldif contained in the
    file-like object old_ldif_fil and the ldif contained in the
    file-like object new_ldif_fil, and write the incremental ldif
    needed to transform old into new to the file-like object diff_fil.

    Expects both old and new ldif entries to be lexically sorted by
    (len(dn), dn), and throws an UnsortedException if that expectation
    is violated.
    """
    diff_writer = DiffWriter(diff_fil)
    _do_ldiff(old_ldif_fil, new_ldif_fil, diff_writer)


def ldiff_and_apply(old_ldif_fil, new_ldif_fil, ldap_server):
    """
    Calculate the difference between the ldif contained in the
    file-like object old_ldif_fil and the ldif contained in the
    file-like object new_ldif_fil, and apply the changes as we go to
    ldap_server, live.

    Expects both old and new ldif entries to be lexically sorted by
    (len(dn), dn), and throws an UnsortedException if that expectation
    is violated.

    Note that is in no way transactional: if the network breaks or
    something, some of the changes may have been written, others not.
    """
    ldap_applier = LdapApplier(ldap_server)
    _do_ldiff(old_ldif_fil, new_ldif_fil, ldap_applier)


def _do_ldiff(old_ldif_fil, new_ldif_fil, handler):
    # We want to be able to parse potentially sizable ldif files and
    # process them in a streaming fashion, especially since the LDIF
    # utilities in python that read in whole files use a tremendous
    # amount of memory.  We accomplish this with mulitprocessing, by
    # running the parsing of the old ldif file in a separate process,
    # and dumping its results in a size-bounded queue for access by
    # this process, where the new ldif is parsed and compared.
    old_ldif_entries = Queue(LDIF_ENTRIES_QUEUE_SIZE)
    old_ldif_proc = Process(target=_queue_ldif_entries,
                            args=(old_ldif_fil, old_ldif_entries))
    old_ldif_proc.start()
    # note we don't join here--we expect either an error or a special
    # DONE token to enter the queue, and the _queue_ldif_entries
    # function to return (thereby ending the process) at that point.


    ldiffer = LDiffer(new_ldif_fil, old_ldif_entries, handler)
    ldiffer.parse()
    # at this point, all the new entries have been written as
    # additions or changes, but there may still be old entries in the
    # queue without corresponding new entries, so we need to run
    # through and mark those all as deleted.
    old_dn_entry = ldiffer.cur_old_dn_entry

    while _is_valid_dn_entry(old_dn_entry):
        handler.handle_delete(old_dn_entry)
        old_dn_entry = _safe_get(old_ldif_entries)
