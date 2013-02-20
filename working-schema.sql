CREATE DATABASE IF NOT EXISTS stringsdatasync CHARACTER SET = 'utf8';

USE stringsdatasync;

CREATE TABLE IF NOT EXISTS sync_targets (
  ldap_server TEXT NOT NULL,
  synced_to INT
);

CREATE TABLE IF NOT EXISTS sync_values (
  id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  value_name TEXT NOT NULL,
  value_data TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
