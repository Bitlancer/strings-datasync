from StringIO import StringIO
from textwrap import dedent
import unittest

from nose.tools import ok_, eq_

from stringsync import db, fixtures, mysql2ldif


class TestMysql2Ldif(unittest.TestCase):

    def setUp(self):
        db.start_test()
        self.conn = db.open_conn()
        fixtures.clean_all(self.conn)

    def tearDown(self):
        fixtures.clean_all(self.conn)
        db.end_test()

    def test_org_only_dump(self):
        org_1_id = fixtures.f_organization_1(self.conn)
        outfile = StringIO()
        mysql2ldif.dump_ldif(self.conn, outfile, org_1_id)
        expected = dedent("""\
                          dn: Organization 1
                          dc: Org 1
                          o: Organization 1
                          objectclass: organization
                          objectclass: dcObject\n\n""")
        eq_(expected, outfile.getvalue())


