from StringIO import StringIO
from textwrap import dedent
import unittest

from nose.tools import ok_, eq_

from stringsync import db, fixtures, mysql2ldif, organizations


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
        curs = self.conn.cursor()
        org_1 = organizations.find_organization(curs, org_1_id)
        outfile = StringIO()
        mysql2ldif.dump_ldif(self.conn, outfile, org_1_id)

        expected = dedent("""\
                          dn: %(org_dn)s
                          dc: %(org_dc)s
                          o: %(org_o)s
                          objectclass: organization
                          objectclass: dcObject

                          dn: ou=people,%(org_dn)s
                          objectclass: organizationalUnit
                          ou: people

                          dn: ou=groups,ou=people,%(org_dn)s
                          objectclass: organizationalUnit
                          ou: groups

                          dn: ou=users,ou=people,%(org_dn)s
                          objectclass: organizationalUnit
                          ou: users

                          dn: ou=unix,%(org_dn)s
                          objectclass: organizationalUnit
                          ou: unix

                          dn: ou=sudoers,ou=unix,%(org_dn)s
                          objectclass: organizationalUnit
                          ou: sudoers

                          dn: cn=defaults,ou=sudoers,ou=unix,%(org_dn)s
                          cn: defaults
                          description: Default sudo options
                          objectclass: sudoRole\n\n""")

        expected = expected % dict(org_dc=organizations.dc(org_1),
                                   org_dn=organizations.dn(org_1),
                                   org_o=organizations.o(org_1))
        eq_(expected, outfile.getvalue())

    def test_sudo_dump(self):
        """
        Test that dumping with a single sudo user works correctly.
        """
        fixtures.f_sudo_user_1(self.conn)
        org_1_id = fixtures.f_organization_1(self.conn)
        curs = self.conn.cursor()
        org_1 = organizations.find_organization(curs, org_1_id)
        outfile = StringIO()
        mysql2ldif.dump_ldif(self.conn, outfile, org_1_id)

        expected = dedent("""\
                          dn: %(org_dn)s
                          dc: %(org_dc)s
                          o: %(org_o)s
                          objectclass: organization
                          objectclass: dcObject

                          dn: ou=people,%(org_dn)s
                          objectclass: organizationalUnit
                          ou: people

                          dn: ou=groups,ou=people,%(org_dn)s
                          objectclass: organizationalUnit
                          ou: groups

                          dn: ou=users,ou=people,%(org_dn)s
                          objectclass: organizationalUnit
                          ou: users

                          dn: ou=unix,%(org_dn)s
                          objectclass: organizationalUnit
                          ou: unix

                          dn: ou=sudoers,ou=unix,%(org_dn)s
                          objectclass: organizationalUnit
                          ou: sudoers

                          dn: cn=defaults,ou=sudoers,ou=unix,%(org_dn)s
                          cn: defaults
                          description: Default sudo options
                          objectclass: sudoRole

                          dn: cn=root,ou=sudoers,ou=unix,%(org_dn)s
                          description: root sudo role
                          objectclass: sudoRole
                          sudoCommand: ALL
                          sudoRunAs: ALL
                          sudouser: bobsudoer\n\n""")

        expected = expected % dict(org_dc=organizations.dc(org_1),
                                   org_dn=organizations.dn(org_1),
                                   org_o=organizations.o(org_1))
        eq_(expected, outfile.getvalue())
