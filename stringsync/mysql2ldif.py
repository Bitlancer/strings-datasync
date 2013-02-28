#!/usr/bin/env python

import logging
import sys

from ldif import LDIFWriter

from db import open_conn
from organizations import find_organizations, Organization


# TODO: ewj make sure that everything is sorted...

def _organization_dn(organization):
    return organization.name


def _organization_dc(organization):
    return [organization.short_name]


def _organization_o(organization):
    return [organization.name]


def _organization_dict(organization):
   return dict(objectclass=['organization', 'dcObject'],
               dc=_organization_dc(organization),
               o=_organization_o(organization))



def _dump_organization(organization, ldif_writer):
    ldif_writer.unparse(_organization_dn(organization),
                        _organization_dict(organization))


def _dump_organizations(curs, ldif_writer):
    organizations = find_organizations(curs)
    for organization in organizations:
        _dump_organization(organization, ldif_writer)

def dump_ldif(outfile):
    ldif_writer = LDIFWriter(outfile)
    conn = open_conn()
    curs = conn.cursor()

    _dump_organizations(curs, ldif_writer)

if __name__ == '__main__':
    dump_ldif(sys.stdout)
