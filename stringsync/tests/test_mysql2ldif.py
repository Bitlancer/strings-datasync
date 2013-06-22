from StringIO import StringIO
from ConfigParser import SafeConfigParser
from textwrap import dedent

from ldif import LDIFWriter
from nose.tools import ok_, eq_, raises

from stringsync import db
from stringsync.mysql2ldif import organization_dn, NoLdapDomain, \
    AmbiguousLdapDomain, organization_name, dump_organization, \
    dump_people_ou
from stringsync import fixtures as f
from stringsync.ldif_writers import BuildDnLdifWriter, build_dn


class StrLdif(object):

    def __init__(self):
        self.sio = StringIO()
        self.ldif_writer = LDIFWriter(self.sio)

    def unparse(self, dn, attrs):
        self.ldif_writer.unparse(dn, attrs)

    def ldif(self):
        return self.sio.getvalue()


class TestMysql2Ldif(object):

    def setUp(self):
        db.start_test()
        config_parser = SafeConfigParser()

        with open('db.ini', 'rb') as fil:
            config_parser.readfp(fil)
            self.conn = db.open_conn(config_parser)
        # in case stuff wasn't cleaned up
        f.clean_all(self.conn)

    def tearDown(self):
        f.clean_all(self.conn)
        db.end_test()

    def test_organization_dn(self):
        org_1 = f.f_organization_1(self.conn)
        _conf = f.f_ldap_domain_config_1(self.conn)
        eq_('dc=org-one-infra,dc=net',
            organization_dn(org_1, self.conn))

    @raises(NoLdapDomain)
    def test_barfs_on_no_domain(self):
        org_1 = f.f_organization_1(self.conn)
        organization_dn(org_1, self.conn)

    @raises(AmbiguousLdapDomain)
    def test_barfs_on_ambig_domain(self):
        org_1 = f.f_organization_1(self.conn)
        _conf = f.f_ldap_domain_config_1(self.conn)
        _conf2 = f.f_ldap_domain_config_2(self.conn)
        organization_dn(org_1, self.conn)

    def test_organization_name(self):
        org_1 = f.f_organization_1(self.conn)
        eq_('Org One', organization_name(org_1, self.conn))
        eq_(None, organization_name(0, self.conn))

    def test_dump_organization(self):
        org_1 = f.f_organization_1(self.conn)
        _conf = f.f_ldap_domain_config_1(self.conn)
        ldif = StrLdif()
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_organization(org_1, self.conn, ldif)
        _check_dn_ldif_writer(new_ldif, 'dc=org-one-infra,dc=net')
        eq_(dd("""\
               dn: dc=org-one-infra,dc=net
               dc: org-one-infra
               o: Org One
               objectClass: organization
               objectClass: dcObject
               structuralObjectClass: organization

               """), ldif.ldif())

    def test_dump_people_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        org_ldif = build_dn('dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_people_ou(self.conn, org_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=people')
        eq_(dd("""\
               dn: ou=people,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               structuralObjectClass: organizationalUnit

               """), ldif.ldif())


def _check_dn_ldif_writer(ldif, dn):
    ok_(isinstance(ldif, BuildDnLdifWriter))
    eq_(dn, ldif.dn)


def dd(s):
    return dedent(s)
