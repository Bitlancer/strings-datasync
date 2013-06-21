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
