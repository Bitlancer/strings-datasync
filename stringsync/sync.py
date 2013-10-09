from StringIO import StringIO
from ConfigParser import SafeConfigParser
import sys

import ldap

from stringsync.mysql2ldif import mysql2ldif, organization_dn
from stringsync.ldif_dumper import dump_tree_sorted
from stringsync import db
from stringsync.ldiff import ldiff_and_apply, ldiff_to_ldif


def _sync_db_to_ldap(organization_id, db_server, ldap_server, dry_run):
    base_domain = organization_dn(organization_id, db_server)
    if not base_domain:
        raise Exception("Couldn't get a base dn for org %s, refusing to continue"
                        % organization_id)
    new_ldif = StringIO()
    mysql2ldif(organization_id, db_server, new_ldif)

    new_ldif.seek(0)


    cur_ldif = StringIO()
    dump_tree_sorted(ldap_server, base_domain, cur_ldif)
    cur_ldif.seek(0)

    if not dry_run:
        ldiff_and_apply(cur_ldif, new_ldif, ldap_server)
    else:
        ldiff_to_ldif(cur_ldif, new_ldif, dry_run)


def sync_from_config(db_ini_fil, ldap_ini_fil, organization_id, dry_run=None):
    """
    If dry_run is non-None, it is considered a file in which to put
    the ldif, and no changes will be applied to the ldap server
    itself.
    """
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

    _sync_db_to_ldap(organization_id, db_server, ldap_server,
                     dry_run=dry_run)
