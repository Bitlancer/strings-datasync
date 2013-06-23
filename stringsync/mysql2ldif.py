"""
Dump the strings mysql data for a given organization to a full ldif.
"""

from stringsync.db import select_row, select_rows, select_val
from stringsync.ldif_writers import build_dn, full_dn


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
                                  structuralObjectClass=['organization'],
                                  o=[full_name],
                                  dc=[_org_dc_from_dn(org_dn)]))
   return build_dn(org_dn, ldif_writer), org_dn


def dump_people_ou(ldif_writer):
   """
   Returns the extended ldif writer of the people ou for use in
   tree-like dumping.
   """
   ldif_writer.unparse(dn='ou=people',
                       attrs=dict(
         objectClass=['organizationalUnit'],
         structuralObjectClass=['organizationalUnit'],
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
         objectClass=['organizationalUnit'],
         structuralObjectClass=['organizationalUnit']))
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
               structuralObjectClass=['groupOfNames'],
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
         objectClass=['organizationalUnit'],
         structuralObjectClass=['organizationalUnit']))
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
                    structuralObjectClass=['inetOrgPerson'],
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
                 objectClass=['organizationalUnit'],
                 structuralObjectClass=['organizationalUnit']))
   return build_dn('ou=nodes', ldif_writer)


def dump_data_centers(organization_id, db, ldif_writer):
   """
   Dump the data centers as organizational units.

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
                    structuralObjectClass=['organizationalUnit'],
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
                    structuralObjectClass=['device'],
                    description=[device['role']],
                    puppetClass=[device['role']],
                    cn=[fqdn]))


def dump_posix_ou(ldif_writer):
   """
   Dump the posix organizational unit to the ldif writer.

   Return an extended ldif writer for child entries.
   """
   ldif_writer.unparse(
      dn='ou=posix',
      attrs=dict(ou=['unix', 'posix'],
                 structuralObjectClass=['organizationalUnit'],
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
                 structuralObjectClass=['organizationalUnit'],
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
                    objectClass=['posixGroup'],
                    structuralObjectClass=['posixGroup']))


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
                 structuralObjectClass=['organizationalUnit'],
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
         user['ssh_public_key'] = []


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
               WHERE t.is_disabled IS FALSE
                       AND
                     t.organization_id = %(organization_id)s
                       AND
                     u.id = %(user_id)s
                       AND
                     da.var = 'dns.external.fqdn'
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
               WHERE t.is_disabled IS FALSE
                       AND
                     t.organization_id = %(organization_id)s
                       AND
                     u.id = %(user_id)s
                       AND
                     da.var = 'dns.external.fqdn'
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
                              'hostObject'],
                 structuralObjectClass=['inetOrgPerson'],
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
   Return a dict of role, external_fqdn for each device in the
   indicated organization.
   """
   select = """
            SELECT r.name,
                   a.val
               FROM device d LEFT OUTER JOIN role r
                      ON d.role_id = r.id
                    LEFT OUTER JOIN device_attribute a
                      ON d.id = a.device_id
               WHERE a.var = 'dns.external.fqdn'
                       AND
                     d.organization_id = %(organization_id)s
            """
   return [dict(role=r[0],
                external_fqdn=r[1])
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
                 var = 'ldap.domain'
             """
   rows = select_rows(db, select, dict(organization_id=organization_id))
   if not rows:
      raise NoLdapDomain("No ldap.domain for organization %s",
                        organization_id)
   if len(rows) > 1:
      raise AmbiguousLdapDomain("Multiple values for ldap.domain %s" %
                               str(rows))
   ldap_domain = rows[0][0]
   return _format_org_dn(ldap_domain)


def _format_org_dn(ldap_domain):
   return ','.join(["dc=%s" % s for s in ldap_domain.split('.')])


def _org_dc_from_dn(dn):
   segs = dn.split(',')
   dc1 = segs[0]
   if not dc1.startswith('dc='):
      raise ValueError("org dn %s didn't start with dc=")
   else:
      return dc1[len('dc='):]


