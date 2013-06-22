import MySQLdb

in_test = False


def start_test():
    global in_test
    in_test = True


def end_test():
    global in_test
    in_test = False


def _settings_from_section(db_config, section):
    return dict(host=db_config.get(section, 'host'),
                user=db_config.get(section, 'user'),
                passwd=db_config.get(section, 'passwd'),
                db=db_config.get(section, 'db'))


def open_conn(db_config):
    if in_test:
        if not db_config.has_section('db-test'):
            raise Exception("In test and no db-test config!")
        db = MySQLdb.connect(**_settings_from_section(db_config, 'db-test'))
    else:
        if not db_config.has_section('db'):
            raise Exception("Not in test and no db config!")
        db = MySQLdb.connect(**_settings_from_section(db_config, 'db'))

    return db


def select_rows(db, select, params):
    curs = db.cursor()
    try:
        curs.execute(select, params)
        return curs.fetchall()
    finally:
        if curs:
            curs.close()


def select_row(db, select, params):
    curs = db.cursor()
    try:
        curs.execute(select, params)
        rows = curs.fetchall()
        if not rows:
            return None
        if len(rows) > 1:
            raise Exception("Select row with %s %s found many rows %s" %
                            (select, params, str(rows)))
        return rows[0]
    finally:
        if curs:
            curs.close()
