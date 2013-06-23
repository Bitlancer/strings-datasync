from StringIO import StringIO
from ConfigParser import SafeConfigParser
from textwrap import dedent

from ldif import LDIFWriter
from nose.tools import ok_, eq_, raises

from stringsync import db
from stringsync.mysql2ldif import organization_dn, NoLdapDomain, \
    AmbiguousLdapDomain, organization_name, dump_organization, \
    dump_people_ou, dump_people_groups_ou, dump_people_groups, \
    dump_people_users_ou, dump_people_users, dump_nodes_ou, \
    dump_data_centers, dump_devices, dump_posix_ou, dump_posix_groups_ou, \
    dump_posix_users_ou, dump_posix_users, dump_posix_groups
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
        new_ldif = dump_people_ou(org_ldif)
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
        new_ldif = dump_people_groups_ou(people_ldif)
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

    def test_dump_people_users_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        people_ldif = build_dn('ou=people,dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_people_users_ou(people_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=users')
        eq_(dd("""\
               dn: ou=users,ou=people,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: users
               structuralObjectClass: organizationalUnit

               """), ldif.ldif())

    def test_dump_people_users(self):
        org_1 = f.f_organization_1(self.conn)
        user_1 = f.f_user_1(self.conn)
        user_2 = f.f_user_2(self.conn)
        disabled_user = f.f_disabled_user(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        users_ldif = build_dn('ou=users,ou=people,dc=org-one-infra,dc=net',
                              ldif)
        # make sure we don't return a modified ldif writer
        eq_(None,
            dump_people_users(org_1, self.conn, users_ldif))
        eq_(dd("""\
               dn: uid=user_one,ou=users,ou=people,dc=org-one-infra,dc=net
               cn: John Random User
               objectClass: inetOrgPerson
               sn: User
               structuralObjectClass: inetOrgPerson
               uid: user_one
               userPassword: {SHA}a63f1597e4efed34dc55d8355c6dc40610eee88e

               dn: uid=user_two,ou=users,ou=people,dc=org-one-infra,dc=net
               cn: Jane Random Userette
               objectClass: inetOrgPerson
               sn: Userette
               structuralObjectClass: inetOrgPerson
               uid: user_two
               userPassword: {SHA}9804b2c400d70b66f2d8e7c3b04bd26c83321d8e

               """), ldif.ldif())

    def test_dump_nodes_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        org_ldif = build_dn('dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_nodes_ou(org_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=nodes')
        eq_(dd("""\
               dn: ou=nodes,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: nodes
               structuralObjectClass: organizationalUnit

               """), ldif.ldif())

    def test_dump_data_centers(self):
        org_1 = f.f_organization_1(self.conn)
        dev_1 = f.f_device_1(self.conn)
        dev_2 = f.f_device_2(self.conn)
        dev_3 = f.f_device_3(self.conn)
        fqdn_1 = f.f_device_1_ex_fqdn(self.conn)
        fqdn_2 = f.f_device_2_ex_fqdn(self.conn)
        fqdn_3 = f.f_device_3_ex_fqdn(self.conn)
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        nodes_ldif = build_dn('ou=nodes,dc=org-one-infra,dc=net', ldif)
        # make sure we don't return an ldif writer
        eq_(None,
            dump_data_centers(org_1, self.conn, nodes_ldif))
        eq_(dd("""\
               dn: ou=data_center_one,ou=nodes,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: data_center_one
               structuralObjectClass: organizationalUnit

               dn: ou=data_center_two,ou=nodes,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: data_center_two
               structuralObjectClass: organizationalUnit

               """), ldif.ldif())

    def test_dump_devices(self):
        org_1 = f.f_organization_1(self.conn)
        dev_1 = f.f_device_1(self.conn)
        dev_2 = f.f_device_2(self.conn)
        dev_3 = f.f_device_3(self.conn)
        fqdn_1 = f.f_device_1_ex_fqdn(self.conn)
        fqdn_2 = f.f_device_2_ex_fqdn(self.conn)
        fqdn_3 = f.f_device_3_ex_fqdn(self.conn)
        role_1 = f.f_role_1(self.conn)
        role_2 = f.f_role_2(self.conn)
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        nodes_ldif = build_dn('ou=nodes,dc=org-one-infra,dc=net', ldif)
        # make sure we don't return an ldif writer
        eq_(None,
            dump_devices(org_1, self.conn, nodes_ldif))
        eq_(dd("""\
          dn: cn=device_one.data_center_one.org-one-infra.net,ou=data_center_one,ou=no
           des,dc=org-one-infra,dc=net
          cn: device_one.data_center_one.org-one-infra.net
          description: role_one
          objectClass: device
          objectClass: puppetClient
          puppetClass: role_one
          structuralObjectClass: device

          dn: cn=device_three.data_center_two.org-one-infra.net,ou=data_center_two,ou=
           nodes,dc=org-one-infra,dc=net
          cn: device_three.data_center_two.org-one-infra.net
          description: role_one
          objectClass: device
          objectClass: puppetClient
          puppetClass: role_one
          structuralObjectClass: device

          dn: cn=device_two.data_center_two.org-one-infra.net,ou=data_center_two,ou=no
           des,dc=org-one-infra,dc=net
          cn: device_two.data_center_two.org-one-infra.net
          description: role_two
          objectClass: device
          objectClass: puppetClient
          puppetClass: role_two
          structuralObjectClass: device

          """), ldif.ldif())


    def test_dump_posix_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        org_ldif = build_dn('dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_posix_ou(org_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=posix')
        eq_(dd("""\
               dn: ou=posix,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: unix
               ou: posix
               structuralObjectClass: organizationalUnit

               """), ldif.ldif())

    def test_dump_posix_groups_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        posix_ldif = build_dn('ou=posix,dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_posix_groups_ou(posix_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=groups')
        eq_(dd("""\
               dn: ou=groups,ou=posix,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: groups
               structuralObjectClass: organizationalUnit

               """), ldif.ldif())

    def test_dump_posix_users_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        posix_ldif = build_dn('ou=posix,dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_posix_users_ou(posix_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=users')
        eq_(dd("""\
               dn: ou=users,ou=posix,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: users
               structuralObjectClass: organizationalUnit

               """), ldif.ldif())

    def test_dump_posix_users(self):
        org_1 = f.f_organization_1(self.conn)

        user_1 = f.f_user_1(self.conn)
        shell_1 = f.f_user_1_posix_login_shell(self.conn)
        uid_1 = f.f_user_1_posix_uid(self.conn)
        u_1_k_1 = f.f_user_1_key_1(self.conn)
        u_1_k_2 = f.f_user_1_key_2(self.conn)
        t_1 = f.f_team_1(self.conn)
        u_t_1 = f.f_membership_u1_t1(self.conn)
        t_1_f_1 = f.f_team_1_formation_1(self.conn)
        t_d_u_1 = f.f_membership_u1_dt(self.conn)
        t_d_f_2 = f.f_disabled_team_formation_2(self.conn)

        # we include disabled team, and connect it to formation 2,
        # which contains device 2, to make sure that a disabled team
        # does not convey rights to a user
        f_1 = f.f_formation_1(self.conn)
        f_2 = f.f_formation_2(self.conn)
        d_1 = f.f_device_1(self.conn)
        d_2 = f.f_device_2(self.conn)
        fqdn_1 = f.f_device_1_ex_fqdn(self.conn)
        d_4 = f.f_device_4(self.conn)
        fqdn_4 = f.f_device_4_ex_fqdn(self.conn)
        fqdn_2 = f.f_device_2_ex_fqdn(self.conn)

        disabled_user = f.f_disabled_user(self.conn)
        shell_disabled = f.f_disabled_user_posix_login_shell(self.conn)
        uid_disabled = f.f_disabled_user_posix_uid(self.conn)
        # to make sure that the keys are removed
        disabled_user_key = f.f_disabled_user_key_1(self.conn)

        # a user with no shell should be treated as a disabled user
        shelless_user = f.f_shelless_user(self.conn)
        uid_shelless = f.f_shelless_user_posix_uid(self.conn)
        # to make sure that the keys are removed
        shelless_user_key = f.f_shelless_user_key_1(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        users_ldif = build_dn('ou=users,ou=posix,dc=org-one-infra,dc=net',
                              ldif)
        # make sure no extended ldif is returned
        eq_(None,
            dump_posix_users(org_1, self.conn, users_ldif))

        eq_(dd("""\
               dn: uid=user_one,ou=users,ou=posix,dc=org-one-infra,dc=net
               authorizedService: *
               cn: John Random User
               gidNumber: 2001
               givenName: John Random
               homeDirectory: /home/user_one
               host: device_four.data_center_two.org-one-infra.net
               host: device_one.data_center_one.org-one-infra.net
               loginShell: /bin/user_1_shell
               objectClass: inetOrgPerson
               objectClass: posixAccount
               objectClass: authorizedServiceObject
               objectClass: hostObject
               sn: User
               sshPublicKey: pub key 1 user 1
               sshPublicKey: pub key 2 user 1
               structuralObjectClass: inetOrgPerson
               uid: user_one
               uidNumber: 2001
               userPassword: {SHA}a63f1597e4efed34dc55d8355c6dc40610eee88e

               dn: uid=disabled_user_one,ou=users,ou=posix,dc=org-one-infra,dc=net
               cn: Dis Abled
               gidNumber: 2002
               givenName: Dis
               homeDirectory: /home/disabled_user_one
               loginShell: /usr/sbin/nologin
               objectClass: inetOrgPerson
               objectClass: posixAccount
               objectClass: authorizedServiceObject
               objectClass: hostObject
               sn: Abled
               structuralObjectClass: inetOrgPerson
               uid: disabled_user_one
               uidNumber: 2002
               userPassword: {MD5}!

               dn: uid=no_shell_user,ou=users,ou=posix,dc=org-one-infra,dc=net
               cn: No Shell
               gidNumber: 2003
               givenName: No
               homeDirectory: /home/no_shell_user
               loginShell: /usr/sbin/nologin
               objectClass: inetOrgPerson
               objectClass: posixAccount
               objectClass: authorizedServiceObject
               objectClass: hostObject
               sn: Shell
               structuralObjectClass: inetOrgPerson
               uid: no_shell_user
               uidNumber: 2003
               userPassword: {MD5}!

               """),
            ldif.ldif())

    def test_dump_posix_groups(self):
        org_1 = f.f_organization_1(self.conn)

        user_1 = f.f_user_1(self.conn)
        uid_1 = f.f_user_1_posix_uid(self.conn)

        # disabled users need groups, too, man.
        disabled_user = f.f_disabled_user(self.conn)
        uid_disabled = f.f_disabled_user_posix_uid(self.conn)

        # shelless users need groups, too, man.
        shelless_user = f.f_shelless_user(self.conn)
        uid_shelless = f.f_shelless_user_posix_uid(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        groups_ldif = build_dn('ou=groups,ou=posix,dc=org-one-infra,dc=net',
                              ldif)
        # make sure no extended ldif is returned
        eq_(None,
            dump_posix_groups(org_1, self.conn, groups_ldif))
        eq_(dd("""\
               dn: cn=user_one,ou=groups,ou=posix,dc=org-one-infra,dc=net
               cn: user_one
               gidNumber: 2001
               objectClass: posixGroup
               structuralObjectClass: posixGroup

               dn: cn=disabled_user_one,ou=groups,ou=posix,dc=org-one-infra,dc=net
               cn: disabled_user_one
               gidNumber: 2002
               objectClass: posixGroup
               structuralObjectClass: posixGroup

               dn: cn=no_shell_user,ou=groups,ou=posix,dc=org-one-infra,dc=net
               cn: no_shell_user
               gidNumber: 2003
               objectClass: posixGroup
               structuralObjectClass: posixGroup

               """),
            ldif.ldif())


def _check_dn_ldif_writer(ldif, dn):
    ok_(isinstance(ldif, BuildDnLdifWriter))
    eq_(dn, ldif.dn)


def dd(s):
    return dedent(s)
