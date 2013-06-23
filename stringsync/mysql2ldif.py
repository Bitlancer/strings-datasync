"""
Dump the strings mysql data for a given organization to a full ldif.
"""

from stringsync.db import select_row, select_rows
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


def dump_people_ou(db, ldif_writer):
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


def dump_people_groups_ou(db, ldif_writer):
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


