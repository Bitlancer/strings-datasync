from nose.tools import ok_, eq_, raises

from stringsync.ldif_writers import SortedLdifWriter, AlreadyCommittedException, \
    BuildDnLdifWriter, full_dn


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


def test_writes_sorted_by_len_then_dn_to_underlying_ldif_on_commit():
    mock_ldif_writer = MockLdifWriter()
    sldif = SortedLdifWriter(mock_ldif_writer)
    eq_([], mock_ldif_writer.called_with)
    sldif.unparse(dn='hi', attrs=dict(hi='here'))
    eq_([], mock_ldif_writer.called_with)
    sldif.unparse(dn='cat', attrs=dict(hi='dog'))
    eq_([], mock_ldif_writer.called_with)
    sldif.unparse(dn='bye', attrs=dict(hi='there'))
    eq_([], mock_ldif_writer.called_with)
    sldif.commit()
    eq_([('hi', dict(hi='here')),
         ('bye', dict(hi='there')),
         ('cat', dict(hi='dog'))],
          mock_ldif_writer.called_with)


def test_with_commits_on_normal_execution():
    mock_ldif_writer = MockLdifWriter()
    with SortedLdifWriter(mock_ldif_writer) as sldif_writer:
        eq_([], mock_ldif_writer.called_with)
        sldif_writer.unparse(dn='hi', attrs=dict(hi='here'))
        eq_([], mock_ldif_writer.called_with)
        sldif_writer.unparse(dn='bye', attrs=dict(hi='there'))
        eq_([], mock_ldif_writer.called_with)
    eq_([('hi', dict(hi='here')),
         ('bye', dict(hi='there'))],
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


def test_build_dn_appends_dn():
    mock_ldif_writer = MockLdifWriter()
    eq_([], mock_ldif_writer.called_with)
    dn_ldif = BuildDnLdifWriter('dc=yup', mock_ldif_writer)
    eq_([], mock_ldif_writer.called_with)
    dn_ldif.unparse('cn=test', dict(foo='bar'))
    eq_([('cn=test,dc=yup', dict(foo='bar'))],
         mock_ldif_writer.called_with)


def test_build_dn_can_nest():
    mock_ldif_writer = MockLdifWriter()
    eq_([], mock_ldif_writer.called_with)
    dn_ldif = BuildDnLdifWriter('dc=yup', mock_ldif_writer)
    eq_([], mock_ldif_writer.called_with)
    dn2_ldif = BuildDnLdifWriter('dc=more', dn_ldif)
    eq_([], mock_ldif_writer.called_with)
    dn2_ldif.unparse('cn=test', dict(foo='bar'))
    eq_([('cn=test,dc=more,dc=yup', dict(foo='bar'))],
         mock_ldif_writer.called_with)


def test_extend_nests():
    mock_ldif_writer = MockLdifWriter()
    eq_([], mock_ldif_writer.called_with)
    dn_ldif = BuildDnLdifWriter('dc=yup', mock_ldif_writer)
    eq_([], mock_ldif_writer.called_with)
    dn2_ldif = dn_ldif.extend('dc=more')
    eq_([], mock_ldif_writer.called_with)
    dn2_ldif.unparse('cn=test', dict(foo='bar'))
    eq_([('cn=test,dc=more,dc=yup', dict(foo='bar'))],
         mock_ldif_writer.called_with)


def test_dn_nests_using_with():
    mock_ldif_writer = MockLdifWriter()
    with BuildDnLdifWriter('dc=yup', mock_ldif_writer) as ldif_dn:
        ldif_dn.unparse('cn=test', dict(foo='bar'))
        with ldif_dn.extend('dc=more') as more_ldif:
            more_ldif.unparse('cn=test2', dict(boo='baz'))
    eq_([('cn=test,dc=yup', dict(foo='bar')),
         ('cn=test2,dc=more,dc=yup', dict(boo='baz'))],
        mock_ldif_writer.called_with)


def test_full_dn():
    mock_ldif_writer = MockLdifWriter()
    eq_(None, full_dn(mock_ldif_writer))
    bl1 = BuildDnLdifWriter('dc=yup', mock_ldif_writer)
    eq_('dc=yup', bl1.full_dn())
    eq_('dc=yup', full_dn(bl1))
    bl2 = BuildDnLdifWriter('ou=nope', bl1)
    eq_('ou=nope,dc=yup', bl2.full_dn())
    eq_('ou=nope,dc=yup', full_dn(bl2))

