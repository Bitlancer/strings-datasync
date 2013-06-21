from nose.tools import ok_, eq_, raises

from stringsync.ldif_writers import SortedLdifWriter, AlreadyCommittedException


class MockLdifWriter(object):

    def __init__(self):
        self.called_with = []

    def unparse(self, dn, attrs):
        self.called_with.append((dn, attrs))


@raises(AlreadyCommittedException)
def test_barfs_on_unparse_post_commit():
    sldif = SortedLdifWriter(MockLdifWriter())
    sldif.commit()
    sldif.unparse(dn='hi', attrs=dict(hi='there'))


@raises(AlreadyCommittedException)
def test_barfs_on_double_commit():
    sldif = SortedLdifWriter(MockLdifWriter())
    sldif.commit()
    sldif.commit()


def test_writes_sorted_by_dn_to_underlying_ldif_on_commit():
    mock_ldif_writer = MockLdifWriter()
    sldif = SortedLdifWriter(mock_ldif_writer)
    eq_([], mock_ldif_writer.called_with)
    sldif.unparse(dn='hi', attrs=dict(hi='here'))
    eq_([], mock_ldif_writer.called_with)
    sldif.unparse(dn='bye', attrs=dict(hi='there'))
    eq_([], mock_ldif_writer.called_with)
    sldif.commit()
    eq_([('bye', dict(hi='there')),
         ('hi', dict(hi='here'))],
          mock_ldif_writer.called_with)


def test_with_commits_on_normal_execution():
    mock_ldif_writer = MockLdifWriter()
    with SortedLdifWriter(mock_ldif_writer) as sldif_writer:
        eq_([], mock_ldif_writer.called_with)
        sldif_writer.unparse(dn='hi', attrs=dict(hi='here'))
        eq_([], mock_ldif_writer.called_with)
        sldif_writer.unparse(dn='bye', attrs=dict(hi='there'))
        eq_([], mock_ldif_writer.called_with)
    eq_([('bye', dict(hi='there')),
         ('hi', dict(hi='here'))],
          mock_ldif_writer.called_with)


def test_with_no_commits_on_exception():
    mock_ldif_writer = MockLdifWriter()
    caught_ex = False
    try:
        with SortedLdifWriter(mock_ldif_writer) as sldif_writer:
            eq_([], mock_ldif_writer.called_with)
            sldif_writer.unparse(dn='hi', attrs=dict(hi='here'))
            eq_([], mock_ldif_writer.called_with)
            raise Exception("testing")
    except:
        caught_ex = True
        eq_([], mock_ldif_writer.called_with)

    # just to make sure I didn't screw up the test
    ok_(caught_ex)






