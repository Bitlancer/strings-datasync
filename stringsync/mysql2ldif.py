#!/usr/bin/env python

import logging
import sys

from ldif import LDIFWriter

from db import open_conn
from stringsync import organizations
from stringsync.organizations import find_organization, Organization
from stringsync import sudoers


def _organization_dict(organization):
   return dict(objectclass=['organization', 'dcObject'],
               dc=[organizations.dc(organization)],
               o=[organizations.o(organization)])


def _dump_organization(curs, ldif_writer, organization):
    ldif_writer.unparse(organizations.dn(organization),
                        _organization_dict(organization))


def _dump_user_ous(ldif_writer, organization):
    """
    Dump the organizational units that should always be there for
    users, namely: people, and under that, groups and users.
    """
    ldif_writer.unparse(
        "ou=people,%s" % organizations.dn(organization),
        dict(ou=["people"],
             objectclass=['organizationalUnit']))

    ldif_writer.unparse(
        "ou=groups,ou=people,%s" % organizations.dn(organization),
        dict(ou=["groups"],
             objectclass=['organizationalUnit']))

    ldif_writer.unparse(
        "ou=users,ou=people,%s" % organizations.dn(organization),
        dict(ou=["users"],
             objectclass=['organizationalUnit']))


def _dump_sudos(curs, ldif_writer, organization):
    # TODO: make these all programmatic if they continue to fit
    # pattern, and ask matty j where they come from
    ldif_writer.unparse(
        "ou=unix,%s" % organizations.dn(organization),
        dict(objectclass=["organizationalUnit"],
             ou=["unix"]))

    ldif_writer.unparse(
        "ou=sudoers,ou=unix,%s" % organizations.dn(organization),
        dict(objectclass=["organizationalUnit"],
             ou=["sudoers"]))

    # TODO: ask matt where this comes from...
    ldif_writer.unparse(
        "cn=defaults,ou=sudoers,ou=unix,%s" % organizations.dn(organization),
        dict(objectclass=["sudoRole"],
             description=["Default sudo options"],
             cn=["defaults"]))

    for sudo_info in sudoers.find_all(curs, organization_id=organization.id):
        _dump_sudo(sudo_info, organization, ldif_writer)


def _dump_sudo(sudo_info, organization, ldif_writer):
    attrs_with_list_vals = dict([(name, [val])
                                 for name, val
                                 in sudo_info.attributes.items()])

    ldif_writer.unparse("cn=%s,ou=sudoers,ou=unix,%s" %
                        (sudo_info.name, organizations.dn(organization)),
                        dict(description=["%s sudo role" % sudo_info.name],
                             objectclass=["sudoRole"],
                             sudouser=sudo_info.users,
                             **attrs_with_list_vals))


# TODO: ask mj...is sudohost important?  It's not here.


def _dump_users(curs, ldif_writer, organization):
    _dump_user_ous(ldif_writer, organization)
    # TODO: user records

class SortedLdifWriter(object):

   def __init__(self, ldif_writer):
      self.ldif_writer = ldif_writer
      self.buffer = []

   def unparse(self, dn, attrs):
      self.buffer.append((dn, attrs))

   def write(self):
      self.buffer.sort()
      for (dn, attrs) in self.buffer:
         self.ldif_writer.unparse(dn, attrs)


def dump_ldif(conn, outfile, organization_id):
    ldif_writer = LDIFWriter(outfile)
    sorted_ldif_writer = SortedLdifWriter(ldif_writer)
    curs = conn.cursor()
    organization = organizations.find_organization(curs, organization_id)
    _dump_organization(curs, sorted_ldif_writer, organization)
    _dump_users(curs, sorted_ldif_writer, organization)
    _dump_sudos(curs, sorted_ldif_writer, organization)
    sorted_ldif_writer.write()

    # TODO: hosts

    # TODO: a group for each user as well
