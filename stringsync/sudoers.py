from collections import namedtuple

SudoInfo = namedtuple('SudoInfo', 'id name attributes users')


def find_all(curs, organization_id):
    sudo_infos = []
    sudos = _find_sudos(curs, organization_id)

    for (sudo_id, sudo_name) in sudos:
        sudo_attrs = _find_attrs(curs, sudo_id)
        sudoers = _find_sudoers(curs, sudo_id)
        sudo_infos.append(SudoInfo(id=sudo_id,
                                   name=sudo_name,
                                   attributes=dict(sudo_attrs),
                                   users=sudoers))

    return sudo_infos


def _find_attrs(curs, sudo_id):
    sql = """SELECT name, value
             FROM sudo_attribute WHERE sudo_id = %s AND is_active = 1"""
    curs.execute(sql, (sudo_id,))
    return list(curs.fetchall())


def _find_sudoers(curs, sudo_id):
    sql = """SELECT u.name FROM user u INNER JOIN tag_user tu ON u.id = tu.user_id
                                INNER JOIN tag t on tu.tag_id = t.id
                                INNER JOIN tag_sudo ts ON t.id = ts.tag_id
                            WHERE u.is_active = 1
                                  AND tu.is_active = 1
                                  AND t.is_active = 1
                                  AND ts.is_active = 1
                                  AND ts.sudo_id = %s"""
    curs.execute(sql, (sudo_id,))
    return list(row[0] for row in curs.fetchall())


def _find_sudos(curs, organization_id):
    sql = """SELECT id, name FROM sudo
                             WHERE organization_id = %s
                                   AND is_active = 1"""
    curs.execute(sql, (organization_id,))
    return list(curs.fetchall())


def _dump_sudo(sudo_info, organization, ldif_writer):
    attrs_with_list_vals = dict([(name, [val])
                                 for name, val
                                 in sudo_info.attrs.items()])

    ldif_writer.unparse("cn=%s,%s" % (sudo_info.name, organizations.dn(organization)),
                        description=["%s sudo role" % sudo_info.name],
                        objectclass=["sudoRole"],
                        sudouser=sudo_info.users,
                        **attrs_with_list_vals)
