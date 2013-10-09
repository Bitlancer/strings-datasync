from optparse import OptionParser
import sys

from stringsync.sync import sync_from_config


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
            sync_from_config(db_ini_fil, ldap_ini_fil,
                             organization_id, dry_run=dry_run_fil)


if __name__ == '__main__':
    main()
