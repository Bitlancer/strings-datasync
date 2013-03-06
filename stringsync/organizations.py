from collections import namedtuple

Organization = namedtuple('Organization', ['id', 'name', 'short_name'])


def _organization_tuple(row):
    return Organization(row[0],
                        row[1],
                        row[2])


def find_organization(curs, organization_id):
    """
    Returns an iterator of Organization named tuples.
    """
    select = """SELECT id, name, short_name
                   FROM organization
                   WHERE is_active = 1
                         AND id = %s
                ORDER BY short_name
             """
    curs.execute(select, (organization_id,))
    rows = curs.fetchall()
    if not rows:
        return None
    return _organization_tuple(rows[0])


# LDAP functions

def dn(organization):
    return organization.name


def dc(organization):
    return organization.short_name


def o(organization):
    return organization.name
