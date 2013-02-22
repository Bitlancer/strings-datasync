#! /usr/bin/env python

import logging
import time

from db import open_conn
import runlock


def run_sync():
    conn = open_conn()
    curs = conn.cursor()
    if runlock.acquire(curs):
        try:
            logging.info("Acquired run lock, will attempt sync.")
            attempt_sync(curs)
        finally:
            runlock.release(curs)
            logging.info("Released run lock.")
    else:
        # TODO: ewj make this into a function
        logging.error("Could not acquire run lock.")
        raise Exception("Could not find the max value id, not syncing.")


def attempt_sync(curs):
    max_value_id = determine_max_value_id(curs)
    logging.info("Max id to be synced is %s", max_value_id)

    sync_targets = determine_sync_targets(curs)
    for ldap_server, synced_to in sync_targets:
        logging.info("Will attempt to sync %s from %s to %s",
                     ldap_server, synced_to, max_value_id)

    min_value_id = calc_min_value_id(sync_targets)
    logging.info("Need to select values in range (%s, %s)",
                 min_value_id, max_value_id)

    values = find_values_in_range(curs, min_value_id, max_value_id)
    new_synced_to_by_target = do_sync(values, sync_targets)
    update_sync_targets(curs, sync_targets, new_synced_to_by_target)


def update_sync_targets(curs, sync_targets, new_synced_to_by_target):
    logging.info("Updating sync targets table with new synced_tos.")
    update = "UPDATE sync_targets SET synced_to = %s WHERE ldap_server = %s"
    new_synced_tos = [(new_synced_to_by_target[ldap_server], ldap_server)
                      for ldap_server, _
                      in sync_targets]
    for (synced_to, ldap_server) in new_synced_tos:
        logging.info("Will update ldap_server %s to synced_to %s",
                     ldap_server, synced_to)
    curs.executemany(update, new_synced_tos)


def do_sync(values, sync_targets):
    live_sync_targets = [(open_ldap_conn(ldap_server), ldap_server, synced_to)
                         for (ldap_server, synced_to) in sync_targets]

    dead_targets = set()
    synced_to_by_target = dict(sync_targets)

    for value in values:
        value_id, value_name, value_data = value
        logging.info("Syncing value %s at id %s", value_name, value_id)

        for ldap_conn, ldap_server, synced_to in live_sync_targets:
            try_write_single_value(ldap_server, ldap_conn, synced_to,
                                   value_name, value_data, value_id,
                                   dead_targets, synced_to_by_target)

    return synced_to_by_target


def try_write_single_value(ldap_server, ldap_conn, synced_to,
                           value_name, value_data, value_id,
                           dead_targets, synced_to_by_target):
    if ldap_server in dead_targets:
        logging.info("Skipping dead server %s", ldap_server)
    elif int(synced_to) >= int(value_id):
        logging.info("Value %s at id %s already on %s, skipping.",
                     value_name,
                     value_id,
                     ldap_server)
    else:
        if write_to_ldap(ldap_conn, ldap_server,
                         value_name, value_data):
            logging.info("Synced value %s at id %s to %s",
                         value_name, value_id, ldap_server)
            assert(synced_to_by_target[ldap_server] < value_id)
            synced_to_by_target[ldap_server] = value_id
        else:
            logging.info("Marking server %s as dead", ldap_server)
            dead_targets.add(ldap_server)


def write_to_ldap(ldap_conn, ldap_server, value_name, value_data):
    # TODO: consider writing this to ldap, maybe.
    return True


def find_values_in_range(curs, min_value_id, max_value_id):
    select = """SELECT id, value_name, value_data
                  FROM sync_values
                  WHERE id >= %s AND id <= %s
             """
    curs.execute(select, (min_value_id, max_value_id))
    row = curs.fetchone()
    while row:
        yield row
        row = curs.fetchone()


def open_ldap_conn(ldap_server):
    # TODO: this should probably, y'know, open something.
    return ldap_server


def calc_min_value_id(sync_targets):
    return min([t[1] for t in sync_targets])


def find_max_value_id(curs):
    select = "SELECT MAX(id) FROM sync_values"
    curs.execute(select)
    return curs.fetchall()[0][0]


def determine_max_value_id(curs):
    max_value_id = find_max_value_id(curs)

    if not max_value_id:
        # TODO: ewj make this into a function
        logging.error("Could not find the max value id.")
        raise Exception("Could not find the max value id.")

    return max_value_id


def find_sync_targets(curs):
    select = "SELECT ldap_server, synced_to FROM sync_targets"
    curs.execute(select)
    return [(r[0], r[1]) for r in curs.fetchall()]


def determine_sync_targets(curs):
    sync_targets = find_sync_targets(curs)

    if not sync_targets:
        # TODO: ewj make this into a function
        logging.error("No sync targets.")
        raise Exception("No sync targets.")

    return sync_targets
