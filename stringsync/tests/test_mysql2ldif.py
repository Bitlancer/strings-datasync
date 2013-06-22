from StringIO import StringIO
from ConfigParser import SafeConfigParser
from textwrap import dedent

from ldif import LDIFWriter
from nose.tools import ok_, eq_, raises

from stringsync import db
from stringsync.mysql2ldif import organization_dn, NoDnsDomain, \
    AmbiguousDnsDomain, organization_name, dump_organization
from stringsync import fixtures as f
from stringsync.ldif_writers import BuildDnLdifWriter


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
        _conf = f.f_dns_external_domain_config_1(self.conn)
        eq_('dc=org-one-infra,dc=net',
            organization_dn(org_1, self.conn))

    @raises(NoDnsDomain)
    def test_barfs_on_no_domain(self):
        org_1 = f.f_organization_1(self.conn)
        organization_dn(org_1, self.conn)

    @raises(AmbiguousDnsDomain)
    def test_barfs_on_ambig_domain(self):
        org_1 = f.f_organization_1(self.conn)
        _conf = f.f_dns_external_domain_config_1(self.conn)
        _conf2 = f.f_dns_external_domain_config_2(self.conn)
        organization_dn(org_1, self.conn)

    def test_organization_name(self):
        org_1 = f.f_organization_1(self.conn)
        eq_('Org One', organization_name(org_1, self.conn))
        eq_(None, organization_name(0, self.conn))

    def test_dump_organization(self):
        org_1 = f.f_organization_1(self.conn)
        _conf = f.f_dns_external_domain_config_1(self.conn)
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

def _check_dn_ldif_writer(ldif, dn):
    ok_(isinstance(ldif, BuildDnLdifWriter))
    eq_(dn, ldif.dn)


def dd(s):
    return dedent(s)
