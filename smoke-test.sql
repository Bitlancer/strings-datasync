-- MySQL dump 10.13  Distrib 5.6.14, for Linux (x86_64)
--
-- Host: localhost    Database: strings
-- ------------------------------------------------------
-- Server version	5.6.14

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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(64) NOT NULL COMMENT 'The name of the application',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application`
--

LOCK TABLES `application` WRITE;
/*!40000 ALTER TABLE `application` DISABLE KEYS */;
INSERT INTO `application` VALUES (10,1,'test1','2013-10-08 21:41:22','2013-10-08 21:41:22'),(11,2,'test','2013-10-08 21:48:13','2013-10-08 21:48:13'),(12,3,'test','2013-10-09 02:05:48','2013-10-09 02:05:48');
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `application_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the application',
  `formation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the formation',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application_formation`
--

LOCK TABLES `application_formation` WRITE;
/*!40000 ALTER TABLE `application_formation` DISABLE KEYS */;
INSERT INTO `application_formation` VALUES (24,1,10,86,'2013-10-08 21:41:44','2013-10-08 21:41:44'),(25,1,10,87,'2013-10-08 21:41:48','2013-10-08 21:41:48');
/*!40000 ALTER TABLE `application_formation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit`
--

DROP TABLE IF EXISTS `audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the audit record',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the user that this record belongs to',
  `event` enum('create','update','delete') NOT NULL DEFAULT 'create' COMMENT 'The CRUD operation',
  `model` varchar(255) NOT NULL COMMENT 'The model which was modified',
  `entity_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the record that was modified',
  `json_object` text NOT NULL COMMENT 'Json representation of the object that was modified',
  `description` text COMMENT 'A more user friendly description of the modification',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4230 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit`
--

LOCK TABLES `audit` WRITE;
/*!40000 ALTER TABLE `audit` DISABLE KEYS */;
INSERT INTO `audit` VALUES (4033,1,31,'create','User',37,'{\"User\":{\"id\":\"37\",\"organization_id\":\"1\",\"name\":\"jcotton\",\"password\":\"51abb9636078defbf888d8457a7c76f85c8f114c\",\"first_name\":\"Jesse\",\"last_name\":\"Cotton\",\"email\":\"jcotton@bitlancer.com\",\"is_admin\":true,\"can_create_user\":false,\"is_disabled\":false,\"updated\":\"2013-10-08 19:05:43\",\"created\":\"2013-10-08 19:05:43\",\"full_name\":\"Jesse Cotton\"}}',NULL,'2013-10-08 19:05:44','2013-10-08 19:05:44'),(4034,1,31,'update','Config',10,'{\"Config\":{\"id\":\"10\",\"organization_id\":\"1\",\"var\":\"posix.next_uid\",\"val\":\"11\",\"updated\":\"2013-10-08 19:05:44\",\"created\":\"2013-06-20 00:09:12\"}}',NULL,'2013-10-08 19:05:44','2013-10-08 19:05:44'),(4035,1,31,'create','UserAttribute',21,'{\"UserAttribute\":{\"id\":\"21\",\"organization_id\":\"1\",\"user_id\":\"37\",\"var\":\"posix.uid\",\"val\":\"10\",\"updated\":\"2013-10-08 19:05:44\",\"created\":\"2013-10-08 19:05:44\"}}',NULL,'2013-10-08 19:05:44','2013-10-08 19:05:44'),(4036,1,31,'create','UserAttribute',22,'{\"UserAttribute\":{\"id\":\"22\",\"organization_id\":\"1\",\"user_id\":\"37\",\"var\":\"posix.gid\",\"val\":\"10\",\"updated\":\"2013-10-08 19:05:44\",\"created\":\"2013-10-08 19:05:44\"}}',NULL,'2013-10-08 19:05:44','2013-10-08 19:05:44'),(4037,1,31,'create','UserAttribute',23,'{\"UserAttribute\":{\"id\":\"23\",\"organization_id\":\"1\",\"user_id\":\"37\",\"var\":\"posix.shell\",\"val\":\"\\/bin\\/bash\",\"updated\":\"2013-10-08 19:05:44\",\"created\":\"2013-10-08 19:05:44\"}}',NULL,'2013-10-08 19:05:44','2013-10-08 19:05:44'),(4038,1,31,'create','User',42,'{\"User\":{\"id\":\"42\",\"organization_id\":\"1\",\"name\":\"ekeller\",\"password\":\"682618169c3cd29221a9b34b8327ea1b74cb8db2\",\"first_name\":\"Eric\",\"last_name\":\"Keller\",\"email\":\"ekeller@bitlancer.com\",\"is_admin\":true,\"can_create_user\":false,\"is_disabled\":false,\"updated\":\"2013-10-08 21:28:04\",\"created\":\"2013-10-08 21:28:04\",\"full_name\":\"Eric Keller\"}}',NULL,'2013-10-08 21:28:04','2013-10-08 21:28:04'),(4039,1,31,'update','Config',10,'{\"Config\":{\"id\":\"10\",\"organization_id\":\"1\",\"var\":\"posix.next_uid\",\"val\":\"12\",\"updated\":\"2013-10-08 21:28:04\",\"created\":\"2013-06-20 00:09:12\"}}',NULL,'2013-10-08 21:28:04','2013-10-08 21:28:04'),(4040,1,31,'create','UserAttribute',30,'{\"UserAttribute\":{\"id\":\"30\",\"organization_id\":\"1\",\"user_id\":\"42\",\"var\":\"posix.uid\",\"val\":\"11\",\"updated\":\"2013-10-08 21:28:04\",\"created\":\"2013-10-08 21:28:04\"}}',NULL,'2013-10-08 21:28:04','2013-10-08 21:28:04'),(4041,1,31,'create','UserAttribute',31,'{\"UserAttribute\":{\"id\":\"31\",\"organization_id\":\"1\",\"user_id\":\"42\",\"var\":\"posix.gid\",\"val\":\"11\",\"updated\":\"2013-10-08 21:28:04\",\"created\":\"2013-10-08 21:28:04\"}}',NULL,'2013-10-08 21:28:04','2013-10-08 21:28:04'),(4042,1,31,'create','UserAttribute',32,'{\"UserAttribute\":{\"id\":\"32\",\"organization_id\":\"1\",\"user_id\":\"42\",\"var\":\"posix.shell\",\"val\":\"\\/bin\\/bash\",\"updated\":\"2013-10-08 21:28:04\",\"created\":\"2013-10-08 21:28:04\"}}',NULL,'2013-10-08 21:28:04','2013-10-08 21:28:04'),(4043,1,31,'create','User',43,'{\"User\":{\"id\":\"43\",\"organization_id\":\"1\",\"name\":\"bgormley\",\"password\":\"e250873dd50af1572764aa6da16b2ee16dd913bf\",\"first_name\":\"Brian\",\"last_name\":\"Gormley\",\"email\":\"bgormley@bitlancer.net\",\"is_admin\":false,\"can_create_user\":false,\"is_disabled\":false,\"updated\":\"2013-10-08 21:28:46\",\"created\":\"2013-10-08 21:28:46\",\"full_name\":\"Brian Gormley\"}}',NULL,'2013-10-08 21:28:46','2013-10-08 21:28:46'),(4044,1,31,'update','Config',10,'{\"Config\":{\"id\":\"10\",\"organization_id\":\"1\",\"var\":\"posix.next_uid\",\"val\":\"13\",\"updated\":\"2013-10-08 21:28:46\",\"created\":\"2013-06-20 00:09:12\"}}',NULL,'2013-10-08 21:28:46','2013-10-08 21:28:46'),(4045,1,31,'create','UserAttribute',33,'{\"UserAttribute\":{\"id\":\"33\",\"organization_id\":\"1\",\"user_id\":\"43\",\"var\":\"posix.uid\",\"val\":\"12\",\"updated\":\"2013-10-08 21:28:46\",\"created\":\"2013-10-08 21:28:46\"}}',NULL,'2013-10-08 21:28:46','2013-10-08 21:28:46'),(4046,1,31,'create','UserAttribute',34,'{\"UserAttribute\":{\"id\":\"34\",\"organization_id\":\"1\",\"user_id\":\"43\",\"var\":\"posix.gid\",\"val\":\"12\",\"updated\":\"2013-10-08 21:28:46\",\"created\":\"2013-10-08 21:28:46\"}}',NULL,'2013-10-08 21:28:46','2013-10-08 21:28:46'),(4047,1,31,'create','UserAttribute',35,'{\"UserAttribute\":{\"id\":\"35\",\"organization_id\":\"1\",\"user_id\":\"43\",\"var\":\"posix.shell\",\"val\":\"\\/bin\\/bash\",\"updated\":\"2013-10-08 21:28:46\",\"created\":\"2013-10-08 21:28:46\"}}',NULL,'2013-10-08 21:28:46','2013-10-08 21:28:46'),(4048,1,31,'create','UserKey',4,'{\"UserKey\":{\"id\":\"4\",\"organization_id\":\"1\",\"user_id\":\"43\",\"name\":\"laptop\",\"public_key\":\"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBXUbbAgfzLMNcWA\\/eq+b2Bt7xG8WM\\/o3Ht+T0e8v2VXeZWUlBRYY3sxQ\\/H\\/hbJyfPnImZEffYlRPNvgKieBtIziqs0GQJBo20SVgVCXEaWNj03Iy\\/g5nST+i82HmzukFCECjeokYW04n7p8mWdpu0pHH7jWGirYWfpLtACygzKtkfP9DsRLWj7JuLYAC6Y4NOoR22I1oWH+mIGqzRyXC3ntAtL3Mmppv9b4iUnOhwfAZhAy9U8fSV9PbqjSoFpiljIs0MYpEvLns8GwOFyWdzMl5Ye4xrMj\\/xOVarP0IWannrMf8wLtil20DAE9H9R9rlTz7LIBIzGtGXXGsDjZtb\",\"updated\":\"2013-10-08 21:29:05\",\"created\":\"2013-10-08 21:29:05\"}}',NULL,'2013-10-08 21:29:05','2013-10-08 21:29:05'),(4049,1,31,'create','UserKey',5,'{\"UserKey\":{\"id\":\"5\",\"organization_id\":\"1\",\"user_id\":\"37\",\"name\":\"test1\",\"public_key\":\"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDS\\/tbMtyOSMDE7qfBxjDdTyLRvn07+r2Jvsjlcm39PM2ez9vCmcM1bRZC3s96nnnbykR6hENwhTXeS\\/nYOEof1UccdE\\/3GixbN+CQ7kOs0fSqGz1BbGENVfWjS06RFyaQvnBjv8d5K8jO\\/TirddauuE4Y1xawxS2mvnnwsWTRdraWrm7Usfd6anin4b2Dnlzor7HNEjaQQWTcHC2w5BIZ3yFYiLzVkT+BpW5dxILDx6hSYBiJK57A3NT6gMIx02jnmihobPGgUf+JU8Y39koU2TfbZ6ZVQEmVb3KnmEfiwSybiYIhkGyL8avXZaVlWPKOrajq62KS+O9b563aX9GGn\",\"updated\":\"2013-10-08 21:30:01\",\"created\":\"2013-10-08 21:30:01\"}}',NULL,'2013-10-08 21:30:01','2013-10-08 21:30:01'),(4050,1,31,'create','UserKey',6,'{\"UserKey\":{\"id\":\"6\",\"organization_id\":\"1\",\"user_id\":\"37\",\"name\":\"test2\",\"public_key\":\"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6VkI9U1idkgIYZ4v2FslY3xH49HokZwu8EJpRZrqq1iFGFTnK8QXMqc8Zr+Ol6uerQV1sUzL0SoZzhsoxejK6U0KiT8cwbuHJDevS7bkaaBJ\\/6h882Z2r3u3G7W7lzvto4d5Y6DeFTU70LiJa2yB+5loOXM2lRCSwGSFfL7+vD5qhFcbgpLUSCfYQGzqQMdYOlgswFBCjhX0+0gQJ0f5qbRQq\\/b+b+S8SiHpBBooUzXL44Wp5uCZ3oim8yxGooqPm0WO29MLmB1vzI17gc6UAgz5xOUNQG3ZSmyhAkzu90I0CsbDdG9uInCoi\\/k1pCKIC2piXqjNPECut0bvDu1mR\",\"updated\":\"2013-10-08 21:30:12\",\"created\":\"2013-10-08 21:30:12\"}}',NULL,'2013-10-08 21:30:12','2013-10-08 21:30:12'),(4051,1,31,'create','User',44,'{\"User\":{\"id\":\"44\",\"organization_id\":\"1\",\"name\":\"mjuszczak\",\"password\":\"5e88105b92d98f1dffbee8d33501e004e32ee897\",\"first_name\":\"Matt\",\"last_name\":\"Juszczak\",\"email\":\"mjuszczak@bitlancer.com\",\"is_admin\":false,\"can_create_user\":false,\"is_disabled\":false,\"updated\":\"2013-10-08 21:30:56\",\"created\":\"2013-10-08 21:30:56\",\"full_name\":\"Matt Juszczak\"}}',NULL,'2013-10-08 21:30:56','2013-10-08 21:30:56'),(4052,1,31,'update','Config',10,'{\"Config\":{\"id\":\"10\",\"organization_id\":\"1\",\"var\":\"posix.next_uid\",\"val\":\"14\",\"updated\":\"2013-10-08 21:30:56\",\"created\":\"2013-06-20 00:09:12\"}}',NULL,'2013-10-08 21:30:56','2013-10-08 21:30:56'),(4053,1,31,'create','UserAttribute',36,'{\"UserAttribute\":{\"id\":\"36\",\"organization_id\":\"1\",\"user_id\":\"44\",\"var\":\"posix.uid\",\"val\":\"13\",\"updated\":\"2013-10-08 21:30:56\",\"created\":\"2013-10-08 21:30:56\"}}',NULL,'2013-10-08 21:30:56','2013-10-08 21:30:56'),(4054,1,31,'create','UserAttribute',37,'{\"UserAttribute\":{\"id\":\"37\",\"organization_id\":\"1\",\"user_id\":\"44\",\"var\":\"posix.gid\",\"val\":\"13\",\"updated\":\"2013-10-08 21:30:56\",\"created\":\"2013-10-08 21:30:56\"}}',NULL,'2013-10-08 21:30:56','2013-10-08 21:30:56'),(4055,1,31,'create','UserAttribute',38,'{\"UserAttribute\":{\"id\":\"38\",\"organization_id\":\"1\",\"user_id\":\"44\",\"var\":\"posix.shell\",\"val\":\"\\/bin\\/bash\",\"updated\":\"2013-10-08 21:30:56\",\"created\":\"2013-10-08 21:30:56\"}}',NULL,'2013-10-08 21:30:56','2013-10-08 21:30:56'),(4056,1,31,'create','UserKey',7,'{\"UserKey\":{\"id\":\"7\",\"organization_id\":\"1\",\"user_id\":\"44\",\"name\":\"laptop\",\"public_key\":\"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD9sVgcQovITajxYBKEquGZrVxMaXD1ZnLZgrGbIpyvGG4QEF4rLLIk8iA5CdJ+w9HDSHi+4yHzWgIUzOLGQhBs9tGE1F9byb\\/zXVonz9zWGqGDUj6hYYQdC+KjytixoKEJr7XQttUWimtFI83MIZipyMMNnCidqTdPdvgCswgZVgRDijl8bSyfhgDPsNd25dD57MQHHyYVzQ\\/OZmroCc6IkPBxVMgO1UhxVPW68VbrugCl5u9E9Rg9Qg6dqAo8itP92xgx03rG6mdLCDhrs\\/\\/stJzq3OKb8Cmyp9c0ALNczliRrsiKD6CW3VNNCVePnqDwh810H1mH9LZEU68IGjX\\/\",\"updated\":\"2013-10-08 21:31:09\",\"created\":\"2013-10-08 21:31:09\"}}',NULL,'2013-10-08 21:31:09','2013-10-08 21:31:09'),(4057,1,31,'create','Team',27,'{\"Team\":{\"id\":\"27\",\"organization_id\":\"1\",\"name\":\"Everyone\",\"is_disabled\":false,\"updated\":\"2013-10-08 21:32:29\",\"created\":\"2013-10-08 21:32:29\"}}',NULL,'2013-10-08 21:32:29','2013-10-08 21:32:29'),(4058,1,31,'create','UserTeam',42,'{\"UserTeam\":{\"id\":\"42\",\"organization_id\":\"1\",\"user_id\":\"37\",\"team_id\":\"27\",\"updated\":\"2013-10-08 21:32:29\",\"created\":\"2013-10-08 21:32:29\"}}',NULL,'2013-10-08 21:32:29','2013-10-08 21:32:29'),(4059,1,31,'create','UserTeam',43,'{\"UserTeam\":{\"id\":\"43\",\"organization_id\":\"1\",\"user_id\":\"42\",\"team_id\":\"27\",\"updated\":\"2013-10-08 21:32:29\",\"created\":\"2013-10-08 21:32:29\"}}',NULL,'2013-10-08 21:32:29','2013-10-08 21:32:29'),(4060,1,31,'create','UserTeam',44,'{\"UserTeam\":{\"id\":\"44\",\"organization_id\":\"1\",\"user_id\":\"43\",\"team_id\":\"27\",\"updated\":\"2013-10-08 21:32:29\",\"created\":\"2013-10-08 21:32:29\"}}',NULL,'2013-10-08 21:32:29','2013-10-08 21:32:29'),(4061,1,31,'create','UserTeam',45,'{\"UserTeam\":{\"id\":\"45\",\"organization_id\":\"1\",\"user_id\":\"44\",\"team_id\":\"27\",\"updated\":\"2013-10-08 21:32:29\",\"created\":\"2013-10-08 21:32:29\"}}',NULL,'2013-10-08 21:32:29','2013-10-08 21:32:29'),(4062,1,31,'create','Team',28,'{\"Team\":{\"id\":\"28\",\"organization_id\":\"1\",\"name\":\"Noone\",\"is_disabled\":false,\"updated\":\"2013-10-08 21:32:46\",\"created\":\"2013-10-08 21:32:46\"}}',NULL,'2013-10-08 21:32:46','2013-10-08 21:32:46'),(4063,1,31,'create','Team',29,'{\"Team\":{\"id\":\"29\",\"organization_id\":\"1\",\"name\":\"Just jesse\",\"is_disabled\":false,\"updated\":\"2013-10-08 21:33:03\",\"created\":\"2013-10-08 21:33:03\"}}',NULL,'2013-10-08 21:33:03','2013-10-08 21:33:03'),(4064,1,31,'create','UserTeam',46,'{\"UserTeam\":{\"id\":\"46\",\"organization_id\":\"1\",\"user_id\":\"37\",\"team_id\":\"29\",\"updated\":\"2013-10-08 21:33:03\",\"created\":\"2013-10-08 21:33:03\"}}',NULL,'2013-10-08 21:33:03','2013-10-08 21:33:03'),(4065,1,31,'create','Team',30,'{\"Team\":{\"id\":\"30\",\"organization_id\":\"1\",\"name\":\"Just brian\",\"is_disabled\":false,\"updated\":\"2013-10-08 21:33:24\",\"created\":\"2013-10-08 21:33:24\"}}',NULL,'2013-10-08 21:33:24','2013-10-08 21:33:24'),(4066,1,31,'create','UserTeam',47,'{\"UserTeam\":{\"id\":\"47\",\"organization_id\":\"1\",\"user_id\":\"43\",\"team_id\":\"30\",\"updated\":\"2013-10-08 21:33:24\",\"created\":\"2013-10-08 21:33:24\"}}',NULL,'2013-10-08 21:33:24','2013-10-08 21:33:24'),(4067,1,31,'create','SudoRole',7,'{\"SudoRole\":{\"id\":\"7\",\"organization_id\":\"1\",\"name\":\"Test1\",\"is_hidden\":false,\"updated\":\"2013-10-08 21:34:36\",\"created\":\"2013-10-08 21:34:36\"}}',NULL,'2013-10-08 21:34:36','2013-10-08 21:34:36'),(4068,1,31,'create','SudoAttribute',34,'{\"SudoAttribute\":{\"id\":\"34\",\"organization_id\":\"1\",\"sudo_id\":\"7\",\"name\":\"sudoRunAs\",\"value\":\"root\",\"updated\":\"2013-10-08 21:34:36\",\"created\":\"2013-10-08 21:34:36\"}}',NULL,'2013-10-08 21:34:36','2013-10-08 21:34:36'),(4069,1,31,'create','SudoAttribute',35,'{\"SudoAttribute\":{\"id\":\"35\",\"organization_id\":\"1\",\"sudo_id\":\"7\",\"name\":\"sudoCommand\",\"value\":\"\\/usr\\/sbin\\/tcpdump\",\"updated\":\"2013-10-08 21:34:36\",\"created\":\"2013-10-08 21:34:36\"}}',NULL,'2013-10-08 21:34:36','2013-10-08 21:34:36'),(4070,1,31,'create','SudoAttribute',36,'{\"SudoAttribute\":{\"id\":\"36\",\"organization_id\":\"1\",\"sudo_id\":\"7\",\"name\":\"sudoCommand\",\"value\":\"\\/usr\\/sbin\\/apachectl\",\"updated\":\"2013-10-08 21:34:36\",\"created\":\"2013-10-08 21:34:36\"}}',NULL,'2013-10-08 21:34:36','2013-10-08 21:34:36'),(4071,1,31,'create','SudoRole',8,'{\"SudoRole\":{\"id\":\"8\",\"organization_id\":\"1\",\"name\":\"Test2\",\"is_hidden\":false,\"updated\":\"2013-10-08 21:35:34\",\"created\":\"2013-10-08 21:35:34\"}}',NULL,'2013-10-08 21:35:34','2013-10-08 21:35:34'),(4072,1,31,'create','SudoAttribute',37,'{\"SudoAttribute\":{\"id\":\"37\",\"organization_id\":\"1\",\"sudo_id\":\"8\",\"name\":\"sudoRunAs\",\"value\":\"root\",\"updated\":\"2013-10-08 21:35:34\",\"created\":\"2013-10-08 21:35:34\"}}',NULL,'2013-10-08 21:35:34','2013-10-08 21:35:34'),(4073,1,31,'create','SudoAttribute',38,'{\"SudoAttribute\":{\"id\":\"38\",\"organization_id\":\"1\",\"sudo_id\":\"8\",\"name\":\"sudoCommand\",\"value\":\"\\/usr\\/bin\\/apachectl\",\"updated\":\"2013-10-08 21:35:34\",\"created\":\"2013-10-08 21:35:34\"}}',NULL,'2013-10-08 21:35:34','2013-10-08 21:35:34'),(4074,1,31,'create','Team',31,'{\"Team\":{\"id\":\"31\",\"organization_id\":\"1\",\"name\":\"Disabled team\",\"is_disabled\":false,\"updated\":\"2013-10-08 21:36:06\",\"created\":\"2013-10-08 21:36:06\"}}',NULL,'2013-10-08 21:36:06','2013-10-08 21:36:06'),(4075,1,31,'create','UserTeam',48,'{\"UserTeam\":{\"id\":\"48\",\"organization_id\":\"1\",\"user_id\":\"37\",\"team_id\":\"31\",\"updated\":\"2013-10-08 21:36:06\",\"created\":\"2013-10-08 21:36:06\"}}',NULL,'2013-10-08 21:36:06','2013-10-08 21:36:06'),(4076,1,31,'create','UserTeam',49,'{\"UserTeam\":{\"id\":\"49\",\"organization_id\":\"1\",\"user_id\":\"42\",\"team_id\":\"31\",\"updated\":\"2013-10-08 21:36:06\",\"created\":\"2013-10-08 21:36:06\"}}',NULL,'2013-10-08 21:36:06','2013-10-08 21:36:06'),(4077,1,31,'create','UserTeam',50,'{\"UserTeam\":{\"id\":\"50\",\"organization_id\":\"1\",\"user_id\":\"43\",\"team_id\":\"31\",\"updated\":\"2013-10-08 21:36:06\",\"created\":\"2013-10-08 21:36:06\"}}',NULL,'2013-10-08 21:36:06','2013-10-08 21:36:06'),(4078,1,31,'update','Team',31,'{\"Team\":{\"id\":\"31\",\"organization_id\":\"1\",\"name\":\"Disabled team\",\"is_disabled\":true,\"updated\":\"2013-10-08 21:36:20\",\"created\":\"2013-10-08 21:36:06\"}}',NULL,'2013-10-08 21:36:20','2013-10-08 21:36:20'),(4079,1,31,'update','User',42,'{\"User\":{\"id\":\"42\",\"organization_id\":\"1\",\"name\":\"ekeller\",\"password\":\"682618169c3cd29221a9b34b8327ea1b74cb8db2\",\"first_name\":\"Eric\",\"last_name\":\"Keller\",\"email\":\"ekeller@bitlancer.com\",\"is_admin\":true,\"can_create_user\":false,\"is_disabled\":true,\"updated\":\"2013-10-08 21:36:38\",\"created\":\"2013-10-08 21:28:04\",\"full_name\":\"Eric Keller\"}}',NULL,'2013-10-08 21:36:38','2013-10-08 21:36:38'),(4080,1,31,'update','User',43,'{\"User\":{\"id\":\"43\",\"organization_id\":\"1\",\"name\":\"bgormley\",\"password\":\"e250873dd50af1572764aa6da16b2ee16dd913bf\",\"first_name\":\"Brian\",\"last_name\":\"Gormley\",\"email\":\"bgormley@bitlancer.net\",\"is_admin\":false,\"can_create_user\":false,\"is_disabled\":true,\"updated\":\"2013-10-08 21:36:43\",\"created\":\"2013-10-08 21:28:46\",\"full_name\":\"Brian Gormley\"}}',NULL,'2013-10-08 21:36:43','2013-10-08 21:36:43'),(4081,1,31,'create','Formation',85,'{\"Formation\":{\"id\":\"85\",\"organization_id\":\"1\",\"implementation_id\":\"1\",\"blueprint_id\":\"6\",\"dictionary_id\":\"1\",\"name\":\"Dev\",\"status\":\"building\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4082,1,31,'create','Device',236,'{\"Device\":{\"id\":\"236\",\"organization_id\":\"1\",\"device_type_id\":\"1\",\"implementation_id\":\"1\",\"formation_id\":\"85\",\"blueprint_part_id\":\"7\",\"role_id\":\"5\",\"name\":\"Jefferson-city\",\"status\":\"building\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4083,1,31,'create','DeviceAttribute',1167,'{\"DeviceAttribute\":{\"id\":\"1167\",\"organization_id\":\"1\",\"device_id\":\"236\",\"var\":\"implementation.region_id\",\"val\":\"dfw\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4084,1,31,'create','DeviceAttribute',1168,'{\"DeviceAttribute\":{\"id\":\"1168\",\"organization_id\":\"1\",\"device_id\":\"236\",\"var\":\"dns.internal.fqdn\",\"val\":\"jefferson-city.dfw01.int.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4085,1,31,'create','DeviceAttribute',1169,'{\"DeviceAttribute\":{\"id\":\"1169\",\"organization_id\":\"1\",\"device_id\":\"236\",\"var\":\"dns.external.fqdn\",\"val\":\"jefferson-city.dfw01.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4086,1,31,'create','DeviceAttribute',1170,'{\"DeviceAttribute\":{\"id\":\"1170\",\"organization_id\":\"1\",\"device_id\":\"236\",\"var\":\"implementation.flavor_id\",\"val\":\"2\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4087,1,31,'create','DeviceAttribute',1171,'{\"DeviceAttribute\":{\"id\":\"1171\",\"organization_id\":\"1\",\"device_id\":\"236\",\"var\":\"implementation.image_id\",\"val\":\"da1f0392-8c64-468f-a839-a9e56caebf07\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4088,1,31,'create','Device',237,'{\"Device\":{\"id\":\"237\",\"organization_id\":\"1\",\"device_type_id\":\"1\",\"implementation_id\":\"1\",\"formation_id\":\"85\",\"blueprint_part_id\":\"7\",\"role_id\":\"5\",\"name\":\"Albany\",\"status\":\"building\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4089,1,31,'create','DeviceAttribute',1172,'{\"DeviceAttribute\":{\"id\":\"1172\",\"organization_id\":\"1\",\"device_id\":\"237\",\"var\":\"implementation.region_id\",\"val\":\"dfw\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4090,1,31,'create','DeviceAttribute',1173,'{\"DeviceAttribute\":{\"id\":\"1173\",\"organization_id\":\"1\",\"device_id\":\"237\",\"var\":\"dns.internal.fqdn\",\"val\":\"albany.dfw01.int.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4091,1,31,'create','DeviceAttribute',1174,'{\"DeviceAttribute\":{\"id\":\"1174\",\"organization_id\":\"1\",\"device_id\":\"237\",\"var\":\"dns.external.fqdn\",\"val\":\"albany.dfw01.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4092,1,31,'create','DeviceAttribute',1175,'{\"DeviceAttribute\":{\"id\":\"1175\",\"organization_id\":\"1\",\"device_id\":\"237\",\"var\":\"implementation.flavor_id\",\"val\":\"2\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4093,1,31,'create','DeviceAttribute',1176,'{\"DeviceAttribute\":{\"id\":\"1176\",\"organization_id\":\"1\",\"device_id\":\"237\",\"var\":\"implementation.image_id\",\"val\":\"da1f0392-8c64-468f-a839-a9e56caebf07\",\"updated\":\"2013-10-08 21:37:48\",\"created\":\"2013-10-08 21:37:48\"}}',NULL,'2013-10-08 21:37:48','2013-10-08 21:37:48'),(4094,1,31,'create','QueueJob',204,'{\"QueueJob\":{\"id\":\"204\",\"organization_id\":\"1\",\"http_method\":\"post\",\"url\":\"http:\\/\\/localhost:8080\\/Formations\\/create\\/85\",\"body\":\"\",\"timeout_secs\":\"60\",\"last_started_at\":null,\"last_finished_at\":null,\"last_response\":null,\"result_code\":null,\"remaining_retries\":\"10\",\"retry_delay_secs\":\"60\"}}',NULL,'2013-10-08 21:37:49','2013-10-08 21:37:49'),(4095,1,31,'create','HieraVariable',114,'{\"HieraVariable\":{\"id\":\"114\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/jefferson-city.dfw01.bitlancer-infra.net\",\"var\":\"ntp::server_address\",\"val\":\"10.1.1.1\",\"updated\":\"2013-10-08 21:37:49\",\"created\":\"2013-10-08 21:37:49\"}}',NULL,'2013-10-08 21:37:49','2013-10-08 21:37:49'),(4096,1,31,'create','HieraVariable',115,'{\"HieraVariable\":{\"id\":\"115\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/albany.dfw01.bitlancer-infra.net\",\"var\":\"ntp::server_address\",\"val\":\"10.1.1.1\",\"updated\":\"2013-10-08 21:37:49\",\"created\":\"2013-10-08 21:37:49\"}}',NULL,'2013-10-08 21:37:49','2013-10-08 21:37:49'),(4097,1,31,'create','Formation',86,'{\"Formation\":{\"id\":\"86\",\"organization_id\":\"1\",\"implementation_id\":\"1\",\"blueprint_id\":\"7\",\"dictionary_id\":\"1\",\"name\":\"Mysql Cluster\",\"status\":\"building\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4098,1,31,'create','Device',238,'{\"Device\":{\"id\":\"238\",\"organization_id\":\"1\",\"device_type_id\":\"1\",\"implementation_id\":\"1\",\"formation_id\":\"86\",\"blueprint_part_id\":\"8\",\"role_id\":\"6\",\"name\":\"Boston\",\"status\":\"building\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4099,1,31,'create','DeviceAttribute',1177,'{\"DeviceAttribute\":{\"id\":\"1177\",\"organization_id\":\"1\",\"device_id\":\"238\",\"var\":\"implementation.region_id\",\"val\":\"dfw\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4100,1,31,'create','DeviceAttribute',1178,'{\"DeviceAttribute\":{\"id\":\"1178\",\"organization_id\":\"1\",\"device_id\":\"238\",\"var\":\"dns.internal.fqdn\",\"val\":\"boston.dfw01.int.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4101,1,31,'create','DeviceAttribute',1179,'{\"DeviceAttribute\":{\"id\":\"1179\",\"organization_id\":\"1\",\"device_id\":\"238\",\"var\":\"dns.external.fqdn\",\"val\":\"boston.dfw01.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4102,1,31,'create','DeviceAttribute',1180,'{\"DeviceAttribute\":{\"id\":\"1180\",\"organization_id\":\"1\",\"device_id\":\"238\",\"var\":\"implementation.flavor_id\",\"val\":\"3\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4103,1,31,'create','DeviceAttribute',1181,'{\"DeviceAttribute\":{\"id\":\"1181\",\"organization_id\":\"1\",\"device_id\":\"238\",\"var\":\"implementation.image_id\",\"val\":\"da1f0392-8c64-468f-a839-a9e56caebf07\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4104,1,31,'create','Device',239,'{\"Device\":{\"id\":\"239\",\"organization_id\":\"1\",\"device_type_id\":\"1\",\"implementation_id\":\"1\",\"formation_id\":\"86\",\"blueprint_part_id\":\"8\",\"role_id\":\"6\",\"name\":\"Harrisburg\",\"status\":\"building\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4105,1,31,'create','DeviceAttribute',1182,'{\"DeviceAttribute\":{\"id\":\"1182\",\"organization_id\":\"1\",\"device_id\":\"239\",\"var\":\"implementation.region_id\",\"val\":\"dfw\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4106,1,31,'create','DeviceAttribute',1183,'{\"DeviceAttribute\":{\"id\":\"1183\",\"organization_id\":\"1\",\"device_id\":\"239\",\"var\":\"dns.internal.fqdn\",\"val\":\"harrisburg.dfw01.int.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4107,1,31,'create','DeviceAttribute',1184,'{\"DeviceAttribute\":{\"id\":\"1184\",\"organization_id\":\"1\",\"device_id\":\"239\",\"var\":\"dns.external.fqdn\",\"val\":\"harrisburg.dfw01.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4108,1,31,'create','DeviceAttribute',1185,'{\"DeviceAttribute\":{\"id\":\"1185\",\"organization_id\":\"1\",\"device_id\":\"239\",\"var\":\"implementation.flavor_id\",\"val\":\"3\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4109,1,31,'create','DeviceAttribute',1186,'{\"DeviceAttribute\":{\"id\":\"1186\",\"organization_id\":\"1\",\"device_id\":\"239\",\"var\":\"implementation.image_id\",\"val\":\"da1f0392-8c64-468f-a839-a9e56caebf07\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4110,1,31,'create','QueueJob',205,'{\"QueueJob\":{\"id\":\"205\",\"organization_id\":\"1\",\"http_method\":\"post\",\"url\":\"http:\\/\\/localhost:8080\\/Formations\\/create\\/86\",\"body\":\"\",\"timeout_secs\":\"60\",\"last_started_at\":null,\"last_finished_at\":null,\"last_response\":null,\"result_code\":null,\"remaining_retries\":\"10\",\"retry_delay_secs\":\"60\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4111,1,31,'create','HieraVariable',116,'{\"HieraVariable\":{\"id\":\"116\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/boston.dfw01.bitlancer-infra.net\",\"var\":\"mysql::innodb_buffer_pool_size\",\"val\":\"768\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4112,1,31,'create','HieraVariable',117,'{\"HieraVariable\":{\"id\":\"117\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/boston.dfw01.bitlancer-infra.net\",\"var\":\"mysql::log_slow_querues\",\"val\":\"1\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4113,1,31,'create','HieraVariable',118,'{\"HieraVariable\":{\"id\":\"118\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/harrisburg.dfw01.bitlancer-infra.net\",\"var\":\"mysql::innodb_buffer_pool_size\",\"val\":\"768\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4114,1,31,'create','HieraVariable',119,'{\"HieraVariable\":{\"id\":\"119\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/harrisburg.dfw01.bitlancer-infra.net\",\"var\":\"mysql::log_slow_querues\",\"val\":\"1\",\"updated\":\"2013-10-08 21:39:10\",\"created\":\"2013-10-08 21:39:10\"}}',NULL,'2013-10-08 21:39:10','2013-10-08 21:39:10'),(4115,1,31,'create','Formation',87,'{\"Formation\":{\"id\":\"87\",\"organization_id\":\"1\",\"implementation_id\":\"1\",\"blueprint_id\":\"8\",\"dictionary_id\":\"1\",\"name\":\"Php-apache-cluster\",\"status\":\"building\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4116,1,31,'create','Device',240,'{\"Device\":{\"id\":\"240\",\"organization_id\":\"1\",\"device_type_id\":\"1\",\"implementation_id\":\"1\",\"formation_id\":\"87\",\"blueprint_part_id\":\"9\",\"role_id\":\"7\",\"name\":\"Saint-paul\",\"status\":\"building\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4117,1,31,'create','DeviceAttribute',1187,'{\"DeviceAttribute\":{\"id\":\"1187\",\"organization_id\":\"1\",\"device_id\":\"240\",\"var\":\"implementation.region_id\",\"val\":\"ord\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4118,1,31,'create','DeviceAttribute',1188,'{\"DeviceAttribute\":{\"id\":\"1188\",\"organization_id\":\"1\",\"device_id\":\"240\",\"var\":\"dns.internal.fqdn\",\"val\":\"saint-paul.ord01.int.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4119,1,31,'create','DeviceAttribute',1189,'{\"DeviceAttribute\":{\"id\":\"1189\",\"organization_id\":\"1\",\"device_id\":\"240\",\"var\":\"dns.external.fqdn\",\"val\":\"saint-paul.ord01.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4120,1,31,'create','DeviceAttribute',1190,'{\"DeviceAttribute\":{\"id\":\"1190\",\"organization_id\":\"1\",\"device_id\":\"240\",\"var\":\"implementation.flavor_id\",\"val\":\"3\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4121,1,31,'create','DeviceAttribute',1191,'{\"DeviceAttribute\":{\"id\":\"1191\",\"organization_id\":\"1\",\"device_id\":\"240\",\"var\":\"implementation.image_id\",\"val\":\"da1f0392-8c64-468f-a839-a9e56caebf07\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4122,1,31,'create','Device',241,'{\"Device\":{\"id\":\"241\",\"organization_id\":\"1\",\"device_type_id\":\"1\",\"implementation_id\":\"1\",\"formation_id\":\"87\",\"blueprint_part_id\":\"9\",\"role_id\":\"7\",\"name\":\"Lansing\",\"status\":\"building\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4123,1,31,'create','DeviceAttribute',1192,'{\"DeviceAttribute\":{\"id\":\"1192\",\"organization_id\":\"1\",\"device_id\":\"241\",\"var\":\"implementation.region_id\",\"val\":\"ord\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4124,1,31,'create','DeviceAttribute',1193,'{\"DeviceAttribute\":{\"id\":\"1193\",\"organization_id\":\"1\",\"device_id\":\"241\",\"var\":\"dns.internal.fqdn\",\"val\":\"lansing.ord01.int.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4125,1,31,'create','DeviceAttribute',1194,'{\"DeviceAttribute\":{\"id\":\"1194\",\"organization_id\":\"1\",\"device_id\":\"241\",\"var\":\"dns.external.fqdn\",\"val\":\"lansing.ord01.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4126,1,31,'create','DeviceAttribute',1195,'{\"DeviceAttribute\":{\"id\":\"1195\",\"organization_id\":\"1\",\"device_id\":\"241\",\"var\":\"implementation.flavor_id\",\"val\":\"3\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4127,1,31,'create','DeviceAttribute',1196,'{\"DeviceAttribute\":{\"id\":\"1196\",\"organization_id\":\"1\",\"device_id\":\"241\",\"var\":\"implementation.image_id\",\"val\":\"da1f0392-8c64-468f-a839-a9e56caebf07\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4128,1,31,'create','Device',242,'{\"Device\":{\"id\":\"242\",\"organization_id\":\"1\",\"device_type_id\":\"2\",\"implementation_id\":\"1\",\"formation_id\":\"87\",\"blueprint_part_id\":\"10\",\"role_id\":\"8\",\"name\":\"Jackson\",\"status\":\"building\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4129,1,31,'create','DeviceAttribute',1197,'{\"DeviceAttribute\":{\"id\":\"1197\",\"organization_id\":\"1\",\"device_id\":\"242\",\"var\":\"implementation.region_id\",\"val\":\"ord\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4130,1,31,'create','DeviceAttribute',1198,'{\"DeviceAttribute\":{\"id\":\"1198\",\"organization_id\":\"1\",\"device_id\":\"242\",\"var\":\"dns.internal.fqdn\",\"val\":\"jackson.ord01.int.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4131,1,31,'create','DeviceAttribute',1199,'{\"DeviceAttribute\":{\"id\":\"1199\",\"organization_id\":\"1\",\"device_id\":\"242\",\"var\":\"dns.external.fqdn\",\"val\":\"jackson.ord01.bitlancer-infra.net\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4132,1,31,'create','QueueJob',206,'{\"QueueJob\":{\"id\":\"206\",\"organization_id\":\"1\",\"http_method\":\"post\",\"url\":\"http:\\/\\/localhost:8080\\/Formations\\/create\\/87\",\"body\":\"\",\"timeout_secs\":\"60\",\"last_started_at\":null,\"last_finished_at\":null,\"last_response\":null,\"result_code\":null,\"remaining_retries\":\"10\",\"retry_delay_secs\":\"60\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4133,1,31,'create','HieraVariable',120,'{\"HieraVariable\":{\"id\":\"120\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/saint-paul.ord01.bitlancer-infra.net\",\"var\":\"apache-server::keep_alive\",\"val\":\"5\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4134,1,31,'create','HieraVariable',121,'{\"HieraVariable\":{\"id\":\"121\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/saint-paul.ord01.bitlancer-infra.net\",\"var\":\"apache-server::max_clients\",\"val\":\"100\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4135,1,31,'create','HieraVariable',122,'{\"HieraVariable\":{\"id\":\"122\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/saint-paul.ord01.bitlancer-infra.net\",\"var\":\"php::log_errors\",\"val\":\"1\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4136,1,31,'create','HieraVariable',123,'{\"HieraVariable\":{\"id\":\"123\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/saint-paul.ord01.bitlancer-infra.net\",\"var\":\"php::datetime\",\"val\":\"UTC\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4137,1,31,'create','HieraVariable',124,'{\"HieraVariable\":{\"id\":\"124\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/lansing.ord01.bitlancer-infra.net\",\"var\":\"apache-server::keep_alive\",\"val\":\"5\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4138,1,31,'create','HieraVariable',125,'{\"HieraVariable\":{\"id\":\"125\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/lansing.ord01.bitlancer-infra.net\",\"var\":\"apache-server::max_clients\",\"val\":\"100\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4139,1,31,'create','HieraVariable',126,'{\"HieraVariable\":{\"id\":\"126\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/lansing.ord01.bitlancer-infra.net\",\"var\":\"php::log_errors\",\"val\":\"1\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4140,1,31,'create','HieraVariable',127,'{\"HieraVariable\":{\"id\":\"127\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/lansing.ord01.bitlancer-infra.net\",\"var\":\"php::datetime\",\"val\":\"UTC\",\"updated\":\"2013-10-08 21:40:28\",\"created\":\"2013-10-08 21:40:28\"}}',NULL,'2013-10-08 21:40:28','2013-10-08 21:40:28'),(4141,1,31,'create','Application',10,'{\"Application\":{\"id\":\"10\",\"organization_id\":\"1\",\"name\":\"Test1\",\"updated\":\"2013-10-08 21:41:22\",\"created\":\"2013-10-08 21:41:22\"}}',NULL,'2013-10-08 21:41:22','2013-10-08 21:41:22'),(4142,1,31,'create','ApplicationFormation',24,'{\"ApplicationFormation\":{\"id\":\"24\",\"organization_id\":\"1\",\"application_id\":\"10\",\"formation_id\":\"86\",\"updated\":\"2013-10-08 21:41:44\",\"created\":\"2013-10-08 21:41:44\"}}',NULL,'2013-10-08 21:41:44','2013-10-08 21:41:44'),(4143,1,31,'create','ApplicationFormation',25,'{\"ApplicationFormation\":{\"id\":\"25\",\"organization_id\":\"1\",\"application_id\":\"10\",\"formation_id\":\"87\",\"updated\":\"2013-10-08 21:41:48\",\"created\":\"2013-10-08 21:41:48\"}}',NULL,'2013-10-08 21:41:48','2013-10-08 21:41:48'),(4144,1,31,'create','TeamApplication',52,'{\"TeamApplication\":{\"id\":\"52\",\"organization_id\":\"1\",\"team_id\":\"27\",\"application_id\":\"10\",\"updated\":\"2013-10-08 21:42:19\",\"created\":\"2013-10-08 21:42:19\"}}',NULL,'2013-10-08 21:42:19','2013-10-08 21:42:19'),(4145,1,31,'create','TeamApplicationSudo',37,'{\"TeamApplicationSudo\":{\"id\":\"37\",\"organization_id\":\"1\",\"team_application_id\":\"52\",\"sudo_id\":\"7\",\"updated\":\"2013-10-08 21:42:28\",\"created\":\"2013-10-08 21:42:28\"}}',NULL,'2013-10-08 21:42:28','2013-10-08 21:42:28'),(4146,1,31,'create','TeamApplication',53,'{\"TeamApplication\":{\"id\":\"53\",\"organization_id\":\"1\",\"team_id\":\"28\",\"application_id\":\"10\",\"updated\":\"2013-10-08 21:42:46\",\"created\":\"2013-10-08 21:42:46\"}}',NULL,'2013-10-08 21:42:46','2013-10-08 21:42:46'),(4147,1,31,'create','TeamApplication',54,'{\"TeamApplication\":{\"id\":\"54\",\"organization_id\":\"1\",\"team_id\":\"29\",\"application_id\":\"10\",\"updated\":\"2013-10-08 21:42:53\",\"created\":\"2013-10-08 21:42:53\"}}',NULL,'2013-10-08 21:42:53','2013-10-08 21:42:53'),(4148,1,31,'create','TeamApplicationSudo',38,'{\"TeamApplicationSudo\":{\"id\":\"38\",\"organization_id\":\"1\",\"team_application_id\":\"54\",\"sudo_id\":\"7\",\"updated\":\"2013-10-08 21:42:57\",\"created\":\"2013-10-08 21:42:57\"}}',NULL,'2013-10-08 21:42:57','2013-10-08 21:42:57'),(4149,1,31,'create','TeamApplicationSudo',39,'{\"TeamApplicationSudo\":{\"id\":\"39\",\"organization_id\":\"1\",\"team_application_id\":\"54\",\"sudo_id\":\"8\",\"updated\":\"2013-10-08 21:43:00\",\"created\":\"2013-10-08 21:43:00\"}}',NULL,'2013-10-08 21:43:00','2013-10-08 21:43:00'),(4150,2,38,'create','User',45,'{\"User\":{\"id\":\"45\",\"organization_id\":\"2\",\"name\":\"mjuszczak\",\"password\":\"5e88105b92d98f1dffbee8d33501e004e32ee897\",\"first_name\":\"Matt\",\"last_name\":\"Juszczak\",\"email\":\"mjuszczak@bitlancer.com\",\"is_admin\":true,\"can_create_user\":false,\"is_disabled\":false,\"updated\":\"2013-10-08 21:45:46\",\"created\":\"2013-10-08 21:45:46\",\"full_name\":\"Matt Juszczak\"}}',NULL,'2013-10-08 21:45:46','2013-10-08 21:45:46'),(4151,2,38,'update','Config',22,'{\"Config\":{\"id\":\"22\",\"organization_id\":\"2\",\"var\":\"posix.next_uid\",\"val\":\"1002\",\"updated\":\"2013-10-08 21:45:46\",\"created\":\"2013-10-08 18:49:51\"}}',NULL,'2013-10-08 21:45:46','2013-10-08 21:45:46'),(4152,2,38,'create','UserAttribute',39,'{\"UserAttribute\":{\"id\":\"39\",\"organization_id\":\"2\",\"user_id\":\"45\",\"var\":\"posix.uid\",\"val\":\"1001\",\"updated\":\"2013-10-08 21:45:46\",\"created\":\"2013-10-08 21:45:46\"}}',NULL,'2013-10-08 21:45:47','2013-10-08 21:45:47'),(4153,2,38,'create','UserAttribute',40,'{\"UserAttribute\":{\"id\":\"40\",\"organization_id\":\"2\",\"user_id\":\"45\",\"var\":\"posix.gid\",\"val\":\"1001\",\"updated\":\"2013-10-08 21:45:47\",\"created\":\"2013-10-08 21:45:47\"}}',NULL,'2013-10-08 21:45:47','2013-10-08 21:45:47'),(4154,2,38,'create','UserAttribute',41,'{\"UserAttribute\":{\"id\":\"41\",\"organization_id\":\"2\",\"user_id\":\"45\",\"var\":\"posix.shell\",\"val\":\"\\/bin\\/sh\",\"updated\":\"2013-10-08 21:45:47\",\"created\":\"2013-10-08 21:45:47\"}}',NULL,'2013-10-08 21:45:47','2013-10-08 21:45:47'),(4155,2,38,'create','Team',32,'{\"Team\":{\"id\":\"32\",\"organization_id\":\"2\",\"name\":\"Everyone\",\"is_disabled\":false,\"updated\":\"2013-10-08 21:46:28\",\"created\":\"2013-10-08 21:46:28\"}}',NULL,'2013-10-08 21:46:28','2013-10-08 21:46:28'),(4156,2,38,'create','UserTeam',51,'{\"UserTeam\":{\"id\":\"51\",\"organization_id\":\"2\",\"user_id\":\"38\",\"team_id\":\"32\",\"updated\":\"2013-10-08 21:46:28\",\"created\":\"2013-10-08 21:46:28\"}}',NULL,'2013-10-08 21:46:28','2013-10-08 21:46:28'),(4157,2,38,'create','UserTeam',52,'{\"UserTeam\":{\"id\":\"52\",\"organization_id\":\"2\",\"user_id\":\"45\",\"team_id\":\"32\",\"updated\":\"2013-10-08 21:46:28\",\"created\":\"2013-10-08 21:46:28\"}}',NULL,'2013-10-08 21:46:28','2013-10-08 21:46:28'),(4158,2,38,'create','User',46,'{\"User\":{\"id\":\"46\",\"organization_id\":\"2\",\"name\":\"bgormley\",\"password\":\"e250873dd50af1572764aa6da16b2ee16dd913bf\",\"first_name\":\"Brian\",\"last_name\":\"Gormley\",\"email\":\"bgormley@bitlancer.net\",\"is_admin\":false,\"can_create_user\":false,\"is_disabled\":false,\"updated\":\"2013-10-08 21:47:12\",\"created\":\"2013-10-08 21:47:12\",\"full_name\":\"Brian Gormley\"}}',NULL,'2013-10-08 21:47:12','2013-10-08 21:47:12'),(4159,2,38,'update','Config',22,'{\"Config\":{\"id\":\"22\",\"organization_id\":\"2\",\"var\":\"posix.next_uid\",\"val\":\"1003\",\"updated\":\"2013-10-08 21:47:12\",\"created\":\"2013-10-08 18:49:51\"}}',NULL,'2013-10-08 21:47:12','2013-10-08 21:47:12'),(4160,2,38,'create','UserAttribute',42,'{\"UserAttribute\":{\"id\":\"42\",\"organization_id\":\"2\",\"user_id\":\"46\",\"var\":\"posix.uid\",\"val\":\"1002\",\"updated\":\"2013-10-08 21:47:12\",\"created\":\"2013-10-08 21:47:12\"}}',NULL,'2013-10-08 21:47:12','2013-10-08 21:47:12'),(4161,2,38,'create','UserAttribute',43,'{\"UserAttribute\":{\"id\":\"43\",\"organization_id\":\"2\",\"user_id\":\"46\",\"var\":\"posix.gid\",\"val\":\"1002\",\"updated\":\"2013-10-08 21:47:12\",\"created\":\"2013-10-08 21:47:12\"}}',NULL,'2013-10-08 21:47:12','2013-10-08 21:47:12'),(4162,2,38,'create','UserAttribute',44,'{\"UserAttribute\":{\"id\":\"44\",\"organization_id\":\"2\",\"user_id\":\"46\",\"var\":\"posix.shell\",\"val\":\"\\/bin\\/sh\",\"updated\":\"2013-10-08 21:47:12\",\"created\":\"2013-10-08 21:47:12\"}}',NULL,'2013-10-08 21:47:12','2013-10-08 21:47:12'),(4163,2,38,'create','UserKey',8,'{\"UserKey\":{\"id\":\"8\",\"organization_id\":\"2\",\"user_id\":\"45\",\"name\":\"laptop\",\"public_key\":\"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3gHZj3q2xpI+Ve3aqxtKy61MUx70cXS4kARHQxRr2Gexc814+QpLTX1TGf7fNbm7tIm\\/MzDXh1xSWVB7LAtX5UFrzcesqvB5FhlFdY9sebFIWLQsERLQbzDIAaP3Y7h01bCNUWDiusjmtIBsRnZlsm59yCZLyRGT5xGy9pQultaxN4beyD6xZN7+35ik43CUKYfrxQ0kqC6ireRgyP+zWVyZHnrDO\\/Ri5OZAWz3e8CDXscys01VavpNrMibPIALYjyjnULXo8mBZ0FSQ31k5UjYTXDXI4QBN6iSGY\\/6He6xcmllTxCjtJA927RSCbZyJ8PUNM6kKynCIkDaa7RGNV\",\"updated\":\"2013-10-08 21:47:32\",\"created\":\"2013-10-08 21:47:32\"}}',NULL,'2013-10-08 21:47:32','2013-10-08 21:47:32'),(4164,2,38,'create','UserTeam',53,'{\"UserTeam\":{\"id\":\"53\",\"organization_id\":\"2\",\"user_id\":\"46\",\"team_id\":\"32\",\"updated\":\"2013-10-08 21:47:49\",\"created\":\"2013-10-08 21:47:49\"}}',NULL,'2013-10-08 21:47:49','2013-10-08 21:47:49'),(4165,2,38,'create','Application',11,'{\"Application\":{\"id\":\"11\",\"organization_id\":\"2\",\"name\":\"Test\",\"updated\":\"2013-10-08 21:48:13\",\"created\":\"2013-10-08 21:48:13\"}}',NULL,'2013-10-08 21:48:13','2013-10-08 21:48:13'),(4166,2,38,'create','Formation',88,'{\"Formation\":{\"id\":\"88\",\"organization_id\":\"2\",\"implementation_id\":\"2\",\"blueprint_id\":\"10\",\"dictionary_id\":\"14\",\"name\":\"Mysql Cluster\",\"status\":\"building\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4167,2,38,'create','Device',243,'{\"Device\":{\"id\":\"243\",\"organization_id\":\"2\",\"device_type_id\":\"1\",\"implementation_id\":\"2\",\"formation_id\":\"88\",\"blueprint_part_id\":\"12\",\"role_id\":\"10\",\"name\":\"New York\",\"status\":\"building\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4168,2,38,'create','DeviceAttribute',1200,'{\"DeviceAttribute\":{\"id\":\"1200\",\"organization_id\":\"2\",\"device_id\":\"243\",\"var\":\"implementation.region_id\",\"val\":\"dfw\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4169,2,38,'create','DeviceAttribute',1201,'{\"DeviceAttribute\":{\"id\":\"1201\",\"organization_id\":\"2\",\"device_id\":\"243\",\"var\":\"dns.internal.fqdn\",\"val\":\"new york.dfw01.int.example-infra.net\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4170,2,38,'create','DeviceAttribute',1202,'{\"DeviceAttribute\":{\"id\":\"1202\",\"organization_id\":\"2\",\"device_id\":\"243\",\"var\":\"dns.external.fqdn\",\"val\":\"new york.dfw01.example-infra.net\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4171,2,38,'create','DeviceAttribute',1203,'{\"DeviceAttribute\":{\"id\":\"1203\",\"organization_id\":\"2\",\"device_id\":\"243\",\"var\":\"implementation.flavor_id\",\"val\":\"4\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4172,2,38,'create','DeviceAttribute',1204,'{\"DeviceAttribute\":{\"id\":\"1204\",\"organization_id\":\"2\",\"device_id\":\"243\",\"var\":\"implementation.image_id\",\"val\":\"\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4173,2,38,'create','Device',244,'{\"Device\":{\"id\":\"244\",\"organization_id\":\"2\",\"device_type_id\":\"1\",\"implementation_id\":\"2\",\"formation_id\":\"88\",\"blueprint_part_id\":\"12\",\"role_id\":\"10\",\"name\":\"Massachusetts\",\"status\":\"building\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4174,2,38,'create','DeviceAttribute',1205,'{\"DeviceAttribute\":{\"id\":\"1205\",\"organization_id\":\"2\",\"device_id\":\"244\",\"var\":\"implementation.region_id\",\"val\":\"dfw\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4175,2,38,'create','DeviceAttribute',1206,'{\"DeviceAttribute\":{\"id\":\"1206\",\"organization_id\":\"2\",\"device_id\":\"244\",\"var\":\"dns.internal.fqdn\",\"val\":\"massachusetts.dfw01.int.example-infra.net\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4176,2,38,'create','DeviceAttribute',1207,'{\"DeviceAttribute\":{\"id\":\"1207\",\"organization_id\":\"2\",\"device_id\":\"244\",\"var\":\"dns.external.fqdn\",\"val\":\"massachusetts.dfw01.example-infra.net\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4177,2,38,'create','DeviceAttribute',1208,'{\"DeviceAttribute\":{\"id\":\"1208\",\"organization_id\":\"2\",\"device_id\":\"244\",\"var\":\"implementation.flavor_id\",\"val\":\"4\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4178,2,38,'create','DeviceAttribute',1209,'{\"DeviceAttribute\":{\"id\":\"1209\",\"organization_id\":\"2\",\"device_id\":\"244\",\"var\":\"implementation.image_id\",\"val\":\"\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4179,2,38,'create','QueueJob',207,'{\"QueueJob\":{\"id\":\"207\",\"organization_id\":\"2\",\"http_method\":\"post\",\"url\":\"http:\\/\\/localhost:8080\\/Formations\\/create\\/88\",\"body\":\"\",\"timeout_secs\":\"60\",\"last_started_at\":null,\"last_finished_at\":null,\"last_response\":null,\"result_code\":null,\"remaining_retries\":\"10\",\"retry_delay_secs\":\"60\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4180,2,38,'create','HieraVariable',128,'{\"HieraVariable\":{\"id\":\"128\",\"organization_id\":\"2\",\"hiera_key\":\"fqdn\\/new york.dfw01.example-infra.net\",\"var\":\"mysql::innodb_buffer_pool_size\",\"val\":\"1536\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4181,2,38,'create','HieraVariable',129,'{\"HieraVariable\":{\"id\":\"129\",\"organization_id\":\"2\",\"hiera_key\":\"fqdn\\/new york.dfw01.example-infra.net\",\"var\":\"mysql::log_slow_querues\",\"val\":\"0\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4182,2,38,'create','HieraVariable',130,'{\"HieraVariable\":{\"id\":\"130\",\"organization_id\":\"2\",\"hiera_key\":\"fqdn\\/massachusetts.dfw01.example-infra.net\",\"var\":\"mysql::innodb_buffer_pool_size\",\"val\":\"1536\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4183,2,38,'create','HieraVariable',131,'{\"HieraVariable\":{\"id\":\"131\",\"organization_id\":\"2\",\"hiera_key\":\"fqdn\\/massachusetts.dfw01.example-infra.net\",\"var\":\"mysql::log_slow_querues\",\"val\":\"0\",\"updated\":\"2013-10-08 21:53:43\",\"created\":\"2013-10-08 21:53:43\"}}',NULL,'2013-10-08 21:53:43','2013-10-08 21:53:43'),(4184,2,38,'create','Device',245,'{\"Device\":{\"id\":\"245\",\"organization_id\":\"2\",\"device_type_id\":\"1\",\"implementation_id\":\"2\",\"formation_id\":\"88\",\"blueprint_part_id\":\"12\",\"role_id\":\"10\",\"name\":\"Alaska\",\"status\":\"building\",\"updated\":\"2013-10-09 02:02:35\",\"created\":\"2013-10-09 02:02:35\"}}',NULL,'2013-10-09 02:02:35','2013-10-09 02:02:35'),(4185,2,38,'create','DeviceAttribute',1285,'{\"DeviceAttribute\":{\"id\":\"1285\",\"organization_id\":\"2\",\"device_id\":\"245\",\"var\":\"implementation.region_id\",\"val\":\"dfw\",\"updated\":\"2013-10-09 02:02:35\",\"created\":\"2013-10-09 02:02:35\"}}',NULL,'2013-10-09 02:02:35','2013-10-09 02:02:35'),(4186,2,38,'create','DeviceAttribute',1286,'{\"DeviceAttribute\":{\"id\":\"1286\",\"organization_id\":\"2\",\"device_id\":\"245\",\"var\":\"dns.internal.fqdn\",\"val\":\"alaska.dfw01.int.example-infra.net\",\"updated\":\"2013-10-09 02:02:35\",\"created\":\"2013-10-09 02:02:35\"}}',NULL,'2013-10-09 02:02:35','2013-10-09 02:02:35'),(4187,2,38,'create','DeviceAttribute',1287,'{\"DeviceAttribute\":{\"id\":\"1287\",\"organization_id\":\"2\",\"device_id\":\"245\",\"var\":\"dns.external.fqdn\",\"val\":\"alaska.dfw01.example-infra.net\",\"updated\":\"2013-10-09 02:02:35\",\"created\":\"2013-10-09 02:02:35\"}}',NULL,'2013-10-09 02:02:36','2013-10-09 02:02:36'),(4188,2,38,'create','DeviceAttribute',1288,'{\"DeviceAttribute\":{\"id\":\"1288\",\"organization_id\":\"2\",\"device_id\":\"245\",\"var\":\"implementation.flavor_id\",\"val\":\"4\",\"updated\":\"2013-10-09 02:02:36\",\"created\":\"2013-10-09 02:02:36\"}}',NULL,'2013-10-09 02:02:36','2013-10-09 02:02:36'),(4189,2,38,'create','DeviceAttribute',1289,'{\"DeviceAttribute\":{\"id\":\"1289\",\"organization_id\":\"2\",\"device_id\":\"245\",\"var\":\"implementation.image_id\",\"val\":\"da1f0392-8c64-468f-a839-a9e56caebf07\",\"updated\":\"2013-10-09 02:02:36\",\"created\":\"2013-10-09 02:02:36\"}}',NULL,'2013-10-09 02:02:36','2013-10-09 02:02:36'),(4190,2,38,'create','HieraVariable',132,'{\"HieraVariable\":{\"id\":\"132\",\"organization_id\":\"2\",\"hiera_key\":\"fqdn\\/alaska.dfw01.example-infra.net\",\"var\":\"mysql::innodb_buffer_pool_size\",\"val\":\"1536\",\"updated\":\"2013-10-09 02:02:36\",\"created\":\"2013-10-09 02:02:36\"}}',NULL,'2013-10-09 02:02:36','2013-10-09 02:02:36'),(4191,2,38,'create','HieraVariable',133,'{\"HieraVariable\":{\"id\":\"133\",\"organization_id\":\"2\",\"hiera_key\":\"fqdn\\/alaska.dfw01.example-infra.net\",\"var\":\"mysql::log_slow_querues\",\"val\":\"0\",\"updated\":\"2013-10-09 02:02:36\",\"created\":\"2013-10-09 02:02:36\"}}',NULL,'2013-10-09 02:02:36','2013-10-09 02:02:36'),(4192,2,38,'create','QueueJob',217,'{\"QueueJob\":{\"id\":\"217\",\"organization_id\":\"2\",\"http_method\":\"post\",\"url\":\"http:\\/\\/localhost:8080\\/Instances\\/create\\/245\",\"body\":\"\",\"timeout_secs\":\"60\",\"last_started_at\":null,\"last_finished_at\":null,\"last_response\":null,\"result_code\":null,\"remaining_retries\":\"20\",\"retry_delay_secs\":\"60\"}}',NULL,'2013-10-09 02:02:36','2013-10-09 02:02:36'),(4193,3,39,'create','User',47,'{\"User\":{\"id\":\"47\",\"organization_id\":\"3\",\"name\":\"mjuszczak\",\"password\":\"5e88105b92d98f1dffbee8d33501e004e32ee897\",\"first_name\":\"Matt\",\"last_name\":\"Juszczak\",\"email\":\"mjuszczak@bitlancer.com\",\"is_admin\":true,\"can_create_user\":false,\"is_disabled\":false,\"updated\":\"2013-10-09 02:04:32\",\"created\":\"2013-10-09 02:04:32\",\"full_name\":\"Matt Juszczak\"}}',NULL,'2013-10-09 02:04:32','2013-10-09 02:04:32'),(4194,3,39,'update','Config',33,'{\"Config\":{\"id\":\"33\",\"organization_id\":\"3\",\"var\":\"posix.next_uid\",\"val\":\"2002\",\"updated\":\"2013-10-09 02:04:32\",\"created\":\"2013-10-08 18:53:28\"}}',NULL,'2013-10-09 02:04:32','2013-10-09 02:04:32'),(4195,3,39,'create','UserAttribute',45,'{\"UserAttribute\":{\"id\":\"45\",\"organization_id\":\"3\",\"user_id\":\"47\",\"var\":\"posix.uid\",\"val\":\"2001\",\"updated\":\"2013-10-09 02:04:32\",\"created\":\"2013-10-09 02:04:32\"}}',NULL,'2013-10-09 02:04:32','2013-10-09 02:04:32'),(4196,3,39,'create','UserAttribute',46,'{\"UserAttribute\":{\"id\":\"46\",\"organization_id\":\"3\",\"user_id\":\"47\",\"var\":\"posix.gid\",\"val\":\"2001\",\"updated\":\"2013-10-09 02:04:32\",\"created\":\"2013-10-09 02:04:32\"}}',NULL,'2013-10-09 02:04:32','2013-10-09 02:04:32'),(4197,3,39,'create','UserAttribute',47,'{\"UserAttribute\":{\"id\":\"47\",\"organization_id\":\"3\",\"user_id\":\"47\",\"var\":\"posix.shell\",\"val\":\"\\/usr\\/bin\\/csh\",\"updated\":\"2013-10-09 02:04:32\",\"created\":\"2013-10-09 02:04:32\"}}',NULL,'2013-10-09 02:04:32','2013-10-09 02:04:32'),(4198,3,39,'create','User',48,'{\"User\":{\"id\":\"48\",\"organization_id\":\"3\",\"name\":\"bgormley\",\"password\":\"e250873dd50af1572764aa6da16b2ee16dd913bf\",\"first_name\":\"Brian\",\"last_name\":\"Gormley\",\"email\":\"bgormley@bitlancer.com\",\"is_admin\":true,\"can_create_user\":false,\"is_disabled\":false,\"updated\":\"2013-10-09 02:05:19\",\"created\":\"2013-10-09 02:05:19\",\"full_name\":\"Brian Gormley\"}}',NULL,'2013-10-09 02:05:20','2013-10-09 02:05:20'),(4199,3,39,'update','Config',33,'{\"Config\":{\"id\":\"33\",\"organization_id\":\"3\",\"var\":\"posix.next_uid\",\"val\":\"2003\",\"updated\":\"2013-10-09 02:05:20\",\"created\":\"2013-10-08 18:53:28\"}}',NULL,'2013-10-09 02:05:20','2013-10-09 02:05:20'),(4200,3,39,'create','UserAttribute',48,'{\"UserAttribute\":{\"id\":\"48\",\"organization_id\":\"3\",\"user_id\":\"48\",\"var\":\"posix.uid\",\"val\":\"2002\",\"updated\":\"2013-10-09 02:05:20\",\"created\":\"2013-10-09 02:05:20\"}}',NULL,'2013-10-09 02:05:20','2013-10-09 02:05:20'),(4201,3,39,'create','UserAttribute',49,'{\"UserAttribute\":{\"id\":\"49\",\"organization_id\":\"3\",\"user_id\":\"48\",\"var\":\"posix.gid\",\"val\":\"2002\",\"updated\":\"2013-10-09 02:05:20\",\"created\":\"2013-10-09 02:05:20\"}}',NULL,'2013-10-09 02:05:20','2013-10-09 02:05:20'),(4202,3,39,'create','UserAttribute',50,'{\"UserAttribute\":{\"id\":\"50\",\"organization_id\":\"3\",\"user_id\":\"48\",\"var\":\"posix.shell\",\"val\":\"\\/usr\\/bin\\/csh\",\"updated\":\"2013-10-09 02:05:20\",\"created\":\"2013-10-09 02:05:20\"}}',NULL,'2013-10-09 02:05:20','2013-10-09 02:05:20'),(4203,3,39,'update','User',48,'{\"User\":{\"id\":\"48\",\"organization_id\":\"3\",\"name\":\"bgormley\",\"password\":\"e250873dd50af1572764aa6da16b2ee16dd913bf\",\"first_name\":\"Brian\",\"last_name\":\"Gormley\",\"email\":\"bgormley@bitlancer.com\",\"is_admin\":true,\"can_create_user\":false,\"is_disabled\":true,\"updated\":\"2013-10-09 02:05:30\",\"created\":\"2013-10-09 02:05:19\",\"full_name\":\"Brian Gormley\"}}',NULL,'2013-10-09 02:05:30','2013-10-09 02:05:30'),(4204,3,39,'create','Application',12,'{\"Application\":{\"id\":\"12\",\"organization_id\":\"3\",\"name\":\"Test\",\"updated\":\"2013-10-09 02:05:48\",\"created\":\"2013-10-09 02:05:48\"}}',NULL,'2013-10-09 02:05:48','2013-10-09 02:05:48'),(4205,1,37,'create','TeamRole',3,'{\"TeamRole\":{\"id\":\"3\",\"organization_id\":\"1\",\"team_id\":\"27\",\"role_id\":\"5\",\"updated\":\"2013-10-09 02:08:26\",\"created\":\"2013-10-09 02:08:26\"}}',NULL,'2013-10-09 02:08:26','2013-10-09 02:08:26'),(4206,1,37,'create','TeamRoleSudo',3,'{\"TeamRoleSudo\":{\"id\":\"3\",\"organization_id\":\"1\",\"team_role_id\":\"3\",\"sudo_id\":\"7\",\"updated\":\"2013-10-09 02:08:33\",\"created\":\"2013-10-09 02:08:33\"}}',NULL,'2013-10-09 02:08:33','2013-10-09 02:08:33'),(4207,1,37,'create','TeamRole',4,'{\"TeamRole\":{\"id\":\"4\",\"organization_id\":\"1\",\"team_id\":\"28\",\"role_id\":\"8\",\"updated\":\"2013-10-09 02:08:43\",\"created\":\"2013-10-09 02:08:43\"}}',NULL,'2013-10-09 02:08:43','2013-10-09 02:08:43'),(4208,1,37,'create','TeamRole',5,'{\"TeamRole\":{\"id\":\"5\",\"organization_id\":\"1\",\"team_id\":\"29\",\"role_id\":\"6\",\"updated\":\"2013-10-09 02:08:51\",\"created\":\"2013-10-09 02:08:51\"}}',NULL,'2013-10-09 02:08:51','2013-10-09 02:08:51'),(4209,1,37,'create','DeviceDns',3,'{\"DeviceDns\":{\"id\":\"3\",\"organization_id\":\"1\",\"application_formation_id\":\"24\",\"device_id\":\"238\",\"name\":\"test.test1.dfw01.int.bitlancer-infra.net\",\"updated\":\"0000-00-00 00:00:00\",\"created\":\"0000-00-00 00:00:00\"}}',NULL,'2013-10-09 02:09:15','2013-10-09 02:09:15'),(4210,1,37,'create','DeviceDns',4,'{\"DeviceDns\":{\"id\":\"4\",\"organization_id\":\"1\",\"application_formation_id\":\"24\",\"device_id\":\"238\",\"name\":\"test2.test1.dfw01.int.bitlancer-infra.net\",\"updated\":\"0000-00-00 00:00:00\",\"created\":\"0000-00-00 00:00:00\"}}',NULL,'2013-10-09 02:09:18','2013-10-09 02:09:18'),(4211,1,37,'create','TeamFormation',5,'{\"TeamFormation\":{\"id\":\"5\",\"organization_id\":\"1\",\"team_id\":\"27\",\"formation_id\":\"85\",\"updated\":\"2013-10-09 02:10:11\",\"created\":\"2013-10-09 02:10:11\"}}',NULL,'2013-10-09 02:10:11','2013-10-09 02:10:11'),(4212,1,37,'create','TeamFormation',6,'{\"TeamFormation\":{\"id\":\"6\",\"organization_id\":\"1\",\"team_id\":\"28\",\"formation_id\":\"86\",\"updated\":\"2013-10-09 02:10:23\",\"created\":\"2013-10-09 02:10:23\"}}',NULL,'2013-10-09 02:10:23','2013-10-09 02:10:23'),(4213,1,37,'create','TeamFormationSudo',1,'{\"TeamFormationSudo\":{\"id\":\"1\",\"organization_id\":\"1\",\"team_formation_id\":\"6\",\"sudo_id\":\"7\",\"updated\":\"2013-10-09 02:10:31\",\"created\":\"2013-10-09 02:10:31\"}}',NULL,'2013-10-09 02:10:31','2013-10-09 02:10:31'),(4214,1,37,'create','Formation',89,'{\"Formation\":{\"id\":\"89\",\"organization_id\":\"1\",\"implementation_id\":\"1\",\"blueprint_id\":\"6\",\"dictionary_id\":\"2\",\"name\":\"Test\",\"status\":\"building\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4215,1,37,'create','Device',246,'{\"Device\":{\"id\":\"246\",\"organization_id\":\"1\",\"device_type_id\":\"1\",\"implementation_id\":\"1\",\"formation_id\":\"89\",\"blueprint_part_id\":\"7\",\"role_id\":\"5\",\"name\":\"Alaska\",\"status\":\"building\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4216,1,37,'create','DeviceAttribute',1290,'{\"DeviceAttribute\":{\"id\":\"1290\",\"organization_id\":\"1\",\"device_id\":\"246\",\"var\":\"implementation.region_id\",\"val\":\"dfw\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4217,1,37,'create','DeviceAttribute',1291,'{\"DeviceAttribute\":{\"id\":\"1291\",\"organization_id\":\"1\",\"device_id\":\"246\",\"var\":\"dns.internal.fqdn\",\"val\":\"alaska.dfw01.int.bitlancer-infra.net\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4218,1,37,'create','DeviceAttribute',1292,'{\"DeviceAttribute\":{\"id\":\"1292\",\"organization_id\":\"1\",\"device_id\":\"246\",\"var\":\"dns.external.fqdn\",\"val\":\"alaska.dfw01.bitlancer-infra.net\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4219,1,37,'create','DeviceAttribute',1293,'{\"DeviceAttribute\":{\"id\":\"1293\",\"organization_id\":\"1\",\"device_id\":\"246\",\"var\":\"implementation.flavor_id\",\"val\":\"2\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4220,1,37,'create','DeviceAttribute',1294,'{\"DeviceAttribute\":{\"id\":\"1294\",\"organization_id\":\"1\",\"device_id\":\"246\",\"var\":\"implementation.image_id\",\"val\":\"da1f0392-8c64-468f-a839-a9e56caebf07\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4221,1,37,'create','Device',247,'{\"Device\":{\"id\":\"247\",\"organization_id\":\"1\",\"device_type_id\":\"1\",\"implementation_id\":\"1\",\"formation_id\":\"89\",\"blueprint_part_id\":\"7\",\"role_id\":\"5\",\"name\":\"Washington\",\"status\":\"building\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4222,1,37,'create','DeviceAttribute',1295,'{\"DeviceAttribute\":{\"id\":\"1295\",\"organization_id\":\"1\",\"device_id\":\"247\",\"var\":\"implementation.region_id\",\"val\":\"dfw\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4223,1,37,'create','DeviceAttribute',1296,'{\"DeviceAttribute\":{\"id\":\"1296\",\"organization_id\":\"1\",\"device_id\":\"247\",\"var\":\"dns.internal.fqdn\",\"val\":\"washington.dfw01.int.bitlancer-infra.net\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4224,1,37,'create','DeviceAttribute',1297,'{\"DeviceAttribute\":{\"id\":\"1297\",\"organization_id\":\"1\",\"device_id\":\"247\",\"var\":\"dns.external.fqdn\",\"val\":\"washington.dfw01.bitlancer-infra.net\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4225,1,37,'create','DeviceAttribute',1298,'{\"DeviceAttribute\":{\"id\":\"1298\",\"organization_id\":\"1\",\"device_id\":\"247\",\"var\":\"implementation.flavor_id\",\"val\":\"2\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4226,1,37,'create','DeviceAttribute',1299,'{\"DeviceAttribute\":{\"id\":\"1299\",\"organization_id\":\"1\",\"device_id\":\"247\",\"var\":\"implementation.image_id\",\"val\":\"da1f0392-8c64-468f-a839-a9e56caebf07\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4227,1,37,'create','QueueJob',218,'{\"QueueJob\":{\"id\":\"218\",\"organization_id\":\"1\",\"http_method\":\"post\",\"url\":\"http:\\/\\/localhost:8080\\/Formations\\/create\\/89\",\"body\":\"\",\"timeout_secs\":\"60\",\"last_started_at\":null,\"last_finished_at\":null,\"last_response\":null,\"result_code\":null,\"remaining_retries\":\"10\",\"retry_delay_secs\":\"60\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4228,1,37,'create','HieraVariable',134,'{\"HieraVariable\":{\"id\":\"134\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/alaska.dfw01.bitlancer-infra.net\",\"var\":\"ntp::server_address\",\"val\":\"10.1.1.1\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43'),(4229,1,37,'create','HieraVariable',135,'{\"HieraVariable\":{\"id\":\"135\",\"organization_id\":\"1\",\"hiera_key\":\"fqdn\\/washington.dfw01.bitlancer-infra.net\",\"var\":\"ntp::server_address\",\"val\":\"10.1.1.1\",\"updated\":\"2013-10-09 02:12:43\",\"created\":\"2013-10-09 02:12:43\"}}',NULL,'2013-10-09 02:12:43','2013-10-09 02:12:43');
/*!40000 ALTER TABLE `audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `audit_delta`
--

DROP TABLE IF EXISTS `audit_delta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audit_delta` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the audit delta record',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `audit_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the audit record this record belongs to',
  `property_name` varchar(255) NOT NULL COMMENT 'The property that was modified',
  `old_value` text COMMENT 'The original value of the property',
  `new_value` text COMMENT 'The new value of the property',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_delta`
--

LOCK TABLES `audit_delta` WRITE;
/*!40000 ALTER TABLE `audit_delta` DISABLE KEYS */;
INSERT INTO `audit_delta` VALUES (77,1,4034,'val','10','11','2013-10-08 19:05:44','2013-10-08 19:05:44'),(78,1,4039,'val','11','12','2013-10-08 21:28:04','2013-10-08 21:28:04'),(79,1,4044,'val','12','13','2013-10-08 21:28:46','2013-10-08 21:28:46'),(80,1,4052,'val','13','14','2013-10-08 21:30:56','2013-10-08 21:30:56'),(81,1,4078,'is_disabled','','1','2013-10-08 21:36:20','2013-10-08 21:36:20'),(82,1,4079,'is_disabled','','1','2013-10-08 21:36:38','2013-10-08 21:36:38'),(83,1,4080,'is_disabled','','1','2013-10-08 21:36:43','2013-10-08 21:36:43'),(84,2,4151,'val','1001','1002','2013-10-08 21:45:46','2013-10-08 21:45:46'),(85,2,4159,'val','1002','1003','2013-10-08 21:47:12','2013-10-08 21:47:12'),(86,3,4194,'val','2001','2002','2013-10-09 02:04:32','2013-10-09 02:04:32'),(87,3,4199,'val','2002','2003','2013-10-09 02:05:20','2013-10-09 02:05:20'),(88,3,4203,'is_disabled','','1','2013-10-09 02:05:30','2013-10-09 02:05:30');
/*!40000 ALTER TABLE `audit_delta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blueprint`
--

DROP TABLE IF EXISTS `blueprint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blueprint` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the blueprint',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(64) NOT NULL COMMENT 'The name of the blueprint',
  `short_description` varchar(255) DEFAULT NULL COMMENT 'The short description of the blueprint',
  `description` text COMMENT 'The full description of the blueprint',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blueprint`
--

LOCK TABLES `blueprint` WRITE;
/*!40000 ALTER TABLE `blueprint` DISABLE KEYS */;
INSERT INTO `blueprint` VALUES (6,1,'Base Node Cluster','A cluster of generic servers','A cluster of generic servers','2013-10-08 19:47:21','2013-10-08 19:47:21'),(7,1,'MySQL Clstuer','A cluster of MySQL servers','A cluster of MySQL servers that can be configured for replication','2013-10-08 19:47:21','2013-10-08 19:47:21'),(8,1,'PHP-Apache Web Cluster','A cluster of PHP-Apache servers','A cluster of PHP-Apache servers','2013-10-08 19:47:21','2013-10-08 19:47:21'),(9,2,'Base Node Cluster','A cluster of generic servers','A cluster of generic servers','2013-10-08 19:48:01','2013-10-08 19:48:01'),(10,2,'MySQL Clstuer','A cluster of MySQL servers','A cluster of MySQL servers that can be configured for replication','2013-10-08 19:48:01','2013-10-08 19:48:01'),(11,2,'PHP-Apache Web Cluster','A cluster of PHP-Apache servers','A cluster of PHP-Apache servers','2013-10-08 19:48:01','2013-10-08 19:48:01'),(12,3,'Base Node Cluster','A cluster of generic servers','A cluster of generic servers','2013-10-08 19:48:14','2013-10-08 19:48:14'),(13,3,'MySQL Clstuer','A cluster of MySQL servers','A cluster of MySQL servers that can be configured for replication','2013-10-08 19:48:14','2013-10-08 19:48:14'),(14,3,'PHP-Apache Web Cluster','A cluster of PHP-Apache servers','A cluster of PHP-Apache servers','2013-10-08 19:48:14','2013-10-08 19:48:14');
/*!40000 ALTER TABLE `blueprint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `blueprint_part`
--

DROP TABLE IF EXISTS `blueprint_part`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blueprint_part` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the blueprint part',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `device_type_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the device_type that this device belongs to',
  `blueprint_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the blueprint',
  `role_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the role this part references',
  `name` varchar(64) NOT NULL COMMENT 'The name of the blueprint part',
  `description` varchar(255) DEFAULT NULL COMMENT 'The description of the blueprint part',
  `minimum` tinyint(3) unsigned DEFAULT '1' COMMENT 'The minimum number of devices that will be spun up',
  `maximum` tinyint(3) unsigned DEFAULT '1' COMMENT 'The maximum number of devices that will be spun up',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blueprint_part`
--

LOCK TABLES `blueprint_part` WRITE;
/*!40000 ALTER TABLE `blueprint_part` DISABLE KEYS */;
INSERT INTO `blueprint_part` VALUES (7,1,1,6,5,'Base Node',NULL,1,9,'2013-10-08 20:48:05','2013-10-08 20:48:05'),(8,1,1,7,6,'MySQL Server',NULL,1,9,'2013-10-08 20:48:05','2013-10-08 20:48:05'),(9,1,1,8,7,'PHP-Apache Web Server',NULL,1,9,'2013-10-08 20:48:05','2013-10-08 20:48:05'),(10,1,2,8,8,'Load-balancer',NULL,1,9,'2013-10-08 20:48:05','2013-10-08 20:48:05'),(11,2,1,9,9,'Base Node',NULL,1,9,'2013-10-08 20:50:47','2013-10-08 20:50:47'),(12,2,1,10,10,'MySQL Server',NULL,1,9,'2013-10-08 20:50:47','2013-10-08 20:50:47'),(13,2,1,11,11,'PHP-Apache Web Server',NULL,1,9,'2013-10-08 20:50:47','2013-10-08 20:50:47'),(14,2,2,11,12,'Load-balancer',NULL,1,9,'2013-10-08 20:50:47','2013-10-08 20:50:47'),(15,3,1,12,13,'Base Node',NULL,1,9,'2013-10-08 20:51:48','2013-10-08 20:51:48'),(16,3,1,13,14,'MySQL Server',NULL,1,9,'2013-10-08 20:51:48','2013-10-08 20:51:48'),(17,3,1,14,15,'PHP-Apache Web Server',NULL,1,9,'2013-10-08 20:51:48','2013-10-08 20:51:48'),(18,3,2,14,16,'Load-balancer',NULL,1,9,'2013-10-08 20:51:48','2013-10-08 20:51:48');
/*!40000 ALTER TABLE `blueprint_part` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES (1,1,'dns.external.domain','bitlancer-infra.net','2013-05-22 16:37:33','2013-05-21 18:46:12'),(2,1,'dns.external.implementation_id','1','2013-05-22 16:40:56','2013-05-21 20:11:59'),(3,1,'dns.external.region_id','DFW','2013-06-13 18:45:02','2013-05-22 16:39:09'),(4,1,'dns.external.domain_id','3845853','2013-08-25 20:28:04','2013-05-22 16:40:14'),(5,1,'dns.external.record_ttl','300','2013-05-22 16:54:16','2013-05-22 16:54:16'),(6,1,'dns.internal.domain','int.bitlancer-infra.net','2013-06-19 18:38:37','2013-06-19 18:38:37'),(7,1,'ldap.basedn','dc=bitlancer-infra,dc=net','2013-06-19 19:35:37','2013-06-19 18:38:37'),(8,1,'dns.internal.network_attribute','implementation.address.private.4','2013-06-19 18:59:46','2013-06-19 18:59:46'),(9,1,'posix.default_shell','/bin/bash','2013-06-20 00:08:50','2013-06-20 00:08:50'),(10,1,'posix.next_uid','14','2013-10-08 21:30:56','2013-06-20 00:09:12'),(11,1,'implementation.image_schedule.retention','3','2013-08-25 20:29:36','2013-08-25 20:29:36'),(12,1,'strings.last_activity_timestamp','2013-09-26 14:01:20','2013-09-26 14:01:20','2013-09-23 14:09:29'),(13,2,'dns.external.domain','example-infra.net','2013-10-08 18:49:51','2013-10-08 18:49:51'),(14,2,'dns.external.implementation_id','2','2013-10-08 18:49:51','2013-10-08 18:49:51'),(15,2,'dns.external.region_id','DFW','2013-10-08 18:49:51','2013-10-08 18:49:51'),(16,2,'dns.external.domain_id','3845854','2013-10-08 18:49:51','2013-10-08 18:49:51'),(17,2,'dns.external.record_ttl','300','2013-10-08 18:49:51','2013-10-08 18:49:51'),(18,2,'dns.internal.domain','int.example-infra.net','2013-10-08 18:49:51','2013-10-08 18:49:51'),(19,2,'ldap.basedn','dc=example-infra,dc=net','2013-10-08 18:49:51','2013-10-08 18:49:51'),(20,2,'dns.internal.network_attribute','implementation.address.private.4','2013-10-08 18:49:51','2013-10-08 18:49:51'),(21,2,'posix.default_shell','/bin/sh','2013-10-08 18:49:51','2013-10-08 18:49:51'),(22,2,'posix.next_uid','1003','2013-10-08 21:47:12','2013-10-08 18:49:51'),(23,2,'implementation.image_schedule.retention','3','2013-10-08 18:50:35','2013-10-08 18:49:51'),(24,3,'dns.external.domain','oasis-infra.net','2013-10-08 19:27:04','2013-10-08 18:53:28'),(25,3,'dns.external.implementation_id','3','2013-10-08 19:27:04','2013-10-08 18:53:28'),(26,3,'dns.external.region_id','ORD','2013-10-08 19:27:04','2013-10-08 18:53:28'),(27,3,'dns.external.domain_id','3845855','2013-10-08 19:27:04','2013-10-08 18:53:28'),(28,3,'dns.external.record_ttl','300','2013-10-08 19:27:04','2013-10-08 18:53:28'),(29,3,'dns.internal.domain','int.oasis-infra.net','2013-10-08 19:27:04','2013-10-08 18:53:28'),(30,3,'ldap.basedn','dc=oasis-infra,dc=net','2013-10-08 19:27:04','2013-10-08 18:53:28'),(31,3,'dns.internal.network_attribute','implementation.address.private.4','2013-10-08 19:27:04','2013-10-08 18:53:28'),(32,3,'posix.default_shell','/usr/bin/csh','2013-10-08 19:27:04','2013-10-08 18:53:28'),(33,3,'posix.next_uid','2003','2013-10-09 02:05:20','2013-10-08 18:53:28'),(34,3,'implementation.image_schedule.retention','5','2013-10-08 19:27:04','2013-10-08 18:53:28');
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
  `blueprint_part_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the blueprint part this record belongs to',
  `role_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the role this device belongs to',
  `name` varchar(128) NOT NULL COMMENT 'The name of the device',
  `status` enum('building','resizing','active','deleting','error') DEFAULT 'building' COMMENT 'The status of this device',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=248 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device`
--

LOCK TABLES `device` WRITE;
/*!40000 ALTER TABLE `device` DISABLE KEYS */;
INSERT INTO `device` VALUES (236,1,1,1,85,7,5,'jefferson-city','active','2013-10-09 01:47:22','2013-10-08 21:37:48'),(237,1,1,1,85,7,5,'albany','active','2013-10-09 01:42:43','2013-10-08 21:37:48'),(238,1,1,1,86,8,6,'boston','active','2013-10-09 01:42:45','2013-10-08 21:39:10'),(239,1,1,1,86,8,6,'harrisburg','active','2013-10-09 01:42:44','2013-10-08 21:39:10'),(240,1,1,1,87,9,7,'saint-paul','active','2013-10-09 01:49:56','2013-10-08 21:40:28'),(241,1,1,1,87,9,7,'lansing','active','2013-10-09 01:47:22','2013-10-08 21:40:28'),(242,1,2,1,87,10,8,'jackson','active','2013-10-09 01:56:30','2013-10-08 21:40:28'),(243,2,1,2,88,12,10,'new york','active','2013-10-09 01:58:23','2013-10-08 21:53:43'),(244,2,1,2,88,12,10,'massachusetts','active','2013-10-09 01:58:23','2013-10-08 21:53:43'),(245,2,1,2,88,12,10,'alaska','building','2013-10-09 02:02:35','2013-10-09 02:02:35'),(246,1,1,1,89,7,5,'alaska','building','2013-10-09 02:12:43','2013-10-09 02:12:43'),(247,1,1,1,89,7,5,'washington','building','2013-10-09 02:12:43','2013-10-09 02:12:43');
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
) ENGINE=InnoDB AUTO_INCREMENT=1300 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_attribute`
--

LOCK TABLES `device_attribute` WRITE;
/*!40000 ALTER TABLE `device_attribute` DISABLE KEYS */;
INSERT INTO `device_attribute` VALUES (1167,1,236,'implementation.region_id','dfw','2013-10-08 21:37:48','2013-10-08 21:37:48'),(1168,1,236,'dns.internal.fqdn','jefferson-city.dfw01.int.bitlancer-infra.net','2013-10-08 21:37:48','2013-10-08 21:37:48'),(1169,1,236,'dns.external.fqdn','jefferson-city.dfw01.bitlancer-infra.net','2013-10-08 21:37:48','2013-10-08 21:37:48'),(1170,1,236,'implementation.flavor_id','2','2013-10-08 21:37:48','2013-10-08 21:37:48'),(1171,1,236,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-08 21:37:48','2013-10-08 21:37:48'),(1172,1,237,'implementation.region_id','dfw','2013-10-08 21:37:48','2013-10-08 21:37:48'),(1173,1,237,'dns.internal.fqdn','albany.dfw01.int.bitlancer-infra.net','2013-10-08 21:37:48','2013-10-08 21:37:48'),(1174,1,237,'dns.external.fqdn','albany.dfw01.bitlancer-infra.net','2013-10-08 21:37:48','2013-10-08 21:37:48'),(1175,1,237,'implementation.flavor_id','2','2013-10-08 21:37:48','2013-10-08 21:37:48'),(1176,1,237,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-08 21:37:48','2013-10-08 21:37:48'),(1177,1,238,'implementation.region_id','dfw','2013-10-08 21:39:10','2013-10-08 21:39:10'),(1178,1,238,'dns.internal.fqdn','boston.dfw01.int.bitlancer-infra.net','2013-10-08 21:39:10','2013-10-08 21:39:10'),(1179,1,238,'dns.external.fqdn','boston.dfw01.bitlancer-infra.net','2013-10-08 21:39:10','2013-10-08 21:39:10'),(1180,1,238,'implementation.flavor_id','3','2013-10-08 21:39:10','2013-10-08 21:39:10'),(1181,1,238,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-08 21:39:10','2013-10-08 21:39:10'),(1182,1,239,'implementation.region_id','dfw','2013-10-08 21:39:10','2013-10-08 21:39:10'),(1183,1,239,'dns.internal.fqdn','harrisburg.dfw01.int.bitlancer-infra.net','2013-10-08 21:39:10','2013-10-08 21:39:10'),(1184,1,239,'dns.external.fqdn','harrisburg.dfw01.bitlancer-infra.net','2013-10-08 21:39:10','2013-10-08 21:39:10'),(1185,1,239,'implementation.flavor_id','3','2013-10-08 21:39:10','2013-10-08 21:39:10'),(1186,1,239,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-08 21:39:10','2013-10-08 21:39:10'),(1187,1,240,'implementation.region_id','ord','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1188,1,240,'dns.internal.fqdn','saint-paul.ord01.int.bitlancer-infra.net','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1189,1,240,'dns.external.fqdn','saint-paul.ord01.bitlancer-infra.net','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1190,1,240,'implementation.flavor_id','3','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1191,1,240,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1192,1,241,'implementation.region_id','ord','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1193,1,241,'dns.internal.fqdn','lansing.ord01.int.bitlancer-infra.net','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1194,1,241,'dns.external.fqdn','lansing.ord01.bitlancer-infra.net','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1195,1,241,'implementation.flavor_id','3','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1196,1,241,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1197,1,242,'implementation.region_id','ord','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1198,1,242,'dns.internal.fqdn','jackson.ord01.int.bitlancer-infra.net','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1199,1,242,'dns.external.fqdn','jackson.ord01.bitlancer-infra.net','2013-10-08 21:40:28','2013-10-08 21:40:28'),(1200,2,243,'implementation.region_id','dfw','2013-10-08 21:53:43','2013-10-08 21:53:43'),(1201,2,243,'dns.internal.fqdn','new york.dfw01.int.example-infra.net','2013-10-08 21:53:43','2013-10-08 21:53:43'),(1202,2,243,'dns.external.fqdn','new york.dfw01.example-infra.net','2013-10-08 21:53:43','2013-10-08 21:53:43'),(1203,2,243,'implementation.flavor_id','4','2013-10-08 21:53:43','2013-10-08 21:53:43'),(1204,2,243,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-08 22:20:22','2013-10-08 21:53:43'),(1205,2,244,'implementation.region_id','dfw','2013-10-08 21:53:43','2013-10-08 21:53:43'),(1206,2,244,'dns.internal.fqdn','massachusetts.dfw01.int.example-infra.net','2013-10-08 21:53:43','2013-10-08 21:53:43'),(1207,2,244,'dns.external.fqdn','massachusetts.dfw01.example-infra.net','2013-10-08 21:53:43','2013-10-08 21:53:43'),(1208,2,244,'implementation.flavor_id','4','2013-10-08 21:53:43','2013-10-08 21:53:43'),(1209,2,244,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-08 22:20:22','2013-10-08 21:53:43'),(1231,1,236,'implementation.id','4c1fd59d-6d08-4a7c-9128-7ba51ca423c1','2013-10-09 01:38:53','2013-10-09 01:38:53'),(1232,1,240,'implementation.id','8fd076b9-355a-4843-8753-f6c92dfc5040','2013-10-09 01:38:53','2013-10-09 01:38:53'),(1233,1,237,'implementation.id','e96624b2-02ee-42e4-9849-12c59d90b1eb','2013-10-09 01:38:53','2013-10-09 01:38:53'),(1234,2,243,'implementation.id','4377869f-a020-45f3-9ac8-4d61b7858be1','2013-10-09 01:38:53','2013-10-09 01:38:53'),(1235,1,240,'implementation.status','active','2013-10-09 01:49:56','2013-10-09 01:38:53'),(1236,1,240,'implementation.status.last_updated','2013-10-09 01:49:56','2013-10-09 01:49:56','2013-10-09 01:38:53'),(1237,1,236,'implementation.status','active','2013-10-09 01:47:22','2013-10-09 01:38:53'),(1238,1,236,'implementation.status.last_updated','2013-10-09 01:47:22','2013-10-09 01:47:22','2013-10-09 01:38:53'),(1239,1,241,'implementation.id','2d5d315b-1f45-4949-8f31-fd08d4d22642','2013-10-09 01:38:54','2013-10-09 01:38:54'),(1240,1,237,'implementation.status','active','2013-10-09 01:42:43','2013-10-09 01:38:54'),(1241,1,237,'implementation.status.last_updated','2013-10-09 01:42:43','2013-10-09 01:42:43','2013-10-09 01:38:54'),(1242,1,241,'implementation.status','active','2013-10-09 01:47:22','2013-10-09 01:38:54'),(1243,1,241,'implementation.status.last_updated','2013-10-09 01:47:22','2013-10-09 01:47:22','2013-10-09 01:38:54'),(1244,2,243,'implementation.status','build','2013-10-09 01:38:54','2013-10-09 01:38:54'),(1245,2,243,'implementation.status.last_updated','2013-10-09 01:38:54','2013-10-09 01:38:54','2013-10-09 01:38:54'),(1246,2,244,'implementation.id','bd4e8849-0182-4f8f-9825-36da71e2922e','2013-10-09 01:38:55','2013-10-09 01:38:55'),(1247,1,238,'implementation.id','e703ecdc-e6a9-4aa2-8d8e-b06c8a2ddcd6','2013-10-09 01:38:56','2013-10-09 01:38:56'),(1248,2,244,'implementation.status','build','2013-10-09 01:38:56','2013-10-09 01:38:56'),(1249,2,244,'implementation.status.last_updated','2013-10-09 01:38:56','2013-10-09 01:38:56','2013-10-09 01:38:56'),(1250,1,238,'implementation.status','active','2013-10-09 01:42:45','2013-10-09 01:38:57'),(1251,1,238,'implementation.status.last_updated','2013-10-09 01:42:45','2013-10-09 01:42:45','2013-10-09 01:38:57'),(1252,1,239,'implementation.id','0e358452-8a1d-47db-8d48-f9aa88a59acf','2013-10-09 01:38:57','2013-10-09 01:38:57'),(1253,1,239,'implementation.status','active','2013-10-09 01:42:44','2013-10-09 01:38:58'),(1254,1,239,'implementation.status.last_updated','2013-10-09 01:42:44','2013-10-09 01:42:44','2013-10-09 01:38:58'),(1255,1,237,'implementation.address.public.6','2001:4800:7812:0514:5541:ae55:ff05:4a02','2013-10-09 01:42:25','2013-10-09 01:42:25'),(1256,1,237,'implementation.address.public.4','166.78.158.250','2013-10-09 01:42:25','2013-10-09 01:42:25'),(1257,1,237,'implementation.address.private.4','10.182.19.46','2013-10-09 01:42:25','2013-10-09 01:42:25'),(1258,2,243,'implementation.address.public.4','50.56.187.231','2013-10-09 01:42:26','2013-10-09 01:42:26'),(1259,2,243,'implementation.address.public.6','2001:4800:780e:0510:5541:ae55:ff05:44dc','2013-10-09 01:42:26','2013-10-09 01:42:26'),(1260,2,243,'implementation.address.private.4','10.180.5.153','2013-10-09 01:42:26','2013-10-09 01:42:26'),(1261,2,244,'implementation.address.public.4','50.56.172.32','2013-10-09 01:42:27','2013-10-09 01:42:27'),(1262,2,244,'implementation.address.public.6','2001:4800:780e:0510:5541:ae55:ff04:7734','2013-10-09 01:42:27','2013-10-09 01:42:27'),(1263,2,244,'implementation.address.private.4','10.180.0.209','2013-10-09 01:42:27','2013-10-09 01:42:27'),(1264,1,239,'implementation.address.public.6','2001:4800:7810:0512:5541:ae55:ff04:a50a','2013-10-09 01:42:27','2013-10-09 01:42:27'),(1265,1,239,'implementation.address.public.4','67.23.43.219','2013-10-09 01:42:27','2013-10-09 01:42:27'),(1266,1,239,'implementation.address.private.4','10.181.11.193','2013-10-09 01:42:27','2013-10-09 01:42:27'),(1267,1,238,'implementation.address.public.6','2001:4800:7810:0512:5541:ae55:ff04:ad75','2013-10-09 01:42:27','2013-10-09 01:42:27'),(1268,1,238,'implementation.address.public.4','67.23.43.49','2013-10-09 01:42:27','2013-10-09 01:42:27'),(1269,1,238,'implementation.address.private.4','10.181.26.26','2013-10-09 01:42:27','2013-10-09 01:42:27'),(1270,1,237,'dns.external.arecord_id','A-10716690','2013-10-09 01:42:41','2013-10-09 01:42:41'),(1271,1,239,'dns.external.arecord_id','A-10716691','2013-10-09 01:42:42','2013-10-09 01:42:42'),(1272,1,238,'dns.external.arecord_id','A-10716692','2013-10-09 01:42:43','2013-10-09 01:42:43'),(1273,1,236,'implementation.address.public.6','2001:4800:7812:0514:5541:ae55:ff04:6218','2013-10-09 01:47:04','2013-10-09 01:47:04'),(1274,1,236,'implementation.address.public.4','166.78.158.235','2013-10-09 01:47:04','2013-10-09 01:47:04'),(1275,1,236,'implementation.address.private.4','10.182.0.181','2013-10-09 01:47:04','2013-10-09 01:47:04'),(1276,1,241,'implementation.address.public.6','2001:4801:7819:0074:5541:ae55:ff11:2aeb','2013-10-09 01:47:04','2013-10-09 01:47:04'),(1277,1,241,'implementation.address.public.4','166.78.243.226','2013-10-09 01:47:04','2013-10-09 01:47:04'),(1278,1,241,'implementation.address.private.4','10.178.22.230','2013-10-09 01:47:04','2013-10-09 01:47:04'),(1279,1,241,'dns.external.arecord_id','A-10716699','2013-10-09 01:47:20','2013-10-09 01:47:20'),(1280,1,236,'dns.external.arecord_id','A-10716700','2013-10-09 01:47:20','2013-10-09 01:47:20'),(1281,1,240,'implementation.address.public.6','2001:4801:7819:0074:5541:ae55:ff11:2923','2013-10-09 01:49:38','2013-10-09 01:49:38'),(1282,1,240,'implementation.address.public.4','166.78.241.61','2013-10-09 01:49:38','2013-10-09 01:49:38'),(1283,1,240,'implementation.address.private.4','10.178.20.83','2013-10-09 01:49:38','2013-10-09 01:49:38'),(1284,1,240,'dns.external.arecord_id','A-10716702','2013-10-09 01:49:54','2013-10-09 01:49:54'),(1285,2,245,'implementation.region_id','dfw','2013-10-09 02:02:35','2013-10-09 02:02:35'),(1286,2,245,'dns.internal.fqdn','alaska.dfw01.int.example-infra.net','2013-10-09 02:02:35','2013-10-09 02:02:35'),(1287,2,245,'dns.external.fqdn','alaska.dfw01.example-infra.net','2013-10-09 02:02:35','2013-10-09 02:02:35'),(1288,2,245,'implementation.flavor_id','4','2013-10-09 02:02:36','2013-10-09 02:02:36'),(1289,2,245,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-09 02:02:36','2013-10-09 02:02:36'),(1290,1,246,'implementation.region_id','dfw','2013-10-09 02:12:43','2013-10-09 02:12:43'),(1291,1,246,'dns.internal.fqdn','alaska.dfw01.int.bitlancer-infra.net','2013-10-09 02:12:43','2013-10-09 02:12:43'),(1292,1,246,'dns.external.fqdn','alaska.dfw01.bitlancer-infra.net','2013-10-09 02:12:43','2013-10-09 02:12:43'),(1293,1,246,'implementation.flavor_id','2','2013-10-09 02:12:43','2013-10-09 02:12:43'),(1294,1,246,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-09 02:12:43','2013-10-09 02:12:43'),(1295,1,247,'implementation.region_id','dfw','2013-10-09 02:12:43','2013-10-09 02:12:43'),(1296,1,247,'dns.internal.fqdn','washington.dfw01.int.bitlancer-infra.net','2013-10-09 02:12:43','2013-10-09 02:12:43'),(1297,1,247,'dns.external.fqdn','washington.dfw01.bitlancer-infra.net','2013-10-09 02:12:43','2013-10-09 02:12:43'),(1298,1,247,'implementation.flavor_id','2','2013-10-09 02:12:43','2013-10-09 02:12:43'),(1299,1,247,'implementation.image_id','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-09 02:12:43','2013-10-09 02:12:43');
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
  `application_formation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the application to formation mapping this record belongs to',
  `device_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the device this record belongs to',
  `name` varchar(255) NOT NULL COMMENT 'The name of the dns record',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device_dns`
--

LOCK TABLES `device_dns` WRITE;
/*!40000 ALTER TABLE `device_dns` DISABLE KEYS */;
INSERT INTO `device_dns` VALUES (3,1,24,238,'test.test1.dfw01.int.bitlancer-infra.net','0000-00-00 00:00:00','0000-00-00 00:00:00'),(4,1,24,238,'test2.test1.dfw01.int.bitlancer-infra.net','0000-00-00 00:00:00','0000-00-00 00:00:00');
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
-- Table structure for table `dictionary`
--

DROP TABLE IF EXISTS `dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dictionary` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the record',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(64) NOT NULL COMMENT 'The name of the dictionary',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dictionary`
--

LOCK TABLES `dictionary` WRITE;
/*!40000 ALTER TABLE `dictionary` DISABLE KEYS */;
INSERT INTO `dictionary` VALUES (1,1,'Production','2013-06-10 19:29:21','2013-06-10 19:29:21'),(2,1,'Development','2013-06-10 19:29:43','2013-06-10 19:29:43'),(14,2,'default','2013-10-08 21:49:24','2013-06-12 14:57:54'),(15,3,'default','2013-10-08 21:49:52','2013-10-08 21:49:52');
/*!40000 ALTER TABLE `dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dictionary_word`
--

DROP TABLE IF EXISTS `dictionary_word`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dictionary_word` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the record',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `dictionary_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the dictionary',
  `word` varchar(64) NOT NULL COMMENT 'The word',
  `status` tinyint(3) unsigned DEFAULT '0' COMMENT 'Status of the word',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=193 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dictionary_word`
--

LOCK TABLES `dictionary_word` WRITE;
/*!40000 ALTER TABLE `dictionary_word` DISABLE KEYS */;
INSERT INTO `dictionary_word` VALUES (1,1,1,'Montgomery',0,'2013-10-08 18:22:50','2013-06-11 18:15:18'),(2,1,1,'Juneau',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(3,1,1,'Phoenix',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(4,1,1,'Little-Rock',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(5,1,1,'Sacramento',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(6,1,1,'Denver',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(7,1,1,'Hartford',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(8,1,1,'Dover',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(9,1,1,'Tallahassee',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(10,1,1,'Atlanta',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(11,1,1,'Honolulu',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(12,1,1,'Boise',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(13,1,1,'Springfield',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(14,1,1,'Indianapolis',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(15,1,1,'Des-Moines',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(16,1,1,'Topeka',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(17,1,1,'Frankfort',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(18,1,1,'Baton-Rouge',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(19,1,1,'Augusta',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(20,1,1,'Annapolis',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(21,1,1,'Boston',1,'2013-10-08 21:39:10','2013-06-11 18:15:31'),(22,1,1,'Lansing',1,'2013-10-08 21:40:28','2013-06-11 18:15:31'),(23,1,1,'Saint-Paul',1,'2013-10-08 21:40:28','2013-06-11 18:15:31'),(24,1,1,'Jackson',1,'2013-10-08 21:40:28','2013-06-11 18:15:31'),(25,1,1,'Jefferson-City',1,'2013-10-08 21:37:49','2013-06-11 18:15:31'),(26,1,1,'Helena',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(27,1,1,'Lincoln',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(28,1,1,'Carson-City',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(29,1,1,'Concord',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(30,1,1,'Trenton',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(31,1,1,'Santa-Fe',0,'2013-10-08 18:22:50','2013-06-11 18:15:31'),(32,1,1,'Albany',1,'2013-10-08 21:37:49','2013-06-11 18:15:31'),(33,1,1,'Raleigh',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(34,1,1,'Bismarck',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(35,1,1,'Columbus',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(36,1,1,'Oklahoma-City',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(37,1,1,'Salem',0,'2013-09-22 21:47:44','2013-06-11 18:15:31'),(38,1,1,'Harrisburg',1,'2013-10-08 21:39:10','2013-06-11 18:15:32'),(39,1,1,'Providence',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(40,1,1,'Columbia',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(41,1,1,'Pierre',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(42,1,1,'Nashville',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(43,1,1,'Austin',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(44,1,1,'Salt-Lake-City',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(45,1,1,'Montpelier',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(46,1,1,'Richmond',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(47,1,1,'Olympia',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(48,1,1,'Charleston',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(49,1,1,'Madison',0,'2013-09-22 21:47:44','2013-06-11 18:15:32'),(50,1,1,'Cheyenne',0,'2013-10-08 18:22:50','2013-06-11 18:15:34'),(51,1,2,'Alabama',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(52,1,2,'Alaska',1,'2013-10-09 02:12:43','2013-06-11 18:15:47'),(53,1,2,'Arizona',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(54,1,2,'Arkansas',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(55,1,2,'California',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(56,1,2,'Colorado',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(57,1,2,'Connecticut',0,'2013-09-22 21:47:44','2013-06-11 18:15:47'),(58,1,2,'Delaware',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(59,1,2,'Florida',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(60,1,2,'Georgia',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(61,1,2,'Hawaii',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(62,1,2,'Idaho',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(63,1,2,'Illinois',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(64,1,2,'Indiana',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(65,1,2,'Iowa',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(66,1,2,'Kansas',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(67,1,2,'Kentucky',0,'2013-09-22 21:47:44','2013-06-11 18:15:47'),(68,1,2,'Louisiana',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(69,1,2,'Maine',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(70,1,2,'Maryland',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(71,1,2,'Massachusetts',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(72,1,2,'Michigan',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(73,1,2,'Minnesota',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(74,1,2,'Mississippi',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(75,1,2,'Missouri',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(76,1,2,'Montana',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(77,1,2,'Nebraska',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(78,1,2,'Nevada',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(79,1,2,'New Hampshire',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(80,1,2,'New Jersey',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(81,1,2,'New Mexico',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(82,1,2,'New York',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(83,1,2,'North Carolina',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(84,1,2,'North Dakota',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(85,1,2,'Ohio',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(86,1,2,'Oklahoma',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(87,1,2,'Oregon',0,'2013-09-22 21:47:44','2013-06-11 18:15:47'),(88,1,2,'Pennsylvania',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(89,1,2,'Rhode Island',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(90,1,2,'South Carolina',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(91,1,2,'South Dakota',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(92,1,2,'Tennessee',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(93,1,2,'Texas',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(94,1,2,'Utah',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(95,1,2,'Vermont',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(96,1,2,'Virginia',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(97,1,2,'Washington',1,'2013-10-09 02:12:43','2013-06-11 18:15:47'),(98,1,2,'West Virginia',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(99,1,2,'Wisconsin',0,'2013-09-03 17:52:39','2013-06-11 18:15:47'),(100,1,2,'Wyoming',0,'2013-09-03 17:52:39','2013-06-11 18:15:48'),(101,2,14,'Alabama',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(102,2,14,'Alaska',1,'2013-10-09 02:02:36','2013-10-08 21:52:24'),(103,2,14,'Arizona',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(104,2,14,'Arkansas',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(105,2,14,'California',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(106,2,14,'Colorado',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(107,2,14,'Connecticut',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(108,2,14,'Delaware',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(109,2,14,'Florida',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(110,2,14,'Georgia',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(111,2,14,'Hawaii',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(112,2,14,'Idaho',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(113,2,14,'Illinois',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(114,2,14,'Indiana',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(115,2,14,'Iowa',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(116,2,14,'Kansas',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(117,2,14,'Kentucky',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(118,2,14,'Louisiana',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(119,2,14,'Maine',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(120,2,14,'Maryland',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(121,2,14,'Massachusetts',1,'2013-10-08 21:53:43','2013-10-08 21:52:24'),(122,2,14,'Michigan',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(123,2,14,'Minnesota',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(124,2,14,'Mississippi',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(125,2,14,'Missouri',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(126,2,14,'Montana',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(127,2,14,'Nebraska',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(128,2,14,'Nevada',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(129,2,14,'New Hampshire',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(130,2,14,'New Jersey',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(131,2,14,'New Mexico',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(132,2,14,'New York',1,'2013-10-08 21:53:43','2013-10-08 21:52:24'),(133,2,14,'North Carolina',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(134,2,14,'North Dakota',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(135,2,14,'Ohio',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(136,2,14,'Oklahoma',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(137,2,14,'Oregon',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(138,2,14,'Pennsylvania',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(139,2,14,'Rhode Island',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(140,2,14,'South Carolina',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(141,2,14,'South Dakota',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(142,2,14,'Tennessee',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(143,2,14,'Texas',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(144,2,14,'Utah',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(145,2,14,'Vermont',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(146,2,14,'Virginia',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(147,2,14,'Washington',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(148,2,14,'West Virginia',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(149,2,14,'Wisconsin',0,'2013-10-08 21:52:24','2013-10-08 21:52:24'),(164,3,15,'Boston',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(165,3,15,'Lansing',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(166,3,15,'Saint-Paul',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(167,3,15,'Jackson',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(168,3,15,'Jefferson-City',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(169,3,15,'Helena',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(170,3,15,'Lincoln',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(171,3,15,'Carson-City',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(172,3,15,'Concord',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(173,3,15,'Trenton',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(174,3,15,'Santa-Fe',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(175,3,15,'Albany',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(176,3,15,'Raleigh',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(177,3,15,'Bismarck',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(178,3,15,'Columbus',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(179,3,15,'Oklahoma-City',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(180,3,15,'Salem',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(181,3,15,'Harrisburg',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(182,3,15,'Providence',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(183,3,15,'Columbia',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(184,3,15,'Pierre',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(185,3,15,'Nashville',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(186,3,15,'Austin',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(187,3,15,'Salt-Lake-City',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(188,3,15,'Montpelier',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(189,3,15,'Richmond',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(190,3,15,'Olympia',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(191,3,15,'Charleston',0,'2013-10-08 21:52:46','2013-10-08 21:52:46'),(192,3,15,'Madison',0,'2013-10-08 21:52:46','2013-10-08 21:52:46');
/*!40000 ALTER TABLE `dictionary_word` ENABLE KEYS */;
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
  `implementation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the implementation this formation belongs to',
  `blueprint_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the blueprint this record belongs to',
  `dictionary_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the dictionary this record belongs to',
  `name` varchar(128) NOT NULL COMMENT 'The name of the formation',
  `status` enum('building','resizing','active','deleting','error') DEFAULT 'building' COMMENT 'The status of this formation',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formation`
--

LOCK TABLES `formation` WRITE;
/*!40000 ALTER TABLE `formation` DISABLE KEYS */;
INSERT INTO `formation` VALUES (85,1,1,6,1,'dev','active','2013-10-09 01:48:27','2013-10-08 21:37:48'),(86,1,1,7,1,'mysql cluster','active','2013-10-09 01:47:01','2013-10-08 21:39:10'),(87,1,1,8,1,'php-apache-cluster','active','2013-10-09 01:58:36','2013-10-08 21:40:28'),(88,2,2,10,14,'mysql cluster','active','2013-10-09 01:58:36','2013-10-08 21:53:43'),(89,1,1,6,2,'test','building','2013-10-09 02:12:43','2013-10-09 02:12:43');
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
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hiera`
--

LOCK TABLES `hiera` WRITE;
/*!40000 ALTER TABLE `hiera` DISABLE KEYS */;
INSERT INTO `hiera` VALUES (114,1,'fqdn/jefferson-city.dfw01.bitlancer-infra.net','ntp::server_address','10.1.1.1','2013-10-08 21:37:49','2013-10-08 21:37:49'),(115,1,'fqdn/albany.dfw01.bitlancer-infra.net','ntp::server_address','10.1.1.1','2013-10-08 21:37:49','2013-10-08 21:37:49'),(116,1,'fqdn/boston.dfw01.bitlancer-infra.net','mysql::innodb_buffer_pool_size','768','2013-10-08 21:39:10','2013-10-08 21:39:10'),(117,1,'fqdn/boston.dfw01.bitlancer-infra.net','mysql::log_slow_querues','1','2013-10-08 21:39:10','2013-10-08 21:39:10'),(118,1,'fqdn/harrisburg.dfw01.bitlancer-infra.net','mysql::innodb_buffer_pool_size','768','2013-10-08 21:39:10','2013-10-08 21:39:10'),(119,1,'fqdn/harrisburg.dfw01.bitlancer-infra.net','mysql::log_slow_querues','1','2013-10-08 21:39:10','2013-10-08 21:39:10'),(120,1,'fqdn/saint-paul.ord01.bitlancer-infra.net','apache-server::keep_alive','5','2013-10-08 21:40:28','2013-10-08 21:40:28'),(121,1,'fqdn/saint-paul.ord01.bitlancer-infra.net','apache-server::max_clients','100','2013-10-08 21:40:28','2013-10-08 21:40:28'),(122,1,'fqdn/saint-paul.ord01.bitlancer-infra.net','php::log_errors','1','2013-10-08 21:40:28','2013-10-08 21:40:28'),(123,1,'fqdn/saint-paul.ord01.bitlancer-infra.net','php::datetime','UTC','2013-10-08 21:40:28','2013-10-08 21:40:28'),(124,1,'fqdn/lansing.ord01.bitlancer-infra.net','apache-server::keep_alive','5','2013-10-08 21:40:28','2013-10-08 21:40:28'),(125,1,'fqdn/lansing.ord01.bitlancer-infra.net','apache-server::max_clients','100','2013-10-08 21:40:28','2013-10-08 21:40:28'),(126,1,'fqdn/lansing.ord01.bitlancer-infra.net','php::log_errors','1','2013-10-08 21:40:28','2013-10-08 21:40:28'),(127,1,'fqdn/lansing.ord01.bitlancer-infra.net','php::datetime','UTC','2013-10-08 21:40:28','2013-10-08 21:40:28'),(128,2,'fqdn/new york.dfw01.example-infra.net','mysql::innodb_buffer_pool_size','1536','2013-10-08 21:53:43','2013-10-08 21:53:43'),(129,2,'fqdn/new york.dfw01.example-infra.net','mysql::log_slow_querues','0','2013-10-08 21:53:43','2013-10-08 21:53:43'),(130,2,'fqdn/massachusetts.dfw01.example-infra.net','mysql::innodb_buffer_pool_size','1536','2013-10-08 21:53:43','2013-10-08 21:53:43'),(131,2,'fqdn/massachusetts.dfw01.example-infra.net','mysql::log_slow_querues','0','2013-10-08 21:53:43','2013-10-08 21:53:43'),(132,2,'fqdn/alaska.dfw01.example-infra.net','mysql::innodb_buffer_pool_size','1536','2013-10-09 02:02:36','2013-10-09 02:02:36'),(133,2,'fqdn/alaska.dfw01.example-infra.net','mysql::log_slow_querues','0','2013-10-09 02:02:36','2013-10-09 02:02:36'),(134,1,'fqdn/alaska.dfw01.bitlancer-infra.net','ntp::server_address','10.1.1.1','2013-10-09 02:12:43','2013-10-09 02:12:43'),(135,1,'fqdn/washington.dfw01.bitlancer-infra.net','ntp::server_address','10.1.1.1','2013-10-09 02:12:43','2013-10-09 02:12:43');
/*!40000 ALTER TABLE `hiera` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `implementation`
--

DROP TABLE IF EXISTS `implementation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `implementation` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the implementation',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `provider_id` bigint(20) unsigned NOT NULL COMMENT 'The provider of this implementation',
  `name` varchar(64) NOT NULL COMMENT 'The name of this implementation',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `implementation`
--

LOCK TABLES `implementation` WRITE;
/*!40000 ALTER TABLE `implementation` DISABLE KEYS */;
INSERT INTO `implementation` VALUES (1,1,1,'Rackspace','2013-05-04 18:27:15','2013-05-04 17:14:34'),(2,2,1,'Rackspace','2013-06-25 14:31:47','2013-06-25 14:31:47'),(3,3,1,'Rackspace','2013-10-08 18:43:29','2013-10-08 18:43:29');
/*!40000 ALTER TABLE `implementation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `implementation_attribute`
--

DROP TABLE IF EXISTS `implementation_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `implementation_attribute` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the attribute',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `implementation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the implementation',
  `var` varchar(128) NOT NULL COMMENT 'The config variable',
  `val` longtext NOT NULL COMMENT 'The variable value',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `implementation_attribute`
--

LOCK TABLES `implementation_attribute` WRITE;
/*!40000 ALTER TABLE `implementation_attribute` DISABLE KEYS */;
INSERT INTO `implementation_attribute` VALUES (1,1,1,'username','bitlancer3','2013-05-20 22:05:14','2013-05-20 15:23:05'),(2,1,1,'api_key','3d0baf0e7b9c4882aefadaf0837ce61b','2013-08-25 20:20:07','2013-05-20 15:24:23'),(3,1,1,'default_image','da1f0392-8c64-468f-a839-a9e56caebf07','2013-05-20 22:04:31','2013-05-20 22:04:31'),(4,1,1,'identity_api_endpoint','https://identity.api.rackspacecloud.com/v2.0/','2013-05-21 15:02:58','2013-05-21 15:02:58'),(5,2,2,'username','bitlancer3','2013-10-08 22:11:25','2013-10-08 22:11:25'),(6,2,2,'api_key','3d0baf0e7b9c4882aefadaf0837ce61b','2013-10-08 22:11:25','2013-10-08 22:11:25'),(7,2,2,'default_image','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-08 22:11:25','2013-10-08 22:11:25'),(8,2,2,'identity_api_endpoint','https://identity.api.rackspacecloud.com/v2.0/','2013-10-08 22:11:25','2013-10-08 22:11:25'),(27,3,3,'username','bitlancer3','2013-10-08 22:12:24','2013-10-08 22:12:24'),(28,3,3,'api_key','3d0baf0e7b9c4882aefadaf0837ce61b','2013-10-08 22:12:24','2013-10-08 22:12:24'),(29,3,3,'default_image','da1f0392-8c64-468f-a839-a9e56caebf07','2013-10-08 22:12:24','2013-10-08 22:12:24'),(30,3,3,'identity_api_endpoint','https://identity.api.rackspacecloud.com/v2.0/','2013-10-08 22:12:24','2013-10-08 22:12:24');
/*!40000 ALTER TABLE `implementation_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jump_server`
--

DROP TABLE IF EXISTS `jump_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jump_server` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the jump server',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `implementation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the implementation this record belongs to',
  `device_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the device this record belongs to',
  `region` varchar(64) NOT NULL COMMENT 'The region this server lives in',
  `private_key` text NOT NULL COMMENT 'The private key that grants the remoteexec user access to this server',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jump_server`
--

LOCK TABLES `jump_server` WRITE;
/*!40000 ALTER TABLE `jump_server` DISABLE KEYS */;
/*!40000 ALTER TABLE `jump_server` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module`
--

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
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module`
--

LOCK TABLES `module` WRITE;
/*!40000 ALTER TABLE `module` DISABLE KEYS */;
INSERT INTO `module` VALUES (11,1,7,'ntp','puppetlabs/ntp','0.0.3',NULL,'2013-10-08 20:16:04','2013-10-08 20:16:04'),(12,1,9,'mysql-server','puppetlabs/mysql-server','5.1',NULL,'2013-10-08 20:16:04','2013-10-08 20:16:04'),(13,1,8,'apache-server','bitlancer/apache-server',NULL,NULL,'2013-10-08 21:00:58','2013-10-08 20:16:04'),(14,2,10,'ntp','puppetlabs/ntp',NULL,NULL,'2013-10-08 20:21:54','2013-10-08 20:21:54'),(15,2,12,'mysql-server','puppetlabs/mysql-server',NULL,NULL,'2013-10-08 20:21:54','2013-10-08 20:21:54'),(16,2,11,'apache-server','bitlancer/apache-server','2.2',NULL,'2013-10-08 21:00:58','2013-10-08 20:21:54'),(17,3,13,'ntp','bitlancer/ntp',NULL,NULL,'2013-10-08 20:23:25','2013-10-08 20:23:25'),(18,3,14,'mysql-server','puppetlabs/mysql-server',NULL,NULL,'2013-10-08 20:23:25','2013-10-08 20:23:25'),(19,3,13,'apache-server','bitlancer/apache-server','2.2',NULL,'2013-10-08 21:00:58','2013-10-08 20:23:25'),(20,1,7,'php','puppetlabs/php','5.4',NULL,'2013-10-08 21:07:11','2013-10-08 21:06:34'),(21,2,15,'php','bitlancer/php','5.3',NULL,'2013-10-08 21:09:50','2013-10-08 21:09:50'),(22,3,16,'php','bitlancer/php','5.3','php-fpm/','2013-10-08 21:10:26','2013-10-08 21:10:26');
/*!40000 ALTER TABLE `module` ENABLE KEYS */;
UNLOCK TABLES;

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
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module_source`
--

LOCK TABLES `module_source` WRITE;
/*!40000 ALTER TABLE `module_source` DISABLE KEYS */;
INSERT INTO `module_source` VALUES (7,1,'Puppet Labs Forge','forge','http://forge.puppetlabs.com','2013-10-08 20:08:41','2013-10-08 20:08:41'),(8,1,'Bitlancer Apache Module','git','git://github.com/bitlancer/puppet-apache.git','2013-10-08 21:03:55','2013-10-08 20:08:41'),(9,1,'Puppet Labs MySQL Module','git','git://github.com/puppet-labs/mysql.git','2013-10-08 20:08:41','2013-10-08 20:08:41'),(10,2,'Puppet Labs Forge','forge','http://forge.puppetlabs.com','2013-10-08 20:09:24','2013-10-08 20:09:24'),(11,2,'Bitlancer Apache Module','git','git://github.com/bitlancer/puppet-apache.git','2013-10-08 21:03:55','2013-10-08 20:09:24'),(12,2,'Puppet Labs MySQL Module','git','git://github.com/puppet-labs/mysql.git','2013-10-08 20:09:24','2013-10-08 20:09:24'),(13,3,'Bitlancer Forge','forge','http://forge.puppetlabs.com','2013-10-08 20:10:02','2013-10-08 20:10:02'),(14,3,'Puppet Labs MySQL Module','git','git://github.com/puppet-labs/mysql.git','2013-10-08 20:10:02','2013-10-08 20:10:02'),(15,2,'Bitlancer PHP Module','git','git://github.com/bitlancer/puppet-php.git','2013-10-08 21:08:27','2013-10-08 21:08:27'),(16,3,'Bitlancer PHP Module','git','git://github.com/bitlancer/puppet-php.git','2013-10-08 21:08:36','2013-10-08 21:08:36');
/*!40000 ALTER TABLE `module_source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module_variable`
--

DROP TABLE IF EXISTS `module_variable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `module_variable` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the variable',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `module_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the module',
  `var` varchar(128) NOT NULL COMMENT 'The variable name in puppet',
  `name` varchar(255) NOT NULL COMMENT 'The variable name',
  `description` text NOT NULL COMMENT 'Description of the variable (help)',
  `default_value` varchar(255) DEFAULT NULL COMMENT 'Optional default value for this variable',
  `validation_pattern` varchar(255) DEFAULT NULL COMMENT 'Optional regular expression to validate the variable value',
  `is_editable` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not the default value is editable',
  `is_required` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT 'Whether or not this variable must be defined',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module_variable`
--

LOCK TABLES `module_variable` WRITE;
/*!40000 ALTER TABLE `module_variable` DISABLE KEYS */;
INSERT INTO `module_variable` VALUES (1,1,1,'ntp::server_address','Server Address','The IP address of the NTP server this client will sync its time with',NULL,'/([0-9]{1,3}.){3,}[0-9]{1,3}/',1,1,'2013-09-12 16:27:38','2013-09-02 16:42:32'),(2,1,2,'mysql-server::innodb_buffer_pool_size','InnoDB Buffer Pool Size','A storage area for caching data and indexes in memory. Ideally, you set the size of the buffer pool to as large a value as practical, leaving enough memory for other processes on the server to run without excessive paging.',NULL,NULL,1,1,'2013-09-12 16:28:34','2013-09-03 03:17:27'),(7,1,2,'mysql-server::log_slow_queries','Log Slow Queries','Enable MySQL\'s slow query log','0',NULL,1,1,'2013-09-12 16:29:47','2013-09-09 21:19:02'),(8,1,11,'ntp::server_address','Server Address','',NULL,'/([0-9]{1,3}.){3,}[0-9]{1,3}/',1,1,'2013-10-08 20:35:32','2013-10-08 20:35:32'),(9,1,12,'mysql::innodb_buffer_pool_size','InnoDB Buffer Pool Size','',NULL,NULL,1,1,'2013-10-08 20:35:32','2013-10-08 20:35:32'),(10,1,12,'mysql::log_slow_querues','Log Slow Queries','','0','/0|1/',1,1,'2013-10-08 20:35:32','2013-10-08 20:35:32'),(11,1,13,'apache-server::keep_alive','Keep-Alive','','5','/[0-9]+/',1,1,'2013-10-08 21:13:02','2013-10-08 20:35:32'),(12,1,13,'apache-server::max_clients','Max Clients','','100','/[0-9]+/',1,1,'2013-10-08 21:12:41','2013-10-08 20:35:32'),(37,2,14,'ntp::server_address','Server Address','',NULL,'/([0-9]{1,3}.){3,}[0-9]{1,3}/',1,1,'2013-10-08 20:38:59','2013-10-08 20:38:59'),(38,2,15,'mysql::innodb_buffer_pool_size','InnoDB Buffer Pool Size','',NULL,NULL,1,1,'2013-10-08 20:38:59','2013-10-08 20:38:59'),(39,2,15,'mysql::log_slow_querues','Log Slow Queries','','0','/0|1/',1,1,'2013-10-08 20:38:59','2013-10-08 20:38:59'),(40,2,16,'apache-server::keep_alive','Keep-Alive','','5','/[0-9]+/',1,1,'2013-10-08 21:13:02','2013-10-08 20:38:59'),(41,2,16,'apache-server::max_clients','Max Clients','','100','/[0-9]+/',1,1,'2013-10-08 21:12:41','2013-10-08 20:38:59'),(43,3,17,'ntp::server_address','Server Address','',NULL,'/([0-9]{1,3}.){3,}[0-9]{1,3}/',1,1,'2013-10-08 20:41:19','2013-10-08 20:41:19'),(44,3,18,'mysql::innodb_buffer_pool_size','InnoDB Buffer Pool Size','',NULL,NULL,1,1,'2013-10-08 20:41:19','2013-10-08 20:41:19'),(45,3,18,'mysql::log_slow_querues','Log Slow Queries','','0','/0|1/',1,1,'2013-10-08 20:41:19','2013-10-08 20:41:19'),(46,3,19,'apache-server::keep_alive','Keep-Alive','','5','/[0-9]+/',1,1,'2013-10-08 21:13:02','2013-10-08 20:41:19'),(47,3,19,'apache-server::max_clients','Max Clients','','100','/[0-9]+/',1,1,'2013-10-08 21:12:41','2013-10-08 20:41:19'),(49,1,20,'php::log_errors','Log Errors','','1','/(0|1)/',1,1,'2013-10-08 21:16:03','2013-10-08 21:16:03'),(50,1,20,'php::datetime','Date/time','','UTC',NULL,1,1,'2013-10-08 21:16:36','2013-10-08 21:16:36'),(51,2,21,'php::datetime','Date/time','','UTC',NULL,1,1,'2013-10-08 21:16:56','2013-10-08 21:16:56'),(52,3,22,'php::datetime','Date/time','','America/New_York',NULL,1,1,'2013-10-08 21:17:20','2013-10-08 21:17:20'),(53,3,22,'php::memory_limit','Memory Limit','','128M',NULL,1,1,'2013-10-08 21:18:25','2013-10-08 21:18:25');
/*!40000 ALTER TABLE `module_variable` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organization`
--

LOCK TABLES `organization` WRITE;
/*!40000 ALTER TABLE `organization` DISABLE KEYS */;
INSERT INTO `organization` VALUES (1,'Bitlancer LLC','bitlancer',0,'2013-09-13 12:59:27','2013-04-29 17:07:51'),(2,'Example','example',0,'2013-10-08 21:45:09','2013-06-25 14:42:30'),(3,'Oasis','oasis',1,'2013-10-09 02:07:05','2013-10-08 18:30:23');
/*!40000 ALTER TABLE `organization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile`
--

DROP TABLE IF EXISTS `profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the profile',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(128) NOT NULL COMMENT 'The name of the profile',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile`
--

LOCK TABLES `profile` WRITE;
/*!40000 ALTER TABLE `profile` DISABLE KEYS */;
INSERT INTO `profile` VALUES (3,1,'Base Node','2013-10-08 19:57:28','2013-10-08 19:57:28'),(4,1,'MySQL Server','2013-10-08 19:57:28','2013-10-08 19:57:28'),(5,1,'PHP-Apache Web Server','2013-10-08 19:57:28','2013-10-08 19:57:28'),(6,2,'Base Node','2013-10-08 19:57:51','2013-10-08 19:57:51'),(7,2,'MySQL Server','2013-10-08 19:57:51','2013-10-08 19:57:51'),(8,2,'PHP-Apache Web Server','2013-10-08 19:57:51','2013-10-08 19:57:51'),(9,3,'Base Node','2013-10-08 19:58:03','2013-10-08 19:58:03'),(10,3,'MySQL Server','2013-10-08 19:58:03','2013-10-08 19:58:03'),(11,3,'PHP-Apache Web Server','2013-10-08 19:58:03','2013-10-08 19:58:03');
/*!40000 ALTER TABLE `profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile_module`
--

DROP TABLE IF EXISTS `profile_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile_module` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `profile_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the profile',
  `module_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the module',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile_module`
--

LOCK TABLES `profile_module` WRITE;
/*!40000 ALTER TABLE `profile_module` DISABLE KEYS */;
INSERT INTO `profile_module` VALUES (3,1,3,11,'2013-10-08 21:23:09','2013-10-08 21:23:09'),(4,1,4,12,'2013-10-08 21:23:09','2013-10-08 21:23:09'),(5,1,5,13,'2013-10-08 21:23:09','2013-10-08 21:23:09'),(6,1,5,20,'2013-10-08 21:23:09','2013-10-08 21:23:09'),(7,2,6,14,'2013-10-08 21:24:23','2013-10-08 21:24:23'),(8,2,7,15,'2013-10-08 21:24:23','2013-10-08 21:24:23'),(9,2,8,16,'2013-10-08 21:24:23','2013-10-08 21:24:23'),(10,2,8,21,'2013-10-08 21:24:23','2013-10-08 21:24:23'),(11,3,9,17,'2013-10-08 21:25:27','2013-10-08 21:25:27'),(12,3,10,18,'2013-10-08 21:25:27','2013-10-08 21:25:27'),(13,3,11,19,'2013-10-08 21:25:27','2013-10-08 21:25:27'),(14,3,11,22,'2013-10-08 21:25:27','2013-10-08 21:25:27');
/*!40000 ALTER TABLE `profile_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provider`
--

DROP TABLE IF EXISTS `provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `provider` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the provider',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization that owns this record',
  `name` varchar(64) NOT NULL COMMENT 'The name of the provider',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provider`
--

LOCK TABLES `provider` WRITE;
/*!40000 ALTER TABLE `provider` DISABLE KEYS */;
INSERT INTO `provider` VALUES (1,NULL,'Rackspace','2013-05-04 14:55:47','2013-05-04 14:55:47');
/*!40000 ALTER TABLE `provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provider_attribute`
--

DROP TABLE IF EXISTS `provider_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `provider_attribute` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the attribute',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization that owns this record',
  `provider_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the provider',
  `var` varchar(128) NOT NULL COMMENT 'The config variable',
  `val` longtext NOT NULL COMMENT 'The variable value',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provider_attribute`
--

LOCK TABLES `provider_attribute` WRITE;
/*!40000 ALTER TABLE `provider_attribute` DISABLE KEYS */;
INSERT INTO `provider_attribute` VALUES (1,NULL,1,'flavors','[{\"id\":2,\"description\":\"512MB Standard Instance (512MB/20GB)\"},{\"id\":3,\"description\":\"1GB Standard Instance (1024MB/40GB)\"},{\"id\":4,\"description\":\"2GB Standard Instance (2048MB/80GB)\"},{\"id\":5,\"description\":\"4GB Standard Instance (4096MB/160GB)\"},{\"id\":6,\"description\":\"8GB Standard Instance (8192MB/320GB)\"},{\"id\":7,\"description\":\"15GB Standard Instance (15360MB/620GB)\"},{\"id\":8,\"description\":\"30GB Standard Instance (30720MB/1200GB)\"}]','2013-06-12 16:27:08','2013-06-04 02:59:32'),(2,NULL,1,'regions','[{\"id\":\"dfw\",\"name\":\"dfw01\",\"description\":\"Dallas\"},{\"id\":\"ord\",\"name\":\"ord01\",\"description\":\"Chicago\"}]','2013-06-12 16:31:22','2013-06-11 14:19:51'),(3,NULL,1,'load_balancers.virtual_ip_types','[\"public\",\"servicenet\"]','2013-09-16 14:41:42','2013-09-16 14:00:42'),(4,NULL,1,'load_balancers.protocols','[{\"name\":\"DNS_TCP\",\"port\":53},{\"name\":\"DNS_UDP\",\"port\":53},{\"name\":\"FTP\",\"port\":21},{\"name\":\"HTTP\",\"port\":80},{\"name\":\"HTTPS\",\"port\":443},{\"name\":\"IMAPS\",\"port\":993},{\"name\":\"IMAPv4\",\"port\":143},{\"name\":\"LDAP\",\"port\":389},{\"name\":\"LDAPS\",\"port\":636},{\"name\":\"MYSQL\",\"port\":3306},{\"name\":\"POP3\",\"port\":110},{\"name\":\"POP3S\",\"port\":995},{\"name\":\"SMTP\",\"port\":25},{\"name\":\"TCP\",\"port\":0},{\"name\":\"TCP_CLIENT_FIRST\",\"port\":0},{\"name\":\"UDP\",\"port\":0},{\"name\":\"UDP_STREAM\",\"port\":0},{\"name\":\"SFTP\",\"port\":22}]','2013-09-16 14:41:53','2013-09-16 14:01:51'),(5,NULL,1,'load_balancers.algorithms','[{\"name\":\"LEAST_CONNECTIONS\"},{\"name\":\"RANDOM\"},{\"name\":\"ROUND_ROBIN\"},{\"name\":\"WEIGHTED_LEAST_CONNECTIONS\"},{\"name\":\"WEIGHTED_ROUND_ROBIN\"}]','2013-09-16 14:42:04','2013-09-16 14:02:23');
/*!40000 ALTER TABLE `provider_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queued_job`
--

DROP TABLE IF EXISTS `queued_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queued_job` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the queued job',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization that owns this record',
  `http_method` varchar(10) NOT NULL COMMENT 'The HTTP VERB that will be used to call this job',
  `url` text NOT NULL COMMENT 'The callback url',
  `body` text COMMENT 'Content sent to the callback url in the POST body',
  `timeout_secs` int(11) NOT NULL DEFAULT '60' COMMENT 'Job execution timeout',
  `last_started_at` timestamp NULL DEFAULT NULL COMMENT 'Last time this job was run',
  `last_finished_at` timestamp NULL DEFAULT NULL COMMENT 'Last time this job completed',
  `last_response` text COMMENT 'The body from the last response of the last execution',
  `result_code` int(11) DEFAULT NULL COMMENT 'HTTP status code',
  `remaining_retries` int(11) NOT NULL DEFAULT '10' COMMENT 'Number of remaining retries before the job is marked as failed',
  `retry_delay_secs` int(11) NOT NULL DEFAULT '60' COMMENT 'Do not retry this job for this number of seconds',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=219 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queued_job`
--

LOCK TABLES `queued_job` WRITE;
/*!40000 ALTER TABLE `queued_job` DISABLE KEYS */;
INSERT INTO `queued_job` VALUES (204,1,'post','http://localhost:8080/Formations/create/85?state=waitingForDevices','',60,'2013-10-09 01:48:27','2013-10-09 01:48:27','{\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}',0,1,60),(205,1,'post','http://localhost:8080/Formations/create/86?state=waitingForDevices','',60,'2013-10-09 01:47:00','2013-10-09 01:47:01','{\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}',0,5,60),(206,1,'post','http://localhost:8080/Formations/create/87?state=waitingForDevices','',60,'2013-10-09 01:48:27','2013-10-09 01:48:27','{\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}',2,0,60),(207,2,'post','http://localhost:8080/Formations/create/88?state=waitingForDevices','',60,'2013-10-09 01:48:27','2013-10-09 01:48:27','{\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}',2,0,60),(208,1,'post','http://localhost:8080/Instances/create/240','',60,'2013-10-09 01:49:36','2013-10-09 01:49:56','{\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}',0,11,120),(209,1,'post','http://localhost:8080/Instances/create/236','',60,'2013-10-09 01:47:01','2013-10-09 01:47:22','{\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}',0,12,120),(210,2,'post','http://localhost:8080/Instances/create/243','',60,'2013-10-09 01:42:23','2013-10-09 01:42:27','{\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"OpenCloud\\\\\\\\Common\\\\\\\\Exceptions\\\\\\\\InstanceNotFound\\\",\\\"file_line\\\":\\\"PersistentObject.php(619)\\\",\\\"message\\\":\\\"OpenCloud\\\\\\\\DNS\\\\\\\\Domain [3845854] not found [https:\\\\\\/\\\\\\/dns.api.rackspacecloud.com\\\\\\/v1.0\\\\\\/598753\\\\\\/domains\\\\\\/3845854]\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/PersistentObject.php(197): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->refresh(\'3845854\')\\\\n#1 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/PersistentObject.php(93): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->populate(\'3845854\')\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/DNS\\\\\\/Service.php(59): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->__construct(Object(OpenCloud\\\\\\\\DNS\\\\\\\\Service), \'3845854\')\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-dns\\\\\\/RackspaceDnsDriver.php(122): OpenCloud\\\\\\\\DNS\\\\\\\\Service->Domain(\'3845854\')\\\\n#4 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/DnsController.php(51): StringsDns\\\\\\\\RackspaceDnsDriver->addDomainRecord(\'3845854\', Object(StringsDns\\\\\\\\DnsRecord), true)\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(324): Application\\\\\\\\DnsController->addDeviceARecord(\'243\')\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(63): Application\\\\\\\\InstancesController->addDeviceARecord(\'243\')\\\\n#7 [internal function]: Application\\\\\\\\InstancesController->create(\'243\')\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'Instances\', \'create\', Array)\\\\n#10 [internal function]: APIFramework\\\\\\\\{closure}(\'243\')\\\\n#11 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#13 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#14 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#15 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#16 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#17 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#18 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#19 {main}\\\"}\"},\"data\":[]}',1,12,120),(211,1,'post','http://localhost:8080/Instances/create/241','',60,'2013-10-09 01:47:01','2013-10-09 01:47:22','{\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}',0,12,120),(212,1,'post','http://localhost:8080/Instances/create/237','',60,'2013-10-09 01:42:23','2013-10-09 01:42:43','{\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}',0,12,120),(213,2,'post','http://localhost:8080/Instances/create/244','',60,'2013-10-09 01:42:24','2013-10-09 01:42:28','{\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"OpenCloud\\\\\\\\Common\\\\\\\\Exceptions\\\\\\\\InstanceNotFound\\\",\\\"file_line\\\":\\\"PersistentObject.php(619)\\\",\\\"message\\\":\\\"OpenCloud\\\\\\\\DNS\\\\\\\\Domain [3845854] not found [https:\\\\\\/\\\\\\/dns.api.rackspacecloud.com\\\\\\/v1.0\\\\\\/598753\\\\\\/domains\\\\\\/3845854]\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/PersistentObject.php(197): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->refresh(\'3845854\')\\\\n#1 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/PersistentObject.php(93): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->populate(\'3845854\')\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/DNS\\\\\\/Service.php(59): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->__construct(Object(OpenCloud\\\\\\\\DNS\\\\\\\\Service), \'3845854\')\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-dns\\\\\\/RackspaceDnsDriver.php(122): OpenCloud\\\\\\\\DNS\\\\\\\\Service->Domain(\'3845854\')\\\\n#4 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/DnsController.php(51): StringsDns\\\\\\\\RackspaceDnsDriver->addDomainRecord(\'3845854\', Object(StringsDns\\\\\\\\DnsRecord), true)\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(324): Application\\\\\\\\DnsController->addDeviceARecord(\'244\')\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(63): Application\\\\\\\\InstancesController->addDeviceARecord(\'244\')\\\\n#7 [internal function]: Application\\\\\\\\InstancesController->create(\'244\')\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'Instances\', \'create\', Array)\\\\n#10 [internal function]: APIFramework\\\\\\\\{closure}(\'244\')\\\\n#11 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#13 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#14 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#15 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#16 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#17 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#18 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#19 {main}\\\"}\"},\"data\":[]}',1,12,120),(214,1,'post','http://localhost:8080/LoadBalancers/create/242','',60,'2013-10-09 01:38:53','2013-10-09 01:38:54','{\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"ErrorException\\\",\\\"file_line\\\":\\\"LoadBalancersController.php(31)\\\",\\\"message\\\":\\\"Undefined index: implementation.nodes\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/LoadBalancersController.php(31): Slim\\\\\\\\Slim::handleErrors(8, \'Undefined index...\', \'\\\\\\/var\\\\\\/www\\\\\\/vhosts...\', 31, Array)\\\\n#1 [internal function]: Application\\\\\\\\LoadBalancersController->create(\'242\')\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'LoadBalancers\', \'create\', Array)\\\\n#4 [internal function]: APIFramework\\\\\\\\{closure}(\'242\')\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#7 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#10 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#11 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#13 {main}\\\"}\"},\"data\":[]}',1,13,120),(215,1,'post','http://localhost:8080/Instances/create/238','',60,'2013-10-09 01:42:25','2013-10-09 01:42:45','{\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}',0,12,120),(216,1,'post','http://localhost:8080/Instances/create/239','',60,'2013-10-09 01:42:25','2013-10-09 01:42:44','{\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}',0,12,120),(217,2,'post','http://localhost:8080/Instances/create/245','',60,NULL,NULL,NULL,NULL,20,60),(218,1,'post','http://localhost:8080/Formations/create/89','',60,NULL,NULL,NULL,NULL,10,60);
/*!40000 ALTER TABLE `queued_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `queued_job_log`
--

DROP TABLE IF EXISTS `queued_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `queued_job_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the log entry',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization that owns this record',
  `job_id` bigint(20) unsigned NOT NULL COMMENT 'The id of job referenced',
  `msg` text NOT NULL COMMENT 'The result returned from the executed job',
  `created_at` timestamp ,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `queued_job_log`
--

LOCK TABLES `queued_job_log` WRITE;
/*!40000 ALTER TABLE `queued_job_log` DISABLE KEYS */;
INSERT INTO `queued_job_log` VALUES (23,NULL,207,'[JOBID 207] Calling job with method post on url http://localhost:8080/Formations/create/88 (timeout 60)','2013-10-08 22:13:27'),(24,NULL,205,'[JOBID 205] Calling job with method post on url http://localhost:8080/Formations/create/86 (timeout 60)','2013-10-08 22:13:27'),(25,NULL,204,'[JOBID 204] Calling job with method post on url http://localhost:8080/Formations/create/85 (timeout 60)','2013-10-08 22:13:27'),(26,NULL,206,'[JOBID 206] Calling job with method post on url http://localhost:8080/Formations/create/87 (timeout 60)','2013-10-08 22:13:27'),(27,NULL,206,'[JOBID 206] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for one or more devices to complete its operation.\"},\"data\":[]}','2013-10-08 22:13:28'),(28,NULL,204,'[JOBID 204] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for one or more devices to complete its operation.\"},\"data\":[]}','2013-10-08 22:13:28'),(29,NULL,205,'[JOBID 205] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for one or more devices to complete its operation.\"},\"data\":[]}','2013-10-08 22:13:28'),(30,NULL,207,'[JOBID 207] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for one or more devices to complete its operation.\"},\"data\":[]}','2013-10-08 22:13:28'),(31,NULL,208,'[JOBID 208] Calling job with method post on url http://localhost:8080/Instances/create/240 (timeout 60)','2013-10-08 22:13:35'),(32,NULL,211,'[JOBID 211] Calling job with method post on url http://localhost:8080/Instances/create/241 (timeout 60)','2013-10-08 22:13:35'),(33,NULL,210,'[JOBID 210] Calling job with method post on url http://localhost:8080/Instances/create/243 (timeout 60)','2013-10-08 22:13:35'),(34,NULL,212,'[JOBID 212] Calling job with method post on url http://localhost:8080/Instances/create/237 (timeout 60)','2013-10-08 22:13:35'),(35,NULL,209,'[JOBID 209] Calling job with method post on url http://localhost:8080/Instances/create/236 (timeout 60)','2013-10-08 22:13:35'),(36,NULL,210,'[JOBID 210] Job failed permanently: {\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"OpenCloud\\\\\\\\Common\\\\\\\\Exceptions\\\\\\\\AuthenticationError\\\",\\\"file_line\\\":\\\"OpenStack.php(362)\\\",\\\"message\\\":\\\"Authentication failure, status [500], response [{\\\\\\\"identityFault\\\\\\\":{\\\\\\\"code\\\\\\\":500}}]\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(289): OpenCloud\\\\\\\\OpenStack->Authenticate()\\\\n#1 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Service.php(349): OpenCloud\\\\\\\\OpenStack->ServiceCatalog()\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Service.php(71): OpenCloud\\\\\\\\Common\\\\\\\\Service->get_endpoint(\'compute\', \'cloudServersOpe...\', \'dfw\', \'publicURL\')\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Nova.php(62): OpenCloud\\\\\\\\Common\\\\\\\\Service->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'compute\', \'cloudServersOpe...\', \'dfw\', \'publicURL\')\\\\n#4 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Compute\\\\\\/Service.php(78): OpenCloud\\\\\\\\Common\\\\\\\\Nova->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'compute\', \'cloudServersOpe...\', \'dfw\', \'publicURL\')\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(890): OpenCloud\\\\\\\\Compute\\\\\\\\Service->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'cloudServersOpe...\', \'dfw\', \'publicURL\')\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(793): OpenCloud\\\\\\\\OpenStack->Service(\'Compute\', \'cloudServersOpe...\', \'dfw\', NULL)\\\\n#7 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/RackspaceInfrastructureDriver.php(32): OpenCloud\\\\\\\\OpenStack->Compute(\'cloudServersOpe...\', \'dfw\')\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/InfrastructureDriver.php(10): StringsInfrastructure\\\\\\\\RackspaceInfrastructureDriver->getProviderConnection()\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(378): StringsInfrastructure\\\\\\\\InfrastructureDriver->__construct(Array)\\\\n#10 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(30): Application\\\\\\\\InstancesController->getProviderDriver(\'2\', \'dfw\')\\\\n#11 [internal function]: Application\\\\\\\\InstancesController->create(\'243\')\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#13 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'Instances\', \'create\', Array)\\\\n#14 [internal function]: APIFramework\\\\\\\\{closure}(\'243\')\\\\n#15 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#16 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#17 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#18 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#19 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#20 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#21 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#22 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#23 {main}\\\"}\"},\"data\":[]}','2013-10-08 22:13:36'),(37,NULL,209,'[JOBID 209] Job failed permanently: {\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"OpenCloud\\\\\\\\Common\\\\\\\\Exceptions\\\\\\\\AuthenticationError\\\",\\\"file_line\\\":\\\"OpenStack.php(362)\\\",\\\"message\\\":\\\"Authentication failure, status [500], response [{\\\\\\\"identityFault\\\\\\\":{\\\\\\\"code\\\\\\\":500}}]\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(289): OpenCloud\\\\\\\\OpenStack->Authenticate()\\\\n#1 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Service.php(349): OpenCloud\\\\\\\\OpenStack->ServiceCatalog()\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Service.php(71): OpenCloud\\\\\\\\Common\\\\\\\\Service->get_endpoint(\'compute\', \'cloudServersOpe...\', \'dfw\', \'publicURL\')\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Nova.php(62): OpenCloud\\\\\\\\Common\\\\\\\\Service->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'compute\', \'cloudServersOpe...\', \'dfw\', \'publicURL\')\\\\n#4 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Compute\\\\\\/Service.php(78): OpenCloud\\\\\\\\Common\\\\\\\\Nova->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'compute\', \'cloudServersOpe...\', \'dfw\', \'publicURL\')\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(890): OpenCloud\\\\\\\\Compute\\\\\\\\Service->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'cloudServersOpe...\', \'dfw\', \'publicURL\')\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(793): OpenCloud\\\\\\\\OpenStack->Service(\'Compute\', \'cloudServersOpe...\', \'dfw\', NULL)\\\\n#7 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/RackspaceInfrastructureDriver.php(32): OpenCloud\\\\\\\\OpenStack->Compute(\'cloudServersOpe...\', \'dfw\')\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/InfrastructureDriver.php(10): StringsInfrastructure\\\\\\\\RackspaceInfrastructureDriver->getProviderConnection()\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(378): StringsInfrastructure\\\\\\\\InfrastructureDriver->__construct(Array)\\\\n#10 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(30): Application\\\\\\\\InstancesController->getProviderDriver(\'1\', \'dfw\')\\\\n#11 [internal function]: Application\\\\\\\\InstancesController->create(\'236\')\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#13 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'Instances\', \'create\', Array)\\\\n#14 [internal function]: APIFramework\\\\\\\\{closure}(\'236\')\\\\n#15 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#16 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#17 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#18 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#19 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#20 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#21 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#22 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#23 {main}\\\"}\"},\"data\":[]}','2013-10-08 22:13:36'),(38,NULL,211,'[JOBID 211] Job failed permanently: {\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"OpenCloud\\\\\\\\Common\\\\\\\\Exceptions\\\\\\\\AuthenticationError\\\",\\\"file_line\\\":\\\"OpenStack.php(362)\\\",\\\"message\\\":\\\"Authentication failure, status [500], response [{\\\\\\\"identityFault\\\\\\\":{\\\\\\\"code\\\\\\\":500}}]\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(289): OpenCloud\\\\\\\\OpenStack->Authenticate()\\\\n#1 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Service.php(349): OpenCloud\\\\\\\\OpenStack->ServiceCatalog()\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Service.php(71): OpenCloud\\\\\\\\Common\\\\\\\\Service->get_endpoint(\'compute\', \'cloudServersOpe...\', \'ord\', \'publicURL\')\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Nova.php(62): OpenCloud\\\\\\\\Common\\\\\\\\Service->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'compute\', \'cloudServersOpe...\', \'ord\', \'publicURL\')\\\\n#4 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Compute\\\\\\/Service.php(78): OpenCloud\\\\\\\\Common\\\\\\\\Nova->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'compute\', \'cloudServersOpe...\', \'ord\', \'publicURL\')\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(890): OpenCloud\\\\\\\\Compute\\\\\\\\Service->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'cloudServersOpe...\', \'ord\', \'publicURL\')\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(793): OpenCloud\\\\\\\\OpenStack->Service(\'Compute\', \'cloudServersOpe...\', \'ord\', NULL)\\\\n#7 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/RackspaceInfrastructureDriver.php(32): OpenCloud\\\\\\\\OpenStack->Compute(\'cloudServersOpe...\', \'ord\')\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/InfrastructureDriver.php(10): StringsInfrastructure\\\\\\\\RackspaceInfrastructureDriver->getProviderConnection()\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(378): StringsInfrastructure\\\\\\\\InfrastructureDriver->__construct(Array)\\\\n#10 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(30): Application\\\\\\\\InstancesController->getProviderDriver(\'1\', \'ord\')\\\\n#11 [internal function]: Application\\\\\\\\InstancesController->create(\'241\')\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#13 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'Instances\', \'create\', Array)\\\\n#14 [internal function]: APIFramework\\\\\\\\{closure}(\'241\')\\\\n#15 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#16 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#17 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#18 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#19 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#20 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#21 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#22 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#23 {main}\\\"}\"},\"data\":[]}','2013-10-08 22:13:36'),(39,NULL,208,'[JOBID 208] Job failed permanently: {\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"OpenCloud\\\\\\\\Common\\\\\\\\Exceptions\\\\\\\\AuthenticationError\\\",\\\"file_line\\\":\\\"OpenStack.php(362)\\\",\\\"message\\\":\\\"Authentication failure, status [500], response [{\\\\\\\"identityFault\\\\\\\":{\\\\\\\"code\\\\\\\":500}}]\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(289): OpenCloud\\\\\\\\OpenStack->Authenticate()\\\\n#1 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Service.php(349): OpenCloud\\\\\\\\OpenStack->ServiceCatalog()\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Service.php(71): OpenCloud\\\\\\\\Common\\\\\\\\Service->get_endpoint(\'compute\', \'cloudServersOpe...\', \'ord\', \'publicURL\')\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/Nova.php(62): OpenCloud\\\\\\\\Common\\\\\\\\Service->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'compute\', \'cloudServersOpe...\', \'ord\', \'publicURL\')\\\\n#4 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Compute\\\\\\/Service.php(78): OpenCloud\\\\\\\\Common\\\\\\\\Nova->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'compute\', \'cloudServersOpe...\', \'ord\', \'publicURL\')\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(890): OpenCloud\\\\\\\\Compute\\\\\\\\Service->__construct(Object(OpenCloud\\\\\\\\Rackspace), \'cloudServersOpe...\', \'ord\', \'publicURL\')\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/OpenStack.php(793): OpenCloud\\\\\\\\OpenStack->Service(\'Compute\', \'cloudServersOpe...\', \'ord\', NULL)\\\\n#7 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/RackspaceInfrastructureDriver.php(32): OpenCloud\\\\\\\\OpenStack->Compute(\'cloudServersOpe...\', \'ord\')\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/InfrastructureDriver.php(10): StringsInfrastructure\\\\\\\\RackspaceInfrastructureDriver->getProviderConnection()\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(378): StringsInfrastructure\\\\\\\\InfrastructureDriver->__construct(Array)\\\\n#10 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(30): Application\\\\\\\\InstancesController->getProviderDriver(\'1\', \'ord\')\\\\n#11 [internal function]: Application\\\\\\\\InstancesController->create(\'240\')\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#13 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'Instances\', \'create\', Array)\\\\n#14 [internal function]: APIFramework\\\\\\\\{closure}(\'240\')\\\\n#15 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#16 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#17 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#18 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#19 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#20 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#21 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#22 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#23 {main}\\\"}\"},\"data\":[]}','2013-10-08 22:13:36'),(40,NULL,215,'[JOBID 215] Calling job with method post on url http://localhost:8080/Instances/create/238 (timeout 60)','2013-10-08 22:13:36'),(41,NULL,216,'[JOBID 216] Calling job with method post on url http://localhost:8080/Instances/create/239 (timeout 60)','2013-10-08 22:13:36'),(42,NULL,213,'[JOBID 213] Calling job with method post on url http://localhost:8080/Instances/create/244 (timeout 60)','2013-10-08 22:13:36'),(43,NULL,214,'[JOBID 214] Calling job with method post on url http://localhost:8080/LoadBalancers/create/242 (timeout 60)','2013-10-08 22:13:36'),(44,NULL,213,'[JOBID 213] Job failed permanently: {\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"OpenCloud\\\\\\\\Common\\\\\\\\Exceptions\\\\\\\\IdRequiredError\\\",\\\"file_line\\\":\\\"PersistentObject.php(593)\\\",\\\"message\\\":\\\"OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject has no ID; cannot be refreshed\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/PersistentObject.php(197): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->refresh(\'\')\\\\n#1 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/PersistentObject.php(93): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->populate(\'\')\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Compute\\\\\\/Service.php(195): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->__construct(Object(OpenCloud\\\\\\\\Compute\\\\\\\\Service), \'\')\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/OpenStackInfrastructureDriver.php(47): OpenCloud\\\\\\\\Compute\\\\\\\\Service->Image(\'\')\\\\n#4 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(38): StringsInfrastructure\\\\\\\\OpenStackInfrastructureDriver->createServer(\'massachusetts\', \'4\', \'\')\\\\n#5 [internal function]: Application\\\\\\\\InstancesController->create(\'244\')\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#7 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'Instances\', \'create\', Array)\\\\n#8 [internal function]: APIFramework\\\\\\\\{closure}(\'244\')\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#10 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#11 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#13 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#14 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#15 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#16 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#17 {main}\\\"}\"},\"data\":[]}','2013-10-08 22:13:38'),(45,NULL,214,'[JOBID 214] Job failed permanently: {\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"ErrorException\\\",\\\"file_line\\\":\\\"LoadBalancersController.php(31)\\\",\\\"message\\\":\\\"Undefined index: implementation.nodes\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/LoadBalancersController.php(31): Slim\\\\\\\\Slim::handleErrors(8, \'Undefined index...\', \'\\\\\\/var\\\\\\/www\\\\\\/vhosts...\', 31, Array)\\\\n#1 [internal function]: Application\\\\\\\\LoadBalancersController->create(\'242\')\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'LoadBalancers\', \'create\', Array)\\\\n#4 [internal function]: APIFramework\\\\\\\\{closure}(\'242\')\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#7 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#10 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#11 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#13 {main}\\\"}\"},\"data\":[]}','2013-10-08 22:13:38'),(46,NULL,216,'[JOBID 216] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-08 22:13:40'),(47,NULL,215,'[JOBID 215] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-08 22:13:41'),(48,NULL,212,'[JOBID 212] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-08 22:13:41'),(49,NULL,212,'[JOBID 212] Calling job with method post on url http://localhost:8080/Instances/create/237 (timeout 60)','2013-10-08 22:16:18'),(50,NULL,205,'[JOBID 205] Calling job with method post on url http://localhost:8080/Formations/create/86?state=waitingForDevices (timeout 60)','2013-10-08 22:16:18'),(51,NULL,206,'[JOBID 206] Calling job with method post on url http://localhost:8080/Formations/create/87?state=waitingForDevices (timeout 60)','2013-10-08 22:16:18'),(52,NULL,204,'[JOBID 204] Calling job with method post on url http://localhost:8080/Formations/create/85?state=waitingForDevices (timeout 60)','2013-10-08 22:16:18'),(53,NULL,207,'[JOBID 207] Calling job with method post on url http://localhost:8080/Formations/create/88?state=waitingForDevices (timeout 60)','2013-10-08 22:16:18'),(54,NULL,205,'[JOBID 205] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:16:19'),(55,NULL,215,'[JOBID 215] Calling job with method post on url http://localhost:8080/Instances/create/238 (timeout 60)','2013-10-08 22:16:19'),(56,NULL,204,'[JOBID 204] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:16:19'),(57,NULL,207,'[JOBID 207] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:16:19'),(58,NULL,206,'[JOBID 206] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:16:19'),(59,NULL,216,'[JOBID 216] Calling job with method post on url http://localhost:8080/Instances/create/239 (timeout 60)','2013-10-08 22:16:19'),(60,NULL,212,'[JOBID 212] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device to spin up\"},\"data\":[]}','2013-10-08 22:16:20'),(61,NULL,216,'[JOBID 216] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device to spin up\"},\"data\":[]}','2013-10-08 22:16:20'),(62,NULL,215,'[JOBID 215] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device to spin up\"},\"data\":[]}','2013-10-08 22:16:21'),(63,NULL,204,'[JOBID 204] Calling job with method post on url http://localhost:8080/Formations/create/85?state=waitingForDevices (timeout 60)','2013-10-08 22:18:44'),(64,NULL,205,'[JOBID 205] Calling job with method post on url http://localhost:8080/Formations/create/86?state=waitingForDevices (timeout 60)','2013-10-08 22:18:44'),(65,NULL,212,'[JOBID 212] Calling job with method post on url http://localhost:8080/Instances/create/237 (timeout 60)','2013-10-08 22:18:44'),(66,NULL,206,'[JOBID 206] Calling job with method post on url http://localhost:8080/Formations/create/87?state=waitingForDevices (timeout 60)','2013-10-08 22:18:44'),(67,NULL,207,'[JOBID 207] Calling job with method post on url http://localhost:8080/Formations/create/88?state=waitingForDevices (timeout 60)','2013-10-08 22:18:44'),(68,NULL,205,'[JOBID 205] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:18:44'),(69,NULL,207,'[JOBID 207] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:18:44'),(70,NULL,215,'[JOBID 215] Calling job with method post on url http://localhost:8080/Instances/create/238 (timeout 60)','2013-10-08 22:18:44'),(71,NULL,216,'[JOBID 216] Calling job with method post on url http://localhost:8080/Instances/create/239 (timeout 60)','2013-10-08 22:18:44'),(72,NULL,204,'[JOBID 204] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:18:44'),(73,NULL,206,'[JOBID 206] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:18:44'),(74,NULL,215,'[JOBID 215] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-08 22:19:05'),(75,NULL,212,'[JOBID 212] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-08 22:19:05'),(76,NULL,216,'[JOBID 216] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-08 22:19:06'),(77,NULL,205,'[JOBID 205] Calling job with method post on url http://localhost:8080/Formations/create/86?state=waitingForDevices (timeout 60)','2013-10-08 22:21:37'),(78,NULL,206,'[JOBID 206] Calling job with method post on url http://localhost:8080/Formations/create/87?state=waitingForDevices (timeout 60)','2013-10-08 22:21:37'),(79,NULL,207,'[JOBID 207] Calling job with method post on url http://localhost:8080/Formations/create/88?state=waitingForDevices (timeout 60)','2013-10-08 22:21:37'),(80,NULL,204,'[JOBID 204] Calling job with method post on url http://localhost:8080/Formations/create/85?state=waitingForDevices (timeout 60)','2013-10-08 22:21:37'),(81,NULL,205,'[JOBID 205] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-08 22:21:37'),(82,NULL,206,'[JOBID 206] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:21:37'),(83,NULL,207,'[JOBID 207] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:21:37'),(84,NULL,204,'[JOBID 204] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:21:37'),(85,NULL,207,'[JOBID 207] Calling job with method post on url http://localhost:8080/Formations/create/88?state=waitingForDevices (timeout 60)','2013-10-08 22:22:39'),(86,NULL,206,'[JOBID 206] Calling job with method post on url http://localhost:8080/Formations/create/87?state=waitingForDevices (timeout 60)','2013-10-08 22:22:39'),(87,NULL,204,'[JOBID 204] Calling job with method post on url http://localhost:8080/Formations/create/85?state=waitingForDevices (timeout 60)','2013-10-08 22:22:39'),(88,NULL,206,'[JOBID 206] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:22:39'),(89,NULL,207,'[JOBID 207] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:22:39'),(90,NULL,204,'[JOBID 204] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:22:39'),(91,NULL,207,'[JOBID 207] Calling job with method post on url http://localhost:8080/Formations/create/88?state=waitingForDevices (timeout 60)','2013-10-08 22:23:52'),(92,NULL,204,'[JOBID 204] Calling job with method post on url http://localhost:8080/Formations/create/85?state=waitingForDevices (timeout 60)','2013-10-08 22:23:52'),(93,NULL,206,'[JOBID 206] Calling job with method post on url http://localhost:8080/Formations/create/87?state=waitingForDevices (timeout 60)','2013-10-08 22:23:52'),(94,NULL,207,'[JOBID 207] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:23:52'),(95,NULL,204,'[JOBID 204] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:23:52'),(96,NULL,206,'[JOBID 206] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-08 22:23:52'),(97,NULL,204,'[JOBID 204] Calling job with method post on url http://localhost:8080/Formations/create/85?state=waitingForDevices (timeout 60)','2013-10-09 01:38:49'),(98,NULL,208,'[JOBID 208] Calling job with method post on url http://localhost:8080/Instances/create/240 (timeout 60)','2013-10-09 01:38:49'),(99,NULL,207,'[JOBID 207] Calling job with method post on url http://localhost:8080/Formations/create/88?state=waitingForDevices (timeout 60)','2013-10-09 01:38:49'),(100,NULL,206,'[JOBID 206] Calling job with method post on url http://localhost:8080/Formations/create/87?state=waitingForDevices (timeout 60)','2013-10-09 01:38:49'),(101,NULL,205,'[JOBID 205] Calling job with method post on url http://localhost:8080/Formations/create/86?state=waitingForDevices (timeout 60)','2013-10-09 01:38:49'),(102,NULL,204,'[JOBID 204] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:38:49'),(103,NULL,205,'[JOBID 205] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:38:49'),(104,NULL,206,'[JOBID 206] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:38:49'),(105,NULL,207,'[JOBID 207] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:38:49'),(106,NULL,210,'[JOBID 210] Calling job with method post on url http://localhost:8080/Instances/create/243 (timeout 60)','2013-10-09 01:38:49'),(107,NULL,211,'[JOBID 211] Calling job with method post on url http://localhost:8080/Instances/create/241 (timeout 60)','2013-10-09 01:38:49'),(108,NULL,209,'[JOBID 209] Calling job with method post on url http://localhost:8080/Instances/create/236 (timeout 60)','2013-10-09 01:38:49'),(109,NULL,212,'[JOBID 212] Calling job with method post on url http://localhost:8080/Instances/create/237 (timeout 60)','2013-10-09 01:38:49'),(110,NULL,208,'[JOBID 208] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-09 01:38:53'),(111,NULL,213,'[JOBID 213] Calling job with method post on url http://localhost:8080/Instances/create/244 (timeout 60)','2013-10-09 01:38:53'),(112,NULL,209,'[JOBID 209] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-09 01:38:53'),(113,NULL,214,'[JOBID 214] Calling job with method post on url http://localhost:8080/LoadBalancers/create/242 (timeout 60)','2013-10-09 01:38:53'),(114,NULL,214,'[JOBID 214] Job failed permanently: {\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"ErrorException\\\",\\\"file_line\\\":\\\"LoadBalancersController.php(31)\\\",\\\"message\\\":\\\"Undefined index: implementation.nodes\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/LoadBalancersController.php(31): Slim\\\\\\\\Slim::handleErrors(8, \'Undefined index...\', \'\\\\\\/var\\\\\\/www\\\\\\/vhosts...\', 31, Array)\\\\n#1 [internal function]: Application\\\\\\\\LoadBalancersController->create(\'242\')\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'LoadBalancers\', \'create\', Array)\\\\n#4 [internal function]: APIFramework\\\\\\\\{closure}(\'242\')\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#7 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#10 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#11 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#13 {main}\\\"}\"},\"data\":[]}','2013-10-09 01:38:54'),(115,NULL,212,'[JOBID 212] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-09 01:38:54'),(116,NULL,215,'[JOBID 215] Calling job with method post on url http://localhost:8080/Instances/create/238 (timeout 60)','2013-10-09 01:38:54'),(117,NULL,216,'[JOBID 216] Calling job with method post on url http://localhost:8080/Instances/create/239 (timeout 60)','2013-10-09 01:38:54'),(118,NULL,211,'[JOBID 211] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-09 01:38:54'),(119,NULL,210,'[JOBID 210] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-09 01:38:54'),(120,NULL,213,'[JOBID 213] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-09 01:38:56'),(121,NULL,215,'[JOBID 215] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-09 01:38:57'),(122,NULL,216,'[JOBID 216] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device build to complete\"},\"data\":[]}','2013-10-09 01:38:58'),(123,NULL,207,'[JOBID 207] Calling job with method post on url http://localhost:8080/Formations/create/88?state=waitingForDevices (timeout 60)','2013-10-09 01:42:23'),(124,NULL,206,'[JOBID 206] Calling job with method post on url http://localhost:8080/Formations/create/87?state=waitingForDevices (timeout 60)','2013-10-09 01:42:23'),(125,NULL,208,'[JOBID 208] Calling job with method post on url http://localhost:8080/Instances/create/240 (timeout 60)','2013-10-09 01:42:23'),(126,NULL,205,'[JOBID 205] Calling job with method post on url http://localhost:8080/Formations/create/86?state=waitingForDevices (timeout 60)','2013-10-09 01:42:23'),(127,NULL,204,'[JOBID 204] Calling job with method post on url http://localhost:8080/Formations/create/85?state=waitingForDevices (timeout 60)','2013-10-09 01:42:23'),(128,NULL,207,'[JOBID 207] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:42:23'),(129,NULL,205,'[JOBID 205] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:42:23'),(130,NULL,204,'[JOBID 204] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:42:23'),(131,NULL,206,'[JOBID 206] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:42:23'),(132,NULL,209,'[JOBID 209] Calling job with method post on url http://localhost:8080/Instances/create/236 (timeout 60)','2013-10-09 01:42:23'),(133,NULL,212,'[JOBID 212] Calling job with method post on url http://localhost:8080/Instances/create/237 (timeout 60)','2013-10-09 01:42:23'),(134,NULL,211,'[JOBID 211] Calling job with method post on url http://localhost:8080/Instances/create/241 (timeout 60)','2013-10-09 01:42:23'),(135,NULL,210,'[JOBID 210] Calling job with method post on url http://localhost:8080/Instances/create/243 (timeout 60)','2013-10-09 01:42:23'),(136,NULL,211,'[JOBID 211] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device to spin up\"},\"data\":[]}','2013-10-09 01:42:24'),(137,NULL,213,'[JOBID 213] Calling job with method post on url http://localhost:8080/Instances/create/244 (timeout 60)','2013-10-09 01:42:24'),(138,NULL,209,'[JOBID 209] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device to spin up\"},\"data\":[]}','2013-10-09 01:42:25'),(139,NULL,215,'[JOBID 215] Calling job with method post on url http://localhost:8080/Instances/create/238 (timeout 60)','2013-10-09 01:42:25'),(140,NULL,208,'[JOBID 208] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device to spin up\"},\"data\":[]}','2013-10-09 01:42:25'),(141,NULL,216,'[JOBID 216] Calling job with method post on url http://localhost:8080/Instances/create/239 (timeout 60)','2013-10-09 01:42:25'),(142,NULL,210,'[JOBID 210] Job failed permanently: {\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"OpenCloud\\\\\\\\Common\\\\\\\\Exceptions\\\\\\\\InstanceNotFound\\\",\\\"file_line\\\":\\\"PersistentObject.php(619)\\\",\\\"message\\\":\\\"OpenCloud\\\\\\\\DNS\\\\\\\\Domain [3845854] not found [https:\\\\\\/\\\\\\/dns.api.rackspacecloud.com\\\\\\/v1.0\\\\\\/598753\\\\\\/domains\\\\\\/3845854]\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/PersistentObject.php(197): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->refresh(\'3845854\')\\\\n#1 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/PersistentObject.php(93): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->populate(\'3845854\')\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/DNS\\\\\\/Service.php(59): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->__construct(Object(OpenCloud\\\\\\\\DNS\\\\\\\\Service), \'3845854\')\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-dns\\\\\\/RackspaceDnsDriver.php(122): OpenCloud\\\\\\\\DNS\\\\\\\\Service->Domain(\'3845854\')\\\\n#4 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/DnsController.php(51): StringsDns\\\\\\\\RackspaceDnsDriver->addDomainRecord(\'3845854\', Object(StringsDns\\\\\\\\DnsRecord), true)\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(324): Application\\\\\\\\DnsController->addDeviceARecord(\'243\')\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(63): Application\\\\\\\\InstancesController->addDeviceARecord(\'243\')\\\\n#7 [internal function]: Application\\\\\\\\InstancesController->create(\'243\')\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'Instances\', \'create\', Array)\\\\n#10 [internal function]: APIFramework\\\\\\\\{closure}(\'243\')\\\\n#11 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#13 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#14 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#15 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#16 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#17 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#18 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#19 {main}\\\"}\"},\"data\":[]}','2013-10-09 01:42:27'),(143,NULL,213,'[JOBID 213] Job failed permanently: {\"meta\":{\"code\":500,\"errorMessage\":\"{\\\"exception\\\":\\\"OpenCloud\\\\\\\\Common\\\\\\\\Exceptions\\\\\\\\InstanceNotFound\\\",\\\"file_line\\\":\\\"PersistentObject.php(619)\\\",\\\"message\\\":\\\"OpenCloud\\\\\\\\DNS\\\\\\\\Domain [3845854] not found [https:\\\\\\/\\\\\\/dns.api.rackspacecloud.com\\\\\\/v1.0\\\\\\/598753\\\\\\/domains\\\\\\/3845854]\\\",\\\"trace\\\":\\\"#0 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/PersistentObject.php(197): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->refresh(\'3845854\')\\\\n#1 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/Common\\\\\\/PersistentObject.php(93): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->populate(\'3845854\')\\\\n#2 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-infrastructure\\\\\\/lib\\\\\\/php-opencloud\\\\\\/lib\\\\\\/OpenCloud\\\\\\/DNS\\\\\\/Service.php(59): OpenCloud\\\\\\\\Common\\\\\\\\PersistentObject->__construct(Object(OpenCloud\\\\\\\\DNS\\\\\\\\Service), \'3845854\')\\\\n#3 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/strings-dns\\\\\\/RackspaceDnsDriver.php(122): OpenCloud\\\\\\\\DNS\\\\\\\\Service->Domain(\'3845854\')\\\\n#4 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/DnsController.php(51): StringsDns\\\\\\\\RackspaceDnsDriver->addDomainRecord(\'3845854\', Object(StringsDns\\\\\\\\DnsRecord), true)\\\\n#5 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(324): Application\\\\\\\\DnsController->addDeviceARecord(\'244\')\\\\n#6 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/controllers\\\\\\/InstancesController.php(63): Application\\\\\\\\InstancesController->addDeviceARecord(\'244\')\\\\n#7 [internal function]: Application\\\\\\\\InstancesController->create(\'244\')\\\\n#8 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(34): call_user_func_array(Array, Array)\\\\n#9 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/Router.php(15): APIFramework\\\\\\\\Router::callController(\'Instances\', \'create\', Array)\\\\n#10 [internal function]: APIFramework\\\\\\\\{closure}(\'244\')\\\\n#11 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Router.php(172): call_user_func_array(Object(Closure), Array)\\\\n#12 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1222): Slim\\\\\\\\Router->dispatch(Object(Slim\\\\\\\\Route))\\\\n#13 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/Flash.php(86): Slim\\\\\\\\Slim->call()\\\\n#14 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/MethodOverride.php(94): Slim\\\\\\\\Middleware\\\\\\\\Flash->call()\\\\n#15 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/core\\\\\\/AuthMiddleware.php(31): Slim\\\\\\\\Middleware\\\\\\\\MethodOverride->call()\\\\n#16 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Middleware\\\\\\/PrettyExceptions.php(67): APIFramework\\\\\\\\AuthMiddleware->call()\\\\n#17 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/lib\\\\\\/Slim\\\\\\/Slim.php(1174): Slim\\\\\\\\Middleware\\\\\\\\PrettyExceptions->call()\\\\n#18 \\\\\\/var\\\\\\/www\\\\\\/vhosts\\\\\\/strings-api\\\\\\/webroot\\\\\\/index.php(153): Slim\\\\\\\\Slim->run()\\\\n#19 {main}\\\"}\"},\"data\":[]}','2013-10-09 01:42:28'),(144,NULL,212,'[JOBID 212] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-09 01:42:43'),(145,NULL,216,'[JOBID 216] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-09 01:42:44'),(146,NULL,215,'[JOBID 215] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-09 01:42:45'),(147,NULL,208,'[JOBID 208] Calling job with method post on url http://localhost:8080/Instances/create/240 (timeout 60)','2013-10-09 01:47:00'),(148,NULL,206,'[JOBID 206] Calling job with method post on url http://localhost:8080/Formations/create/87?state=waitingForDevices (timeout 60)','2013-10-09 01:47:00'),(149,NULL,204,'[JOBID 204] Calling job with method post on url http://localhost:8080/Formations/create/85?state=waitingForDevices (timeout 60)','2013-10-09 01:47:00'),(150,NULL,207,'[JOBID 207] Calling job with method post on url http://localhost:8080/Formations/create/88?state=waitingForDevices (timeout 60)','2013-10-09 01:47:00'),(151,NULL,205,'[JOBID 205] Calling job with method post on url http://localhost:8080/Formations/create/86?state=waitingForDevices (timeout 60)','2013-10-09 01:47:00'),(152,NULL,206,'[JOBID 206] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:47:01'),(153,NULL,204,'[JOBID 204] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:47:01'),(154,NULL,205,'[JOBID 205] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-09 01:47:01'),(155,NULL,207,'[JOBID 207] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:47:01'),(156,NULL,209,'[JOBID 209] Calling job with method post on url http://localhost:8080/Instances/create/236 (timeout 60)','2013-10-09 01:47:01'),(157,NULL,211,'[JOBID 211] Calling job with method post on url http://localhost:8080/Instances/create/241 (timeout 60)','2013-10-09 01:47:01'),(158,NULL,208,'[JOBID 208] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting for device to spin up\"},\"data\":[]}','2013-10-09 01:47:03'),(159,NULL,211,'[JOBID 211] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-09 01:47:22'),(160,NULL,209,'[JOBID 209] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-09 01:47:22'),(161,NULL,206,'[JOBID 206] Calling job with method post on url http://localhost:8080/Formations/create/87?state=waitingForDevices (timeout 60)','2013-10-09 01:48:27'),(162,NULL,207,'[JOBID 207] Calling job with method post on url http://localhost:8080/Formations/create/88?state=waitingForDevices (timeout 60)','2013-10-09 01:48:27'),(163,NULL,204,'[JOBID 204] Calling job with method post on url http://localhost:8080/Formations/create/85?state=waitingForDevices (timeout 60)','2013-10-09 01:48:27'),(164,NULL,207,'[JOBID 207] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:48:27'),(165,NULL,206,'[JOBID 206] Job failed temporarily: {\"meta\":{\"code\":503,\"errorMessage\":\"Waiting on device operations.\"},\"data\":[]}','2013-10-09 01:48:27'),(166,NULL,204,'[JOBID 204] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-09 01:48:27'),(167,NULL,208,'[JOBID 208] Calling job with method post on url http://localhost:8080/Instances/create/240 (timeout 60)','2013-10-09 01:49:36'),(168,NULL,208,'[JOBID 208] Job succeeded: {\"meta\":{\"code\":200,\"errorMessage\":\"\"},\"data\":[]}','2013-10-09 01:49:56');
/*!40000 ALTER TABLE `queued_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the role',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `name` varchar(128) NOT NULL COMMENT 'The name of the role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (5,1,'Bitlancer Base Node','2013-10-08 20:01:19','2013-10-08 19:51:33'),(6,1,'Bitlancer MySQL Server','2013-10-08 20:01:19','2013-10-08 19:51:33'),(7,1,'Bitlancer PHP-Apache Web Server','2013-10-08 20:01:19','2013-10-08 19:51:33'),(8,1,'Bitlancer Load-balancer','2013-10-08 20:01:19','2013-10-08 19:51:33'),(9,2,'Example Base Node','2013-10-08 20:01:37','2013-10-08 19:51:55'),(10,2,'Example MySQL Server','2013-10-08 20:01:37','2013-10-08 19:51:55'),(11,2,'Example PHP-Apache Web Server','2013-10-08 20:01:37','2013-10-08 19:51:55'),(12,2,'Example Load-balancer','2013-10-08 20:01:37','2013-10-08 19:51:55'),(13,3,'Oasis Base Node','2013-10-08 20:01:45','2013-10-08 19:52:04'),(14,3,'Oasis MySQL Server','2013-10-08 20:01:45','2013-10-08 19:52:04'),(15,3,'Oasis PHP-Apache Web Server','2013-10-08 20:01:45','2013-10-08 19:52:04'),(16,3,'Oasis Load-balancer','2013-10-08 20:01:45','2013-10-08 19:52:04');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_profile`
--

DROP TABLE IF EXISTS `role_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_profile` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `role_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the role',
  `profile_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the profile',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_profile`
--

LOCK TABLES `role_profile` WRITE;
/*!40000 ALTER TABLE `role_profile` DISABLE KEYS */;
INSERT INTO `role_profile` VALUES (3,1,5,3,'2013-10-08 20:54:35','2013-10-08 20:54:12'),(4,1,6,4,'2013-10-08 20:54:35','2013-10-08 20:54:12'),(5,1,7,5,'2013-10-08 20:54:35','2013-10-08 20:54:12'),(6,2,9,6,'2013-10-08 20:56:03','2013-10-08 20:56:03'),(7,2,10,7,'2013-10-08 20:56:03','2013-10-08 20:56:03'),(8,2,11,8,'2013-10-08 20:56:03','2013-10-08 20:56:03'),(9,3,13,9,'2013-10-08 20:57:18','2013-10-08 20:57:18'),(10,3,14,10,'2013-10-08 20:57:18','2013-10-08 20:57:18'),(11,3,15,11,'2013-10-08 20:57:18','2013-10-08 20:57:18');
/*!40000 ALTER TABLE `role_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `script`
--

DROP TABLE IF EXISTS `script`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `script` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the script',
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `model` varchar(255) NOT NULL COMMENT 'The model this record is associated with',
  `foreign_key_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the foreign record this record belongs to',
  `name` varchar(128) NOT NULL COMMENT 'The name of the script',
  `type` enum('git') NOT NULL DEFAULT 'git' COMMENT 'The source type of this record',
  `url` varchar(255) NOT NULL COMMENT 'The url of the script source',
  `path` varchar(255) DEFAULT NULL COMMENT 'Optional path to module within the git repository',
  `parameters` text COMMENT 'Optional string of parameters that will be passed to the script during execution',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `script`
--

LOCK TABLES `script` WRITE;
/*!40000 ALTER TABLE `script` DISABLE KEYS */;
/*!40000 ALTER TABLE `script` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the service',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization that owns this record',
  `name` varchar(64) NOT NULL COMMENT 'The name of the service',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service`
--

LOCK TABLES `service` WRITE;
/*!40000 ALTER TABLE `service` DISABLE KEYS */;
INSERT INTO `service` VALUES (1,NULL,'infrastructure','2013-05-04 14:55:05','2013-05-04 14:55:05'),(2,NULL,'dns','2013-05-21 18:47:16','2013-05-21 18:47:16');
/*!40000 ALTER TABLE `service` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_provider`
--

DROP TABLE IF EXISTS `service_provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_provider` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'The id of the mapping',
  `organization_id` bigint(20) unsigned DEFAULT NULL COMMENT 'If applicable, the id of the organization that owns this record',
  `service_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the service',
  `provider_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the provider',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_provider`
--

LOCK TABLES `service_provider` WRITE;
/*!40000 ALTER TABLE `service_provider` DISABLE KEYS */;
INSERT INTO `service_provider` VALUES (1,NULL,1,1,'2013-05-04 17:25:49','2013-05-04 17:25:49'),(2,NULL,2,1,'2013-05-21 18:49:53','2013-05-21 18:49:53');
/*!40000 ALTER TABLE `service_provider` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sudo`
--

LOCK TABLES `sudo` WRITE;
/*!40000 ALTER TABLE `sudo` DISABLE KEYS */;
INSERT INTO `sudo` VALUES (7,1,'Test1',0,'2013-10-08 21:34:36','2013-10-08 21:34:36'),(8,1,'Test2',0,'2013-10-08 21:35:34','2013-10-08 21:35:34');
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
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sudo_attribute`
--

LOCK TABLES `sudo_attribute` WRITE;
/*!40000 ALTER TABLE `sudo_attribute` DISABLE KEYS */;
INSERT INTO `sudo_attribute` VALUES (34,1,7,'sudoRunAs','root','2013-10-08 21:34:36','2013-10-08 21:34:36'),(35,1,7,'sudoCommand','/usr/sbin/tcpdump','2013-10-08 21:34:36','2013-10-08 21:34:36'),(36,1,7,'sudoCommand','/usr/sbin/apachectl','2013-10-08 21:34:36','2013-10-08 21:34:36'),(37,1,8,'sudoRunAs','root','2013-10-08 21:35:34','2013-10-08 21:35:34'),(38,1,8,'sudoCommand','/usr/bin/apachectl','2013-10-08 21:35:34','2013-10-08 21:35:34');
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
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES (27,1,'Everyone',0,'2013-10-08 21:32:29','2013-10-08 21:32:29'),(28,1,'Noone',0,'2013-10-08 21:32:46','2013-10-08 21:32:46'),(29,1,'Just jesse',0,'2013-10-08 21:33:03','2013-10-08 21:33:03'),(30,1,'Just brian',0,'2013-10-08 21:33:24','2013-10-08 21:33:24'),(31,1,'Disabled team',1,'2013-10-08 21:36:20','2013-10-08 21:36:06'),(32,2,'Everyone',0,'2013-10-08 21:47:49','2013-10-08 21:46:28');
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `team_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team',
  `application_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the application',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_application`
--

LOCK TABLES `team_application` WRITE;
/*!40000 ALTER TABLE `team_application` DISABLE KEYS */;
INSERT INTO `team_application` VALUES (52,1,27,10,'2013-10-08 21:42:19','2013-10-08 21:42:19'),(53,1,28,10,'2013-10-08 21:42:46','2013-10-08 21:42:46'),(54,1,29,10,'2013-10-08 21:42:53','2013-10-08 21:42:53');
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `team_application_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team to application mapping',
  `sudo_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the sudo role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_application_sudo`
--

LOCK TABLES `team_application_sudo` WRITE;
/*!40000 ALTER TABLE `team_application_sudo` DISABLE KEYS */;
INSERT INTO `team_application_sudo` VALUES (37,1,52,7,'2013-10-08 21:42:28','2013-10-08 21:42:28'),(38,1,54,7,'2013-10-08 21:42:57','2013-10-08 21:42:57'),(39,1,54,8,'2013-10-08 21:43:00','2013-10-08 21:43:00');
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `team_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team',
  `device_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the device',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_device`
--

LOCK TABLES `team_device` WRITE;
/*!40000 ALTER TABLE `team_device` DISABLE KEYS */;
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `team_device_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team to device mapping',
  `sudo_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the sudo role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_device_sudo`
--

LOCK TABLES `team_device_sudo` WRITE;
/*!40000 ALTER TABLE `team_device_sudo` DISABLE KEYS */;
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `team_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team',
  `formation_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the formation',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_formation`
--

LOCK TABLES `team_formation` WRITE;
/*!40000 ALTER TABLE `team_formation` DISABLE KEYS */;
INSERT INTO `team_formation` VALUES (5,1,27,85,'2013-10-09 02:10:11','2013-10-09 02:10:11'),(6,1,28,86,'2013-10-09 02:10:23','2013-10-09 02:10:23');
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
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
INSERT INTO `team_formation_sudo` VALUES (1,1,6,7,'2013-10-09 02:10:31','2013-10-09 02:10:31');
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `team_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team',
  `role_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_role`
--

LOCK TABLES `team_role` WRITE;
/*!40000 ALTER TABLE `team_role` DISABLE KEYS */;
INSERT INTO `team_role` VALUES (3,1,27,5,'2013-10-09 02:08:26','2013-10-09 02:08:26'),(4,1,28,8,'2013-10-09 02:08:43','2013-10-09 02:08:43'),(5,1,29,6,'2013-10-09 02:08:51','2013-10-09 02:08:51');
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `team_role_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team to role mapping',
  `sudo_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the sudo role',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_role_sudo`
--

LOCK TABLES `team_role_sudo` WRITE;
/*!40000 ALTER TABLE `team_role_sudo` DISABLE KEYS */;
INSERT INTO `team_role_sudo` VALUES (3,1,3,7,'2013-10-09 02:08:33','2013-10-09 02:08:33');
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
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
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (37,1,'jcotton','51abb9636078defbf888d8457a7c76f85c8f114c','Jesse','Cotton','jcotton@bitlancer.com',1,0,0,'2013-10-08 19:05:43','2013-10-08 19:05:43'),(38,2,'jcotton','51abb9636078defbf888d8457a7c76f85c8f114c','Jesse','Cotton','jcotton@bitlancer.com',1,0,0,'2013-10-08 19:07:11','2013-10-08 19:06:16'),(39,3,'jcotton','51abb9636078defbf888d8457a7c76f85c8f114c','Jesse','Cotton','jcotton@bitlancer.com',1,0,0,'2013-10-08 19:07:17','2013-10-08 19:06:22'),(42,1,'ekeller','682618169c3cd29221a9b34b8327ea1b74cb8db2','Eric','Keller','ekeller@bitlancer.com',1,0,1,'2013-10-08 21:36:38','2013-10-08 21:28:04'),(43,1,'bgormley','e250873dd50af1572764aa6da16b2ee16dd913bf','Brian','Gormley','bgormley@bitlancer.net',0,0,1,'2013-10-08 21:36:43','2013-10-08 21:28:46'),(44,1,'mjuszczak','5e88105b92d98f1dffbee8d33501e004e32ee897','Matt','Juszczak','mjuszczak@bitlancer.com',0,0,0,'2013-10-08 21:30:56','2013-10-08 21:30:56'),(45,2,'mjuszczak','5e88105b92d98f1dffbee8d33501e004e32ee897','Matt','Juszczak','mjuszczak@bitlancer.com',1,0,0,'2013-10-08 21:45:46','2013-10-08 21:45:46'),(46,2,'bgormley','e250873dd50af1572764aa6da16b2ee16dd913bf','Brian','Gormley','bgormley@bitlancer.net',0,0,0,'2013-10-08 21:47:12','2013-10-08 21:47:12'),(47,3,'mjuszczak','5e88105b92d98f1dffbee8d33501e004e32ee897','Matt','Juszczak','mjuszczak@bitlancer.com',1,0,0,'2013-10-09 02:04:32','2013-10-09 02:04:32'),(48,3,'bgormley','e250873dd50af1572764aa6da16b2ee16dd913bf','Brian','Gormley','bgormley@bitlancer.com',1,0,1,'2013-10-09 02:05:30','2013-10-09 02:05:19');
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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_attribute`
--

LOCK TABLES `user_attribute` WRITE;
/*!40000 ALTER TABLE `user_attribute` DISABLE KEYS */;
INSERT INTO `user_attribute` VALUES (21,1,37,'posix.uid','10','2013-10-08 19:05:44','2013-10-08 19:05:44'),(22,1,37,'posix.gid','10','2013-10-08 19:05:44','2013-10-08 19:05:44'),(23,1,37,'posix.shell','/bin/bash','2013-10-08 19:05:44','2013-10-08 19:05:44'),(24,2,38,'posix.uid','1000','2013-10-08 19:33:45','2013-10-08 19:09:02'),(25,2,38,'posix.gid','1000','2013-10-08 19:33:45','2013-10-08 19:09:02'),(26,2,38,'posix.shell','/bin/sh','2013-10-08 19:27:50','2013-10-08 19:09:02'),(27,3,39,'posix.uid','2000','2013-10-08 19:33:59','2013-10-08 19:09:03'),(28,3,39,'posix.gid','2000','2013-10-08 19:33:59','2013-10-08 19:09:03'),(29,3,39,'posix.shell','/usr/bin/csh','2013-10-08 19:28:13','2013-10-08 19:09:03'),(30,1,42,'posix.uid','11','2013-10-08 21:28:04','2013-10-08 21:28:04'),(31,1,42,'posix.gid','11','2013-10-08 21:28:04','2013-10-08 21:28:04'),(32,1,42,'posix.shell','/bin/bash','2013-10-08 21:28:04','2013-10-08 21:28:04'),(33,1,43,'posix.uid','12','2013-10-08 21:28:46','2013-10-08 21:28:46'),(34,1,43,'posix.gid','12','2013-10-08 21:28:46','2013-10-08 21:28:46'),(35,1,43,'posix.shell','/bin/bash','2013-10-08 21:28:46','2013-10-08 21:28:46'),(36,1,44,'posix.uid','13','2013-10-08 21:30:56','2013-10-08 21:30:56'),(37,1,44,'posix.gid','13','2013-10-08 21:30:56','2013-10-08 21:30:56'),(38,1,44,'posix.shell','/bin/bash','2013-10-08 21:30:56','2013-10-08 21:30:56'),(39,2,45,'posix.uid','1001','2013-10-08 21:45:46','2013-10-08 21:45:46'),(40,2,45,'posix.gid','1001','2013-10-08 21:45:47','2013-10-08 21:45:47'),(41,2,45,'posix.shell','/bin/sh','2013-10-08 21:45:47','2013-10-08 21:45:47'),(42,2,46,'posix.uid','1002','2013-10-08 21:47:12','2013-10-08 21:47:12'),(43,2,46,'posix.gid','1002','2013-10-08 21:47:12','2013-10-08 21:47:12'),(44,2,46,'posix.shell','/bin/sh','2013-10-08 21:47:12','2013-10-08 21:47:12'),(45,3,47,'posix.uid','2001','2013-10-09 02:04:32','2013-10-09 02:04:32'),(46,3,47,'posix.gid','2001','2013-10-09 02:04:32','2013-10-09 02:04:32'),(47,3,47,'posix.shell','/usr/bin/csh','2013-10-09 02:04:32','2013-10-09 02:04:32'),(48,3,48,'posix.uid','2002','2013-10-09 02:05:20','2013-10-09 02:05:20'),(49,3,48,'posix.gid','2002','2013-10-09 02:05:20','2013-10-09 02:05:20'),(50,3,48,'posix.shell','/usr/bin/csh','2013-10-09 02:05:20','2013-10-09 02:05:20');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_key`
--

LOCK TABLES `user_key` WRITE;
/*!40000 ALTER TABLE `user_key` DISABLE KEYS */;
INSERT INTO `user_key` VALUES (4,1,43,'laptop','ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBXUbbAgfzLMNcWA/eq+b2Bt7xG8WM/o3Ht+T0e8v2VXeZWUlBRYY3sxQ/H/hbJyfPnImZEffYlRPNvgKieBtIziqs0GQJBo20SVgVCXEaWNj03Iy/g5nST+i82HmzukFCECjeokYW04n7p8mWdpu0pHH7jWGirYWfpLtACygzKtkfP9DsRLWj7JuLYAC6Y4NOoR22I1oWH+mIGqzRyXC3ntAtL3Mmppv9b4iUnOhwfAZhAy9U8fSV9PbqjSoFpiljIs0MYpEvLns8GwOFyWdzMl5Ye4xrMj/xOVarP0IWannrMf8wLtil20DAE9H9R9rlTz7LIBIzGtGXXGsDjZtb','2013-10-08 21:29:05','2013-10-08 21:29:05'),(5,1,37,'test1','ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDS/tbMtyOSMDE7qfBxjDdTyLRvn07+r2Jvsjlcm39PM2ez9vCmcM1bRZC3s96nnnbykR6hENwhTXeS/nYOEof1UccdE/3GixbN+CQ7kOs0fSqGz1BbGENVfWjS06RFyaQvnBjv8d5K8jO/TirddauuE4Y1xawxS2mvnnwsWTRdraWrm7Usfd6anin4b2Dnlzor7HNEjaQQWTcHC2w5BIZ3yFYiLzVkT+BpW5dxILDx6hSYBiJK57A3NT6gMIx02jnmihobPGgUf+JU8Y39koU2TfbZ6ZVQEmVb3KnmEfiwSybiYIhkGyL8avXZaVlWPKOrajq62KS+O9b563aX9GGn','2013-10-08 21:30:01','2013-10-08 21:30:01'),(6,1,37,'test2','ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6VkI9U1idkgIYZ4v2FslY3xH49HokZwu8EJpRZrqq1iFGFTnK8QXMqc8Zr+Ol6uerQV1sUzL0SoZzhsoxejK6U0KiT8cwbuHJDevS7bkaaBJ/6h882Z2r3u3G7W7lzvto4d5Y6DeFTU70LiJa2yB+5loOXM2lRCSwGSFfL7+vD5qhFcbgpLUSCfYQGzqQMdYOlgswFBCjhX0+0gQJ0f5qbRQq/b+b+S8SiHpBBooUzXL44Wp5uCZ3oim8yxGooqPm0WO29MLmB1vzI17gc6UAgz5xOUNQG3ZSmyhAkzu90I0CsbDdG9uInCoi/k1pCKIC2piXqjNPECut0bvDu1mR','2013-10-08 21:30:12','2013-10-08 21:30:12'),(7,1,44,'laptop','ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD9sVgcQovITajxYBKEquGZrVxMaXD1ZnLZgrGbIpyvGG4QEF4rLLIk8iA5CdJ+w9HDSHi+4yHzWgIUzOLGQhBs9tGE1F9byb/zXVonz9zWGqGDUj6hYYQdC+KjytixoKEJr7XQttUWimtFI83MIZipyMMNnCidqTdPdvgCswgZVgRDijl8bSyfhgDPsNd25dD57MQHHyYVzQ/OZmroCc6IkPBxVMgO1UhxVPW68VbrugCl5u9E9Rg9Qg6dqAo8itP92xgx03rG6mdLCDhrs//stJzq3OKb8Cmyp9c0ALNczliRrsiKD6CW3VNNCVePnqDwh810H1mH9LZEU68IGjX/','2013-10-08 21:31:09','2013-10-08 21:31:09'),(8,2,45,'laptop','ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3gHZj3q2xpI+Ve3aqxtKy61MUx70cXS4kARHQxRr2Gexc814+QpLTX1TGf7fNbm7tIm/MzDXh1xSWVB7LAtX5UFrzcesqvB5FhlFdY9sebFIWLQsERLQbzDIAaP3Y7h01bCNUWDiusjmtIBsRnZlsm59yCZLyRGT5xGy9pQultaxN4beyD6xZN7+35ik43CUKYfrxQ0kqC6ireRgyP+zWVyZHnrDO/Ri5OZAWz3e8CDXscys01VavpNrMibPIALYjyjnULXo8mBZ0FSQ31k5UjYTXDXI4QBN6iSGY/6He6xcmllTxCjtJA927RSCbZyJ8PUNM6kKynCIkDaa7RGNV','2013-10-08 21:47:32','2013-10-08 21:47:32');
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
  `organization_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the organization that owns this record',
  `user_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the user',
  `team_id` bigint(20) unsigned NOT NULL COMMENT 'The id of the team',
  `updated` datetime  COMMENT 'The date and time of the last update to this record',
  `created` datetime  COMMENT 'The date and time this record was created',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_team`
--

LOCK TABLES `user_team` WRITE;
/*!40000 ALTER TABLE `user_team` DISABLE KEYS */;
INSERT INTO `user_team` VALUES (42,1,37,27,'2013-10-08 21:32:29','2013-10-08 21:32:29'),(43,1,42,27,'2013-10-08 21:32:29','2013-10-08 21:32:29'),(44,1,43,27,'2013-10-08 21:32:29','2013-10-08 21:32:29'),(45,1,44,27,'2013-10-08 21:32:29','2013-10-08 21:32:29'),(46,1,37,29,'2013-10-08 21:33:03','2013-10-08 21:33:03'),(47,1,43,30,'2013-10-08 21:33:24','2013-10-08 21:33:24'),(48,1,37,31,'2013-10-08 21:36:06','2013-10-08 21:36:06'),(49,1,42,31,'2013-10-08 21:36:06','2013-10-08 21:36:06'),(50,1,43,31,'2013-10-08 21:36:06','2013-10-08 21:36:06'),(51,2,38,32,'2013-10-08 21:46:28','2013-10-08 21:46:28'),(52,2,45,32,'2013-10-08 21:46:28','2013-10-08 21:46:28'),(53,2,46,32,'2013-10-08 21:47:49','2013-10-08 21:47:49');
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

-- Dump completed on 2013-10-09 12:44:21
