import os
from StringIO import StringIO

from nose.tools import eq_, raises

from stringsync import ldiff


def _t_fname(fname):
    dirname = os.path.dirname(os.path.abspath(__file__))
    return os.path.join(dirname, 'tfiles', fname)


TEST_DATA = [
    # standalone operations

    # simple change
    ('entry1.txt', 'entry2.txt', 'results1.txt'),
    # simple addition
    ('entry1.txt', 'entry3.txt', 'results2.txt'),
    # simple deletion
    ('entry3.txt', 'entry1.txt', 'results3.txt'),

    # combination of operations

    # change and addition
    ('entry1.txt', 'entry4.txt', 'results4.txt'),
    # change and deletion
    ('entry4.txt', 'entry1.txt', 'results5.txt'),
    # addition and deletion
    ('entry1.txt', 'entry5.txt', 'results6.txt'),
    # addition and change
    ('entry1.txt', 'entry7.txt', 'results8.txt'),
    # deletion and addition
    ('entry5.txt', 'entry1.txt', 'results9.txt'),
    # deletion and change
    ('entry4.txt', 'entry8.txt', 'results10.txt'),

    # test with some base64
    ('entry1.txt', 'entry6.txt', 'results7.txt'),
]


def _diff(old_ldif_fname, new_ldif_fname, diff_fil):
    with open(_t_fname(old_ldif_fname), 'rb') as old_ldif_fil:
        with open(_t_fname(new_ldif_fname), 'rb') as new_ldif_fil:
            ldiff.ldiff(old_ldif_fil, new_ldif_fil, diff_fil)


def _check_expected(old_ldif_fname, new_ldif_fname, ldif_diff_fname):
    diff_fil = StringIO()
    _diff(old_ldif_fname, new_ldif_fname, diff_fil)
    actual = diff_fil.getvalue()
    with open(_t_fname(ldif_diff_fname), 'rb') as results_fil:
        expected = results_fil.read()
    eq_(expected, actual)


def test_ldiff_cases():
    for (old_ldif_fname, new_ldif_fname, ldif_diff_fname) in TEST_DATA:
        yield _check_expected, old_ldif_fname, new_ldif_fname, ldif_diff_fname


@raises(Exception)
def test_handle_change_protects_dns():
    stringio = StringIO()
    diff_writer = ldiff.DiffWriter(stringio)
    diff_writer.handle_change(ldiff.DnEntry('hi', {}),
                              ldiff.DnEntry('bye', {}))


@raises(ldiff.UnsortedException)
def test_unsorted_old_ldif_errs():
    diff_fil = StringIO()
    _diff('unsorted.txt', 'entry1.txt', diff_fil)


@raises(ldiff.UnsortedException)
def test_unsorted_new_ldif_errs():
    diff_fil = StringIO()
    _diff('entry1.txt', 'unsorted.txt', diff_fil)
