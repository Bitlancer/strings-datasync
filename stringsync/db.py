import MySQLdb


def open_conn():
    db = MySQLdb.connect(host='localhost',
                         user='root',
                         passwd='root',
                         db='stringsdatasync')
    return db
