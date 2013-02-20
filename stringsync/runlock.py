# TODO: ewj make this a template, populate with unique source / target
# info.
RUN_LOCK_NAME = 'strings-sync-lock'
RUN_LOCK_TIMEOUT_SECS = 10


def acquire(curs):
    curs.execute("SELECT GET_LOCK(%s, %s)",
                 (RUN_LOCK_NAME, RUN_LOCK_TIMEOUT_SECS))
    # mysql's GET_LOCK returns 1L if the lock was acquired by this
    # connection.
    acquired = curs.fetchall()[0][0]
    return acquired == 1L


def release(curs):
    curs.execute("SELECT RELEASE_LOCK(%s)",
                 (RUN_LOCK_NAME,))
    released = curs.fetchall()[0][0]
    return released == 1L
