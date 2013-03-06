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


def clean_all(conn):
    curs = conn.cursor()
    for table in TABLES:
        curs.execute("TRUNCATE TABLE %s" % table)


def f_organization_1(conn):
    return f_organization(conn, name='Organization 1', short_name='Org 1')


def f_organization(conn, name=None, short_name=None):
    sql = "INSERT INTO organization (name, short_name) VALUES (%s, %s)"
    return _insert_and_get_id(conn, sql, (name, short_name))


def _insert_and_get_id(conn, sql, args):
    curs = conn.cursor()
    curs.execute(sql, args)
    curs.execute("SELECT LAST_INSERT_ID()")
    return curs.fetchone()[0]
