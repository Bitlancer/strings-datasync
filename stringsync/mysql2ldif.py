#!/usr/bin/env python

import logging
import sys

from ldif import LDIFWriter

from db import open_conn
from organizations import find_organization, Organization


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


def _dump_organization(curs, ldif_writer, organization_id):
    organization = find_organization(curs, organization_id)
    ldif_writer.unparse(_organization_dn(organization),
                        _organization_dict(organization))


def dump_ldif(conn, outfile, organization_id):
    ldif_writer = LDIFWriter(outfile)
    curs = conn.cursor()
    _dump_organization(curs, ldif_writer, organization_id)
