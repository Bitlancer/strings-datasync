"""
Dump the strings mysql data for a given organization to a full ldif.
"""

class NoDnsDomain(Exception):
   """
   Raised when an organization has no dns.external.domain config
   value.
   """
   pass


class AmbiguousDnsDomain(Exception):
   """
   Raised when an organization has multiple dns.external.domain config
   values.
   """
   pass


def organization_dn(organization_id, db):
   select = """
             SELECT val
               FROM config
               WHERE
                 organization_id = %(organization_id)s
                   AND
                 var = 'dns.external.domain'
             """
   curs = db.cursor()
   try:
      curs.execute(select, dict(organization_id=organization_id))
      rows = curs.fetchall()
      if not rows:
         raise NoDnsDomain("No dns.external.domain for organization %s",
                           organization_id)
      if len(rows) > 1:
         raise AmbiguousDnsDomain("Multiple values for dns.external.domain %s" %
                                  str(rows))
      dns_external_domain = rows[0][0]
      return _format_org_dn(dns_external_domain)
   finally:
      if curs:
         curs.close()


def _format_org_dn(dns_external_domain):
   return ','.join(["dc=%s" % s for s in dns_external_domain.split('.')])
