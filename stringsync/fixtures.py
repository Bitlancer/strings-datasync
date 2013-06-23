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
    'device_attribute'
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


def f_role_1(conn):
    return f_role(conn,
                  organization_id=f_organization_1(conn),
                  name="role_one")


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


def f_formation_2(conn):
    return f_formation(conn,
                       organization_id=f_organization_1(conn),
                       name="formation_two")


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


def f_device_3_ex_fqdn(conn):
    return f_device_attribute(
        conn,
        organization_id=f_organization_1(conn),
        device_id=f_device_3(conn),
        var='dns.external.fqdn',
        val='device_three.data_center_two.org-one-infra.net')


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
def f_device_attribute(conn, organization_id, device_id, var, val):
    sql = """INSERT INTO device_attribute
               (organization_id, device_id, var, val)
                 VALUES
               (%s, %s, %s, %s)"""
    return _insert_and_get_id(conn, sql,
                              (organization_id, device_id, var, val))


def _insert_and_get_id(conn, sql, args):
    curs = conn.cursor()
    curs.execute(sql, args)
    curs.execute("SELECT LAST_INSERT_ID()")
    conn.commit()
    return curs.fetchone()[0]
