TABLES = [
    'config',
    'device',
    'device_meta',
    'device_type',
    'hiera',
    'module',
    'module_meta',
    'organization',
    'provider',
    'region',
    'service',
    'service_region',
    'sudo',
    'sudo_attribute',
    'tag',
    'tag_sudo',
    'tag_user',
    'target',
    'user',
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
    return f_organization(conn, name='Organization 1', short_name='Org 1')


def f_user_1(conn):
    return f_user(conn,
                  organization_id=f_organization_1(conn),
                  name="bobuser",
                  password="bobuserpw",
                  first_name="Bob",
                  last_name="User",
                  email="bobuser@example.com",
                  phone="555-BOB-USER")


def f_sudo_user_1(conn):
    user_id = f_user(conn,
                     organization_id=f_organization_1(conn),
                     name="bobsudoer",
                     password="bobsudoerpw",
                     first_name="Bob",
                     last_name="Sudoer",
                     email="bobsudoer@example.com",
                     phone="555-BOB-SUDO")

    sudo_id = f_sudo_root_1(conn)

    f_sudo_attr(conn, sudo_id=sudo_id, name='sudoRunAs', value='ALL')

    f_sudo_attr(conn, sudo_id=sudo_id, name='sudoCommand', value='ALL')

    tag_id = f_tag(conn, organization_id=f_organization_1(conn), name='admin',
                   tag_type='infrastructure')

    f_tag_sudo(conn, tag_id=tag_id, sudo_id=sudo_id)
    f_tag_user(conn, tag_id=tag_id, user_id=user_id)

    return user_id


def f_sudo_root_1(conn):
    return f_sudo(conn, organization_id=f_organization_1(conn), name='root')

def f_tag_admin_1(conn):
    return f_tag(conn,
                 organization_id=f_organization_1(conn),
                 name='admin',
                 tag_type='infrastructure')


@fixture
def f_organization(conn, name=None, short_name=None):
    sql = "INSERT INTO organization (name, short_name) VALUES (%s, %s)"
    return _insert_and_get_id(conn, sql, (name, short_name))


@fixture
def f_user(conn, organization_id=None, name=None, password=None, first_name=None,
           last_name=None, email=None, phone=None):
    sql = """INSERT INTO user (organization_id, name, password, first_name, last_name,
                               email, phone)
                         VALUES (%s, %s, %s, %s, %s, %s, %s)"""
    return _insert_and_get_id(conn, sql, (organization_id, name, password, first_name,
                                          last_name, email, phone))


@fixture
def f_sudo(conn, name=None, organization_id=None):
    sql = "INSERT INTO sudo (name, organization_id) VALUES (%s, %s)"
    return _insert_and_get_id(conn, sql, (name, organization_id))


@fixture
def f_sudo_attr(conn, sudo_id=None, name=None, value=None):
    sql = """INSERT INTO sudo_attribute (name, value, sudo_id)
                         VALUES (%s, %s, %s)"""
    return _insert_and_get_id(conn, sql, (name, value, sudo_id))


@fixture
def f_tag(conn, organization_id=None, name=None, tag_type=None):
    sql = """INSERT INTO tag (name, tag_type, organization_id)
                         VALUES (%s, %s, %s)"""
    return _insert_and_get_id(conn, sql, (name, tag_type, organization_id))


@fixture
def f_tag_sudo(conn, tag_id=None, sudo_id=None):
    sql = """INSERT INTO tag_sudo (tag_id, sudo_id)
                         VALUES (%s, %s)"""
    return _insert_and_get_id(conn, sql, (tag_id, sudo_id))


@fixture
def f_tag_user(conn, tag_id=None, user_id=None):
    sql = """INSERT INTO tag_user (tag_id, user_id)
                         VALUES (%s, %s)"""
    return _insert_and_get_id(conn, sql, (tag_id, user_id))


def _insert_and_get_id(conn, sql, args):

    curs = conn.cursor()
    curs.execute(sql, args)
    curs.execute("SELECT LAST_INSERT_ID()")
    return curs.fetchone()[0]
