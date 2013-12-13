strings-datasync
================

Bitlancer Strings Data Sync

## Unit testing

* Spin up a centos VM
* run install_deps.sh
* start mysql
* create database strings_test
* grant all on strings_test.* to 'app_datasync'@'localhost' IDENTIFIED BY 'test'
* mysql -u root strings_test < smoketest.sql
* run "nosetest" from within strings-datasync
