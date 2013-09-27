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
-- Dumping data for table `application`
--

LOCK TABLES `application` WRITE;
/*!40000 ALTER TABLE `application` DISABLE KEYS */;
INSERT INTO `application` VALUES (1,1,'Drupal 7','2013-06-19 22:09:02','2013-05-06 11:28:59');
/*!40000 ALTER TABLE `application` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `application_formation`
--

LOCK TABLES `application_formation` WRITE;
/*!40000 ALTER TABLE `application_formation` DISABLE KEYS */;
INSERT INTO `application_formation` VALUES (1,1,1,1,'2013-06-19 22:09:17','2013-06-19 22:09:17');
/*!40000 ALTER TABLE `application_formation` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES (1,1,'dns.external.domain','bitlancer-infra.net','2013-05-22 16:37:33','2013-05-21 18:46:12'),(2,1,'dns.external.implementation_id','1','2013-05-22 16:40:56','2013-05-21 20:11:59'),(3,1,'dns.external.region_id','DFW','2013-06-13 18:45:02','2013-05-22 16:39:09'),(4,1,'dns.external.domain_id','3725229','2013-05-22 16:40:14','2013-05-22 16:40:14'),(5,1,'dns.external.record_ttl','300','2013-05-22 16:54:16','2013-05-22 16:54:16'),(6,1,'dns.internal.domain','int.bitlancer-infra.net','2013-06-19 18:38:37','2013-06-19 18:38:37'),(7,1,'ldap.domain','bitlancer-infra.net','2013-06-19 23:16:22','2013-06-19 18:38:37'),(8,1,'dns.internal.network_attribute','implementation.address.private.4','2013-06-19 18:59:46','2013-06-19 18:59:46');
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `device`
--

LOCK TABLES `device` WRITE;
/*!40000 ALTER TABLE `device` DISABLE KEYS */;
INSERT INTO `device` VALUES (79,1,1,1,1,1,'bob','active','2013-06-19 22:11:41','2013-06-14 16:23:40');
/*!40000 ALTER TABLE `device` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `device_attribute`
--

LOCK TABLES `device_attribute` WRITE;
/*!40000 ALTER TABLE `device_attribute` DISABLE KEYS */;
INSERT INTO `device_attribute` VALUES (394,1,1,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-06-19 22:12:28','2013-06-14 16:23:40'),(395,1,1,'implementation.region_id','dfw','2013-06-19 22:12:28','2013-06-14 16:23:40'),(396,1,1,'implementation.flavor_id','2','2013-06-19 22:12:28','2013-06-14 16:23:40'),(397,1,1,'implementation.id','03205569-2854-4c7e-bf22-7875686a5527','2013-06-19 22:12:28','2013-06-14 20:25:30'),(398,1,1,'implementation.status','active','2013-06-19 22:12:28','2013-06-14 20:25:31'),(399,1,1,'implementation.status.last_updated','2013-06-14 16:31:09','2013-06-19 22:12:28','2013-06-14 20:25:31'),(400,1,1,'implementation.address.public.6','2001:4800:7814:0000:5541:ae55:ff05:28d3','2013-06-19 22:12:28','2013-06-14 20:30:50'),(401,1,1,'implementation.address.public.4','166.78.166.105','2013-06-19 22:12:28','2013-06-14 20:30:50'),(402,1,1,'implementation.address.private.4','10.182.130.128','2013-06-19 22:12:28','2013-06-14 20:30:50'),(403,1,1,'dns.external.arecord_id','A-10129850','2013-06-19 22:12:28','2013-06-14 20:31:08'),(419,1,1,'implementation.address.bitlancer.4','192.168.10.100','2013-06-19 22:12:28','2013-06-14 20:30:50'),(420,1,1,'dns.internal.fqdn','bob.dfw01.int.bitlancer-example.net','2013-06-19 23:12:53','2013-06-19 23:12:53'),(421,1,1,'dns.external.fqdn','bob.dfw01.bitlancer-example.net','2013-06-19 23:12:53','2013-06-19 23:12:53');
/*!40000 ALTER TABLE `device_attribute` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `device_dns`
--

LOCK TABLES `device_dns` WRITE;
/*!40000 ALTER TABLE `device_dns` DISABLE KEYS */;
INSERT INTO `device_dns` VALUES (1,1,1,'db.drupal7.dfw01.int.bitlancer-example.net','2013-06-19 22:13:31','2013-06-19 22:13:31');
/*!40000 ALTER TABLE `device_dns` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `device_type`
--

LOCK TABLES `device_type` WRITE;
/*!40000 ALTER TABLE `device_type` DISABLE KEYS */;
INSERT INTO `device_type` VALUES (1,'instance','2013-06-14 16:10:01','2013-06-14 16:10:01'),(2,'load-balancer','2013-06-14 16:10:10','2013-06-14 16:10:10');
/*!40000 ALTER TABLE `device_type` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `formation`
--

LOCK TABLES `formation` WRITE;
/*!40000 ALTER TABLE `formation` DISABLE KEYS */;
INSERT INTO `formation` VALUES (1,1,'Bob\'s Servers','active','2013-06-19 22:14:47','2013-06-14 16:23:40');
/*!40000 ALTER TABLE `formation` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `hiera`
--

LOCK TABLES `hiera` WRITE;
/*!40000 ALTER TABLE `hiera` DISABLE KEYS */;
INSERT INTO `hiera` VALUES (1,1,'production/dfw01/common','dns_server','10.10.10.10','2013-06-19 21:31:31','2013-06-19 21:09:23'),(2,1,'production/dfw01/common','dns_server','10.10.10.11','2013-06-19 21:31:31','2013-06-19 21:09:25'),(3,1,'fqdn/bob.dfw01.bitlancer-example.net','mysql_server_id','10','2013-06-19 21:31:31','2013-06-19 21:10:22'),(4,1,'production/common','ldap_pdns_username','pdns','2013-06-19 21:31:31','2013-06-19 21:30:07'),(5,1,'production/common','ldap_pdns_password','ezNeenAcer1Nothcok6VejDyubBap5','2013-06-19 21:31:31','2013-06-19 21:30:24'),(6,1,'production/common','ldap_puppet_username','puppet','2013-06-19 21:31:31','2013-06-19 21:30:33'),(7,1,'production/common','ldap_puppet_password','Pam5QuadKidsukDabEkvosh9','2013-06-19 21:31:31','2013-06-19 21:30:45'),(8,1,'production/common','ldap_pam_username','pam','2013-06-19 21:31:31','2013-06-19 21:30:52'),(9,1,'production/common','ldap_pam_password','pargimCob0griabtadVad0','2013-06-19 21:31:31','2013-06-19 21:31:02');
/*!40000 ALTER TABLE `hiera` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `organization`
--

LOCK TABLES `organization` WRITE;
/*!40000 ALTER TABLE `organization` DISABLE KEYS */;
INSERT INTO `organization` VALUES (1,'Bitlancer Example, LLC','bitlancer',0,'2013-06-19 22:15:13','2013-04-29 17:07:51');
/*!40000 ALTER TABLE `organization` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,1,'Base Node','2013-06-19 22:18:33','2013-05-20 15:28:37');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `sudo`
--

LOCK TABLES `sudo` WRITE;
/*!40000 ALTER TABLE `sudo` DISABLE KEYS */;
INSERT INTO `sudo` VALUES (1,1,'root',0,'2013-06-19 22:24:20','2013-05-09 14:38:41');
/*!40000 ALTER TABLE `sudo` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `sudo_attribute`
--

LOCK TABLES `sudo_attribute` WRITE;
/*!40000 ALTER TABLE `sudo_attribute` DISABLE KEYS */;
INSERT INTO `sudo_attribute` VALUES (4,1,1,'sudoRunAs','root','2013-06-19 22:25:02','2013-05-09 14:38:41'),(5,1,1,'sudoCommand','ALL','2013-06-19 22:25:08','2013-05-09 14:38:41');
/*!40000 ALTER TABLE `sudo_attribute` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES (1,1,'developers',0,'2013-06-19 22:04:33','2013-05-11 16:39:59');
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team_application`
--

LOCK TABLES `team_application` WRITE;
/*!40000 ALTER TABLE `team_application` DISABLE KEYS */;
INSERT INTO `team_application` VALUES (1,1,1,6,'2013-05-20 13:58:32','2013-05-13 13:32:07');
/*!40000 ALTER TABLE `team_application` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team_application_sudo`
--

LOCK TABLES `team_application_sudo` WRITE;
/*!40000 ALTER TABLE `team_application_sudo` DISABLE KEYS */;
INSERT INTO `team_application_sudo` VALUES (1,1,1,1,'2013-06-19 22:26:33','2013-05-13 13:32:40');
/*!40000 ALTER TABLE `team_application_sudo` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team_device`
--

LOCK TABLES `team_device` WRITE;
/*!40000 ALTER TABLE `team_device` DISABLE KEYS */;
INSERT INTO `team_device` VALUES (1,1,1,1,'2013-06-19 22:27:06','2013-06-19 22:27:06');
/*!40000 ALTER TABLE `team_device` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team_device_sudo`
--

LOCK TABLES `team_device_sudo` WRITE;
/*!40000 ALTER TABLE `team_device_sudo` DISABLE KEYS */;
INSERT INTO `team_device_sudo` VALUES (1,1,1,1,'2013-06-19 22:27:23','2013-06-19 22:27:23');
/*!40000 ALTER TABLE `team_device_sudo` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team_formation`
--

LOCK TABLES `team_formation` WRITE;
/*!40000 ALTER TABLE `team_formation` DISABLE KEYS */;
INSERT INTO `team_formation` VALUES (1,1,1,1,'2013-06-19 22:27:41','2013-06-19 22:27:41');
/*!40000 ALTER TABLE `team_formation` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team_formation_sudo`
--

LOCK TABLES `team_formation_sudo` WRITE;
/*!40000 ALTER TABLE `team_formation_sudo` DISABLE KEYS */;
INSERT INTO `team_formation_sudo` VALUES (1,1,1,1,'2013-06-19 22:27:51','2013-06-19 22:27:51');
/*!40000 ALTER TABLE `team_formation_sudo` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team_role`
--

LOCK TABLES `team_role` WRITE;
/*!40000 ALTER TABLE `team_role` DISABLE KEYS */;
INSERT INTO `team_role` VALUES (1,1,1,1,'2013-06-19 22:27:59','2013-06-19 22:27:59');
/*!40000 ALTER TABLE `team_role` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `team_role_sudo`
--

LOCK TABLES `team_role_sudo` WRITE;
/*!40000 ALTER TABLE `team_role_sudo` DISABLE KEYS */;
INSERT INTO `team_role_sudo` VALUES (1,1,1,1,'2013-06-19 22:28:07','2013-06-19 22:28:07');
/*!40000 ALTER TABLE `team_role_sudo` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,1,'mjuszczak','51abb9636078defbf888d8457a7c76f85c8f114c','Matt','Juszczak','matt@atopia.net',1,0,0,'2013-06-16 06:22:21','2013-04-29 17:14:40');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `user_attribute`
--

LOCK TABLES `user_attribute` WRITE;
/*!40000 ALTER TABLE `user_attribute` DISABLE KEYS */;
INSERT INTO `user_attribute` VALUES (1,1,1,'posix.shell','/bin/bash','2013-06-19 23:25:30','2013-06-19 23:21:33'),(2,1,1,'posix.uid','2000','2013-06-19 23:25:33','2013-06-19 23:21:33');
/*!40000 ALTER TABLE `user_attribute` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `user_key`
--

LOCK TABLES `user_key` WRITE;
/*!40000 ALTER TABLE `user_key` DISABLE KEYS */;
INSERT INTO `user_key` VALUES (1,1,1,'matt@lappy','ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA3x94TspDy4fc1hqdsZJdlXH1Vxd65B11JReP0Ze8zzemktbEF6oCUj4jwWplL7vlTJPMkwEnyQBQ4SCFYA75JbADnARjAYs/84ZHICyzblDbI1pGA34N5GP5RFmRGYve9n7TKGJRZiQ3cfqSpT8dKe1OszdgDqs2koemEO/MXNETpMEEipGaFBpw6ZYlkCV1LzsGOkQkOMpjwNuS8eo8zer5IsM+wE5KChnZ/iEABOR/dxOxKTJCWFQjrDL3CMeGwE3BIlIXhCiT4UugFypocHjYci5CdTm6ekfJrzdkSUlCzzMAG9ueCv4SIgcSS4gOCptOLhoubKvBiAMJPXH9cw== matt@lappy','2013-06-19 12:03:32','2013-06-19 12:03:32');
/*!40000 ALTER TABLE `user_key` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Dumping data for table `user_team`
--

LOCK TABLES `user_team` WRITE;
/*!40000 ALTER TABLE `user_team` DISABLE KEYS */;
INSERT INTO `user_team` VALUES (1,1,1,1,'2013-06-19 22:22:42','2013-05-14 09:45:24');
/*!40000 ALTER TABLE `user_team` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-06-19 23:27:23
