from stringsync.ldif_writers import SortedLdifWriter

from ldif import LDIFWriter
import ldap


def dump_tree_sorted(ldap_server, base_domain, out_fil):
    diff_writer = SortedLdifWriter(LDIFWriter(out_fil))
    for dn, attrs in ldap_server.search_s(base_domain, ldap.SCOPE_SUBTREE):
        diff_writer.unparse(dn, attrs)
    diff_writer.commit()
