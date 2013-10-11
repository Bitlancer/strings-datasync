from optparse import OptionParser
from ConfigParser import SafeConfigParser
import sys

import ldap

from stringsync.sync import sync_from_config
from stringsync.mysql2ldif import mysql2ldif, organization_dn
from stringsync import db


def _all_organization_ids(db_server):
    sql = """SELECT id FROM organization"""
    return [r[0] for r in db.select_rows(db_server, sql, dict())]


def main():
    usage = '\n'.join(["%prog [options] <db_ini> <ldap_ini> [organization_id]",
                       "",
                       "If organization_id provided, only that organization",
                       "will be synced.  If not, all organizations will be",
                       "synced."])
    parser = OptionParser(usage=usage)
    parser.add_option("--dry-run",
                      help=("Just print the ldif to stdout, don't apply"
                            " (requires an organization_id)"),
                      action="store_true",
                      default=False,
                      dest="dry_run")

    opts, args = parser.parse_args()

    if len(args) < 2:
        parser.error("At least db_ini and ldap_ini required.")
    if len(args) == 2 and opts.dry_run:
        parser.error("--dry-run requires an organization_id")
    if len(args) > 3:
        parser.error("At most one organzination_id can be specified at once.")

    db_ini_fname = args[0]
    ldap_ini_fname = args[1]

    dry_run_fil = None
    if opts.dry_run:
        dry_run_fil = sys.stdout

    with open(db_ini_fname, 'rb') as db_ini_fil:
        with open(ldap_ini_fname, 'rb') as ldap_ini_fil:
            db_config_parser = SafeConfigParser()
            db_config_parser.readfp(db_ini_fil)
            db_server = db.open_conn(db_config_parser)

            organization_ids = []

            if len(args) == 3:
                organization_ids.append(args[2])
            else:
                organization_ids = _all_organization_ids(db_server)

            ldap_config_parser = SafeConfigParser()
            ldap_config_parser.readfp(ldap_ini_fil)
            ldap_uri = ldap_config_parser.get('sync', 'uri')

            for organization_id in organization_ids:
                base_dn = organization_dn(organization_id, db_server)

                ldap_auth_name = ','.join([ldap_config_parser.get('sync', 'name'),
                                           base_dn])
                ldap_auth_pass = ldap_config_parser.get('sync', 'pass')

                ldap_server = ldap.initialize(ldap_uri)
                ldap_server.simple_bind_s(ldap_auth_name, ldap_auth_pass)

                sync_from_config(db_server, ldap_server,
                                 organization_id, dry_run=dry_run_fil)


if __name__ == '__main__':
    main()
