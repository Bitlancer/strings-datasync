from collections import namedtuple

Organization = namedtuple('Organization', ['name', 'short_name'])

def _organization_tuple(row):
    return Organization(row[0],
                        row[1])


def find_organizations(curs):
    """
    Returns an iterator of Organization named tuples.
    """
    select = """SELECT name, short_name
                   FROM organization
                   WHERE is_active = 1
                ORDER BY short_name
             """
    curs.execute(select)
    row = curs.fetchone()
    while row:
        yield _organization_tuple(row)
        row = curs.fetchone()

