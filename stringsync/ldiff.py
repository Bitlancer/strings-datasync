from collections import namedtuple
import logging
from multiprocessing import Queue, Process

from ldif import LDIFParser, LDIFWriter
from ldap import modlist


class UnsortedException(Exception):
    pass


class SortEnforcer(object):

    def __init__(self):
        self.last_seen = None

    def check_and_update(self, new_value):
        if (self.last_seen is not None and
            self.last_seen > new_value):
            raise UnsortedException('Saw %s after %s' %
                                    (new_value, self.last_seen))
        self.last_seen = new_value


INCOMING_ENTRY_BUFFER_SIZE = 100
DONE = "DONE"


# intentionally high--this isn't to deal with slow disks, but stuck
# processes and programmer error
QUEUE_TIMEOUT_SECS = 60


def _safe_get(ldif_entries):
    return ldif_entries.get(timeout=QUEUE_TIMEOUT_SECS)


DnEntry = namedtuple('DnEntry', 'dn entry')


def _check_error(dn_entry):
    if isinstance(dn_entry, Exception):
        raise dn_entry


def _is_done(dn_entry):
    return dn_entry == DONE


def _is_valid_dn_entry(dn_entry):
    _check_error(dn_entry)
    return not _is_done(dn_entry)


class LDiffer(LDIFParser):

    def __init__(self, new_ldif_fil, old_ldif_entries, diff_writer):
        LDIFParser.__init__(self, new_ldif_fil)

        self.old_ldif_entries = old_ldif_entries
        self.diff_writer = diff_writer

        self.sort_enforcer = SortEnforcer()

        self.cur_old_dn_entry = None
        self._pull_old_dn_entry()

    def handle(self, dn, entry):
        self.sort_enforcer.check_and_update(dn)

        while self._is_old_dn_entry_prev(dn):
            self.diff_writer.handle_delete(self.cur_old_dn_entry)
            self._pull_old_dn_entry()

        if self._is_old_dn_entry_same(dn):
            self.diff_writer.handle_change(self.cur_old_dn_entry,
                                           DnEntry(dn, entry))
            self._pull_old_dn_entry()
        else:
            self.diff_writer.handle_add(DnEntry(dn, entry))
            # don't pull the next old dn_entry, as the the old stream is
            # already after the new stream lexically, and the
            # cur_old_dn_entry hasn't been handled.

    def _is_old_dn_entry_same(self, dn):
        return (self._is_valid_cur_old_dn_entry() and
                self.cur_old_dn_entry.dn == dn)

    def _is_old_dn_entry_prev(self, dn):
        return self._is_valid_cur_old_dn_entry() and self.cur_old_dn_entry.dn < dn

    def _is_valid_cur_old_dn_entry(self):
        return _is_valid_dn_entry(self.cur_old_dn_entry)

    def _pull_old_dn_entry(self):
        if self._is_valid_cur_old_dn_entry():
            self.cur_old_dn_entry = _safe_get(self.old_ldif_entries)


class LDIFQueuer(LDIFParser):

    def __init__(self, ldif_fil, ldif_entries):
        LDIFParser.__init__(self, ldif_fil)
        self.ldif_entries = ldif_entries
        self.sort_enforcer = SortEnforcer()

    def handle(self, dn, entry):
        try:
            self.sort_enforcer.check_and_update(dn)
            self.ldif_entries.put(DnEntry(dn, entry))
        except UnsortedException, e:
            self.ldif_entries.put(e)


def _queue_ldif_entries(ldif_fil, ldif_entries):
    ldif_queuer = LDIFQueuer(ldif_fil, ldif_entries)
    ldif_queuer.parse()
    ldif_entries.put(DONE)


class DiffWriter(object):

    def __init__(self, diff_fil):
        self.writer = LDIFWriter(diff_fil)
        # unfortunately we have to maintain this separately from the
        # LDIFWriter since the writer appears to offer no way to
        # delete a full dn.
        self.diff_fil = diff_fil

    def handle_add(self, dn_entry):
        addition = modlist.addModlist(dn_entry.entry)
        self.writer.unparse(dn_entry.dn, addition)

    def handle_change(self, old_dn_entry, new_dn_entry):
        if old_dn_entry.dn != new_dn_entry.dn:
            raise Exception("In a change operation, old and new dns must be the same.")
        changes = modlist.modifyModlist(old_dn_entry.entry, new_dn_entry.entry)
        self.writer.unparse(old_dn_entry.dn, changes)

    def handle_delete(self, dn_entry):
        self.diff_fil.write("dn: %s\n" % dn_entry.dn)
        self.diff_fil.write('changetype: delete\n')
        self.diff_fil.write('\n')



def ldiff(old_ldif_fil, new_ldif_fil, diff_fil):
    """
    Expects both ldif's to contain entries sorted by dn.

    Only use this function, nothing else from this module directly.

    TODO: docs
    """
    old_ldif_entries = Queue(INCOMING_ENTRY_BUFFER_SIZE)
    old_ldif_proc = Process(target=_queue_ldif_entries,
                            args=(old_ldif_fil, old_ldif_entries))
    old_ldif_proc.start()

    diff_writer = DiffWriter(diff_fil)

    ldiffer = LDiffer(new_ldif_fil, old_ldif_entries, diff_writer)
    ldiffer.parse()
    # at this point, all the new entries have been exhausted, but
    # there may still be old entries that need to be deleted.
    old_dn_entry = ldiffer.cur_old_dn_entry

    while _is_valid_dn_entry(old_dn_entry):
        diff_writer.handle_delete(old_dn_entry)
        old_dn_entry = _safe_get(old_ldif_entries)
