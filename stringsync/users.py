from collections import namedtuple


UserInfo = namedtuple('UserInfo', 'id name password first_name last_name email phone')


def find_all(curs, organization_id):
    user_infos = []
    for row in _find_users(curs, organization_id):
        user_infos.append(UserInfo(id=row[0],
                                   name=row[1],
                                   password=row[2],
                                   first_name=row[3],
                                   last_name=row[4],
                                   email=row[5],
                                   phone=row[6]))

    return user_infos


def _find_users(curs, organization_id):
    sql = """SELECT id,
                    name,
                    password,
                    first_name,
                    last_name,
                    email,
                    phone
             FROM user
             WHERE organization_id = %s
                   AND is_active = 1"""
    curs.execute(sql, (organization_id,))
    return list(curs.fetchall())
