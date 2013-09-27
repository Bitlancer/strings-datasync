from StringIO import StringIO

from stringsync.ldif_writers import SortedLdifWriter

from ldif import LDIFWriter
import ldap


def dump_tree_sorted(ldap_uri, auth_name, auth_pass, base_domain):
    stringio = StringIO()
    diff_writer = SortedLdifWriter(LDIFWriter(stringio))
    l = ldap.initialize(ldap_uri)
    l.simple_bind_s(auth_name, auth_pass)
    for dn, attrs in l.search_s(base_domain, ldap.SCOPE_SUBTREE):
        diff_writer.unparse(dn, attrs)
    diff_writer.commit()
    return stringio.getvalue()
