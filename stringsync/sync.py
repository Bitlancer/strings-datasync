from StringIO import StringIO
from ConfigParser import SafeConfigParser
import sys

import ldap

from stringsync.mysql2ldif import mysql2ldif, organization_dn
from stringsync.ldif_dumper import dump_tree_sorted
from stringsync import db

def _bring_up_to_date(ldap_server, base_domain, new_ldif):
    cur_ldif = StringIO()

    dump_tree_sorted(ldap_server, base_domain, cur_ldif)

    cur_ldif.seek(0)

    ldiff_and_apply(cur_ldif, new_ldif, ldap_server)



def _sync_db_to_ldap(organization_id, db_server, ldap_server):
    base_domain = organization_dn(organization_id, db_server)
    if not base_domain:
        raise Exception("Couldn't get a base dn for org %s, refusing to continue"
                        % organization_id)
    new_ldif = StringIO()
    mysql2ldif(organization_id, db_server, new_ldif)

    new_ldif.seek(0)
    print new_ldif.getvalue()
    new_ldif.seek(0)

    _bring_up_to_date(ldap_server, base_domain, new_ldif)



def sync_from_config(db_ini_fil, ldap_ini_fil, organization_id):
    db_config_parser = SafeConfigParser()
    db_config_parser.readfp(db_ini_fil)
    db_server = db.open_conn(db_config_parser)

    ldap_config_parser = SafeConfigParser()
    ldap_config_parser.readfp(ldap_ini_fil)
    ldap_uri = ldap_config_parser.get('sync', 'uri')
    ldap_auth_name = ldap_config_parser.get('sync', 'name')
    ldap_auth_pass = ldap_config_parser.get('sync', 'pass')

    ldap_server = ldap.initialize(ldap_uri)
    ldap_server.simple_bind_s(ldap_auth_name, ldap_auth_pass)

    _sync_db_to_ldap(organization_id, db_server, ldap_server)


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print >> sys.stderr, "Usage: sync.py db_ini ldap_ini organization_id"
    db_ini, ldap_ini, organization_id = sys.argv[1:]
    with open(db_ini, 'rb') as db_ini_fil:
        with open(ldap_ini, 'rb') as ldap_ini_fil:
            sync_from_config(db_ini_fil, ldap_ini_fil, organization_id)

