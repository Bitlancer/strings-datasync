TABLES = [
    'organization',
    'config'
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


def _insert_and_get_id(conn, sql, args):
    curs = conn.cursor()
    curs.execute(sql, args)
    curs.execute("SELECT LAST_INSERT_ID()")
    conn.commit()
    return curs.fetchone()[0]
