import os
import subprocess
import time

from nose.tools import eq_

from stringsync.ldif_dumper import dump_tree_sorted

DIRNAME = os.path.dirname(os.path.abspath(__file__))
LDAP_SERVER_CMD = ["%s/run_embedded_ldap.rb" % DIRNAME,
                   "%s/tfiles/testing.ldif" % DIRNAME,
                   "dc=example,dc=org"]


class TestLdifDump(object):

    def setUp(self):
        self.proc = subprocess.Popen(LDAP_SERVER_CMD,
                                     stdin=subprocess.PIPE,
                                     stdout=subprocess.PIPE)
        # to get the READY
        self.proc.stdout.readline()

    def tearDown(self):
        self.proc.stdin.write("DIE\n")
        self.proc.stdin.flush()
        self.proc.wait()

    def test_this(self):
        sorted_ldif = dump_tree_sorted("ldap://localhost:3897",
                                       "uid=aa729,ou=people,dc=example,dc=org",
                                       "smada",
                                       "dc=example,dc=org")
        with open(os.path.join(DIRNAME,
                               "tfiles",
                               "sorted_testing.ldif")) as exp_f:
            eq_(exp_f.read().strip(), sorted_ldif.strip())




