-- MySQL dump 10.13  Distrib 5.1.49, for pc-linux-gnu (i686)
--
-- Host: localhost    Database: userbase
-- ------------------------------------------------------
-- Server version	5.1.49

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
-- Table structure for table `u_accounts`
--

DROP TABLE IF EXISTS `u_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `u_accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` text,
  `plan` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Payment plan ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `u_account_users`
--

DROP TABLE IF EXISTS `u_account_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `u_account_users` (
  `account_id` int(10) unsigned NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `role` tinyint(4) unsigned NOT NULL DEFAULT '0',
  KEY `user_account` (`account_id`),
  KEY `account_user` (`user_id`),
  CONSTRAINT `account_user` FOREIGN KEY (`user_id`) REFERENCES `u_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `u_account_users_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `u_accounts` (`id`),
  CONSTRAINT `u_account_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `u_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `u_activity`
--

DROP TABLE IF EXISTS `u_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `u_activity` (
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Time of activity',
  `user_id` int(10) unsigned NOT NULL COMMENT 'User ID',
  `activity_id` int(2) unsigned NOT NULL COMMENT 'Activity ID',
  KEY `time` (`time`),
  KEY `user_id` (`user_id`),
  KEY `activity_id` (`activity_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Stores user activities';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `u_googlefriendconnect`
--

DROP TABLE IF EXISTS `u_googlefriendconnect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `u_googlefriendconnect` (
  `user_id` int(10) unsigned NOT NULL COMMENT 'User ID',
  `google_id` varchar(255) NOT NULL COMMENT 'Google Friend Connect ID',
  `userpic` text NOT NULL COMMENT 'Google Friend Connect User picture',
  PRIMARY KEY (`user_id`,`google_id`),
  CONSTRAINT `gfc_user` FOREIGN KEY (`user_id`) REFERENCES `u_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `u_invitation`
--

DROP TABLE IF EXISTS `u_invitation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `u_invitation` (
  `code` char(10) NOT NULL COMMENT 'Code',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When invitation was created',
  `issuedby` bigint(10) unsigned NOT NULL DEFAULT '1' COMMENT 'User who issued the invitation. Default is Sergey.',
  `sentto` text COMMENT 'Note about who this invitation was sent to',
  `user` bigint(10) unsigned DEFAULT NULL COMMENT 'User name',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `u_oid_associations`
--

DROP TABLE IF EXISTS `u_oid_associations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `u_oid_associations` (
  `server_url` blob NOT NULL,
  `handle` varchar(255) NOT NULL DEFAULT '',
  `secret` blob NOT NULL,
  `issued` int(11) NOT NULL DEFAULT '0',
  `lifetime` int(11) NOT NULL DEFAULT '0',
  `assoc_type` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`server_url`(255),`handle`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `u_oid_nonces`
--

DROP TABLE IF EXISTS `u_oid_nonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `u_oid_nonces` (
  `server_url` text NOT NULL,
  `timestamp` int(11) NOT NULL DEFAULT '0',
  `salt` varchar(40) NOT NULL DEFAULT '',
  UNIQUE KEY `server_url` (`server_url`(255),`timestamp`,`salt`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `u_users`
--

DROP TABLE IF EXISTS `u_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `u_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `regtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Time of registration',
  `name` text NOT NULL,
  `username` varchar(25) DEFAULT NULL,
  `email` varchar(320) DEFAULT NULL,
  `pass` varchar(40) NOT NULL COMMENT 'Password digest',
  `salt` varchar(13) NOT NULL COMMENT 'Salt',
  `temppass` varchar(13) DEFAULT NULL COMMENT 'Temporary password used for password recovery',
  `temppasstime` timestamp NULL DEFAULT NULL COMMENT 'Temporary password generation time',
  `requirespassreset` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Flag indicating that user must reset their password before using the site',
  `fb_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Facebook user ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `fb_id` (`fb_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `u_user_preferences`
--

DROP TABLE IF EXISTS `u_user_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `u_user_preferences` (
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `current_account_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `preference_current_account` (`current_account_id`),
  CONSTRAINT `preference_user` FOREIGN KEY (`user_id`) REFERENCES `u_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `u_user_preferences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `u_users` (`id`),
  CONSTRAINT `u_user_preferences_ibfk_2` FOREIGN KEY (`current_account_id`) REFERENCES `u_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-10-03 14:51:27
