from StringIO import StringIO
from ConfigParser import SafeConfigParser
from textwrap import dedent

from ldif import LDIFWriter
from nose.tools import ok_, eq_, raises

from stringsync import db
from stringsync.mysql2ldif import organization_dn, NoLdapDomain, \
    AmbiguousLdapDomain, organization_name, dump_organization, \
    dump_people_ou, dump_people_groups_ou, dump_people_groups
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
        new_ldif, org_dn = dump_organization(org_1, self.conn, ldif)
        _check_dn_ldif_writer(new_ldif, 'dc=org-one-infra,dc=net')
        eq_("dc=org-one-infra,dc=net", org_dn)
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
               ou: people
               structuralObjectClass: organizationalUnit

               """), ldif.ldif())

    def test_dump_people_groups_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        people_ldif = build_dn('ou=people,dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_people_groups_ou(self.conn, people_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=groups')
        eq_(dd("""\
               dn: ou=groups,ou=people,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: groups
               structuralObjectClass: organizationalUnit

               """), ldif.ldif())

    def test_dump_people_groups(self):
        org_1 = f.f_organization_1(self.conn)
        team_1 = f.f_team_1(self.conn)
        team_2 = f.f_team_2(self.conn)
        memberless_team = f.f_memberless_team(self.conn)
        disabled_team = f.f_disabled_team(self.conn)
        only_disabled_members_team = f.f_disabled_members_team(self.conn)
        user_1 = f.f_user_1(self.conn)
        user_2 = f.f_user_2(self.conn)
        disabled_user = f.f_disabled_user(self.conn)
        member_team_1_user_1 = f.f_membership_u1_t1(self.conn)
        member_disabled_team_user_1 = f.f_membership_u1_dt(self.conn)
        member_team_1_user_2 = f.f_membership_u2_t1(self.conn)
        member_team_2_user_1 = f.f_membership_u1_t2(self.conn)
        member_team_2_disabled_user = f.f_membership_du_t2(self.conn)
        member_team_2_user_1 = f.f_membership_u1_t2(self.conn)
        member_disabled_user_tod = f.f_membership_du_tod(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        groups_ldif = build_dn('ou=groups,ou=people,dc=org-one-infra,dc=net',
                               ldif)
        # leaves, shouldn't return anything
        eq_(None,
            dump_people_groups(
                organization_id=org_1,
                member_dn='ou=users,ou=people,dc=org-one-infra,dc=net',
                db=self.conn,
                ldif_writer=groups_ldif))
        eq_(dd("""\
               dn: cn=team_one,ou=groups,ou=people,dc=org-one-infra,dc=net
               cn: team_one
               member: uid=user_one,ou=users,ou=people,dc=org-one-infra,dc=net
               member: uid=user_two,ou=users,ou=people,dc=org-one-infra,dc=net
               objectClass: top
               objectClass: groupOfNames
               structuralObjectClass: groupOfNames

               dn: cn=team_two,ou=groups,ou=people,dc=org-one-infra,dc=net
               cn: team_two
               member: uid=user_one,ou=users,ou=people,dc=org-one-infra,dc=net
               objectClass: top
               objectClass: groupOfNames
               structuralObjectClass: groupOfNames

               """),
            ldif.ldif())


def _check_dn_ldif_writer(ldif, dn):
    ok_(isinstance(ldif, BuildDnLdifWriter))
    eq_(dn, ldif.dn)


def dd(s):
    return dedent(s)
