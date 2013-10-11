from optparse import OptionParser
from ConfigParser import SafeConfigParser
import sys

import ldap

from stringsync.sync import sync_from_config
from stringsync.mysql2ldif import mysql2ldif, organization_dn
from stringsync import db


def main():
    usage = "%prog [options] <db_ini> <ldap_ini> <organization_id>"
    parser = OptionParser(usage=usage)
    parser.add_option("--dry-run",
                      help="Just print the ldif to stdout, don't apply",
                      action="store_true",
                      default=False,
                      dest="dry_run")

    opts, args = parser.parse_args()

    if len(args) != 3:
        parser.error("3 args required, %d supplied" % len(args))

    db_ini_fname, ldap_ini_fname, organization_id = args

    dry_run_fil = None
    if opts.dry_run:
        dry_run_fil = sys.stdout

    with open(db_ini_fname, 'rb') as db_ini_fil:
        with open(ldap_ini_fname, 'rb') as ldap_ini_fil:
            db_config_parser = SafeConfigParser()
            db_config_parser.readfp(db_ini_fil)
            db_server = db.open_conn(db_config_parser)

            base_dn = organization_dn(organization_id, db_server)

            ldap_config_parser = SafeConfigParser()
            ldap_config_parser.readfp(ldap_ini_fil)
            ldap_uri = ldap_config_parser.get('sync', 'uri')
            ldap_auth_name = ','.join([ldap_config_parser.get('sync', 'name'),
                                       base_dn])
            ldap_auth_pass = ldap_config_parser.get('sync', 'pass')

            ldap_server = ldap.initialize(ldap_uri)
            ldap_server.simple_bind_s(ldap_auth_name, ldap_auth_pass)

            sync_from_config(db_server, ldap_server,
                             organization_id, dry_run=dry_run_fil)


if __name__ == '__main__':
    main()
