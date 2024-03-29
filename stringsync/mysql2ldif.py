"""
Dump the strings mysql data for a given organization to a full ldif.
"""
from ConfigParser import SafeConfigParser
from collections import defaultdict, namedtuple
import hashlib
import base64
import itertools
import json
import re
import sys

from ldif import LDIFWriter

from stringsync.db import select_row, select_rows, select_val, open_conn
from stringsync.ldif_writers import build_dn, full_dn, SortedLdifWriter


class NoLdapDomain(Exception):
   """
   Raised when an organization has no ldap.domain config value.
   """
   pass


class AmbiguousLdapDomain(Exception):
   """
   Raised when an organization has multiple ldap.domain config values.
   """
   pass


def mysql2ldif(organization_id, db, out_fil):
   ldif = LDIFWriter(out_fil)
   with SortedLdifWriter(ldif) as s_ldif:
      with dump_organization(organization_id, db, s_ldif) as org_ldif:
         with dump_people_ou(org_ldif) as p_ldif:
            with dump_people_users_ou(p_ldif) as pu_ldif:
               pu_dn = full_dn(pu_ldif)
               dump_people_users(organization_id, db, pu_ldif)
            with dump_people_groups_ou(p_ldif) as pg_ldif:
               dump_people_groups(organization_id, pu_dn, db, pg_ldif)
         with dump_posix_ou(org_ldif) as pos_ldif:
            with dump_posix_groups_ou(pos_ldif) as posg_ldif:
               dump_posix_groups(organization_id, db, posg_ldif)
            with dump_posix_users_ou(pos_ldif) as posu_ldif:
               dump_posix_users(organization_id, db, posu_ldif)
         with dump_sudoers_ou(org_ldif) as su_ldif:
            dump_sudoers_defaults(su_ldif)
            dump_sudoers(organization_id, db, su_ldif)
         with dump_nodes_ou(org_ldif) as n_ldif:
            dump_data_centers(organization_id, db, n_ldif)
            dump_devices(organization_id, db, n_ldif)
         with dump_hosts_ou(org_ldif) as h_ldif:
            dump_hosts_with_partials(organization_id, db, h_ldif)
         with dump_ldap_ou(org_ldif) as ldap_ldif:
            with dump_ldap_users_ou(ldap_ldif) as ldapu_ldif:
               ldap_dn = full_dn(ldapu_ldif)
               dump_ldap_users(organization_id, db, ldapu_ldif)
            with dump_ldap_groups_ou(ldap_ldif) as ldapg_ldif:
               dump_ldap_ro_group(organization_id, ldap_dn, db, ldapg_ldif)
         with dump_hiera_ou(org_ldif) as hiera_ldif:
            dump_hiera_values(organization_id, db, hiera_ldif)
         with dump_librarian_ou(org_ldif) as librarian_ldif:
            dump_librarian_values(organization_id, db, librarian_ldif)


def dump_organization(organization_id, db, ldif_writer):
   """
   Returns the extended ldif writer of the organization for use in
   tree-like dumping, and the org dn for use in dumping members.
   """
   org_dn = organization_dn(organization_id, db)
   full_name = organization_name(organization_id, db)
   ldif_writer.unparse(dn=org_dn,
                       attrs=dict(objectClass=['organization',
                                               'dcObject'],
                                  o=[full_name],
                                  dc=[_org_dc_from_dn(org_dn)]))
   return build_dn(org_dn, ldif_writer)


def dump_people_ou(ldif_writer):
   """
   Returns the extended ldif writer of the people ou for use in
   tree-like dumping.
   """
   ldif_writer.unparse(dn='ou=people',
                       attrs=dict(
         objectClass=['organizationalUnit'],
         ou=['people']))
   return build_dn('ou=people', ldif_writer)


def dump_people_groups_ou(ldif_writer):
   """
   Returns the extended ldif writer of the people groups ou for use in
   tree-like dumping.
   """
   ldif_writer.unparse(dn='ou=groups',
                       attrs=dict(
         ou=['groups'],
         objectClass=['organizationalUnit']))
   return build_dn('ou=groups', ldif_writer)


def dump_people_groups(organization_id, member_dn, db, ldif_writer):
   """
   Dump the entries under ou=groups,ou=people,...

   These correspond to the 'team' records in the db, and find the
   members using 'user_team.'

   Disabled teams should not be written at all, nor should teams with
   only disabled members.

   Represents leaves in the ldif tree and does not return an extended
   ldif writer.

   - `member_dn`: the dn to append to member names
   """
   team_ids_and_names = _select_active_teams(organization_id, db)
   for team_id, team_name in team_ids_and_names:
      member_names = _select_active_team_member_names(team_id, db)
      # make the order of members deterministic and therefore easy to
      # test.
      member_names.sort()
      # don't write memberless teams
      if member_names:
         ldif_writer.unparse(dn='cn=%s' % team_name,
                             attrs=dict(
               cn=[team_name],
               objectClass=['top', 'groupOfNames'],
               member=[_format_member(member_name,
                                      member_dn)
                       for member_name
                       in member_names]))


def dump_people_users_ou(ldif_writer):
   """
   Dump the users ou under people.

   Return an extended ldif writer for further writing.
   """
   ldif_writer.unparse(dn='ou=users',
                       attrs=dict(
         ou=['users'],
         objectClass=['organizationalUnit']))
   return build_dn('ou=users', ldif_writer)


def dump_people_users(organization_id, db, ldif_writer):
   """
   Dump the user entries under ou=users,ou=people.

   As these are leave entries, no extended ldif writer is returned.
   """
   user_data = _select_active_user_data(organization_id, db)
   for user in user_data:
      ldif_writer.unparse(
         dn="uid=%s" % user['name'],
         attrs=dict(objectClass=['inetOrgPerson'],
                    cn=[' '.join([user['first_name'],
                                  user['last_name']])],
                    sn=[user['last_name']],
                    uid=[user['name']],
                    userPassword=["{SHA}%s" % user['password']]))


def dump_nodes_ou(ldif_writer):
   """
   Dump the nodes ou.

   Returns an extended ldif_writer to write sub-entries in the tree.
   """
   ldif_writer.unparse(
      dn='ou=nodes',
      attrs=dict(ou=['nodes'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=nodes', ldif_writer)


def dump_data_centers(organization_id, db, ldif_writer):
   """
   Dump the data centers as organizational units under nodes.

   We generate the data centers by assuming that the second segment of
   the external fqdns are always the data center, and generating from
   those.

   Even though these are technically not leaf entries, don't return an
   extended ldif writer, since there's not an easy way to iterate
   through the devices in a data center, and instead we just generate
   the datacenter ou part of the device dn when dumping devices
   individually.
   """
   device_fqdns = _select_device_fqdns(organization_id, db)
   data_centers = list(set([_data_center(fqdn)
                            for fqdn
                            in device_fqdns]))
   # make this predictable and therefore testable
   data_centers.sort()
   for data_center in data_centers:
      ldif_writer.unparse(
         dn='ou=%s' % data_center,
         attrs=dict(objectClass=['organizationalUnit'],
                    ou=[data_center]))


def dump_devices(organization_id, db, ldif_writer):
   """
   Dump the devices with puppet info under nodes.

   As these are leaf entries, don't return an extended ldif writer.
   """
   devices = _select_devices(organization_id, db)

   # sort by cn to make it predictable and testable
   cn_and_devices = [(device['external_fqdn'], device)
                     for device
                     in devices]
   cn_and_devices.sort()
   devices = [d[1] for d in cn_and_devices]

   for device in devices:
      fqdn = device['external_fqdn']
      # we determine the data center here rather than iterating
      # underneath it b/c there's no good iteration organization in
      # the database.
      ldif_writer.unparse(
         dn="cn=%s,ou=%s" % (fqdn, _data_center(fqdn)),
         attrs=dict(objectClass=['device', 'puppetClient'],
                    description=[device['role']],
                    cn=[fqdn],
                    puppetClass=[device['role']],
                    environment=[device['environment']],
                    puppetVar=["role=%s" % device['role']]))


def dump_posix_ou(ldif_writer):
   """
   Dump the posix organizational unit to the ldif writer.

   Return an extended ldif writer for child entries.
   """
   ldif_writer.unparse(
      dn='ou=posix',
      attrs=dict(ou=['unix', 'posix'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=posix', ldif_writer)


def dump_posix_groups_ou(ldif_writer):
   """
   Dump the ou for posix groups

   For the moment, yes, this is identical to dump_people_groups_ou in
   function, but I'm keeping them separate in case they diverge, as
   that would be a nasty bug to track down.

   Return an extended ldif writer for child entries.
   """
   ldif_writer.unparse(
      dn='ou=groups',
      attrs=dict(ou=['groups'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=groups', ldif_writer)


def dump_posix_groups(organization_id, db, ldif_writer):
   """
   Write one posix group for each user (whether disabled or not).

   As these are leaf entries, don't return an ldif writer.
   """
   user_ids_and_names = _user_ids_and_names_for_posix_groups(organization_id,
                                                             db)
   for user_id, name in user_ids_and_names:
      gid = _select_posix_uid_num(db, user_id)
      if gid is None:
         raise Exception("Missing uid for user %s" % name)
      ldif_writer.unparse(
         dn="cn=%s" % name,
         attrs=dict(cn=[name],
                    gidNumber=[gid],
                    objectClass=['posixGroup']))


def dump_posix_users_ou(ldif_writer):
   """
   Dump the ou for posix users

   For the moment, yes, this is identical to dump_people_users_ou in
   function, but I'm keeping them separate in case they diverge, as
   that would be a nasty bug to track down.

   Return an extended ldif writer for child entries.
   """
   ldif_writer.unparse(
      dn='ou=users',
      attrs=dict(ou=['users'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=users', ldif_writer)


def dump_posix_users(organization_id, db, ldif_writer):
   """
   Dump posix users to ldif, including service and host permissions.

   Disabled users will still be written, but:

   - their login shell will be set to nologin

   - their password will be set to {MD5}!

   - (future) they won't have access to any hosts
   """
   users = _select_posix_users(organization_id, db)
   _deactivate_disabled_posix_users(users)
   for user in users:
      _dump_posix_user_to_ldif(user, ldif_writer)


def dump_hosts_ou(ldif_writer):
   """
   Dump the top-level hosts ou, return an extended ldif_writer for
   further use.
   """
   ldif_writer.unparse(
      dn='ou=hosts',
      attrs=dict(ou=['hosts'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=hosts', ldif_writer)


def dump_hosts_with_partials(organization_id, db, ldif_writer):
   """
   Dump the host dns records, including the partial domains building
   up to the full hosts.

   Since these are leaf entries, don't return an extended ldif.
   """
   dns_attr = _select_dns_int_config_attr(organization_id, db)
   if dns_attr is None:
      raise Exception("Dns attr in config was None, can't gen hosts.")
   device_fqdns_addys = _select_device_info_for_hosts(dns_attr,
                                                      organization_id,
                                                      db)
   device_fqdns_addys.sort()
   _dump_dc_objects(device_fqdns_addys, ldif_writer)
   for fqdn, addy in device_fqdns_addys:
      ldif_writer.unparse(
         dn=','.join(['dc=%s' % s for s in fqdn.split('.')]),
         attrs=dict(objectClass=['dNSDomain', 'domainRelatedObject'],
                    dc=[fqdn.split('.')[0]],
                    associatedDomain=[fqdn],
                    aRecord=[addy],
		    soaRecord=["ns01.dfw01.socius.strings-service.net it.bitlancer.com 1 1800 3600 86400 7200"]))


def dump_sudoers_ou(ldif_writer):
   """
   Dump the sudoers ou and return an extended ldif_writer.
   """
   ldif_writer.unparse(
      dn='ou=sudoers',
      attrs=dict(ou=['sudoers'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=sudoers', ldif_writer)


def dump_sudoers_defaults(ldif_writer):
   """
   Dump the hard-coded sudoers defaults.

   As this is a leaf entry, don't return a new ldif writer.
   """
   ldif_writer.unparse(
      dn='cn=defaults',
      attrs=dict(cn=['defaults'],
                 objectClass=['sudoRole'],
                 description=['Default sudo options']))


def dump_sudoers(organization_id, db, ldif_writer):
   """
   Dump sudoers entries.

   Since these are leaf entries, do not return an ldif writer for
   extended writing.
   """
   for sudo in _select_sudo_info(organization_id, db):
      for select, cn_template in [("""
                                   SELECT t.id,
                                          d.name
                                   FROM team_device td INNER JOIN team_device_sudo tds
                                          ON td.id = tds.team_device_id
                                   INNER JOIN team t
                                          ON t.id = td.team_id
                                   INNER JOIN device d
                                          ON td.device_id = d.id
                                   INNER JOIN device_type dt
                                          ON dt.id = d.device_type_id
                                   WHERE t.organization_id = %(organization_id)s
                                           AND
                                         sudo_id = %(sudo_id)s
                                           AND
                                         t.is_disabled IS FALSE
                                           AND
                                         d.can_sync_to_ldap = 1
                                           AND
                                         dt.name = 'instance'
                                   ORDER BY t.id
                                   """,
                                   'team_device_%s_%s'),
                                  ("""
                                   SELECT t.id,
                                          d.name
                                   FROM team_role tr INNER JOIN team_role_sudo trs
                                          ON tr.id = trs.team_role_id
                                   INNER JOIN team t
                                          ON t.id = tr.team_id
                                   INNER JOIN device d
                                          ON tr.role_id = d.role_id
                                   INNER JOIN device_type dt
                                          ON dt.id = d.device_type_id
                                   WHERE t.organization_id = %(organization_id)s
                                           AND
                                         sudo_id = %(sudo_id)s
                                           AND
                                         t.is_disabled IS FALSE
                                           AND
                                         d.can_sync_to_ldap = 1
                                           AND
                                         dt.name = 'instance'
                                   ORDER BY t.id
                                   """,
                                   "team_role_%s_%s"),
                                  ("""
                                   SELECT t.id,
                                          d.name
                                   FROM team_formation tf INNER JOIN team_formation_sudo tfs
                                          ON tf.id = tfs.team_formation_id
                                   INNER JOIN team t
                                          ON t.id = tf.team_id
                                   INNER JOIN device d
                                          ON tf.formation_id = d.formation_id
                                   INNER JOIN device_type dt
                                          ON dt.id = d.device_type_id
                                   WHERE t.organization_id = %(organization_id)s
                                          AND
                                   sudo_id = %(sudo_id)s
                                          AND
                                   t.is_disabled IS FALSE
                                          AND
                                   d.can_sync_to_ldap = 1
                                          AND
                                   dt.name = 'instance'
                                   ORDER BY t.id
                                   """,
                                   "team_formation_%s_%s"),
                                  ("""
                                   SELECT t.id,
                                          d.name
                                   FROM team_application ta INNER JOIN team_application_sudo tas
                                          ON ta.id = tas.team_application_id
                                   INNER JOIN team t
                                          ON t.id = ta.team_id
                                   INNER JOIN application_formation af
                                          ON af.application_id = ta.application_id
                                   INNER JOIN device d
                                          ON af.formation_id = d.formation_id
                                   INNER JOIN device_type dt
                                          ON dt.id = d.device_type_id
                                   WHERE t.organization_id = %(organization_id)s
                                           AND
                                         sudo_id = %(sudo_id)s
                                           AND
                                         t.is_disabled IS FALSE
                                            AND
                                         d.can_sync_to_ldap = 1
                                            AND
                                         dt.name = 'instance'
                                   ORDER BY t.id
                                   """,
                                   "team_application_%s_%s")]:
         tids_dnames = select_rows(db,
                                   select,
                                   dict(organization_id=organization_id,
                                        sudo_id=sudo['sudo_id']))
         _dump_sudo_tids_dnames(sudo, cn_template,
                                tids_dnames, db, ldif_writer)


def dump_hiera_ou(ldif_writer):
   """
   Dump the top-level ou for hiera data, and return an extended
   ldif_writer.
   """
   ldif_writer.unparse(
      dn='ou=hiera',
      attrs=dict(ou=['hiera'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=hiera', ldif_writer)


def dump_librarian_ou(ldif_writer):
   """
   Dump the top-level ou for librarian data, and return an extended
   ldif_writer.
   """
   ldif_writer.unparse(
      dn='ou=librarian',
      attrs=dict(ou=['librarian'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=librarian', ldif_writer)


def dump_hiera_values(organization_id, db, ldif_writer):
   """
   Dump the entries for hiera values.

   This includes dumping parts of the hiera key path as ous, for
   example a hiera key of the form:

   production/dfw01/common

   would result in two ous:

   - ou=production

   - ou=dfw01,ou=production

   And a cn beneath:

   cn=common,ou=dfw01,ou=production

   where the var / vals for that key would be collected and exported
   as json in the description field of a 'device' entry (device is
   used purely for convenience).

   Since these are leaf entries, don't return an extended ldif writer.
   """
   hiera_keys_vars_vals = _select_all_hiera(organization_id, db)
   hiera_keys_vars_vals = list(hiera_keys_vars_vals)
   hiera_keys_vars_vals.sort()

   by_key = dict()

   for key, key_var_vals in itertools.groupby(hiera_keys_vars_vals,
                                             lambda x: x[0]):
      vars_vals = [(t[1], t[2]) for t in key_var_vals]
      vars_vals.sort()
      by_key[key] = vars_vals

   ou_names = set()
   for key in by_key.keys():
      for ou_name in _gen_hiera_ou_names(key):
         ou_names.add(ou_name)

   # make it easier to test
   ou_names = sorted(list(ou_names))

   _dump_hiera_ou_names(ou_names, ldif_writer)

   for key, vars_vals in sorted(by_key.items()):
      _dump_hiera_val(key, vars_vals, ldif_writer)


def _dump_hiera_val(key, vars_vals, ldif_writer):
   ldif_writer.unparse(
      dn=_dn_from_hiera_key(key),
      attrs=dict(objectClass=['device', 'top'],
                 cn=[key.split('/')[-1]],
                 description=[_descrip_from_hiera_vars_vals(vars_vals)]))


def _dn_from_hiera_key(hiera_key):
   if not "/" in hiera_key:
     return "cn=%s" % hiera_key
   segs = hiera_key.split('/')
   segs.reverse()
   return "cn=%s,%s" % (segs[0],
                        ','.join(['ou=%s' % s for s in segs[1:]]))


def _descrip_from_hiera_vars_vals(vars_vals):
   to_json = []
   vars_vals.sort()
   for var, var_val in itertools.groupby(vars_vals, lambda x: x[0]):
      var_val = list(var_val)
      if len(var_val) == 1:
         # If the val contains json, we need to parse it,
         # otherwise the call to dumps() will turn everything
         # into a string
         new_var_val = var_val[0][1]
         try:
             new_var_val = json.loads(var_val[0][1])
         except ValueError:
             new_var_val = var_val[0][1]
         to_json.append((var, new_var_val))
      else:
         to_json.append((var, [v[1] for v in var_val]))
   return json.dumps(dict(to_json), sort_keys=True)


def _dump_hiera_ou_names(ou_names, ldif_writer):
   for top, ou_name in ou_names:
      ldif_writer.unparse(
         dn=ou_name,
         attrs=dict(ou=[top],
                    objectClass=['organizationalUnit', 'top']))


def _gen_hiera_ou_names(hiera_key):
   segs = hiera_key.split('/')
   segs.reverse()
   for n in range(1, len(segs)):
      yield segs[n], ','.join(['ou=%s'% s for s in segs[n:]])


def _select_all_hiera(organization_id, db):
   """
   Return a list of tuples of:

   (hiera_key, var, val)

   for all hiera entries in the organization.
   """
   select = """
            SELECT hiera_key,
                   var,
                   val
              FROM hiera
              WHERE organization_id = %(organization_id)s
            """
   return select_rows(db, select, dict(organization_id=organization_id))


LibrarianInfo = namedtuple('LibrarianInfo', ['name',
                                             'type',
                                             'url',
                                             'reference',
                                             'path'])


def dump_librarian_values(organization_id, db, ldif_writer):
   """
   Dump the entries for librarian values.

   This includes dumping parts of the librarian module names as ous.

   For example, the following names:

   'puppetlabs/ntp'

   and

   'bitlancer/something'

   would result in the creation of two ous:

   - ou=bitlancer,ou=librarian,...

   - ou=puppetlabs,ou=librarian,...

   and below common names:

   - cn=ntp,ou=puppetlabs,ou=librarian,...

   - cn=something,ou=bitlancer,ou=librarian,...

   with a json in the description field of a 'device' entry (device is
   used purely for convenience), where the json consists of the
   following fields from mysql:

   {
     "name": module.name,
     "type": module_source.type,
     "url": module_source.url,
     "reference": module.reference,
     "path": module.path
   }

   Since these are leaf entries, don't return an extended ldif writer.
   """
   librarian_infos = _select_librarian_infos(organization_id, db)
   names = [li.name for li in librarian_infos]
   # sort to make it easier to test
   ou_names = sorted(list(set([name.split('/')[0] for name in names])))

   _dump_librarian_ou_names(ou_names, ldif_writer)

   for li in librarian_infos:
      _dump_librarian_entry(li, ldif_writer)


def _dump_librarian_entry(librarian_info, ldif_writer):
   ldif_writer.unparse(
      dn=_dn_from_librarian_name(librarian_info.name),
      attrs=dict(objectClass=['device', 'top'],
                 cn=[librarian_info.name.split('/')[1]],
                 description=[_descrip_from_librarian_info(librarian_info)]))


def _dn_from_librarian_name(name):
   fst, snd = name.split('/')
   return "cn=%s,ou=%s" % (snd, fst)


def _descrip_from_librarian_info(librarian_info):
   return json.dumps(dict(name=librarian_info.name,
                          type=librarian_info.type,
                          url=librarian_info.url,
                          reference=librarian_info.reference,
                          path=librarian_info.path),
                     sort_keys=True)


def _dump_librarian_ou_names(ou_names, ldif_writer):
   for ou_name in ou_names:
      ldif_writer.unparse(
         dn="ou=%s" % ou_name,
         attrs=dict(ou=[ou_name],
                    objectClass=['organizationalUnit', 'top']))


def _select_librarian_infos(organization_id, db):
   select = """
            SELECT m.name,
                   ms.type,
                   ms.url,
                   m.reference,
                   m.path
            FROM module m LEFT OUTER JOIN
                 module_source ms ON m.module_source_id = ms.id
            WHERE m.organization_id = %(organization_id)s
            """
   rows = select_rows(db, select, dict(organization_id=organization_id))

   return [LibrarianInfo(name=row[0],
                         type=row[1],
                         url=row[2],
                         reference=row[3],
                         path=row[4])
           for row
           in rows]


def _dump_sudo_tids_dnames(sudo, cn_template,
                           tids_dnames, db, ldif_writer):
   for team_id, tid_and_dnames in itertools.groupby(tids_dnames, lambda x: x[0]):
      device_names = sorted(list(set([td[1] for td in tid_and_dnames])))
      team_name, members = _select_sudo_team_name_and_members(
         team_id,
         db)
      cn = cn_template % (_safe_team_name(team_name),
                          sudo['sudo_role'])
      ldif_writer.unparse(
         dn='cn=%s' % cn,
         attrs=dict(cn=[cn],
                    objectClass=['sudoRole'],
                    sudoCommand=sorted(sudo['sudo_command']),
                    sudoHost=sorted(device_names),
                    sudoRunAsUser=sorted(sudo['sudo_run_as']),
                    sudoOption=sorted(sudo['sudo_option']),
                    description=sudo['description'],
                    sudoUser=sorted(members)))


def _safe_team_name(team_name):
   return team_name.replace(' ', '_')


def _select_sudo_team_name_and_members(team_id, db):
   select_name = """
                 SELECT name
                   FROM team
                   WHERE id = %(team_id)s
                 """
   team_name = select_val(db, select_name, dict(team_id=team_id))
   select_members = """
                    SELECT u.name
                      FROM user u INNER JOIN user_team ut
                             ON u.id = ut.user_id
                      WHERE u.is_disabled IS FALSE
                              AND
                            ut.team_id = %(team_id)s
                    """
   members = [r[0] for r in select_rows(db, select_members,
                                        dict(team_id=team_id))]
   return team_name, members


def _select_sudo_team_ids_device_names(organization_id, sudo_id, db):
   select = """
            SELECT td.team_id,
                   d.name
              FROM team_device td INNER JOIN team_device_sudo tds
                     ON td.id = tds.team_device_id
                   INNER JOIN device d
                     ON td.device_id = d.id
                   INNER JOIN device_type dt
                     ON dt.id = d.device_type_id
              WHERE organization_id = %(organization_id)s
                      AND
                    sudo_id = %(sudo_id)s
                      AND
                    d.can_sync_to_ldap = 1
                      AND
                    dt.name = 'instance'
            """
   return select_rows(db, select, dict(organization_id=organization_id,
                                       sudo_id=sudo_id))


def dump_ldap_ou(ldif_writer):
   """
   Dump the ldap ou and return an extended ldif_writer for further
   entries.
   """
   ldif_writer.unparse(
      dn='ou=ldap',
      attrs=dict(ou=['ldap'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=ldap', ldif_writer)


def dump_ldap_groups_ou(ldif_writer):
   """
   Dump the ldap groups ou and return an extended ldif_writer for
   further entries.
   """
   ldif_writer.unparse(
      dn='ou=groups',
      attrs=dict(ou=['groups'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=groups', ldif_writer)


def dump_ldap_ro_group(organization_id, member_dn, db, ldif_writer):
   """
   Dump the ro ldap group with the members.

   As this is a leaf entry, don't return a new ldif_writer.

   - `member_dn`: e.g ou=users,ou=ldap,.... is appended to each member
     uid when writing the group.
   """
   names_and_passwords = _select_ldap_names_and_passwords(organization_id, db)

   if names_and_passwords:
      ldif_writer.unparse(
         dn='cn=ro',
         attrs=dict(cn=['ro'],
                    objectClass=['groupOfNames'],
                    member=['uid=%s,%s' % (ldap_name_and_password[0], member_dn)
                            for ldap_name_and_password
                            in names_and_passwords]))


def dump_ldap_users_ou(ldif_writer):
   """
   Dump the ou=users in ldap, and return an extended ldif writer for
   the user entries.
   """
   ldif_writer.unparse(
      dn='ou=users',
      attrs=dict(ou=['users'],
                 objectClass=['organizationalUnit']))
   return build_dn('ou=users', ldif_writer)


def dump_ldap_users(organization_id, db, ldif_writer):
   """
   Dump the entries under ou=users,ou=ldap.

   Since these are leaf entries, don't return an ldif_writer for
   extended writing.
   """
   unames_and_passwords = _select_ldap_names_and_passwords(organization_id,
                                                           db)
   for uname, password in unames_and_passwords:
      ldif_writer.unparse(
         dn='uid=%s' % uname,
         attrs=dict(uid=[uname],
                    objectClass=['inetOrgPerson'],
                    cn=['%s user' % uname],
                    sn=['%s user' % uname],
                    userPassword=['{SHA}%s' % _sha1(password)]))


def _select_ldap_names_and_passwords(organization_id, db):
   select = """
            SELECT var,
                   val
              FROM hiera
              WHERE (
                      var LIKE 'ldap_%%_username'
                        OR
                      var LIKE 'ldap_%%_password'
                    )
                      AND
                    organization_id = %(organization_id)s
            """
   rows = select_rows(db, select, dict(organization_id=organization_id))
   rows = [(_extract_ldap_grist(var), var, val)
           for var, val
           in rows]
   rows.sort()

   users_and_passwords = []

   for ldap_grist, grouped_rows in  itertools.groupby(rows, lambda r: r[0]):
      if ldap_grist is None:
         raise Exception("Could not extract ldap grist from vars %s" %
                         list(grouped_rows))
      ldap_password = None
      ldap_username = None

      for _grist, var, val in grouped_rows:
         if var.endswith('_username'):
            if ldap_username is not None:
               raise Exception("Two usernames for ldap grist %s" % ldap_grist)
            ldap_username = val
         if var.endswith('_password'):
            if ldap_password is not None:
               raise Exception("Two passwords for ldap grist %s" % ldap_grist)
            ldap_password = val
      if ldap_password is None:
         raise Exception("No password for ldap grist %s" % ldap_grist)
      if ldap_username is None:
         raise Exception("No username for ldap grist %s" % ldap_grist)
      users_and_passwords.append((ldap_username, ldap_password))

   # make this predictable and easier to test
   users_and_passwords.sort()

   return users_and_passwords


LDAP_GRIST_RE = re.compile('^ldap_([^_]+)_[^_]+$')


def _extract_ldap_grist(ldap_str):
   """
   For values of the form:

   ldap_<something>_<something2>

   extract <something>

   Return None if extraction couldn't be done.
   """
   m = LDAP_GRIST_RE.match(ldap_str)
   if m:
      return m.group(1)
   else:
      return None


def _select_sudo_info(organization_id, db):
   """
   Return a list of dicts with sudo info including:

   - sudo_id (id from the db, for use in later selects etc.)

   - sudo_role (str)

   - description (list of len 1)

   - sudo_command (list of commands)

   - sudo_run_as (list of users)

   - sudo_option (list of options)
   """
   sudo_ids_names = _select_sudo_ids_names(organization_id, db)
   # dicts by id of the sudo
   sudos = defaultdict(lambda: defaultdict(list))
   for sudo_id, name in sudo_ids_names:
      sudos[sudo_id]['sudo_role'] = name
      # this is generated, always
      sudos[sudo_id]['description'].append('%s sudo role' % name)
      for a_name, a_value in _select_sudo_attrs(sudo_id, db):
         if a_name == 'sudoCommand':
            sudos[sudo_id]['sudo_command'].append(a_value)
         elif a_name == 'sudoRunAs':
            sudos[sudo_id]['sudo_run_as'].append(a_value)
         elif a_name == 'sudoOption':
            sudos[sudo_id]['sudo_option'].append(a_value)
         else:
            raise Exception("Did not recognize sudo attr %s" % a_name)

   for sudo_id, sudo_dict in sudos.items():
      sudo_dict['sudo_id'] = sudo_id
   sudos = [(s['sudo_role'], s) for s in sudos.values()]
   # sort to make it easier to test
   sudos.sort()
   sudos = [s[1] for s in sudos]
   return sudos


def _select_sudo_users(organization_id, sudo_id, db):
   # here you are edmund
   return []


def _select_sudo_attrs(sudo_id, db):
   select = """
            SELECT name,
                   value
              FROM sudo_attribute
              WHERE sudo_id = %(sudo_id)s
            """
   return select_rows(db, select, dict(sudo_id=sudo_id))


def _select_sudo_ids_names(organization_id, db):
   # note that is_hidden is about display and not consulted here
   select = """
            SELECT id,
                   name
              FROM sudo
              WHERE organization_id = %(organization_id)s
            """
   return select_rows(db, select, dict(organization_id=organization_id))


def _dump_dc_objects(device_fqdns_addys, ldif_writer):
   dc_objects = set()
   for fqdn, addy in device_fqdns_addys:
      for dc_object in _dc_objects_from_fqdn(fqdn):
         dc_objects.add(tuple(dc_object))

   dc_objects = list(dc_objects)
   # make it easy to test this b/c determinable
   dc_objects.sort()

   for dc_object in dc_objects:
      dc = dc_object[0]
      ldif_writer.unparse(
         dn=','.join(['dc=%s' % d for d in dc_object]),
         attrs=dict(dc=[dc],
                    objectClass=['dcObject', 'dNSDomain']))


def _dc_objects_from_fqdn(fqdn):
   segs = fqdn.split('.')
   segs.reverse()
   for seg_len in range(1, len(segs)):
      yield reversed(segs[:seg_len])


def _select_device_info_for_hosts(dns_attr, organization_id, db):
   select = """
            SELECT d.id,
                   da.var,
                   da.val
              FROM device d INNER JOIN device_attribute da
                     ON d.id = da.device_id
                    INNER JOIN device_type dt
                      ON d.device_type_id = dt.id
              WHERE d.organization_id = %(organization_id)s
                      AND
                    da.var IN ('dns.internal.fqdn', '{dns_attr}')
                      AND
                    d.can_sync_to_ldap = 1
                      AND
                    dt.name = 'instance'
            """.format(dns_attr=dns_attr)
   rows = select_rows(db, select, dict(organization_id=organization_id))

   devices = defaultdict(dict)
   for (device_id, var, val) in rows:
      if var == 'dns.internal.fqdn':
         devices[device_id]['fqdn'] = val
      elif var == dns_attr:
         devices[device_id]['dns'] = val
      else:
         raise Exception("Bad var name %s" % var)

   device_infos = []
   for device_id, attrs in devices.items():
      if len(attrs) != 2:
         raise Exception("Device id %s only had host attrs %s" %
                         (device_id, attrs))
      device_infos.append((attrs['fqdn'], attrs['dns']))
      for device_dns_fqdn in _select_device_dns_fqdn(device_id, db):
         device_infos.append((device_dns_fqdn, attrs['dns']))

   return device_infos


def _select_device_dns_fqdn(device_id, db):
   select = """
            SELECT name
              FROM device_dns
              WHERE device_id = %(device_id)s
            """
   return [r[0] for r in select_rows(db, select, dict(device_id=device_id))]


def _select_dns_int_config_attr(organization_id, db):
   select = """
            SELECT val
              FROM config
              WHERE var = 'dns.internal.network_attribute'
                      AND
                    organization_id = %(organization_id)s
            """
   return select_val(db, select, dict(organization_id=organization_id))


def _user_ids_and_names_for_posix_groups(organization_id, db):
   """
   Return the user ids and names for all users, disabled or not, in
   the organization, for user in creating posix groups.
   """
   select = """
            SELECT id,
                   name
              FROM user
              WHERE organization_id = %(organization_id)s
           """
   return select_rows(db, select, dict(organization_id=organization_id))


def _deactivate_disabled_posix_users(users):
   for user in users:
      if user['is_disabled'] or not user['posix_login_shell']:
         user['posix_login_shell'] = '/usr/sbin/nologin'
         user['formatted_password'] = '{MD5}!'
         user['host'] = []
         user['authorized_service'] = []


def _select_posix_users(organization_id, db):
   """
   Get back the user data needed for creation of posix users in a dict
   for each user with the following keys:

   - name

   - first_name

   - last_name

   - formatted_password

   - is_disabled

   - posix_login_shell

   - posix_uid_num

   - host

   - authorized_service

   - ssh_public_key
   """
   user_fields = ['id',
                  'name',
                  'first_name',
                  'last_name',
                  'password',
                  'is_disabled']

   s_user = """
            SELECT {user_fields}
              FROM user
              WHERE organization_id = %(organization_id)s
            """.format(user_fields=', '.join(user_fields))

   users = [dict(zip(user_fields, row))
            for row
            in select_rows(db,
                           s_user,
                           dict(organization_id=organization_id))]

   for user in users:
      user['formatted_password'] = "{SHA}%s" % user['password']
      # just make it a little harder to screw this up downstram
      del user['password']

   for user in users:
      user['posix_uid_num'] = _select_posix_uid_num(db, user['id'])
      user['posix_login_shell'] = _select_posix_login_shell(db, user['id'])
      user['authorized_service'] = ['*']
      user['host'] = _hosts_for_posix_user(user['id'],
                                           organization_id,
                                           db)
      user['ssh_public_key'] = _public_keys_for_posix_user(
         user['id'],
         organization_id,
         db)

   return users


def _public_keys_for_posix_user(user_id, organization_id, db):
   select = """
            SELECT public_key
              FROM user_key
              WHERE organization_id = %(organization_id)s
                      AND
                    user_id = %(user_id)s
            """
   return [r[0]
           for r
           in select_rows(db,
                          select,
                          dict(organization_id=organization_id,
                               user_id=user_id))]


def _hosts_for_posix_user(user_id, organization_id, db):
   """
   Note that we don't care if the user is disabled, as hosts will be
   removed later for a disabled user, but we do care very much if the
   teams are disabled.
   """
   # access to a host can be granted through:
   #
   # team access to a device
   #
   # team access to a formation (which carries to devices)
   #
   # team access to an application (which carries to formations, which
   # carries to devices)
   #
   # team to role to device
   #
   selects = ["""
              SELECT da.val
                FROM user u INNER JOIN user_team ut
                       ON u.id = ut.user_id
                     INNER JOIN team t
                       ON ut.team_id = t.id
                     INNER JOIN team_formation tf
                       ON tf.team_id = t.id
                     INNER JOIN device d
                       ON tf.formation_id = d.formation_id
                     INNER JOIN device_attribute da
                       ON da.device_id = d.id
                     INNER JOIN device_type dt
                       ON dt.id = d.device_type_id
               WHERE t.is_disabled IS FALSE
                       AND
                     t.organization_id = %(organization_id)s
                       AND
                     u.id = %(user_id)s
                       AND
                     da.var = 'dns.external.fqdn'
                       AND
                     d.can_sync_to_ldap = 1
                       AND
                     dt.name = 'instance'
              """,
              """
              SELECT da.val
                FROM user u INNER JOIN user_team ut
                       ON u.id = ut.user_id
                     INNER JOIN team t
                       ON ut.team_id = t.id
                     INNER JOIN team_application ta
                       ON ta.team_id = t.id
                     INNER JOIN application_formation af
                       ON af.application_id = ta.application_id
                     INNER JOIN device d
                       ON af.formation_id = d.formation_id
                     INNER JOIN device_attribute da
                       ON da.device_id = d.id
                     INNER JOIN device_type dt
                       ON dt.id = d.device_type_id
               WHERE t.is_disabled IS FALSE
                       AND
                     t.organization_id = %(organization_id)s
                       AND
                     u.id = %(user_id)s
                       AND
                     da.var = 'dns.external.fqdn'
                       AND
                     d.can_sync_to_ldap = 1
                       AND
                     dt.name = 'instance'
              """,
              """
              SELECT da.val
                FROM user u INNER JOIN user_team ut
                       ON u.id = ut.user_id
                     INNER JOIN team t
                       ON ut.team_id = t.id
                     INNER JOIN team_device td
                       ON td.team_id = t.id
                     INNER JOIN device_attribute da
                       ON da.device_id = td.device_id
                     INNER JOIN device d
                       ON td.device_id = d.id
                     INNER JOIN device_type dt
                       ON dt.id = d.device_type_id
               WHERE t.is_disabled IS FALSE
                       AND
                     t.organization_id = %(organization_id)s
                       AND
                     u.id = %(user_id)s
                       AND
                     da.var = 'dns.external.fqdn'
                       AND
                     d.can_sync_to_ldap = 1
                       AND
                     dt.name = 'instance'
              """,
              """
              SELECT da.val
                FROM user u INNER JOIN user_team ut
                       ON u.id = ut.user_id
                     INNER JOIN team t
                       ON ut.team_id = t.id
                     INNER JOIN team_role tr
                       ON tr.team_id = t.id
                     INNER JOIN device d
                       ON tr.role_id = d.role_id
                     INNER JOIN device_attribute da
                       ON da.device_id = d.id
                     INNER JOIN device_type dt
                       ON dt.id = d.device_type_id
               WHERE t.is_disabled IS FALSE
                       AND
                     t.organization_id = %(organization_id)s
                       AND
                     u.id = %(user_id)s
                       AND
                     da.var = 'dns.external.fqdn'
                       AND
                     d.can_sync_to_ldap = 1
                       AND
                     dt.name = 'instance'
              """]
   hosts = []
   for select in selects:
      hosts.extend([r[0]
                    for r
                    in select_rows(db,
                                   select,
                                   dict(organization_id=organization_id,
                                        user_id=user_id))])

   hosts = list(set(hosts))
   # make it easier to test these
   hosts.sort()
   return hosts


def _dump_posix_user_to_ldif(user, ldif_writer):
   ldif_writer.unparse(
      dn="uid=%s" % user['name'],
      attrs=dict(objectClass=['inetOrgPerson',
                              'posixAccount',
                              'authorizedServiceObject',
                              'hostObject',
                              'ldapPublicKey'],
                 uidNumber=[user['posix_uid_num']],
                 gidNumber=[user['posix_uid_num']],
                 loginShell=[user['posix_login_shell']],
                 userPassword=[user['formatted_password']],
                 cn=[" ".join([user['first_name'],
                               user['last_name']])],
                 givenName=[user['first_name']],
                 homeDirectory=['/home/%s' % user['name']],
                 sn=[user['last_name']],
                 uid=[user['name']],
                 authorizedService=user['authorized_service'],
                 host=user['host'],
                 sshPublicKey=user['ssh_public_key']))


def _select_posix_login_shell(db, user_id):
   """
   Returns None if not found, will be handled later.

   Multiple values will cause a kersplosion in the form of an
   exception.
   """
   sql = """
         SELECT val
           FROM user_attribute
           WHERE var = 'posix.shell'
                   AND
                 user_id = %(user_id)s
         """
   return select_val(db, sql, dict(user_id=user_id))


def _select_posix_uid_num(db, user_id):
   """
   Returns None if not found, will be handled later.

   Multiple values will cause a kersplosion in the form of an
   exception.
   """
   sql = """
         SELECT val
           FROM user_attribute
           WHERE var = 'posix.uid'
                   AND
                 user_id = %(user_id)s
         """
   return select_val(db, sql, dict(user_id=user_id))


def _select_devices(organization_id, db):
   """
   Return a dict of env, role, external_fqdn for each device in the
   indicated organization.
   """
   select = """
            SELECT e.name,
                   r.name,
                   a.val
               FROM device d INNER JOIN environment e
                      ON d.environment_id = e.id
                    INNER JOIN role r
                      ON d.role_id = r.id
                    INNER JOIN device_attribute a
                      ON d.id = a.device_id
                    INNER JOIN device_type dt
                      ON d.device_type_id = dt.id
               WHERE a.var = 'dns.external.fqdn'
                       AND
                     d.organization_id = %(organization_id)s
                      AND
                    d.can_sync_to_ldap = 1
                      AND
                    dt.name = 'instance'
            """
   return [dict(environment=r[0],
                role=r[1],
                external_fqdn=r[2])
           for r
           in select_rows(db, select, dict(organization_id=organization_id))]


def _data_center(fqdn):
   segs = fqdn.split('.')
   if len(segs) < 2:
      raise Exception("FQDN has no data center %s" % fqdn)
   return segs[1]


def _select_device_fqdns(organization_id, db):
   select = """
            SELECT val
              FROM device_attribute
              WHERE var = 'dns.external.fqdn'
                      AND
                    organization_id = %(organization_id)s
            """
   return [r[0]
           for r
           in select_rows(db,
                          select,
                          dict(organization_id=organization_id))]


def _select_active_user_data(organization_id, db):
   """
   Return a list of dicts of active user data for the organization.

   The dict fields are:

   - name

   - first_name

   - password

   - first_name

   - last_name
   """
   fields = ['name',
             'first_name',
             'password',
             'first_name',
             'last_name']
   select = """
            SELECT {fields}
              FROM user
              WHERE is_disabled IS FALSE
                      AND
                    organization_id = %(organization_id)s
            """.format(fields=', '.join(fields))

   return [dict(zip(fields, row))
           for row
           in select_rows(db, select, dict(organization_id=organization_id))]


def _format_member(member_name, member_dn):
   return 'uid=%s,%s' % (member_name, member_dn)


def _select_active_team_member_names(team_id, db):
   select = """
            SELECT u.name
              FROM user u
                INNER JOIN user_team ut
                  ON u.id = ut.user_id
              WHERE u.is_disabled IS FALSE
                      AND
                    ut.team_id = %(team_id)s
            """
   return [r[0] for r in select_rows(db, select, dict(team_id=team_id))]


def _select_active_teams(organization_id, db):
   select = """
            SELECT id,
                   name
              FROM team
              WHERE is_disabled IS FALSE
                      AND
                    organization_id = %(organization_id)s
            """
   return select_rows(db, select, dict(organization_id=organization_id))


def organization_name(organization_id, db):
   """
   Get the name of an organization.
   """
   select = """
            SELECT name
              FROM organization
              WHERE id = %(organization_id)s
            """
   row = select_row(db, select, dict(organization_id=organization_id))
   if not row:
      return None
   else:
      return row[0]


def organization_dn(organization_id, db):
   select = """
             SELECT val
               FROM config
               WHERE
                 organization_id = %(organization_id)s
                   AND
                 var = 'ldap.basedn'
             """
   rows = select_rows(db, select, dict(organization_id=organization_id))
   if not rows:
      raise NoLdapDomain("No ldap.basedn for organization %s",
                        organization_id)
   if len(rows) > 1:
      raise AmbiguousLdapDomain("Multiple values for ldap.basedn %s" %
                               str(rows))
   ldap_domain = rows[0][0]
   return ldap_domain


def _org_dc_from_dn(dn):
   segs = dn.split(',')
   dc1 = segs[0]
   if not dc1.startswith('dc='):
      raise ValueError("org dn %s didn't start with dc=")
   else:
      return dc1[len('dc='):]


def _sha1(s):
    sha1 = hashlib.sha1()
    sha1.update(s)
    return base64.b64encode(sha1.digest())


if __name__ == '__main__':
   db_ini_fname = sys.argv[1]
   org_id = sys.argv[2]
   with open(db_ini_fname, 'rb') as db_ini_fil:
      db_config_parser = SafeConfigParser()
      db_config_parser.readfp(db_ini_fil)
      db_server = open_conn(db_config_parser)
      mysql2ldif(org_id, db_server, sys.stdout)
