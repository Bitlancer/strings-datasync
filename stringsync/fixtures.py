import hashlib


def _sha1(s):
    sha1 = hashlib.sha1()
    sha1.update(s)
    return sha1.hexdigest()


TABLES = [
    'organization',
    'config',
    'team',
    'user_team',
    'user',
    'device',
    'role',
    'formation',
    'device_attribute',
    'user_attribute',
    'team_formation',
    'user_key',
    'application',
    'team_application',
    'application_formation',
    'team_device',
    'device_dns',
    'sudo',
    'sudo_attribute',
    'team_role',
    'hiera',
    'team_device_sudo',
    'team_role_sudo',
    'team_formation_sudo',
    'team_application_sudo'
]


fixt_results = {}


def reset_fixtures():
    global fixt_results
    fixt_results = {}


def _args_to_fixt_key(*args, **kwargs):
    kwargs_as_list = list(kwargs.items())
    kwargs_as_list.sort()
    return (args, tuple(kwargs_as_list))


def exists_fixt(*args, **kwargs):
    global fixt_results
    return _args_to_fixt_key(*args, **kwargs) in fixt_results


def get_fixt(*args, **kwargs):
    global fixt_results
    return fixt_results[_args_to_fixt_key(*args, **kwargs)]


def set_fixt(_fixture_value_093, *args, **kwargs):
    global fixt_results
    fixt_results[_args_to_fixt_key(*args, **kwargs)] = _fixture_value_093


def fixture(fixt_func):

    def _fixt_func(*args, **kwargs):
        if exists_fixt(*args, **kwargs):
            return get_fixt(*args, **kwargs)
        else:
            result = fixt_func(*args, **kwargs)
            set_fixt(result, *args, **kwargs)
            return result

    return _fixt_func


def clean_all(conn):
    curs = conn.cursor()
    for table in TABLES:
        curs.execute("TRUNCATE TABLE %s" % table)
    reset_fixtures()


def f_organization_1(conn):
    return f_organization(conn, name='Org One', short_name='OrgOne')


def f_ldap_domain_config_1(conn):
    return f_config(conn,
                    organization_id=f_organization_1(conn),
                    var='ldap.domain',
                    val='org-one-infra.net')


def f_ldap_domain_config_2(conn):
    return f_config(conn,
                    organization_id=f_organization_1(conn),
                    var='ldap.domain',
                    val='org-one-infra-2.net')


def f_internal_dns_attr_config_1(conn):
    return f_config(conn,
                    organization_id=f_organization_1(conn),
                    var='dns.internal.network_attribute',
                    val='implementation.address.private.4')


def f_team_1(conn):
    return f_team(conn,
                  organization_id=f_organization_1(conn),
                  name='team_one')


def f_team_2(conn):
    return f_team(conn,
                  organization_id=f_organization_1(conn),
                  name='team_two')


def f_disabled_members_team(conn):
    return f_team(conn,
                  organization_id=f_organization_1(conn),
                  name='team_disabled_members')


def f_memberless_team(conn):
    return f_team(conn,
                  organization_id=f_organization_1(conn),
                  name='team_memberless')


def f_disabled_team(conn):
    return f_team(conn,
                  organization_id=f_organization_1(conn),
                  name='disabled_team_one',
                  is_disabled=True)


def f_user_1(conn):
    return f_user(conn,
                  organization_id=f_organization_1(conn),
                  name="user_one",
                  password="password one",
                  first_name="John Random",
                  last_name="User",
                  email="jrandom@example.com")


def f_shelless_user(conn):
    return f_user(conn,
                  organization_id=f_organization_1(conn),
                  name="no_shell_user",
                  password="password noshell",
                  first_name="No",
                  last_name="Shell",
                  email="noshell@example.com")


def f_disabled_team_formation_2(conn):
    return f_team_formation(conn,
                            organization_id=f_organization_1(conn),
                            team_id=f_disabled_team(conn),
                            formation_id=f_formation_2(conn))


def f_user_2(conn):
    return f_user(conn,
                  organization_id=f_organization_1(conn),
                  name="user_two",
                  password="password two",
                  first_name="Jane Random",
                  last_name="Userette",
                  email="jane.random@example.com")


def f_disabled_user(conn):
    return f_user(conn,
                  organization_id=f_organization_1(conn),
                  name="disabled_user_one",
                  password="password disabled",
                  first_name="Dis",
                  last_name="Abled",
                  email="disabled@example.com",
                  is_disabled=True)


def f_user_1_posix_uid(conn):
    return f_user_attribute(conn,
                            organization_id=f_organization_1(conn),
                            user_id=f_user_1(conn),
                            var='posix.uid',
                            val=2001)


def f_user_1_posix_login_shell(conn):
    return f_user_attribute(conn,
                            organization_id=f_organization_1(conn),
                            user_id=f_user_1(conn),
                            var='posix.shell',
                            val='/bin/user_1_shell')


def f_disabled_user_posix_uid(conn):
    return f_user_attribute(conn,
                            organization_id=f_organization_1(conn),
                            user_id=f_disabled_user(conn),
                            var='posix.uid',
                            val=2002)


def f_shelless_user_posix_uid(conn):
    return f_user_attribute(conn,
                            organization_id=f_organization_1(conn),
                            user_id=f_shelless_user(conn),
                            var='posix.uid',
                            val=2003)



def f_disabled_user_posix_login_shell(conn):
    return f_user_attribute(conn,
                            organization_id=f_organization_1(conn),
                            user_id=f_disabled_user(conn),
                            var='posix.shell',
                            val='/bin/disabled_user_shell_oops')


def f_membership_u1_t1(conn):
    return f_membership(conn,
                        organization_id=f_organization_1(conn),
                        user_id=f_user_1(conn),
                        team_id=f_team_1(conn))


def f_membership_u2_t1(conn):
    return f_membership(conn,
                        organization_id=f_organization_1(conn),
                        user_id=f_user_2(conn),
                        team_id=f_team_1(conn))


def f_membership_u1_t2(conn):
    return f_membership(conn,
                        organization_id=f_organization_1(conn),
                        user_id=f_user_1(conn),
                        team_id=f_team_2(conn))


def f_membership_du_t1(conn):
    return f_membership(conn,
                        organization_id=f_organization_1(conn),
                        user_id=f_disabled_user(conn),
                        team_id=f_team_1(conn))


def f_membership_su_t1(conn):
    return f_membership(conn,
                        organization_id=f_organization_1(conn),
                        user_id=f_shelless_user(conn),
                        team_id=f_team_1(conn))


def f_membership_du_t2(conn):
    return f_membership(conn,
                        organization_id=f_organization_1(conn),
                        user_id=f_disabled_user(conn),
                        team_id=f_team_2(conn))


def f_membership_du_tod(conn):
    return f_membership(conn,
                        organization_id=f_organization_1(conn),
                        user_id=f_disabled_user(conn),
                        team_id=f_disabled_members_team(conn))


def f_membership_u1_dt(conn):
    return f_membership(conn,
                        organization_id=f_organization_1(conn),
                        user_id=f_user_1(conn),
                        team_id=f_disabled_team(conn))


def f_formation_1(conn):
    return f_formation(conn,
                       organization_id=f_organization_1(conn),
                       name="formation_one")


def f_team_1_formation_1(conn):
    return f_team_formation(conn,
                            organization_id=f_organization_1(conn),
                            team_id=f_team_1(conn),
                            formation_id=f_formation_1(conn))


def f_team_1_formation_1_sudo_1(conn):
    return f_team_formation_sudo(conn,
                                 organization_id=f_organization_1(conn),
                                 team_formation_id=f_team_1_formation_1(conn),
                                 sudo_id=f_sudo_1(conn))


def f_role_1(conn):
    return f_role(conn,
                  organization_id=f_organization_1(conn),
                  name="role_one")


def f_role_3(conn):
    return f_role(conn,
                  organization_id=f_organization_1(conn),
                  name="role_three")


def f_role_4(conn):
    return f_role(conn,
                  organization_id=f_organization_1(conn),
                  name="role_four")


def f_team_1_role_3(conn):
    return f_team_role(conn,
                       organization_id=f_organization_1(conn),
                       team_id=f_team_1(conn),
                       role_id=f_role_3(conn))


def f_disabled_team_role_4(conn):
    return f_team_role(conn,
                       organization_id=f_organization_1(conn),
                       team_id=f_disabled_team(conn),
                       role_id=f_role_4(conn))


def f_formation_7(conn):
    return f_formation(conn,
                       organization_id=f_organization_1(conn),
                       name="formation_seven")


def f_device_7(conn):
    return f_device(conn,
                    organization_id=f_organization_1(conn),
                    name="device_seven",
                    role_id=f_role_3(conn),
                    formation_id=f_formation_7(conn))


def f_device_8(conn):
    return f_device(conn,
                    organization_id=f_organization_1(conn),
                    name="device_eight",
                    role_id=f_role_4(conn),
                    formation_id=f_formation_7(conn))


def f_device_1(conn):
    return f_device(conn,
                    organization_id=f_organization_1(conn),
                    name="device_one",
                    role_id=f_role_1(conn),
                    formation_id=f_formation_1(conn))


def f_device_1_ex_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_1(conn),
        var='dns.external.fqdn',
        val='device_one.data_center_one.org-one-infra.net')


def f_device_7_ex_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_7(conn),
        var='dns.external.fqdn',
        val='device_seven.data_center_one.org-one-infra.net')


def f_device_8_ex_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_8(conn),
        var='dns.external.fqdn',
        val='device_eight.data_center_one.org-one-infra.net')


def f_device_1_int_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_1(conn),
        var='dns.internal.fqdn',
        val='device_one.int.data_center_one.org-one-infra.net')


def f_device_2_int_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_2(conn),
        var='dns.internal.fqdn',
        val='device_two.int.data_center_two.org-one-infra.net')


def f_device_1_int_addr(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_1(conn),
        var='implementation.address.private.4',
        val='192.168.1.101')


def f_device_2_int_addr(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_2(conn),
        var='implementation.address.private.4',
        val='192.168.1.102')


def f_formation_2(conn):
    return f_formation(conn,
                       organization_id=f_organization_1(conn),
                       name="formation_two")


def f_formation_3(conn):
    return f_formation(conn,
                       organization_id=f_organization_1(conn),
                       name="formation_three")


def f_formation_6(conn):
    return f_formation(conn,
                       organization_id=f_organization_1(conn),
                       name="formation_six")


def f_application_1(conn):
    return f_application(conn,
                       organization_id=f_organization_1(conn),
                       name="application_one")


def f_application_1_formation_3(conn):
    return f_application_formation(
        conn,
        organization_id=f_organization_1(conn),
        application_id=f_application_1(conn),
        formation_id=f_formation_3(conn))


def f_team_1_application_1(conn):
    return f_team_application(conn,
                              organization_id=f_organization_1(conn),
                              application_id=f_application_1(conn),
                              team_id=f_team_1(conn))


def f_team_1_application_1_sudo_1(conn):
    return f_team_application_sudo(
        conn,
        organization_id=f_organization_1(conn),
        team_application_id=f_team_1_application_1(conn),
        sudo_id=f_sudo_1(conn))


def f_disabled_team_application_2(conn):
    return f_team_application(conn,
                              organization_id=f_organization_1(conn),
                              application_id=f_application_2(conn),
                              team_id=f_disabled_team(conn))


def f_application_2(conn):
    return f_application(conn,
                       organization_id=f_organization_1(conn),
                       name="application_two")


def f_application_2_formation_2(conn):
    return f_application_formation(
        conn,
        organization_id=f_organization_1(conn),
        application_id=f_application_2(conn),
        formation_id=f_formation_2(conn))


def f_role_2(conn):
    return f_role(conn,
                  organization_id=f_organization_1(conn),
                  name="role_two")


def f_device_2(conn):
    return f_device(conn,
                    organization_id=f_organization_1(conn),
                    name="device_two",
                    role_id=f_role_2(conn),
                    formation_id=f_formation_2(conn))


def f_device_5(conn):
    return f_device(conn,
                    organization_id=f_organization_1(conn),
                    name="device_five",
                    role_id=f_role_2(conn),
                    formation_id=f_formation_3(conn))


def f_device_5_ex_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_5(conn),
        var='dns.external.fqdn',
        val='device_five.data_center_two.org-one-infra.net')


def f_device_6(conn):
    return f_device(conn,
                    organization_id=f_organization_1(conn),
                    name="device_six",
                    role_id=f_role_2(conn),
                    formation_id=f_formation_6(conn))


def f_device_6_ex_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_6(conn),
        var='dns.external.fqdn',
        val='device_six.data_center_two.org-one-infra.net')


def f_device_2_ex_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_2(conn),
        var='dns.external.fqdn',
        val='device_two.data_center_two.org-one-infra.net')


def f_device_3(conn):
    return f_device(conn,
                    organization_id=f_organization_1(conn),
                    name="device_three",
                    role_id=f_role_1(conn),
                    formation_id=f_formation_2(conn))


def f_disabled_team_formation_2_sudo_1(conn):
    return f_team_formation_sudo(
        conn,
        organization_id=f_organization_1(conn),
        team_formation_id=f_disabled_team_formation_2(conn),
        sudo_id=f_sudo_1(conn))


def f_device_3_ex_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_3(conn),
        var='dns.external.fqdn',
        val='device_three.data_center_two.org-one-infra.net')


def f_device_4(conn):
    return f_device(conn,
                    organization_id=f_organization_1(conn),
                    name="device_four",
                    role_id=f_role_1(conn),
                    formation_id=f_formation_1(conn))


def f_device_4_ex_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_4(conn),
        var='dns.external.fqdn',
        val='device_four.data_center_two.org-one-infra.net')


def f_user_1_key_1(conn):
    return f_user_key(conn,
                      organization_id=f_organization_1(conn),
                      user_id=f_user_1(conn),
                      name='user1@key1',
                      public_key='pub key 1 user 1')


def f_user_1_key_2(conn):
    return f_user_key(conn,
                      organization_id=f_organization_1(conn),
                      user_id=f_user_1(conn),
                      name='user1@key2',
                      public_key='pub key 2 user 1')


def f_disabled_user_key_1(conn):
    return f_user_key(conn,
                      organization_id=f_organization_1(conn),
                      user_id=f_disabled_user(conn),
                      name='disableduser1@key1',
                      public_key='pub key 1 disabled user')


def f_shelless_user_key_1(conn):
    return f_user_key(conn,
                      organization_id=f_organization_1(conn),
                      user_id=f_shelless_user(conn),
                      name='shellessuser1@key1',
                      public_key='pub key 1 shelless user')


def f_disabled_team_device_2(conn):
    return f_team_device(conn,
                         organization_id=f_organization_1(conn),
                         team_id=f_disabled_team(conn),
                         device_id=f_device_2(conn))


def f_team_1_device_6(conn):
    return f_team_device(conn,
                         organization_id=f_organization_1(conn),
                         team_id=f_team_1(conn),
                         device_id=f_device_6(conn))


def f_team_1_device_4(conn):
    return f_team_device(conn,
                         organization_id=f_organization_1(conn),
                         team_id=f_team_1(conn),
                         device_id=f_device_4(conn))


def f_team_1_device_6_sudo_1(conn):
    return f_team_device_sudo(conn,
                              organization_id=f_organization_1(conn),
                              team_device_id=f_team_1_device_6(conn),
                              sudo_id=f_sudo_1(conn))


def f_team_1_device_4_sudo_1(conn):
    return f_team_device_sudo(conn,
                              organization_id=f_organization_1(conn),
                              team_device_id=f_team_1_device_4(conn),
                              sudo_id=f_sudo_1(conn))


def f_disabled_team_device_2_sudo_1(conn):
    return f_team_device_sudo(conn,
                              organization_id=f_organization_1(conn),
                              team_device_id=f_disabled_team_device_2(conn),
                              sudo_id=f_sudo_1(conn))


def f_team_1_role_3_sudo_1(conn):
    return f_team_role_sudo(conn,
                            organization_id=f_organization_1(conn),
                            team_role_id=f_team_1_role_3(conn),
                            sudo_id=f_sudo_1(conn))


def f_disabled_team_role_4_sudo_1(conn):
    return f_team_role_sudo(conn,
                            organization_id=f_organization_1(conn),
                            team_role_id=f_disabled_team_role_4(conn),
                            sudo_id=f_sudo_1(conn))



def f_device_dns_alt_device_1(conn):
    return f_device_dns(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_1(conn),
        name="alt_device_one.int.data_center_one.org-one-infra.net")


def f_sudo_1(conn):
    return f_sudo(conn,
                  organization_id=f_organization_1(conn),
                  name='sudo_role_1')


def f_sudo_1_cmd_ls(conn):
    return f_sudo_attribute(conn,
                            organization_id=f_organization_1(conn),
                            sudo_id=f_sudo_1(conn),
                            name='sudoCommand',
                            value='ls')


def f_sudo_1_cmd_mv(conn):
    return f_sudo_attribute(conn,
                            organization_id=f_organization_1(conn),
                            sudo_id=f_sudo_1(conn),
                            name='sudoCommand',
                            value='mv')


def f_sudo_1_run_as_bob(conn):
    return f_sudo_attribute(conn,
                            organization_id=f_organization_1(conn),
                            sudo_id=f_sudo_1(conn),
                            name='sudoRunAs',
                            value='bob')


def f_sudo_1_run_as_jim(conn):
    return f_sudo_attribute(conn,
                            organization_id=f_organization_1(conn),
                            sudo_id=f_sudo_1(conn),
                            name='sudoRunAs',
                            value='jim')


def f_sudo_1_opt_1(conn):
    return f_sudo_attribute(conn,
                            organization_id=f_organization_1(conn),
                            sudo_id=f_sudo_1(conn),
                            name='sudoOption',
                            value='sudo_opt_1')


def f_sudo_1_opt_2(conn):
    return f_sudo_attribute(conn,
                            organization_id=f_organization_1(conn),
                            sudo_id=f_sudo_1(conn),
                            name='sudoOption',
                            value='sudo_opt_2')


def f_hiera_pdns_passwd(conn):
    return f_hiera(conn,
                   organization_id=f_organization_1(conn),
                   hiera_key='production/common',
                   var='ldap_pdns_password',
                   val='ldap pdns passwd!')


def f_hiera_pdns_username(conn):
    return f_hiera(conn,
                   organization_id=f_organization_1(conn),
                   hiera_key='production/common',
                   var='ldap_pdns_username',
                   val='pdns')


def f_hiera_puppet_passwd(conn):
    return f_hiera(conn,
                   organization_id=f_organization_1(conn),
                   hiera_key='production/common',
                   var='ldap_puppet_password',
                   val='ldap puppet passwd!')


def f_hiera_puppet_username(conn):
    return f_hiera(conn,
                   organization_id=f_organization_1(conn),
                   hiera_key='production/common',
                   var='ldap_puppet_username',
                   val='puppet')


def f_hiera_prod_dfw01_common_dns_server_2(conn):
    return f_hiera(conn,
                   organization_id=f_organization_1(conn),
                   hiera_key='production/dfw01/common',
                   var='dns_server',
                   val='10.10.10.11')


def f_hiera_prod_dfw01_common_dns_server_1(conn):
    return f_hiera(conn,
                   organization_id=f_organization_1(conn),
                   hiera_key='production/dfw01/common',
                   var='dns_server',
                   val='10.10.10.10')


def f_hiera_fqdn_bob_mysql_server_id(conn):
    return f_hiera(conn,
                   organization_id=f_organization_1(conn),
                   hiera_key='fqdn/bob.dfw01.bitlancer-example.net',
                   var='mysql_server_id',
                   val='10')

@fixture
def f_organization(conn, name=None, short_name=None, is_disabled=False):
    sql = """INSERT INTO organization
               (name, short_name, is_disabled)
                 VALUES
               (%s, %s, %s)"""
    return _insert_and_get_id(conn, sql, (name, short_name, is_disabled))


@fixture
def f_config(conn, organization_id, var, val):
    sql = """INSERT INTO config
               (organization_id, var, val)
                 VALUES
               (%s, %s, %s)"""
    return _insert_and_get_id(conn, sql, (organization_id, var, val))


@fixture
def f_team(conn, organization_id, name, is_disabled=False):
    sql = """INSERT INTO team
               (organization_id, name, is_disabled)
                 VALUES
               (%s, %s, %s)"""
    return _insert_and_get_id(conn, sql, (organization_id, name, is_disabled))


@fixture
def f_user(conn, organization_id, name, password,
           first_name, last_name, email, is_admin=False,
           can_create_user=False, is_disabled=False):
    sql = """INSERT INTO user
               (organization_id, name, password,
                first_name, last_name, email,
                is_admin, can_create_user, is_disabled)
                 VALUES
               (%(organization_id)s, %(name)s, %(password)s,
                %(first_name)s, %(last_name)s, %(email)s,
                %(is_admin)s, %(can_create_user)s, %(is_disabled)s)"""
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   name=name,
                                   password=_sha1(password),
                                   first_name=first_name,
                                   last_name=last_name,
                                   email=email,
                                   is_admin=is_admin,
                                   can_create_user=can_create_user,
                                   is_disabled=is_disabled))

@fixture
def f_membership(conn, organization_id, user_id, team_id):
    sql = """INSERT INTO user_team
               (organization_id, user_id, team_id)
                 VALUES
               (%s, %s, %s)"""
    return _insert_and_get_id(conn, sql, (organization_id, user_id, team_id))


@fixture
def f_device(conn,
             organization_id,
             name,
             role_id,
             formation_id,
             device_type_id=1,
             implementation_id=1):
    sql = """
          INSERT INTO device
            (organization_id, name, role_id,
             formation_id, device_type_id, implementation_id)
              VALUES
            (%(organization_id)s, %(name)s, %(role_id)s,
             %(formation_id)s, %(device_type_id)s, %(implementation_id)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   name=name,
                                   role_id=role_id,
                                   formation_id=formation_id,
                                   device_type_id=device_type_id,
                                   implementation_id=implementation_id))


@fixture
def f_role(conn, organization_id, name):
    sql = """
          INSERT INTO role
            (organization_id, name)
              VALUES
            (%(organization_id)s, %(name)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   name=name))


@fixture
def f_formation(conn, organization_id, name):
    sql = """
          INSERT INTO formation
            (organization_id, name)
              VALUES
            (%(organization_id)s, %(name)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   name=name))


@fixture
def f_team_formation(conn, organization_id, team_id, formation_id):
    sql = """
          INSERT INTO team_formation
            (organization_id, team_id, formation_id)
          VALUES
            (%(organization_id)s, %(team_id)s, %(formation_id)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   team_id=team_id,
                                   formation_id=formation_id))


@fixture
def f_device_attribute(conn, organization_id, device_id, var, val):
    sql = """INSERT INTO device_attribute
               (organization_id, device_id, var, val)
                 VALUES
               (%s, %s, %s, %s)"""
    return _insert_and_get_id(conn, sql,
                              (organization_id, device_id, var, val))


@fixture
def f_user_attribute(conn, organization_id, user_id, var, val):
    sql = """INSERT INTO user_attribute
               (organization_id, user_id, var, val)
                 VALUES
               (%s, %s, %s, %s)"""
    return _insert_and_get_id(conn, sql,
                              (organization_id, user_id, var, val))


@fixture
def f_user_key(conn, organization_id, user_id, name, public_key):
    sql = """
          INSERT INTO user_key
            (organization_id, user_id, name, public_key)
              VALUES
            (%(organization_id)s, %(user_id)s, %(name)s, %(public_key)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   user_id=user_id,
                                   name=name,
                                   public_key=public_key))


@fixture
def f_application(conn, organization_id, name):
    sql = """
          INSERT INTO application
            (organization_id, name)
              VALUES
            (%(organization_id)s, %(name)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   name=name))


@fixture
def f_team_application(conn, organization_id, team_id, application_id):
    sql = """
          INSERT INTO team_application
            (organization_id, team_id, application_id)
          VALUES
            (%(organization_id)s, %(team_id)s, %(application_id)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   team_id=team_id,
                                   application_id=application_id))


@fixture
def f_application_formation(conn, organization_id,
                            application_id, formation_id):
    sql = """
          INSERT INTO application_formation
            (organization_id, application_id, formation_id)
          VALUES
            (%(organization_id)s, %(application_id)s, %(formation_id)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   application_id=application_id,
                                   formation_id=formation_id))


@fixture
def f_team_device(conn, organization_id, team_id, device_id):
    sql = """
          INSERT INTO team_device
            (organization_id, team_id, device_id)
          VALUES
            (%(organization_id)s, %(team_id)s, %(device_id)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   team_id=team_id,
                                   device_id=device_id))


@fixture
def f_device_dns(conn, organization_id, device_id, name):
    sql = """
          INSERT INTO device_dns
            (organization_id, device_id, name)
          VALUES
            (%(organization_id)s, %(device_id)s, %(name)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   device_id=device_id,
                                   name=name))

@fixture
def f_sudo(conn, organization_id, name, is_hidden=False):
    sql = """
          INSERT INTO sudo
            (organization_id, name, is_hidden)
              VALUES
            (%(organization_id)s, %(name)s, %(is_hidden)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   name=name,
                                   is_hidden=is_hidden))


@fixture
def f_sudo_attribute(conn, organization_id, sudo_id, name, value):
    sql = """
          INSERT INTO sudo_attribute
            (organization_id, sudo_id, name, value)
              VALUES
            (%(organization_id)s, %(sudo_id)s, %(name)s, %(value)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   name=name,
                                   value=value,
                                   sudo_id=sudo_id))


@fixture
def f_team_role(conn, organization_id, team_id, role_id):
    sql = """
          INSERT INTO team_role
            (organization_id, team_id, role_id)
          VALUES
            (%(organization_id)s, %(team_id)s, %(role_id)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   team_id=team_id,
                                   role_id=role_id))


@fixture
def f_hiera(conn, organization_id, hiera_key, var, val):
    sql = """
          INSERT INTO hiera
            (organization_id, hiera_key, var, val)
              VALUES
            (%(organization_id)s, %(hiera_key)s, %(var)s, %(val)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   hiera_key=hiera_key,
                                   var=var,
                                   val=val))


@fixture
def f_team_device_sudo(conn, organization_id, team_device_id, sudo_id):
    sql = """
          INSERT INTO team_device_sudo
            (organization_id, team_device_id, sudo_id)
              VALUES
            (%(organization_id)s, %(team_device_id)s, %(sudo_id)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   team_device_id=team_device_id,
                                   sudo_id=sudo_id))


@fixture
def f_team_role_sudo(conn, organization_id, team_role_id, sudo_id):
    sql = """
          INSERT INTO team_role_sudo
            (organization_id, team_role_id, sudo_id)
              VALUES
            (%(organization_id)s, %(team_role_id)s, %(sudo_id)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   team_role_id=team_role_id,
                                   sudo_id=sudo_id))


@fixture
def f_team_formation_sudo(conn, organization_id, team_formation_id, sudo_id):
    sql = """
          INSERT INTO team_formation_sudo
            (organization_id, team_formation_id, sudo_id)
              VALUES
            (%(organization_id)s, %(team_formation_id)s, %(sudo_id)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   team_formation_id=team_formation_id,
                                   sudo_id=sudo_id))


@fixture
def f_team_application_sudo(conn, organization_id, team_application_id, sudo_id):
    sql = """
          INSERT INTO team_application_sudo
            (organization_id, team_application_id, sudo_id)
              VALUES
            (%(organization_id)s, %(team_application_id)s, %(sudo_id)s)
          """
    return _insert_and_get_id(conn, sql,
                              dict(organization_id=organization_id,
                                   team_application_id=team_application_id,
                                   sudo_id=sudo_id))


def _insert_and_get_id(conn, sql, args):
    curs = conn.cursor()
    curs.execute(sql, args)
    curs.execute("SELECT LAST_INSERT_ID()")
    conn.commit()
    return curs.fetchone()[0]
