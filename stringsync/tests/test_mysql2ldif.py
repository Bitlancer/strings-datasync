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
    dump_posix_users_ou, dump_posix_users, dump_posix_groups, \
    dump_hosts_ou, dump_hosts_with_partials, dump_sudoers_ou, \
    dump_sudoers_defaults, dump_sudoers, dump_ldap_ou, \
    dump_ldap_groups_ou, dump_ldap_ro_group, dump_ldap_users_ou, \
    dump_ldap_users, dump_hiera_ou, dump_hiera_values, dump_librarian_ou, \
    dump_librarian_values
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

               dn: cn=team_two,ou=groups,ou=people,dc=org-one-infra,dc=net
               cn: team_two
               member: uid=user_one,ou=users,ou=people,dc=org-one-infra,dc=net
               objectClass: top
               objectClass: groupOfNames

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
               uid: user_one
               userPassword: {SHA}a63f1597e4efed34dc55d8355c6dc40610eee88e

               dn: uid=user_two,ou=users,ou=people,dc=org-one-infra,dc=net
               cn: Jane Random Userette
               objectClass: inetOrgPerson
               sn: Userette
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

               dn: ou=data_center_two,ou=nodes,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: data_center_two

               """), ldif.ldif())

    def test_dump_devices(self):
        org_1 = f.f_organization_1(self.conn)
        dev_1 = f.f_device_1(self.conn)
        dev_2 = f.f_device_2(self.conn)
        dev_3 = f.f_device_3(self.conn)
        building_dev = f.f_device_building(self.conn)
        cant_sync_dev = f.f_device_cant_sync(self.conn)
        non_instance_dev = f.f_device_non_instance(self.conn)
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

          dn: cn=device_three.data_center_two.org-one-infra.net,ou=data_center_two,ou=
           nodes,dc=org-one-infra,dc=net
          cn: device_three.data_center_two.org-one-infra.net
          description: role_one
          objectClass: device
          objectClass: puppetClient
          puppetClass: role_one

          dn: cn=device_two.data_center_two.org-one-infra.net,ou=data_center_two,ou=no
           des,dc=org-one-infra,dc=net
          cn: device_two.data_center_two.org-one-infra.net
          description: role_two
          objectClass: device
          objectClass: puppetClient
          puppetClass: role_two

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

        # for access through applications...
        a_1 = f.f_application_1(self.conn)
        a_1_f_3 = f.f_application_1_formation_3(self.conn)
        t_1_a_1 = f.f_team_1_application_1(self.conn)

        # including making sure that disabled teams don't get in
        # through applications...
        a_2 = f.f_application_2(self.conn)
        a_2_f_2 = f.f_application_2_formation_2(self.conn)
        dt_a2 = f.f_disabled_team_application_2(self.conn)

        # for team access to devices...
        t1_d6 = f.f_team_1_device_6(self.conn)
        # including making sure that disabled teams don't get to
        # devices.
        dt_d2 = f.f_disabled_team_device_2(self.conn)

        # we include disabled team, and connect it to formation 2,
        # which contains device 2, to make sure that a disabled team
        # does not convey rights to a user
        f_1 = f.f_formation_1(self.conn)
        f_2 = f.f_formation_2(self.conn)
        f_3 = f.f_formation_3(self.conn)
        d_1 = f.f_device_1(self.conn)
        d_2 = f.f_device_2(self.conn)
        fqdn_1 = f.f_device_1_ex_fqdn(self.conn)
        d_4 = f.f_device_4(self.conn)
        fqdn_4 = f.f_device_4_ex_fqdn(self.conn)
        fqdn_2 = f.f_device_2_ex_fqdn(self.conn)
        d_5 = f.f_device_5(self.conn)
        fqdn_5 = f.f_device_5_ex_fqdn(self.conn)
        d_6 = f.f_device_6(self.conn)
        fqdn_6 = f.f_device_6_ex_fqdn(self.conn)
        d_7 = f.f_device_7(self.conn)
        fqdn_7 = f.f_device_7_ex_fqdn(self.conn)

        # connect the teams to roles to make sure that devices can be
        # accessed that way (device 7 has role 3)
        r_7 = f.f_role_3(self.conn)
        # connect team one to role 3
        t_1_r_3 = f.f_team_1_role_3(self.conn)

        # but that connecting a disabled team to role 4 doesn't grant
        # access to the prohibited device_8
        r_4 = f.f_role_4(self.conn)
        dt_r_4 = f.f_disabled_team_role_4(self.conn)

        disabled_user = f.f_disabled_user(self.conn)
        shell_disabled = f.f_disabled_user_posix_login_shell(self.conn)
        uid_disabled = f.f_disabled_user_posix_uid(self.conn)
        # to make sure that the keys are removed
        disabled_user_key = f.f_disabled_user_key_1(self.conn)
        du_t1 = f.f_membership_du_t1(self.conn)

        # a user with no shell should be treated as a disabled user
        shelless_user = f.f_shelless_user(self.conn)
        uid_shelless = f.f_shelless_user_posix_uid(self.conn)
        # to make sure that the keys are removed
        shelless_user_key = f.f_shelless_user_key_1(self.conn)
        su_t1 = f.f_membership_su_t1(self.conn)

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
               host: device_five.data_center_two.org-one-infra.net
               host: device_four.data_center_two.org-one-infra.net
               host: device_one.data_center_one.org-one-infra.net
               host: device_seven.data_center_one.org-one-infra.net
               host: device_six.data_center_two.org-one-infra.net
               loginShell: /bin/user_1_shell
               objectClass: inetOrgPerson
               objectClass: posixAccount
               objectClass: authorizedServiceObject
               objectClass: hostObject
               objectClass: ldapPublicKey
               sn: User
               sshPublicKey: pub key 1 user 1
               sshPublicKey: pub key 2 user 1
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
               objectClass: ldapPublicKey
               sn: Abled
               sshPublicKey: pub key 1 disabled user
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
               objectClass: ldapPublicKey
               sn: Shell
               sshPublicKey: pub key 1 shelless user
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

               dn: cn=disabled_user_one,ou=groups,ou=posix,dc=org-one-infra,dc=net
               cn: disabled_user_one
               gidNumber: 2002
               objectClass: posixGroup

               dn: cn=no_shell_user,ou=groups,ou=posix,dc=org-one-infra,dc=net
               cn: no_shell_user
               gidNumber: 2003
               objectClass: posixGroup

               """),
            ldif.ldif())

    def test_dump_hosts_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        org_ldif = build_dn('dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_hosts_ou(org_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=hosts')
        eq_(dd("""\
               dn: ou=hosts,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: hosts

               """), ldif.ldif())

    def test_dump_hosts_with_partials(self):
        org_1 = f.f_organization_1(self.conn)

        conf = f.f_internal_dns_attr_config_1(self.conn)

        d_1 = f.f_device_1(self.conn)
        d_2 = f.f_device_2(self.conn)

        int_add_d_1 = f.f_device_1_int_addr(self.conn)
        int_add_d_2 = f.f_device_2_int_addr(self.conn)

        d1_int_fqdn = f.f_device_1_int_fqdn(self.conn)
        d2_int_fqdn = f.f_device_2_int_fqdn(self.conn)

        # and to test entries in device_dns
        alt_dns = f.f_device_dns_alt_device_1(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        hosts_ldif = build_dn('ou=hosts,dc=org-one-infra,dc=net', ldif)
        # make sure we don't return a new ldif
        eq_(None,
            dump_hosts_with_partials(org_1, self.conn, hosts_ldif))
        eq_(dd(
          """\
          dn: dc=data_center_one,dc=org-one-infra,dc=net,ou=hosts,dc=org-one-infra,dc=
           net
          dc: data_center_one
          objectClass: dcObject
          objectClass: dNSDomain

          dn: dc=data_center_two,dc=org-one-infra,dc=net,ou=hosts,dc=org-one-infra,dc=
           net
          dc: data_center_two
          objectClass: dcObject
          objectClass: dNSDomain

          dn: dc=int,dc=data_center_one,dc=org-one-infra,dc=net,ou=hosts,dc=org-one-in
           fra,dc=net
          dc: int
          objectClass: dcObject
          objectClass: dNSDomain

          dn: dc=int,dc=data_center_two,dc=org-one-infra,dc=net,ou=hosts,dc=org-one-in
           fra,dc=net
          dc: int
          objectClass: dcObject
          objectClass: dNSDomain

          dn: dc=net,ou=hosts,dc=org-one-infra,dc=net
          dc: net
          objectClass: dcObject
          objectClass: dNSDomain

          dn: dc=org-one-infra,dc=net,ou=hosts,dc=org-one-infra,dc=net
          dc: org-one-infra
          objectClass: dcObject
          objectClass: dNSDomain

          dn: dc=alt_device_one,dc=int,dc=data_center_one,dc=org-one-infra,dc=net,ou=h
           osts,dc=org-one-infra,dc=net
          aRecord: 192.168.1.101
          associatedDomain: alt_device_one.int.data_center_one.org-one-infra.net
          dc: alt_device_one
          objectClass: dNSDomain
          objectClass: domainRelatedObject

          dn: dc=device_one,dc=int,dc=data_center_one,dc=org-one-infra,dc=net,ou=hosts
           ,dc=org-one-infra,dc=net
          aRecord: 192.168.1.101
          associatedDomain: device_one.int.data_center_one.org-one-infra.net
          dc: device_one
          objectClass: dNSDomain
          objectClass: domainRelatedObject

          dn: dc=device_two,dc=int,dc=data_center_two,dc=org-one-infra,dc=net,ou=hosts
           ,dc=org-one-infra,dc=net
          aRecord: 192.168.1.102
          associatedDomain: device_two.int.data_center_two.org-one-infra.net
          dc: device_two
          objectClass: dNSDomain
          objectClass: domainRelatedObject

          """), ldif.ldif())

    def test_dump_sudoers_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        org_ldif = build_dn('dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_sudoers_ou(org_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=sudoers')
        eq_(dd("""\
               dn: ou=sudoers,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: sudoers

               """), ldif.ldif())

    def test_dump_sudoers_defaults(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        sudoers_ldif = build_dn('ou=sudoers,dc=org-one-infra,dc=net', ldif)
        # should not return a new ldif
        eq_(None,
            dump_sudoers_defaults(sudoers_ldif))
        eq_(dd("""\
               dn: cn=defaults,ou=sudoers,dc=org-one-infra,dc=net
               cn: defaults
               description: Default sudo options
               objectClass: sudoRole

               """), ldif.ldif())

    def test_dump_sudoers_through_team_device(self):
        org_1 = f.f_organization_1(self.conn)

        s = f.f_sudo_1(self.conn)
        s_c1 = f.f_sudo_1_cmd_ls(self.conn)
        s_c1 = f.f_sudo_1_cmd_mv(self.conn)
        s_r1 = f.f_sudo_1_run_as_bob(self.conn)
        s_r1 = f.f_sudo_1_run_as_jim(self.conn)
        s_o1 = f.f_sudo_1_opt_1(self.conn)
        s_o2 = f.f_sudo_1_opt_2(self.conn)

        u_1 = f.f_user_1(self.conn)
        u_2 = f.f_user_2(self.conn)
        d_u = f.f_disabled_user(self.conn)

        d_6 = f.f_device_6(self.conn)
        d_2 = f.f_device_2(self.conn)

        # this should get the team to device 6
        t_1 = f.f_team_1(self.conn)
        t_1_d_6 = f.f_team_1_device_6(self.conn)
        t_1_d_4 = f.f_team_1_device_4(self.conn)
        dt_d_2 = f.f_disabled_team_device_2(self.conn)

        # this *shouldn't* get the team to device 2, b/c it's disabled
        dt = f.f_disabled_team(self.conn)
        dt_d_2 = f.f_disabled_team_device_2(self.conn)

        u1_t1 = f.f_membership_u1_t1(self.conn)
        u2_t1 = f.f_membership_u2_t1(self.conn)
        u1_dt = f.f_membership_u1_dt(self.conn)
        du_t1 = f.f_membership_du_t1(self.conn)

        t_1_d_6_s_1 = f.f_team_1_device_6_sudo_1(self.conn)
        t_1_d_4_s_1 = f.f_team_1_device_4_sudo_1(self.conn)
        dt_d_2_s_1 = f.f_disabled_team_device_2_sudo_1(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        sudoers_ldif = build_dn('ou=sudoers,dc=org-one-infra,dc=net', ldif)
        # should not return a new ldif
        eq_(None,
            dump_sudoers(org_1, self.conn, sudoers_ldif))
        eq_(dd(
            """\
            dn: cn=team_device_team_one_sudo_role_1,ou=sudoers,dc=org-one-infra,dc=net
            cn: team_device_team_one_sudo_role_1
            description: sudo_role_1 sudo role
            objectClass: sudoRole
            sudoCommand: ls
            sudoCommand: mv
            sudoHost: device_four
            sudoHost: device_six
            sudoOption: sudo_opt_1
            sudoOption: sudo_opt_2
            sudoRunAs: bob
            sudoRunAs: jim
            sudoUser: user_one
            sudoUser: user_two

            """), ldif.ldif())

    def test_dump_sudoers_through_team_role(self):
        org_1 = f.f_organization_1(self.conn)

        f.f_team_1_role_3(self.conn)
        f.f_disabled_team_role_4(self.conn)

        # device 7 has role 3
        f.f_device_7(self.conn)

        # user 1 is in team 1
        f.f_membership_u1_t1(self.conn)
        # so is disabled user, but he shouldn't show up
        f.f_membership_du_t1(self.conn)
        # user 1 is also in disabled team
        f.f_membership_u1_dt(self.conn)

        # team 1 role 3 has sudo 1
        f.f_team_1_role_3_sudo_1(self.conn)

        # test that disabled team doesn't get anywhere...
        f.f_disabled_team_role_4(self.conn)

        # device 8 has role 4
        f.f_device_8(self.conn)

        # disabled team role 4 has sudo 1
        f.f_disabled_team_role_4_sudo_1(self.conn)

        f.f_sudo_1_cmd_ls(self.conn)
        f.f_sudo_1_cmd_mv(self.conn)
        f.f_sudo_1_run_as_bob(self.conn)
        f.f_sudo_1_run_as_jim(self.conn)
        f.f_sudo_1_opt_1(self.conn)
        f.f_sudo_1_opt_2(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        sudoers_ldif = build_dn('ou=sudoers,dc=org-one-infra,dc=net', ldif)
        # should not return a new ldif
        eq_(None,
            dump_sudoers(org_1, self.conn, sudoers_ldif))
        eq_(dd(
            """\
            dn: cn=team_role_team_one_sudo_role_1,ou=sudoers,dc=org-one-infra,dc=net
            cn: team_role_team_one_sudo_role_1
            description: sudo_role_1 sudo role
            objectClass: sudoRole
            sudoCommand: ls
            sudoCommand: mv
            sudoHost: device_seven
            sudoOption: sudo_opt_1
            sudoOption: sudo_opt_2
            sudoRunAs: bob
            sudoRunAs: jim
            sudoUser: user_one

            """), ldif.ldif())

    def test_dump_sudo_through_formations(self):
        org_1 = f.f_organization_1(self.conn)

        # device 1 is in formation 1
        f.f_formation_1(self.conn)
        f.f_device_1(self.conn)

        # user 1 is in team 1
        f.f_membership_u1_t1(self.conn)
        # so is disabled user, but he shouldn't show up
        f.f_membership_du_t1(self.conn)
        # user 1 is also in disabled team
        f.f_membership_u1_dt(self.conn)

        # team 1 has access to formation 1
        f.f_team_1_formation_1(self.conn)

        # team 1 formation 1 has sudo 1
        f.f_team_1_formation_1_sudo_1(self.conn)

        # test that disabled team doesn't get anywhere...
        f.f_disabled_team_formation_2(self.conn)

        # device 3 has formation 2
        f.f_device_3(self.conn)

        # disabled team formation 2 has sudo 1
        f.f_disabled_team_formation_2_sudo_1(self.conn)

        f.f_sudo_1_cmd_ls(self.conn)
        f.f_sudo_1_cmd_mv(self.conn)
        f.f_sudo_1_run_as_bob(self.conn)
        f.f_sudo_1_run_as_jim(self.conn)
        f.f_sudo_1_opt_1(self.conn)
        f.f_sudo_1_opt_2(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        sudoers_ldif = build_dn('ou=sudoers,dc=org-one-infra,dc=net', ldif)
        # should not return a new ldif
        eq_(None,
            dump_sudoers(org_1, self.conn, sudoers_ldif))
        eq_(dd(
            """\
          dn: cn=team_formation_team_one_sudo_role_1,ou=sudoers,dc=org-one-infra,dc=ne
           t
          cn: team_formation_team_one_sudo_role_1
          description: sudo_role_1 sudo role
          objectClass: sudoRole
          sudoCommand: ls
          sudoCommand: mv
          sudoHost: device_one
          sudoOption: sudo_opt_1
          sudoOption: sudo_opt_2
          sudoRunAs: bob
          sudoRunAs: jim
          sudoUser: user_one

          """), ldif.ldif())

    def test_dump_sudo_through_applications(self):
        org_1 = f.f_organization_1(self.conn)

        # user 1 is in team 1
        f.f_membership_u1_t1(self.conn)
        # so is disabled user, but he shouldn't show up
        f.f_membership_du_t1(self.conn)
        # user 1 is also in disabled team
        f.f_membership_u1_dt(self.conn)

        f.f_application_1_formation_3(self.conn)

        # device 5 is in formation 3
        f.f_device_5(self.conn)

        # device 10 is in formation 3
        f.f_device_10(self.conn)

        f.f_team_1_application_1(self.conn)

        # team 1 application 1 has sudo 1
        f.f_team_1_application_1_sudo_1(self.conn)

        # disabled teams shouldn't grant sudo
        f.f_disabled_team_application_2(self.conn)

        # application 2 applies to formation 2
        f.f_application_2_formation_2(self.conn)

        # device 3 is in formation 2
        f.f_device_3(self.conn)

        f.f_sudo_1_cmd_ls(self.conn)
        f.f_sudo_1_cmd_mv(self.conn)
        f.f_sudo_1_run_as_bob(self.conn)
        f.f_sudo_1_run_as_jim(self.conn)
        f.f_sudo_1_opt_1(self.conn)
        f.f_sudo_1_opt_2(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        sudoers_ldif = build_dn('ou=sudoers,dc=org-one-infra,dc=net', ldif)
        # should not return a new ldif
        eq_(None,
            dump_sudoers(org_1, self.conn, sudoers_ldif))
        eq_(dd(
            """\
         dn: cn=team_application_team_one_sudo_role_1,ou=sudoers,dc=org-one-infra,dc=
          net
         cn: team_application_team_one_sudo_role_1
         description: sudo_role_1 sudo role
         objectClass: sudoRole
         sudoCommand: ls
         sudoCommand: mv
         sudoHost: device_five
         sudoHost: device_ten
         sudoOption: sudo_opt_1
         sudoOption: sudo_opt_2
         sudoRunAs: bob
         sudoRunAs: jim
         sudoUser: user_one

         """), ldif.ldif())

    def test_dump_ldap_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        org_ldif = build_dn('dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_ldap_ou(org_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=ldap')
        eq_(dd("""\
               dn: ou=ldap,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: ldap

               """), ldif.ldif())

    def test_dump_ldap_groups_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        ldap_ldif = build_dn('ou=ldap,dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_ldap_groups_ou(ldap_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=groups')
        eq_(dd("""\
               dn: ou=groups,ou=ldap,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: groups

               """), ldif.ldif())

    def test_dump_ldap_ro_group(self):
        org_1 = f.f_organization_1(self.conn)

        h_pdns_uname = f.f_hiera_pdns_username(self.conn)
        h_pdns_passwd = f.f_hiera_pdns_passwd(self.conn)
        h_puppet_uname = f.f_hiera_puppet_username(self.conn)
        h_puppet_passwd = f.f_hiera_puppet_passwd(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        groups_ldif = build_dn('ou=groups,ou=ldap,dc=org-one-infra,dc=net',
                               ldif)
        # this will have to supplied externally in the moment
        member_dn = "ou=users,ou=ldap,dc=org-one-infra,dc=net"
        # should not return a new ldif
        eq_(None,
            dump_ldap_ro_group(org_1,
                               member_dn=member_dn,
                               db=self.conn,
                               ldif_writer=groups_ldif))
        eq_(dd("""\
               dn: cn=ro,ou=groups,ou=ldap,dc=org-one-infra,dc=net
               cn: ro
               member: uid=pdns,ou=users,ou=ldap,dc=org-one-infra,dc=net
               member: uid=puppet,ou=users,ou=ldap,dc=org-one-infra,dc=net
               objectClass: groupOfNames

               """), ldif.ldif())

    def test_dump_ldap_users_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        ldap_ldif = build_dn('ou=ldap,dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_ldap_users_ou(ldap_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=users')
        eq_(dd("""\
               dn: ou=users,ou=ldap,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: users

               """), ldif.ldif())

    def test_dump_ldap_users(self):
        org_1 = f.f_organization_1(self.conn)

        h_pdns_uname = f.f_hiera_pdns_username(self.conn)
        h_pdns_passwd = f.f_hiera_pdns_passwd(self.conn)
        h_puppet_uname = f.f_hiera_puppet_username(self.conn)
        h_puppet_passwd = f.f_hiera_puppet_passwd(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        users_ldif = build_dn('ou=users,ou=ldap,dc=org-one-infra,dc=net',
                              ldif)
        # should not return a new ldif
        eq_(None,
            dump_ldap_users(org_1,
                            db=self.conn,
                            ldif_writer=users_ldif))
        eq_(dd("""\
               dn: uid=pdns,ou=users,ou=ldap,dc=org-one-infra,dc=net
               cn: pdns user
               objectClass: inetOrgPerson
               sn: pdns user
               uid: pdns
               userPassword: {SHA}953902cd692dc4e7e311b510aed9bba3d518968f

               dn: uid=puppet,ou=users,ou=ldap,dc=org-one-infra,dc=net
               cn: puppet user
               objectClass: inetOrgPerson
               sn: puppet user
               uid: puppet
               userPassword: {SHA}566e5ce5cf3251c39958b4735d7572d869de15b3

               """), ldif.ldif())

    def test_dump_hiera_ou(self):
        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        org_ldif = build_dn('dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        new_ldif = dump_hiera_ou(org_ldif)
        _check_dn_ldif_writer(new_ldif, 'ou=hiera')
        eq_(dd("""\
               dn: ou=hiera,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: hiera

               """), ldif.ldif())

    def test_hiera_values(self):
        org_1 = f.f_organization_1(self.conn)

        f.f_hiera_puppet_username(self.conn)
        f.f_hiera_puppet_passwd(self.conn)
        f.f_hiera_pdns_username(self.conn)
        f.f_hiera_pdns_passwd(self.conn)
        f.f_hiera_prod_dfw01_common_dns_server_1(self.conn)
        f.f_hiera_prod_dfw01_common_dns_server_2(self.conn)
        f.f_hiera_fqdn_bob_mysql_server_id(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        hiera_ldif = build_dn('ou=hiera,dc=org-one-infra,dc=net',
                              ldif)
        # should not return a new ldif
        eq_(None,
            dump_hiera_values(org_1,
                              db=self.conn,
                              ldif_writer=hiera_ldif))
        eq_(dd("""\
          dn: ou=dfw01,ou=production,ou=hiera,dc=org-one-infra,dc=net
          objectClass: organizationalUnit
          objectClass: top
          ou: dfw01

          dn: ou=fqdn,ou=hiera,dc=org-one-infra,dc=net
          objectClass: organizationalUnit
          objectClass: top
          ou: fqdn

          dn: ou=production,ou=hiera,dc=org-one-infra,dc=net
          objectClass: organizationalUnit
          objectClass: top
          ou: production

          dn: cn=bob.dfw01.bitlancer-example.net,ou=fqdn,ou=hiera,dc=org-one-infra,dc=
           net
          cn: bob.dfw01.bitlancer-example.net
          description: {"mysql_server_id": "10"}
          objectClass: device
          objectClass: top

          dn: cn=common,ou=production,ou=hiera,dc=org-one-infra,dc=net
          cn: common
          description: {"ldap_pdns_password": "ldap pdns passwd!", "ldap_pdns_username
           ": "pdns", "ldap_puppet_password": "ldap puppet passwd!", "ldap_puppet_user
           name": "puppet"}
          objectClass: device
          objectClass: top

          dn: cn=common,ou=dfw01,ou=production,ou=hiera,dc=org-one-infra,dc=net
          cn: common
          description: {"dns_server": ["10.10.10.10", "10.10.10.11"]}
          objectClass: device
          objectClass: top

          """), ldif.ldif())


    def test_dump_librarian_ou(self):
        org_1 = f.f_organization_1(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        org_ldif = build_dn('dc=org-one-infra,dc=net', ldif)
        # make sure we return a modified ldif writer for further use
        librarian_ldif = dump_librarian_ou(org_ldif)
        _check_dn_ldif_writer(librarian_ldif, 'ou=librarian')
        eq_(dd("""\
               dn: ou=librarian,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               ou: librarian

               """), ldif.ldif())




    def test_dump_librarian_values(self):
        org_1 = f.f_organization_1(self.conn)
        mod_source_apache = f.f_module_source_apache(self.conn)
        mod_mysql = f.f_module_mysql(self.conn)
        mod_source_puppetlabs = f.f_module_source_puppetlabs(self.conn)
        mod_ntp = f.f_module_ntp(self.conn)

        ldif = StrLdif()
        # just to make sure that we're wrapping, as that's what will
        # happen
        librarian_ldif = build_dn('ou=librarian,dc=org-one-infra,dc=net',
                                  ldif)

        eq_(None,
            dump_librarian_values(org_1,
                                  db=self.conn,
                                  ldif_writer=librarian_ldif))

        eq_(dd("""\
               dn: ou=bitlancer,ou=librarian,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               objectClass: top
               ou: bitlancer

               dn: ou=puppetlabs,ou=librarian,dc=org-one-infra,dc=net
               objectClass: organizationalUnit
               objectClass: top
               ou: puppetlabs

               dn: cn=mysql,ou=bitlancer,ou=librarian,dc=org-one-infra,dc=net
               cn: mysql
               description: {"name": "bitlancer/mysql", "path": "feature/great-new-feature"
                , "reference": "1.1", "type": "git", "url": "git://something/somethingelse"
                }
               objectClass: device
               objectClass: top

               dn: cn=ntp,ou=puppetlabs,ou=librarian,dc=org-one-infra,dc=net
               cn: ntp
               description: {"name": "puppetlabs/ntp", "path": null, "reference": null, "ty
                pe": "git", "url": "git://something/somethingelse"}
               objectClass: device
               objectClass: top

               """),
            ldif.ldif())




def _check_dn_ldif_writer(ldif, dn):
    ok_(isinstance(ldif, BuildDnLdifWriter))
    eq_(dn, ldif.dn)


def dd(s):
    return dedent(s)
