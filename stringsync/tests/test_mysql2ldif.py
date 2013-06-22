from ConfigParser import SafeConfigParser

from nose.tools import ok_, eq_

from stringsync import db
from stringsync.mysql2ldif import organization_dn
from stringsync import fixtures


class TestMysql2Ldif(object):

    def setUp(self):
        db.start_test()
        config_parser = SafeConfigParser()

        with open('db.ini', 'rb') as fil:
            config_parser.readfp(fil)
            self.conn = db.open_conn(config_parser)
        # in case stuff wasn't cleaned up
        fixtures.clean_all(self.conn)

    def tearDown(self):
        fixtures.clean_all(self.conn)
        db.end_test()

    def test_organization_dn(self):
        org_1 = fixtures.f_organization_1(self.conn)
        _conf = fixtures.f_dns_external_domain_config_1(self.conn)
        eq_('dc=org-one-infra,dc=net',
            organization_dn(org_1, self.conn))

