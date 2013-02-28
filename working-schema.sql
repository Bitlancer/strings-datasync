-- MySQL dump 10.13  Distrib 5.6.10, for Linux (x86_64)
--
-- Host: localhost    Database: stringsdev
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
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the config record',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization',
  `var` varchar(128) NOT NULL COMMENT 'The config variable',
  `val` longtext NOT NULL COMMENT 'The variable value',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the config record is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `device`
--

DROP TABLE IF EXISTS `device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the device',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization this device belongs to',
  `endpoint_id` bigint(20) unsigned NOT NULL COMMENT 'The endpoint this device is managed from',
  `type_id` int(10) unsigned NOT NULL COMMENT 'The id of the device type',
  `name` varchar(128) NOT NULL COMMENT 'The name of the device',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the device is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `device_meta`
--

DROP TABLE IF EXISTS `device_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_meta` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the meta record',
  `device_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the device',
  `var` varchar(128) NOT NULL COMMENT 'The meta variable',
  `val` longtext NOT NULL COMMENT 'The variable value',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the meta record is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `device_type`
--

DROP TABLE IF EXISTS `device_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_type` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the device type',
  `type` varchar(64) NOT NULL COMMENT 'The type of the device',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the device type is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hiera`
--

DROP TABLE IF EXISTS `hiera`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hiera` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the hiera record',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization this hiera record belongs to',
  `hiera_key` varchar(128) NOT NULL COMMENT 'The search key for hiera',
  `var` varchar(128) NOT NULL COMMENT 'The configuration variable',
  `val` longtext NOT NULL COMMENT 'The variable value',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the hiera record is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `module`
--

DROP TABLE IF EXISTS `module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `module` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the module',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization this module belongs to',
  `name` varchar(128) NOT NULL COMMENT 'The name of the module',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the module is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `module_meta`
--

DROP TABLE IF EXISTS `module_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `module_meta` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the meta record',
  `module_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the module',
  `var` varchar(128) NOT NULL COMMENT 'The meta variable',
  `val` longtext NOT NULL COMMENT 'The variable value',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the meta record is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
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
  `short_name` varchar(64) NOT NULL COMMENT 'Short name of the organization',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the organization is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `provider`
--

DROP TABLE IF EXISTS `provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `provider` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the provider',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization',
  `name` varchar(64) NOT NULL COMMENT 'The name of the provider',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the provider is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `region` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the region',
  `provider_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the provider',
  `name` varchar(64) NOT NULL COMMENT 'The name of the provider',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the region is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the service',
  `provider_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the provider',
  `name` varchar(64) NOT NULL COMMENT 'The name of the service',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the service is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_region`
--

DROP TABLE IF EXISTS `service_region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_region` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `service_id` bigint(11) unsigned NOT NULL COMMENT 'The id of the service',
  `region_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the region',
  `endpoint_url` varchar(255) NOT NULL COMMENT 'The URL of the API endpoint',
  `endpoint_version` varchar(16) NOT NULL COMMENT 'The version of the endpoint API',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the map record is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sudo`
--

DROP TABLE IF EXISTS `sudo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sudo` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the sudo role',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization this sudo role belongs to',
  `name` varchar(128) NOT NULL COMMENT 'The name of the sudo role',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the sudo role is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sudo_attribute`
--

DROP TABLE IF EXISTS `sudo_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sudo_attribute` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the sudo config option',
  `sudo_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the sudo role',
  `name` enum('sudoCommand','sudoRunAs','sudoOption') NOT NULL COMMENT 'The name of the sudo attribute',
  `value` varchar(128) NOT NULL COMMENT 'The value of the sudo attribute',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the sudo attribute is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the tag',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization',
  `name` varchar(64) NOT NULL COMMENT 'The name of the tag',
  `tag_type` enum('system','infrastructure','application') NOT NULL COMMENT 'The type of tag',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the tag is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_sudo`
--

DROP TABLE IF EXISTS `tag_sudo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_sudo` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `tag_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the tag',
  `sudo_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the sudo role',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the map record is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tag_user`
--

DROP TABLE IF EXISTS `tag_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `tag_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the tag',
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the user',
  `is_grantable` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Whether or not the user can grant this permission to others',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the map record is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `target`
--

DROP TABLE IF EXISTS `target`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `target` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the target',
  `region_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the region',
  `name` varchar(64) NOT NULL COMMENT 'The name of the target',
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the target is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the user',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization',
  `name` varchar(64) NOT NULL COMMENT 'The username of the user, used to login to the product',
  `password` varchar(64) NOT NULL COMMENT 'The SHA1 password of the user',
  `first_name` varchar(64) NOT NULL COMMENT 'The first name of the user',
  `last_name` varchar(64) NOT NULL COMMENT 'The last name of the user',
  `email` varchar(128) NOT NULL,
  `phone` varchar(64) NOT NULL,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the user is active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-02-28 14:07:11
