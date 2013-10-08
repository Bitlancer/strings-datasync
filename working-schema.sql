-- MySQL dump 10.13  Distrib 5.6.10, for Linux (x86_64)
--
-- Host: localhost    Database: strings
-- ------------------------------------------------------
-- Server version	5.6.10-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `application`
--

DROP TABLE IF EXISTS `application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `application` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the application',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(64) NOT NULL COMMENT 'The name of the application',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `application_formation`
--

DROP TABLE IF EXISTS `application_formation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `application_formation` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `application_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the application',
  `formation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the formation',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the config record',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization that owns this record',
  `var` varchar(128) NOT NULL COMMENT 'The config variable',
  `val` longtext NOT NULL COMMENT 'The variable value',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `device`
--

DROP TABLE IF EXISTS `device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the device',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `device_type_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the device_type that this device belongs to',
  `implementation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the implementation of this device',
  `formation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the formation this device belongs to',
  `role_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the role this device belongs to',
  `name` varchar(128) NOT NULL COMMENT 'The name of the device',
  `status` enum('building','resizing','active','deleting','error') DEFAULT 'building' COMMENT 'The status of this device',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `device_attribute`
--

DROP TABLE IF EXISTS `device_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_attribute` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the attribute',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `device_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the device',
  `var` varchar(128) NOT NULL COMMENT 'The config variable',
  `val` longtext NOT NULL COMMENT 'The variable value',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=422 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `device_dns`
--

DROP TABLE IF EXISTS `device_dns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_dns` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the device dns record',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `device_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the device this record belongs to',
  `name` varchar(255) NOT NULL COMMENT 'The name of the dns record',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `device_type`
--

DROP TABLE IF EXISTS `device_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_type` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the device type record',
  `name` varchar(128) NOT NULL COMMENT 'The name of the device type',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `formation`
--

DROP TABLE IF EXISTS `formation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formation` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the formation',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(128) NOT NULL COMMENT 'The name of the formation',
  `status` enum('building','resizing','active','deleting','error') DEFAULT 'building' COMMENT 'The status of this formation',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hiera`
--

DROP TABLE IF EXISTS `hiera`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hiera` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the hiera record',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `hiera_key` varchar(128) NOT NULL COMMENT 'The search key for hiera',
  `var` varchar(128) NOT NULL COMMENT 'The configuration variable',
  `val` longtext NOT NULL COMMENT 'The variable value',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organization`
--

DROP TABLE IF EXISTS `organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organization` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the organization',
  `name` varchar(64) NOT NULL COMMENT 'The name of the organization',
  `short_name` varchar(64) NOT NULL COMMENT 'A short name for the organization',
  `is_disabled` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Whether or not this organization is disabled',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the role',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(128) NOT NULL COMMENT 'The name of the role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sudo`
--

DROP TABLE IF EXISTS `sudo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sudo` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the sudo role',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(128) NOT NULL COMMENT 'The name of the sudo role',
  `is_hidden` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Whether or not the sudo role is hidden from the end user',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sudo_attribute`
--

DROP TABLE IF EXISTS `sudo_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sudo_attribute` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the sudo attribute',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `sudo_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the sudo role',
  `name` enum('sudoCommand','sudoRunAs','sudoOption') NOT NULL COMMENT 'The name of the sudo attribute',
  `value` varchar(128) NOT NULL COMMENT 'The value of the sudo attribute',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the team',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(64) NOT NULL COMMENT 'The name of the team',
  `is_disabled` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Whether or not the team is disabled',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_application`
--

DROP TABLE IF EXISTS `team_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_application` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `team_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team',
  `application_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the application',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_application_sudo`
--

DROP TABLE IF EXISTS `team_application_sudo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_application_sudo` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `team_application_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team to application mapping',
  `sudo_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the sudo role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_device`
--

DROP TABLE IF EXISTS `team_device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_device` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `team_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team',
  `device_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the device',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_device_sudo`
--

DROP TABLE IF EXISTS `team_device_sudo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_device_sudo` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `team_device_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team to device mapping',
  `sudo_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the sudo role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_formation`
--

DROP TABLE IF EXISTS `team_formation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_formation` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `team_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team',
  `formation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the formation',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_formation_sudo`
--

DROP TABLE IF EXISTS `team_formation_sudo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_formation_sudo` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `team_formation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team to formation mapping',
  `sudo_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the sudo role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_role`
--

DROP TABLE IF EXISTS `team_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `team_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team',
  `role_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_role_sudo`
--

DROP TABLE IF EXISTS `team_role_sudo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_role_sudo` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `team_role_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team to role mapping',
  `sudo_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the sudo role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the user',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(64) NOT NULL COMMENT 'The username of the user',
  `password` varchar(64) NOT NULL COMMENT 'The SHA1 password of the user',
  `first_name` varchar(64) NOT NULL COMMENT 'The first name of the user',
  `last_name` varchar(64) NOT NULL COMMENT 'The last name of the user',
  `email` varchar(128) NOT NULL COMMENT 'The email address of the user',
  `is_admin` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Whether or not the user is an admin',
  `can_create_user` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Whether or not the user can create users',
  `is_disabled` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Whether or not the user is disabled',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_attribute`
--

DROP TABLE IF EXISTS `user_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_attribute` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the attribute',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the user',
  `var` varchar(128) NOT NULL COMMENT 'The config variable',
  `val` longtext NOT NULL COMMENT 'The variable value',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_key`
--

DROP TABLE IF EXISTS `user_key`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_key` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the key',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the user',
  `name` varchar(64) NOT NULL COMMENT 'The name of the key',
  `public_key` text NOT NULL COMMENT 'The public key',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_team`
--

DROP TABLE IF EXISTS `user_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_team` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'The id of the organization that owns this record',
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the user',
  `team_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `module` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the module',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `module_source_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the module source',
  `short_name` varchar(128) NOT NULL COMMENT 'The friendly name of the module',
  `name` varchar(255) NOT NULL COMMENT 'The name of the module',
  `reference` varchar(255) DEFAULT NULL COMMENT 'Optional reference to version, revision, branch or tag of module',
  `path` varchar(255) DEFAULT NULL COMMENT 'Optional path to module within the git repository',
  `updated` datetime COMMENT 'The date and time of the last update to this record',
  `created` datetime COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `module_source`
--

DROP TABLE IF EXISTS `module_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `module_source` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the module source',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(128) NOT NULL COMMENT 'The name of the module source',
  `type` enum('forge','git') NOT NULL DEFAULT 'git' COMMENT 'The module source type',
  `url` varchar(255) NOT NULL COMMENT 'The url of the module source',
  `updated` datetime COMMENT 'The date and time of the last update to this record',
  `created` datetime COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-06-19 23:27:23
