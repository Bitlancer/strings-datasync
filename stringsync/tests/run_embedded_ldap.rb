#!/usr/bin/ruby -rubygems

# This is just a dumb wrapper around ladle so that I can use ApacheDS
# to test ldap interaction without porting the wrapper to python.
#
# Small but important points:
#
# - we print READY and make sure to flush stdout so that the spawning
# process (in this case a nosetest) can meaningfully block waiting for
# READY and know that the server has started, rather than having to do
# some flaky sleep and pray the server is ready.
#
# - the calling process tells the server to die by writing anything on
# this stdin, but needs to be careful to flush, since otherwise this
# could wait a long time, and needs to make sure that the string ends
# with \n, since otherwise it will get buffered on this side.
#
# The arguments are: <path to intial ldif file> <base domain>
#

require 'ladle'

test_ldif_file = ARGV[0]
domain = ARGV[1]

ldap_server = Ladle::Server.new(:tmpdir => '/tmp',
                                :port => 3897,
                                :quiet => true,
                                :domain => domain,
                                :allow_anonymous => false,
                                :ldif => test_ldif_file).start

STDOUT.puts("READY")
STDOUT.flush()

STDIN.gets()
STDOUT.puts("DONE")
STDOUT.flush()

ldap_server.stop
