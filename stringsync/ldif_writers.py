"""
Various classes that wrap LDIFWriter for extended utility (such as
sorting of output and tree-like management of nested dn's).
"""

class AlreadyCommittedException(Exception):
    """
    Thrown when an attempt is made to write to a SortedLdifWriter that
    has already committed.
    """
    pass


class SortedLdifWriter(object):
    """
    A wrapper around a normal ldif writer that buffers calls to
    'unparse' and writes them in sorted order when finished.

    Can (and should) be used in a 'with' statement, e.g.:

    >>> ldif_writer = LDIFWriter(open('file.ldif', 'wb'))
    >>> with SortedLdifWriter(ldif_writer) as sldif_writer:
    ...     sldif_writer.unparse(dn='dc=hi', dict(attr1='something'))
    ...

    If not used in a 'with' statement, must have 'commit' called on it
    to actually commit the results to the underlying ldif writer.

    Note that once 'commit' has been called, the writer is invalid for
    further use, and will raise an exception.
    """

    def __init__(self, ldif_writer):
        """
        - `ldif_writer`: the underlying ldif_writer to write to on
          commit.
        """
        self.ldif_writer = ldif_writer
        self.buffer = []
        self.committed = False

    def __enter__(self):
        return self

    def __exit__(self, ttype, value, traceback):
        # don't commit if there has been an exception.
        if value is None:
            self.commit()
        return False

    def unparse(self, dn, attrs):
        """
        Buffer a call to unparse, with the same params, to be written
        to the underlying ldif writer after a commit.

        Raises AlreadyCommittedException if commit has already been
        called.
        """
        if self.committed:
            raise AlreadyCommittedException()
        self.buffer.append((dn, attrs))

    def commit(self):
        """
        Sort the buffered unparse calls by dn and commit them to the
        underlying ldif_writer.

        Raises AlreadyCommittedException if commit has already been
        called.
        """
        if self.committed:
            raise AlreadyCommittedException()
        self.buffer.sort()
        for (dn, attrs) in self.buffer:
            self.ldif_writer.unparse(dn, attrs)
        self.committed = True


def build_dn(dn, ldif_writer):
    """
    Return a BuildDnLdifWriter created from dn.

    Nicer syntax only.
    """
    return BuildDnLdifWriter(dn, ldif_writer)


class BuildDnLdifWriter(object):
    """
    Helps maintain a nested DN hierarchy, appending to dns passed in
    to unparse calls and relaying to an underlying ldif writer.

    e.g.

    >>> sio = StringIO()
    >>> ldif_writer = LDIFWriter(sio)
    >>> with BuildDnLdifWriter('dc=test', ldif_writer) as test_ldif:
    ...     test_ldif.unparse(dn='cn=hi', dict(foo='bar'))
    ...     with BuildDnLdifWriter('dc=more', test_ldif) as more_ldif:
    ...         more_ldif.unparse(dn='cn=morehi', dict(baz='bam'))
    ...
    >>> sio.getvalue()
    dn: cn=hi,dc=test
    foo: bar

    dn: cn=morehi,dc=more,dc=test
    baz: bam

    Or, for a nicer syntax, the following would be equivalent:

    >>> sio = StringIO()
    >>> ldif_writer = LDIFWriter(sio)
    >>> with build_dn('dc=test', ldif_writer) as test_ldif:
    ...     test_ldif.unparse(dn='cn=hi', dict(foo='bar'))
    ...     with test_ldif.extend_dn('dc=more') as more_ldif:
    ...         more_ldif.unparse(dn='cn=morehi', dict(baz='bam'))
    """

    def __init__(self, dn, ldif_writer):
        self.dn = dn
        self.ldif_writer = ldif_writer

    def __enter__(self):
        return self

    def __exit__(self, ttype, value, traceback):
        return False

    def unparse(self, dn, attrs):
        """
        Delegate to the wrapped ldif_writer's unparse, appending to
        the dn first.
        """
        self.ldif_writer.unparse(','.join([dn, self.dn]), attrs)

    def extend(self, dn):
        """
        Return a new BuildDnLdifWriter that builds on self, further appending to
        self's dn.
        """
        return BuildDnLdifWriter(dn, self)

    def full_dn(self):
        """
        Return the dn of this and any wrapped BuildDnLdifWriters.
        """
        wrapped_dn = full_dn(self.ldif_writer)
        if wrapped_dn:
            return ','.join([self.dn, wrapped_dn])
        else:
            return self.dn


def full_dn(ldif_writer):
    """
    Convenience function, return None if ldif_writer doesn't support
    'full_dn', else ldif_writer.full_dn()
    """
    if hasattr(ldif_writer, 'full_dn'):
        return ldif_writer.full_dn()
    else:
        return None
