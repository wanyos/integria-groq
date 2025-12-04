DROP DATABASE IF EXISTS `integria`;
CREATE DATABASE  IF NOT EXISTS `integria` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `integria`;
-- MySQL dump 10.13  Distrib 8.0.33, for macos13 (arm64)
--
-- Host: localhost    Database: integria
-- ------------------------------------------------------
-- Server version	8.4.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Volver a activar restricciones de clave externa
SET FOREIGN_KEY_CHECKS = 0;

--
-- Table structure for table `emt_localizacion`
--

DROP TABLE IF EXISTS `emt_localizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emt_localizacion` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `localizacion` varchar(100) DEFAULT NULL,
  `id_ubicacion` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_ubicacion` (`id_ubicacion`),
  CONSTRAINT `emt_localizacion_ibfk_1` FOREIGN KEY (`id_ubicacion`) REFERENCES `emt_ubicacion` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=558 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emt_modelo_memoria`
--

DROP TABLE IF EXISTS `emt_modelo_memoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emt_modelo_memoria` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `modelo_memoria` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emt_modelo_placabase`
--

DROP TABLE IF EXISTS `emt_modelo_placabase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emt_modelo_placabase` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `modelo_placabase` varchar(100) CHARACTER SET ucs2 COLLATE ucs2_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emt_phone_class`
--

DROP TABLE IF EXISTS `emt_phone_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emt_phone_class` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emt_phone_model`
--

DROP TABLE IF EXISTS `emt_phone_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emt_phone_model` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `id_phone_class` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_phone_class` (`id_phone_class`),
  CONSTRAINT `emt_phone_model_ibfk_4` FOREIGN KEY (`id_phone_class`) REFERENCES `emt_phone_class` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `emt_ubicacion`
--

DROP TABLE IF EXISTS `emt_ubicacion`;
CREATE TABLE `emt_ubicacion` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `ubicacion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `emt_zona`
--

DROP TABLE IF EXISTS `emt_zona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emt_zona` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `zona` varchar(100) DEFAULT NULL,
  `id_localizacion` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_localizacion` (`id_localizacion`),
  CONSTRAINT `emt_zona_ibfk_1` FOREIGN KEY (`id_localizacion`) REFERENCES `emt_localizacion` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1023 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tagenda`
--

DROP TABLE IF EXISTS `tagenda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tagenda` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `public` tinyint unsigned NOT NULL DEFAULT '0',
  `alarm` int unsigned NOT NULL DEFAULT '0',
  `duration` int unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT 'N/A',
  `description` mediumtext NOT NULL,
  `id_lead` int NOT NULL DEFAULT '0',
  `id_lead_visibility` tinyint NOT NULL,
  `group_visibility` smallint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ta_idx_1` (`id_user`),
  CONSTRAINT `tagenda_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2653 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tagenda_groups`
--

DROP TABLE IF EXISTS `tagenda_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tagenda_groups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `agenda_id` int unsigned NOT NULL,
  `group_id` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `agenda_id` (`agenda_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `tagenda_groups_ibfk_1` FOREIGN KEY (`agenda_id`) REFERENCES `tagenda` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tagenda_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `tgrupo` (`id_grupo`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4021 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tattachment`
--

DROP TABLE IF EXISTS `tattachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tattachment` (
  `id_attachment` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_incidencia` bigint NOT NULL DEFAULT '0',
  `id_task` int DEFAULT '0',
  `id_kb` bigint NOT NULL DEFAULT '0',
  `id_lead` bigint NOT NULL DEFAULT '0',
  `id_company` bigint NOT NULL DEFAULT '0',
  `id_project` bigint NOT NULL DEFAULT '0',
  `id_todo` bigint NOT NULL DEFAULT '0',
  `id_usuario` varchar(60) NOT NULL DEFAULT '',
  `id_contact` mediumint NOT NULL DEFAULT '0',
  `filename` varchar(255) NOT NULL DEFAULT '',
  `description` text,
  `size` bigint NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_invoice` bigint NOT NULL DEFAULT '0',
  `id_contract` mediumint unsigned NOT NULL DEFAULT '0',
  `public_key` varchar(100) DEFAULT NULL,
  `file_sharing` tinyint unsigned DEFAULT '0',
  `id_template_work_parts` int unsigned DEFAULT '0',
  `validate_work_parts` int unsigned DEFAULT '0',
  `template` tinyint(1) NOT NULL DEFAULT '0',
  `id_wu` bigint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_attachment`),
  UNIQUE KEY `public_key` (`public_key`)
) ENGINE=InnoDB AUTO_INCREMENT=31428 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tattachment_track`
--

DROP TABLE IF EXISTS `tattachment_track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tattachment_track` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_attachment` bigint unsigned NOT NULL,
  `timestamp` datetime NOT NULL,
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `action` enum('download','creation','modification','deletion') NOT NULL,
  `data` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbackup`
--

DROP TABLE IF EXISTS `tbackup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbackup` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `real_name` varchar(200) NOT NULL,
  `mode` tinyint unsigned NOT NULL,
  `backup_date` datetime NOT NULL,
  `id_programming` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbackup_programming`
--

DROP TABLE IF EXISTS `tbackup_programming`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbackup_programming` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `mode` tinyint unsigned NOT NULL,
  `periodicity` bigint unsigned NOT NULL,
  `last_executed` datetime NOT NULL,
  `mail` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbuilding`
--

DROP TABLE IF EXISTS `tbuilding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tbuilding` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcampaign`
--

DROP TABLE IF EXISTS `tcampaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcampaign` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tchat_channels`
--

DROP TABLE IF EXISTS `tchat_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tchat_channels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` text NOT NULL,
  `options` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tchat_channels_users`
--

DROP TABLE IF EXISTS `tchat_channels_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tchat_channels_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` varchar(60) NOT NULL DEFAULT '',
  `channel` int DEFAULT NULL,
  `languages` text NOT NULL,
  `description` varchar(255) NOT NULL DEFAULT '',
  `avatar` varchar(60) NOT NULL DEFAULT '',
  `avatar_b64` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `channel` (`channel`),
  KEY `user` (`user`),
  CONSTRAINT `tchat_channels_users_ibfk_1` FOREIGN KEY (`channel`) REFERENCES `tchat_channels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tchat_channels_users_ibfk_2` FOREIGN KEY (`user`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcompany`
--

DROP TABLE IF EXISTS `tcompany`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcompany` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL DEFAULT '',
  `address` varchar(300) NOT NULL DEFAULT '',
  `fiscal_id` varchar(250) DEFAULT NULL,
  `country` tinytext,
  `website` tinytext,
  `comments` text,
  `id_company_role` mediumint unsigned NOT NULL,
  `id_parent` mediumint unsigned DEFAULT NULL,
  `manager` varchar(150) NOT NULL DEFAULT '',
  `last_update` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `payment_conditions` mediumint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=259 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcompany_activity`
--

DROP TABLE IF EXISTS `tcompany_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcompany_activity` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_company` mediumint unsigned NOT NULL,
  `written_by` varchar(60) NOT NULL DEFAULT '',
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `description` text,
  PRIMARY KEY (`id`),
  KEY `id_company` (`id_company`),
  CONSTRAINT `tcompany_activity_ibfk_1` FOREIGN KEY (`id_company`) REFERENCES `tcompany` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcompany_contact`
--

DROP TABLE IF EXISTS `tcompany_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcompany_contact` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_company` mediumint unsigned NOT NULL,
  `fullname` varchar(150) NOT NULL DEFAULT '',
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(55) DEFAULT NULL,
  `mobile` varchar(55) DEFAULT NULL,
  `position` varchar(150) DEFAULT NULL,
  `description` text,
  `disabled` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_company` (`id_company`),
  CONSTRAINT `tcompany_contact_ibfk_1` FOREIGN KEY (`id_company`) REFERENCES `tcompany` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2872851 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcompany_field`
--

DROP TABLE IF EXISTS `tcompany_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcompany_field` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(100) NOT NULL DEFAULT '',
  `type` enum('text','textarea','combo','linked','numeric','date','checkbox') DEFAULT 'text',
  `combo_value` text,
  `parent` mediumint unsigned DEFAULT '0',
  `linked_value` longtext,
  `order` mediumint unsigned DEFAULT '0',
  `show_in_search` int NOT NULL DEFAULT '0',
  `show_in_list` int NOT NULL DEFAULT '0',
  `id_section` mediumint unsigned NOT NULL DEFAULT '1',
  `field_order` int NOT NULL DEFAULT '0',
  `show_in_invoice` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcompany_field_data`
--

DROP TABLE IF EXISTS `tcompany_field_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcompany_field_data` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_company` mediumint unsigned NOT NULL,
  `id_company_field` mediumint unsigned NOT NULL,
  `data` text,
  PRIMARY KEY (`id`),
  KEY `id_company_field` (`id_company_field`),
  KEY `id_company` (`id_company`),
  CONSTRAINT `tcompany_field_data_ibfk_1` FOREIGN KEY (`id_company_field`) REFERENCES `tcompany_field` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tcompany_field_data_ibfk_2` FOREIGN KEY (`id_company`) REFERENCES `tcompany` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=482 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcompany_field_section`
--

DROP TABLE IF EXISTS `tcompany_field_section`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcompany_field_section` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  `expand` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcompany_role`
--

DROP TABLE IF EXISTS `tcompany_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcompany_role` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tconfig`
--

DROP TABLE IF EXISTS `tconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tconfig` (
  `id_config` int unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(100) NOT NULL DEFAULT '',
  `value` text NOT NULL,
  PRIMARY KEY (`id_config`)
) ENGINE=InnoDB AUTO_INCREMENT=3172572 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcontact_activity`
--

DROP TABLE IF EXISTS `tcontact_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcontact_activity` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_contact` mediumint unsigned NOT NULL,
  `written_by` mediumtext,
  `description` mediumtext,
  `creation` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `id_contact_idx` (`id_contact`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcontact_field`
--

DROP TABLE IF EXISTS `tcontact_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcontact_field` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(100) NOT NULL DEFAULT '',
  `type` enum('text','textarea','combo','linked','numeric','date','checkbox') DEFAULT 'text',
  `combo_value` text,
  `parent` mediumint unsigned DEFAULT '0',
  `linked_value` longtext,
  `show_in_search` int NOT NULL DEFAULT '0',
  `show_in_list` int NOT NULL DEFAULT '0',
  `field_order` mediumint unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcontact_field_data`
--

DROP TABLE IF EXISTS `tcontact_field_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcontact_field_data` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_contact` mediumint unsigned NOT NULL,
  `id_contact_field` mediumint unsigned NOT NULL,
  `data` text,
  PRIMARY KEY (`id`),
  KEY `id_contact_field` (`id_contact_field`),
  KEY `id_contact` (`id_contact`),
  CONSTRAINT `tcontact_field_data_ibfk_1` FOREIGN KEY (`id_contact_field`) REFERENCES `tcontact_field` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tcontact_field_data_ibfk_2` FOREIGN KEY (`id_contact`) REFERENCES `tcompany_contact` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcontract`
--

DROP TABLE IF EXISTS `tcontract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcontract` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `contract_number` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  `date_begin` date NOT NULL DEFAULT '0000-00-00',
  `date_end` date NOT NULL DEFAULT '0000-00-00',
  `id_company` mediumint unsigned DEFAULT NULL,
  `id_sla` mediumint unsigned DEFAULT NULL,
  `id_group` mediumint unsigned DEFAULT NULL,
  `private` tinyint unsigned NOT NULL DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '1',
  `id_contract_type` mediumint unsigned DEFAULT NULL,
  `related_contract` text,
  PRIMARY KEY (`id`),
  KEY `id_company` (`id_company`),
  CONSTRAINT `tcontract_ibfk_1` FOREIGN KEY (`id_company`) REFERENCES `tcompany` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcontract_field`
--

DROP TABLE IF EXISTS `tcontract_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcontract_field` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(100) NOT NULL DEFAULT '',
  `type` enum('text','textarea','combo','linked','numeric','date') DEFAULT 'text',
  `combo_value` text,
  `parent` mediumint unsigned DEFAULT '0',
  `linked_value` longtext,
  `order` mediumint unsigned DEFAULT '0',
  `show_in_list` int NOT NULL DEFAULT '0',
  `show_in_search` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcontract_field_data`
--

DROP TABLE IF EXISTS `tcontract_field_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcontract_field_data` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_contract` mediumint unsigned NOT NULL,
  `id_contract_field` mediumint unsigned NOT NULL,
  `data` text,
  PRIMARY KEY (`id`),
  KEY `id_contract_field` (`id_contract_field`),
  KEY `id_contract` (`id_contract`),
  CONSTRAINT `tcontract_field_data_ibfk_1` FOREIGN KEY (`id_contract_field`) REFERENCES `tcontract_field` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tcontract_field_data_ibfk_2` FOREIGN KEY (`id_contract`) REFERENCES `tcontract` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcontract_template`
--

DROP TABLE IF EXISTS `tcontract_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcontract_template` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  `content` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcontract_type`
--

DROP TABLE IF EXISTS `tcontract_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcontract_type` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcontract_type_field`
--

DROP TABLE IF EXISTS `tcontract_type_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcontract_type_field` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_contract_type` mediumint unsigned NOT NULL,
  `label` varchar(100) NOT NULL DEFAULT '',
  `type` enum('text','textarea','combo','linked','numeric','date','checkbox') DEFAULT 'text',
  `combo_value` longtext,
  `show_in_list` tinyint unsigned NOT NULL DEFAULT '0',
  `parent` mediumint unsigned DEFAULT '0',
  `linked_value` longtext,
  `order` mediumint unsigned DEFAULT '0',
  `field_order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcontract_type_field_data`
--

DROP TABLE IF EXISTS `tcontract_type_field_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcontract_type_field_data` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_contract` mediumint unsigned NOT NULL,
  `id_contract_type_field` mediumint unsigned NOT NULL,
  `data` text,
  PRIMARY KEY (`id`),
  KEY `id_contract_type_field` (`id_contract_type_field`),
  KEY `id_contract` (`id_contract`),
  CONSTRAINT `tcontract_type_field_data_ibfk_1` FOREIGN KEY (`id_contract_type_field`) REFERENCES `tcontract_type_field` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tcontract_type_field_data_ibfk_2` FOREIGN KEY (`id_contract`) REFERENCES `tcontract` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcrm_template`
--

DROP TABLE IF EXISTS `tcrm_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcrm_template` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `subject` varchar(250) DEFAULT NULL,
  `description` mediumtext,
  `id_language` varchar(6) DEFAULT NULL,
  `id_company` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcustom_screen`
--

DROP TABLE IF EXISTS `tcustom_screen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcustom_screen` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content` text,
  `home_enabled` int unsigned DEFAULT '0',
  `menu_enabled` int unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcustom_screen_data`
--

DROP TABLE IF EXISTS `tcustom_screen_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcustom_screen_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_custom_screen` int NOT NULL,
  `id_widget_type` int NOT NULL,
  `column` int unsigned NOT NULL,
  `row` int unsigned NOT NULL,
  `data` text,
  PRIMARY KEY (`id`),
  KEY `id_custom_screen` (`id_custom_screen`),
  KEY `id_widget_type` (`id_widget_type`),
  CONSTRAINT `tcustom_screen_data_ibfk_1` FOREIGN KEY (`id_custom_screen`) REFERENCES `tcustom_screen` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tcustom_screen_data_ibfk_2` FOREIGN KEY (`id_widget_type`) REFERENCES `tcustom_screen_widget` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcustom_screen_widget`
--

DROP TABLE IF EXISTS `tcustom_screen_widget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcustom_screen_widget` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL,
  `description` mediumtext NOT NULL,
  `icon` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class` (`class`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tcustom_search`
--

DROP TABLE IF EXISTS `tcustom_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tcustom_search` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `section` varchar(20) NOT NULL,
  `id_user` varchar(60) NOT NULL,
  `form_values` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_user` (`id_user`,`name`,`section`),
  CONSTRAINT `tcustom_search_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=125 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tdownload`
--

DROP TABLE IF EXISTS `tdownload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdownload` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `location` text NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `description` text NOT NULL,
  `tag` text NOT NULL,
  `id_category` mediumint unsigned NOT NULL DEFAULT '0',
  `id_user` varchar(60) NOT NULL,
  `public` int unsigned NOT NULL DEFAULT '0',
  `external_id` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tdownload_category`
--

DROP TABLE IF EXISTS `tdownload_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdownload_category` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  `icon` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tdownload_category_group`
--

DROP TABLE IF EXISTS `tdownload_category_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdownload_category_group` (
  `id_category` mediumint unsigned NOT NULL,
  `id_group` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id_category`,`id_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tdownload_tracking`
--

DROP TABLE IF EXISTS `tdownload_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdownload_tracking` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_download` mediumint unsigned NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_user` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tdownload_type`
--

DROP TABLE IF EXISTS `tdownload_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdownload_type` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `description` text,
  `icon` varchar(100) DEFAULT NULL,
  `id_parent` mediumint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tdownload_type_file`
--

DROP TABLE IF EXISTS `tdownload_type_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tdownload_type_file` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_type` mediumint unsigned NOT NULL,
  `id_download` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temail`
--

DROP TABLE IF EXISTS `temail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temail` (
  `usuario` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT '',
  `email` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `temail_template`
--

DROP TABLE IF EXISTS `temail_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temail_template` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `id_group` int unsigned NOT NULL DEFAULT '0',
  `template_action` varchar(200) NOT NULL DEFAULT '',
  `predefined_templates` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tevent`
--

DROP TABLE IF EXISTS `tevent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tevent` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(250) DEFAULT NULL,
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `id_item` int unsigned DEFAULT NULL,
  `id_item2` int unsigned DEFAULT NULL,
  `id_item3` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tevent_idx_1` (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=18355 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tfolder_report`
--

DROP TABLE IF EXISTS `tfolder_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tfolder_report` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` mediumtext NOT NULL,
  `description` text,
  `private` tinyint unsigned NOT NULL DEFAULT '0',
  `id_group` varchar(60) NOT NULL DEFAULT '1',
  `id_user` varchar(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tgitlab_issue`
--

DROP TABLE IF EXISTS `tgitlab_issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgitlab_issue` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_gitlab` int unsigned NOT NULL,
  `title` varchar(150) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `state` varchar(100) NOT NULL DEFAULT '',
  `proyect_name` varchar(150) NOT NULL DEFAULT '',
  `milestone` varchar(150) NOT NULL DEFAULT '',
  `labels` mediumtext NOT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `closed_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `author` varchar(250) NOT NULL DEFAULT '',
  `assigned` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tgitlab_issue_comment`
--

DROP TABLE IF EXISTS `tgitlab_issue_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgitlab_issue_comment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_gitlab` int unsigned NOT NULL,
  `id_gitlab_issue` int unsigned NOT NULL,
  `author` varchar(250) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tgitlab_label`
--

DROP TABLE IF EXISTS `tgitlab_label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgitlab_label` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tgitlab_milestone`
--

DROP TABLE IF EXISTS `tgitlab_milestone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgitlab_milestone` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `milestone` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tgitlab_state`
--

DROP TABLE IF EXISTS `tgitlab_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgitlab_state` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `state` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tgrupo`
--

DROP TABLE IF EXISTS `tgrupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgrupo` (
  `id_grupo` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL DEFAULT '',
  `icon` varchar(50) DEFAULT NULL,
  `banner` varchar(150) DEFAULT NULL,
  `url` varchar(150) DEFAULT NULL,
  `lang` varchar(10) DEFAULT NULL,
  `parent` mediumint unsigned NOT NULL DEFAULT '0',
  `id_user_default` varchar(60) NOT NULL DEFAULT '',
  `id_sla` mediumint unsigned DEFAULT NULL,
  `soft_limit` int unsigned NOT NULL DEFAULT '0',
  `hard_limit` int unsigned NOT NULL DEFAULT '0',
  `forced_email` tinyint unsigned NOT NULL DEFAULT '1',
  `email` varchar(128) DEFAULT '',
  `enforce_soft_limit` int unsigned NOT NULL DEFAULT '0',
  `id_inventory_default` bigint unsigned NOT NULL,
  `autocreate_user` int unsigned NOT NULL DEFAULT '0',
  `grant_access` int unsigned NOT NULL DEFAULT '0',
  `send_welcome` int unsigned NOT NULL DEFAULT '0',
  `default_company` mediumint unsigned NOT NULL DEFAULT '0',
  `email_queue` text,
  `welcome_email` text,
  `default_profile` int unsigned NOT NULL DEFAULT '0',
  `nivel` tinyint(1) NOT NULL DEFAULT '0',
  `simple_mode` tinyint unsigned NOT NULL DEFAULT '0',
  `id_incident_type` mediumint unsigned DEFAULT NULL,
  `email_from` varchar(150) DEFAULT '',
  `email_group` text,
  `default_status` mediumint unsigned NOT NULL DEFAULT '1',
  `mail_options` int NOT NULL DEFAULT '0',
  `mail_creation_ticket` int NOT NULL DEFAULT '0',
  `mail_close_ticket` int NOT NULL DEFAULT '0',
  `mail_update_status_ticket` int NOT NULL DEFAULT '0',
  `mail_update_owner_ticket` int NOT NULL DEFAULT '0',
  `mail_update_priority_ticket` int NOT NULL DEFAULT '0',
  `mail_update_group_ticket` int NOT NULL DEFAULT '0',
  `mail_update_other_ticket` int NOT NULL DEFAULT '0',
  `mail_create_WU` int NOT NULL DEFAULT '0',
  `mail_create_attach` int NOT NULL DEFAULT '0',
  `mail_validate_work_order` int NOT NULL DEFAULT '0',
  `send_satisfaction` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_grupo`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tholidays`
--

DROP TABLE IF EXISTS `tholidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tholidays` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `day` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `day` (`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincidencia`
--

DROP TABLE IF EXISTS `tincidencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincidencia` (
  `id_incidencia` bigint unsigned NOT NULL AUTO_INCREMENT,
  `inicio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `cierre` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `titulo` mediumtext,
  `descripcion` mediumtext,
  `id_usuario` varchar(60) NOT NULL DEFAULT '',
  `estado` tinyint unsigned NOT NULL DEFAULT '0',
  `prioridad` tinyint unsigned NOT NULL DEFAULT '0',
  `id_grupo` mediumint NOT NULL DEFAULT '0',
  `actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_creator` varchar(60) DEFAULT NULL,
  `id_task` int NOT NULL DEFAULT '0',
  `resolution` tinyint unsigned NOT NULL DEFAULT '0',
  `epilog` mediumtext NOT NULL,
  `id_parent` bigint unsigned DEFAULT NULL,
  `sla_disabled` mediumint unsigned NOT NULL DEFAULT '0',
  `affected_sla_id` tinyint unsigned NOT NULL DEFAULT '0',
  `id_incident_type` mediumint unsigned DEFAULT NULL,
  `score` mediumint DEFAULT '0',
  `email_copy` mediumtext NOT NULL,
  `editor` varchar(60) NOT NULL DEFAULT '',
  `id_group_creator` mediumint NOT NULL DEFAULT '0',
  `last_stat_check` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `closed_by` varchar(60) NOT NULL DEFAULT '',
  `blocked` tinyint unsigned NOT NULL DEFAULT '0',
  `old_status` tinyint unsigned NOT NULL DEFAULT '0',
  `old_resolution` tinyint unsigned NOT NULL DEFAULT '0',
  `old_status2` tinyint unsigned NOT NULL DEFAULT '0',
  `old_resolution2` tinyint unsigned NOT NULL DEFAULT '0',
  `extra_data2` varchar(100) NOT NULL DEFAULT '',
  `extra_data3` varchar(100) NOT NULL DEFAULT '',
  `extra_data4` varchar(100) NOT NULL DEFAULT '',
  `black_medals` int NOT NULL DEFAULT '0',
  `gold_medals` int NOT NULL DEFAULT '0',
  `never_show_score` tinyint unsigned NOT NULL DEFAULT '0',
  `hash` varchar(100) NOT NULL DEFAULT '',
  `rating` int NOT NULL DEFAULT '0',
  `comment_score` varchar(300) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_incidencia`),
  KEY `incident_idx_1` (`id_usuario`),
  KEY `incident_idx_2` (`estado`),
  KEY `incident_idx_3` (`id_grupo`),
  KEY `id_parent` (`id_parent`),
  CONSTRAINT `tincidencia_ibfk_1` FOREIGN KEY (`id_parent`) REFERENCES `tincidencia` (`id_incidencia`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57496 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincident_field_data`
--

DROP TABLE IF EXISTS `tincident_field_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincident_field_data` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_incident` bigint unsigned NOT NULL,
  `id_incident_field` mediumint unsigned NOT NULL,
  `data` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1247530 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincident_inventory`
--

DROP TABLE IF EXISTS `tincident_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincident_inventory` (
  `id_incident` bigint unsigned NOT NULL,
  `id_inventory` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id_incident`,`id_inventory`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincident_resolution`
--

DROP TABLE IF EXISTS `tincident_resolution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincident_resolution` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincident_sla_graph_data`
--

DROP TABLE IF EXISTS `tincident_sla_graph_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincident_sla_graph_data` (
  `id_incident` int NOT NULL DEFAULT '0',
  `utimestamp` int unsigned NOT NULL DEFAULT '0',
  `value` int unsigned NOT NULL DEFAULT '0',
  KEY `sla_graph_index1` (`id_incident`),
  KEY `idx_utimestamp_sla_graph` (`utimestamp`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincident_stats`
--

DROP TABLE IF EXISTS `tincident_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincident_stats` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_incident` bigint unsigned NOT NULL DEFAULT '0',
  `seconds` bigint unsigned NOT NULL DEFAULT '0',
  `metric` enum('user_time','status_time','group_time','total_time','total_w_third') NOT NULL,
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `status` tinyint NOT NULL DEFAULT '0',
  `id_group` mediumint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `isx1` (`id_incident`)
) ENGINE=InnoDB AUTO_INCREMENT=114142 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincident_status`
--

DROP TABLE IF EXISTS `tincident_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincident_status` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincident_track`
--

DROP TABLE IF EXISTS `tincident_track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincident_track` (
  `id_it` int unsigned NOT NULL AUTO_INCREMENT,
  `id_incident` bigint unsigned NOT NULL DEFAULT '0',
  `state` int unsigned NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `id_aditional` varchar(60) NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `extra_info` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_it`),
  KEY `tit_idx_1` (`id_incident`),
  CONSTRAINT `tincident_track_ibfk_1` FOREIGN KEY (`id_incident`) REFERENCES `tincidencia` (`id_incidencia`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=409594 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincident_type`
--

DROP TABLE IF EXISTS `tincident_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincident_type` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  `id_wizard` mediumint unsigned DEFAULT NULL,
  `id_group` text NOT NULL,
  `id_incident_type_template` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_incident_type_template` (`id_incident_type_template`),
  CONSTRAINT `tincident_type_ibfk_1` FOREIGN KEY (`id_incident_type_template`) REFERENCES `tincident_type_template` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincident_type_field`
--

DROP TABLE IF EXISTS `tincident_type_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincident_type_field` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_incident_type` mediumint unsigned NOT NULL,
  `label` varchar(100) NOT NULL DEFAULT '',
  `type` enum('text','textarea','combo','linked','numeric','date','checkbox') DEFAULT 'text',
  `combo_value` longtext,
  `show_in_list` tinyint unsigned NOT NULL DEFAULT '0',
  `global_id` mediumint unsigned DEFAULT NULL,
  `parent` mediumint unsigned DEFAULT '0',
  `linked_value` longtext,
  `order` mediumint unsigned DEFAULT '0',
  `field_order` int NOT NULL DEFAULT '0',
  `is_required` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=242 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tincident_type_template`
--

DROP TABLE IF EXISTS `tincident_type_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tincident_type_template` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  `content` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinventory`
--

DROP TABLE IF EXISTS `tinventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinventory` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_object_type` mediumint unsigned DEFAULT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `name` text,
  `public` tinyint unsigned DEFAULT '1',
  `description` text,
  `id_contract` mediumint unsigned DEFAULT NULL,
  `id_manufacturer` mediumint unsigned DEFAULT NULL,
  `id_parent` mediumint unsigned DEFAULT NULL,
  `show_list` tinyint unsigned DEFAULT '1',
  `last_update` date NOT NULL DEFAULT '0000-00-00',
  `status` varchar(200) DEFAULT NULL,
  `receipt_date` date NOT NULL DEFAULT '0000-00-00',
  `issue_date` date NOT NULL DEFAULT '0000-00-00',
  `id_pandora` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `tinv_idx_1` (`id_contract`)
) ENGINE=InnoDB AUTO_INCREMENT=31098 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinventory_acl`
--

DROP TABLE IF EXISTS `tinventory_acl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinventory_acl` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_inventory` bigint unsigned NOT NULL,
  `id_reference` varchar(60) NOT NULL DEFAULT '',
  `type` enum('user','company') DEFAULT 'user',
  PRIMARY KEY (`id`),
  KEY `id_inventory_idx` (`id_inventory`)
) ENGINE=InnoDB AUTO_INCREMENT=155993 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinventory_relationship`
--

DROP TABLE IF EXISTS `tinventory_relationship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinventory_relationship` (
  `id_object_src` mediumint unsigned NOT NULL,
  `id_object_dst` mediumint unsigned NOT NULL,
  KEY `tinvrsx_1` (`id_object_src`),
  KEY `tinvrsx_2` (`id_object_dst`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinventory_reports`
--

DROP TABLE IF EXISTS `tinventory_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinventory_reports` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '',
  `sql` text,
  `id_group` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinventory_track`
--

DROP TABLE IF EXISTS `tinventory_track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinventory_track` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_inventory` bigint unsigned NOT NULL DEFAULT '0',
  `id_aditional` varchar(60) NOT NULL DEFAULT '0',
  `state` int unsigned NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tinventorytask_idx_1` (`id_inventory`),
  CONSTRAINT `tinventory_track_ibfk_1` FOREIGN KEY (`id_inventory`) REFERENCES `tinventory` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=472551 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinvoice`
--

DROP TABLE IF EXISTS `tinvoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinvoice` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_user` varchar(60) DEFAULT NULL,
  `id_task` int unsigned DEFAULT NULL,
  `id_company` int unsigned DEFAULT NULL,
  `bill_id` tinytext NOT NULL,
  `concept1` mediumtext,
  `concept2` mediumtext,
  `concept3` mediumtext,
  `concept4` mediumtext,
  `concept5` mediumtext,
  `amount1` float(11,2) NOT NULL DEFAULT '0.00',
  `amount2` float(11,2) NOT NULL DEFAULT '0.00',
  `amount3` float(11,2) NOT NULL DEFAULT '0.00',
  `amount4` float(11,2) NOT NULL DEFAULT '0.00',
  `amount5` float(11,2) NOT NULL DEFAULT '0.00',
  `tax` mediumtext NOT NULL,
  `currency` varchar(3) NOT NULL DEFAULT 'EUR',
  `description` mediumtext NOT NULL,
  `id_attachment` bigint unsigned DEFAULT NULL,
  `locked` tinyint unsigned NOT NULL DEFAULT '0',
  `locked_id_user` varchar(60) DEFAULT NULL,
  `invoice_create_date` date NOT NULL DEFAULT '0000-00-00',
  `invoice_payment_date` date DEFAULT NULL,
  `status` enum('pending','paid','canceled') DEFAULT 'pending',
  `invoice_type` enum('Submitted','Received') DEFAULT 'Submitted',
  `reference` text NOT NULL,
  `id_language` varchar(6) NOT NULL DEFAULT '',
  `internal_note` mediumtext NOT NULL,
  `invoice_expiration_date` date NOT NULL DEFAULT '0000-00-00',
  `bill_id_pattern` tinytext NOT NULL,
  `bill_id_variable` int unsigned DEFAULT NULL,
  `contract_number` mediumint unsigned NOT NULL DEFAULT '0',
  `discount_before` float(11,2) NOT NULL DEFAULT '0.00',
  `discount_concept` varchar(100) NOT NULL DEFAULT '',
  `tax_name` mediumtext NOT NULL,
  `irpf` float(11,2) NOT NULL DEFAULT '0.00',
  `concept_irpf` varchar(100) NOT NULL DEFAULT '',
  `rates` float(11,10) NOT NULL DEFAULT '0.0000000000',
  `currency_change` varchar(15) NOT NULL DEFAULT 'None',
  PRIMARY KEY (`id`),
  KEY `tcost_idx_1` (`id_user`),
  KEY `tcost_idx_2` (`id_company`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tkb_category`
--

DROP TABLE IF EXISTS `tkb_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tkb_category` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  `icon` varchar(75) DEFAULT NULL,
  `parent` mediumint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tkb_data`
--

DROP TABLE IF EXISTS `tkb_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tkb_data` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(250) DEFAULT NULL,
  `data` mediumtext NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_language` varchar(6) NOT NULL DEFAULT '',
  `id_user` varchar(150) NOT NULL DEFAULT '',
  `id_product` mediumint unsigned DEFAULT '0',
  `id_category` mediumint unsigned DEFAULT '0',
  `rating_total` int NOT NULL DEFAULT '0',
  `rating_votes` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tkb_idx_1` (`id_product`),
  KEY `tkb_idx_2` (`id_category`),
  KEY `tkb_idx_3` (`id_language`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tkb_product`
--

DROP TABLE IF EXISTS `tkb_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tkb_product` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  `icon` varchar(75) DEFAULT NULL,
  `parent` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tkb_product_group`
--

DROP TABLE IF EXISTS `tkb_product_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tkb_product_group` (
  `id_product` mediumint unsigned NOT NULL,
  `id_group` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id_product`,`id_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tlanguage`
--

DROP TABLE IF EXISTS `tlanguage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tlanguage` (
  `id_language` varchar(6) NOT NULL DEFAULT '',
  `name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tlead`
--

DROP TABLE IF EXISTS `tlead`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tlead` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_company` mediumint unsigned NOT NULL,
  `id_language` varchar(6) DEFAULT NULL,
  `id_category` mediumint unsigned DEFAULT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `fullname` varchar(150) DEFAULT NULL,
  `email` tinytext,
  `phone` tinytext,
  `mobile` tinytext,
  `position` tinytext,
  `company` tinytext,
  `country` tinytext,
  `description` mediumtext,
  `creation` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modification` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `progress` mediumint DEFAULT '0',
  `estimated_sale` mediumint DEFAULT '0',
  `id_campaign` int unsigned NOT NULL DEFAULT '0',
  `executive_overview` tinytext,
  `alarm` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `estimated_close_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `id_company_idx` (`id_company`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tlead_activity`
--

DROP TABLE IF EXISTS `tlead_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tlead_activity` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_lead` mediumint unsigned NOT NULL,
  `written_by` mediumtext,
  `description` mediumtext,
  `creation` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `id_lead_idx` (`id_lead`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tlead_history`
--

DROP TABLE IF EXISTS `tlead_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tlead_history` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_lead` mediumint unsigned NOT NULL,
  `id_user` mediumtext,
  `description` mediumtext,
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `id_lead_idx` (`id_lead`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tlead_progress`
--

DROP TABLE IF EXISTS `tlead_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tlead_progress` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tlead_tag`
--

DROP TABLE IF EXISTS `tlead_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tlead_tag` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` bigint unsigned NOT NULL,
  `lead_id` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tag_id` (`tag_id`),
  KEY `lead_id` (`lead_id`),
  CONSTRAINT `tlead_tag_ibfk_1` FOREIGN KEY (`tag_id`) REFERENCES `ttag` (`id`) ON DELETE CASCADE,
  CONSTRAINT `tlead_tag_ibfk_2` FOREIGN KEY (`lead_id`) REFERENCES `tlead` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tlink`
--

DROP TABLE IF EXISTS `tlink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tlink` (
  `id_link` int(10) unsigned zerofill NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `link` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_link`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmanufacturer`
--

DROP TABLE IF EXISTS `tmanufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tmanufacturer` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `address` varchar(250) DEFAULT NULL,
  `comments` varchar(250) DEFAULT NULL,
  `id_company_role` mediumint unsigned NOT NULL,
  `id_sla` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmenu_visibility`
--

DROP TABLE IF EXISTS `tmenu_visibility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tmenu_visibility` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `menu_section` varchar(100) NOT NULL DEFAULT '',
  `id_group` int unsigned NOT NULL DEFAULT '0',
  `mode` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmilestone`
--

DROP TABLE IF EXISTS `tmilestone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tmilestone` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_project` int NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `name` varchar(250) NOT NULL DEFAULT '',
  `description` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tm_idx_1` (`id_project`),
  CONSTRAINT `tmilestone_ibfk_1` FOREIGN KEY (`id_project`) REFERENCES `tproject` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmilestone_field`
--

DROP TABLE IF EXISTS `tmilestone_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tmilestone_field` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(100) NOT NULL DEFAULT '',
  `type` enum('textarea','text','combo','checkbox') DEFAULT 'text',
  `combo_value` text,
  `field_order` mediumint unsigned DEFAULT '0',
  `field_visibility` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmilestone_field_data`
--

DROP TABLE IF EXISTS `tmilestone_field_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tmilestone_field_data` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_milestone` varchar(60) NOT NULL DEFAULT '',
  `id_milestone_field` mediumint unsigned NOT NULL,
  `data` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tnewsboard`
--

DROP TABLE IF EXISTS `tnewsboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tnewsboard` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(250) NOT NULL DEFAULT '',
  `content` text NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_group` int NOT NULL DEFAULT '0',
  `expire` tinyint(1) DEFAULT '0',
  `expire_timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `creator` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tnewsletter`
--

DROP TABLE IF EXISTS `tnewsletter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tnewsletter` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` text,
  `id_group` mediumint unsigned NOT NULL,
  `description` text,
  `from_desc` text,
  `from_address` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tnewsletter_address`
--

DROP TABLE IF EXISTS `tnewsletter_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tnewsletter_address` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_newsletter` bigint NOT NULL,
  `name` tinytext,
  `email` tinytext,
  `status` int unsigned NOT NULL DEFAULT '0',
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `validated` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tnewsletter_content`
--

DROP TABLE IF EXISTS `tnewsletter_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tnewsletter_content` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_newsletter` bigint NOT NULL,
  `email_subject` text,
  `html` longtext,
  `plain` longtext,
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int unsigned NOT NULL DEFAULT '0',
  `id_campaign` int unsigned NOT NULL DEFAULT '0',
  `from_address` varchar(120) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tnewsletter_queue`
--

DROP TABLE IF EXISTS `tnewsletter_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tnewsletter_queue` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_newsletter_content` bigint NOT NULL,
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tnewsletter_queue_data`
--

DROP TABLE IF EXISTS `tnewsletter_queue_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tnewsletter_queue_data` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_queue` bigint NOT NULL,
  `id_newsletter` bigint NOT NULL,
  `id_newsletter_content` bigint NOT NULL,
  `email` tinytext,
  `name` tinytext,
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tnewsletter_tracking`
--

DROP TABLE IF EXISTS `tnewsletter_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tnewsletter_tracking` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_newsletter` bigint NOT NULL,
  `id_newsletter_address` bigint NOT NULL,
  `id_newsletter_content` bigint NOT NULL,
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tobject_field_data`
--

DROP TABLE IF EXISTS `tobject_field_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tobject_field_data` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_inventory` bigint unsigned NOT NULL,
  `id_object_type_field` mediumint unsigned NOT NULL,
  `data` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1492642 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tobject_type`
--

DROP TABLE IF EXISTS `tobject_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tobject_type` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  `icon` text,
  `min_stock` int NOT NULL DEFAULT '0',
  `show_in_list` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tobject_type_field`
--

DROP TABLE IF EXISTS `tobject_type_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tobject_type_field` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_object_type` mediumint unsigned DEFAULT NULL,
  `label` varchar(100) NOT NULL DEFAULT '',
  `type` enum('numeric','text','combo','external','date','checkbox') DEFAULT 'text',
  `combo_value` text,
  `external_table_name` text,
  `external_reference_field` text,
  `unique` int DEFAULT '0',
  `inherit` int DEFAULT '0',
  `show_list` tinyint unsigned DEFAULT '1',
  `parent_table_name` text,
  `parent_reference_field` text,
  `not_allow_updates` tinyint unsigned DEFAULT '0',
  `external_label` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=448 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tpending_mail`
--

DROP TABLE IF EXISTS `tpending_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tpending_mail` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `attempts` int unsigned NOT NULL DEFAULT '0',
  `status` int unsigned NOT NULL DEFAULT '0',
  `recipient` text,
  `subject` text,
  `body` text,
  `attachment_list` text,
  `from` text,
  `cc` text,
  `extra_headers` text,
  `image_list` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54884 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tphone_class`
--

DROP TABLE IF EXISTS `tphone_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tphone_class` (
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tprofile`
--

DROP TABLE IF EXISTS `tprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tprofile` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL DEFAULT '',
  `ir` tinyint(1) NOT NULL DEFAULT '0',
  `iw` tinyint(1) NOT NULL DEFAULT '0',
  `im` tinyint(1) NOT NULL DEFAULT '0',
  `um` tinyint(1) NOT NULL DEFAULT '0',
  `dm` tinyint(1) NOT NULL DEFAULT '0',
  `fm` tinyint(1) NOT NULL DEFAULT '0',
  `ar` tinyint(1) NOT NULL DEFAULT '0',
  `aw` tinyint(1) NOT NULL DEFAULT '0',
  `am` tinyint(1) NOT NULL DEFAULT '0',
  `pr` tinyint(1) NOT NULL DEFAULT '0',
  `pm` tinyint(1) NOT NULL DEFAULT '0',
  `kr` tinyint(1) NOT NULL DEFAULT '0',
  `kw` tinyint(1) NOT NULL DEFAULT '0',
  `km` tinyint(1) NOT NULL DEFAULT '0',
  `vr` tinyint(1) NOT NULL DEFAULT '0',
  `vw` tinyint(1) NOT NULL DEFAULT '0',
  `vm` tinyint(1) NOT NULL DEFAULT '0',
  `wr` tinyint(1) NOT NULL DEFAULT '0',
  `ww` tinyint(1) NOT NULL DEFAULT '0',
  `wm` tinyint(1) NOT NULL DEFAULT '0',
  `cr` tinyint(1) NOT NULL DEFAULT '0',
  `cw` tinyint(1) NOT NULL DEFAULT '0',
  `cm` tinyint(1) NOT NULL DEFAULT '0',
  `clm` tinyint(1) NOT NULL DEFAULT '0',
  `cim` tinyint(1) NOT NULL DEFAULT '0',
  `cn` tinyint(1) NOT NULL DEFAULT '0',
  `frr` tinyint(1) NOT NULL DEFAULT '0',
  `frw` tinyint(1) NOT NULL DEFAULT '0',
  `frm` tinyint(1) NOT NULL DEFAULT '0',
  `si` tinyint(1) NOT NULL DEFAULT '0',
  `qa` tinyint(1) NOT NULL DEFAULT '0',
  `rr` tinyint(1) NOT NULL DEFAULT '0',
  `rm` tinyint(1) NOT NULL DEFAULT '0',
  `hr` tinyint(1) NOT NULL DEFAULT '0',
  `cir` tinyint(1) NOT NULL DEFAULT '0',
  `ciw` tinyint(1) NOT NULL DEFAULT '0',
  `clr` tinyint(1) NOT NULL DEFAULT '0',
  `clw` tinyint(1) NOT NULL DEFAULT '0',
  `cuw` tinyint(1) NOT NULL DEFAULT '0',
  `cow` tinyint(1) NOT NULL DEFAULT '0',
  `com` tinyint(1) NOT NULL DEFAULT '0',
  `gr` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tproject`
--

DROP TABLE IF EXISTS `tproject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tproject` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(240) NOT NULL DEFAULT '',
  `description` mediumtext NOT NULL,
  `start` date NOT NULL DEFAULT '0000-00-00',
  `end` date NOT NULL DEFAULT '0000-00-00',
  `id_owner` varchar(60) NOT NULL DEFAULT '',
  `disabled` int unsigned NOT NULL DEFAULT '0',
  `id_project_group` mediumint unsigned NOT NULL DEFAULT '0',
  `cc` varchar(150) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `iproject_idx_1` (`id_project_group`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tproject_group`
--

DROP TABLE IF EXISTS `tproject_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tproject_group` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `icon` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tproject_track`
--

DROP TABLE IF EXISTS `tproject_track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tproject_track` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_project` int NOT NULL DEFAULT '0',
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `state` tinyint unsigned NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_aditional` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tpt_idx_1` (`id_project`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `tproject_track_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `tproject_track_ibfk_2` FOREIGN KEY (`id_project`) REFERENCES `tproject` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `treport_library`
--

DROP TABLE IF EXISTS `treport_library`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `treport_library` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_scheduled_report` int unsigned NOT NULL,
  `date_execution` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `utimestamp` bigint unsigned NOT NULL DEFAULT '0',
  `hash` varchar(150) NOT NULL DEFAULT '',
  `filename` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `id_scheduled_report` (`id_scheduled_report`),
  CONSTRAINT `treport_library_ibfk_1` FOREIGN KEY (`id_scheduled_report`) REFERENCES `treport_scheduler` (`id_scheduled_report`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `treport_scheduler`
--

DROP TABLE IF EXISTS `treport_scheduler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `treport_scheduler` (
  `id_scheduled_report` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL DEFAULT '',
  `user` varchar(60) NOT NULL DEFAULT '',
  `type` varchar(150) NOT NULL DEFAULT '',
  `action` varchar(150) NOT NULL DEFAULT '',
  `email_destination` mediumtext,
  `email_company` int unsigned DEFAULT '0',
  `email_contents` mediumtext,
  `id_report_template` int unsigned DEFAULT '0',
  `id_company` int unsigned DEFAULT '0',
  `scheduled_period` enum('one_time_only','weekly','monthly') DEFAULT 'one_time_only',
  `execution_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_execution` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `executions` int unsigned DEFAULT '0',
  `filters` text NOT NULL,
  PRIMARY KEY (`id_scheduled_report`),
  KEY `user` (`user`),
  CONSTRAINT `treport_scheduler_ibfk_1` FOREIGN KEY (`user`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `treport_template`
--

DROP TABLE IF EXISTS `treport_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `treport_template` (
  `id_report` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(150) NOT NULL DEFAULT '',
  `id_user` varchar(100) NOT NULL DEFAULT '',
  `name` varchar(150) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `custom_logo` varchar(200) DEFAULT NULL,
  `header` mediumtext,
  `first_page` mediumtext,
  `footer` mediumtext,
  PRIMARY KEY (`id_report`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trole`
--

DROP TABLE IF EXISTS `trole`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trole` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(125) NOT NULL DEFAULT '',
  `description` varchar(255) DEFAULT '',
  `cost` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trole_people_project`
--

DROP TABLE IF EXISTS `trole_people_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trole_people_project` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `id_role` int unsigned NOT NULL DEFAULT '0',
  `id_project` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `trp_idx_1` (`id_user`),
  KEY `trp_idx_2` (`id_project`),
  KEY `id_role` (`id_role`),
  CONSTRAINT `trole_people_project_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `trole_people_project_ibfk_2` FOREIGN KEY (`id_role`) REFERENCES `trole` (`id`) ON DELETE CASCADE,
  CONSTRAINT `trole_people_project_ibfk_3` FOREIGN KEY (`id_project`) REFERENCES `tproject` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trole_people_task`
--

DROP TABLE IF EXISTS `trole_people_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trole_people_task` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `id_role` int unsigned NOT NULL DEFAULT '0',
  `id_task` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_user` (`id_user`),
  KEY `id_role` (`id_role`),
  KEY `id_task` (`id_task`),
  CONSTRAINT `trole_people_task_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `trole_people_task_ibfk_2` FOREIGN KEY (`id_role`) REFERENCES `trole` (`id`) ON DELETE CASCADE,
  CONSTRAINT `trole_people_task_ibfk_3` FOREIGN KEY (`id_task`) REFERENCES `ttask` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tsesion`
--

DROP TABLE IF EXISTS `tsesion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tsesion` (
  `ID_sesion` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ID_usuario` varchar(60) NOT NULL DEFAULT '0',
  `IP_origen` varchar(100) NOT NULL DEFAULT '',
  `accion` varchar(100) NOT NULL DEFAULT '',
  `descripcion` varchar(200) NOT NULL DEFAULT '',
  `extra_info` text,
  `fecha` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `utimestamp` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID_sesion`),
  KEY `tsession_idx_1` (`ID_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=1175779 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tsessions_php`
--

DROP TABLE IF EXISTS `tsessions_php`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tsessions_php` (
  `id_session` char(52) NOT NULL,
  `last_active` int NOT NULL,
  `data` text,
  PRIMARY KEY (`id_session`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tsla`
--

DROP TABLE IF EXISTS `tsla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tsla` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `description` text,
  `min_response` float(11,2) NOT NULL DEFAULT '0.00',
  `max_response` float(11,2) NOT NULL DEFAULT '0.00',
  `max_incidents` int DEFAULT NULL,
  `max_inactivity` float(11,2) unsigned DEFAULT '96.00',
  `enforced` tinyint DEFAULT '0',
  `five_daysonly` tinyint DEFAULT '0',
  `time_from` tinyint DEFAULT '0',
  `time_to` tinyint DEFAULT '0',
  `id_sla_base` mediumint unsigned DEFAULT '0',
  `no_holidays` tinyint DEFAULT '0',
  `id_sla_type` mediumint unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttag`
--

DROP TABLE IF EXISTS `ttag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ttag` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `colour` enum('blue','grey','green','yellow','orange','red') DEFAULT 'orange',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttask`
--

DROP TABLE IF EXISTS `ttask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ttask` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_project` int NOT NULL DEFAULT '0',
  `id_parent_task` int DEFAULT '0',
  `name` varchar(240) NOT NULL DEFAULT '',
  `description` mediumtext NOT NULL,
  `completion` tinyint unsigned NOT NULL DEFAULT '0',
  `priority` tinyint unsigned NOT NULL DEFAULT '0',
  `dep_type` tinyint unsigned NOT NULL DEFAULT '0',
  `start` date NOT NULL DEFAULT '0000-00-00',
  `end` date NOT NULL DEFAULT '0000-00-00',
  `hours` int unsigned NOT NULL DEFAULT '0',
  `estimated_cost` float(9,2) unsigned NOT NULL DEFAULT '0.00',
  `periodicity` enum('none','weekly','monthly','year','21days','10days','15days','60days','90days','120days','180days') DEFAULT 'none',
  `count_hours` tinyint(1) DEFAULT '1',
  `cc` varchar(150) DEFAULT '',
  `send_mail` tinyint(1) NOT NULL DEFAULT '1',
  `set_hours` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `itask_idx_1` (`id_project`),
  CONSTRAINT `ttask_ibfk_1` FOREIGN KEY (`id_project`) REFERENCES `tproject` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttask_inventory`
--

DROP TABLE IF EXISTS `ttask_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ttask_inventory` (
  `id_task` int NOT NULL,
  `id_inventory` mediumint unsigned NOT NULL,
  PRIMARY KEY (`id_task`,`id_inventory`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttask_link`
--

DROP TABLE IF EXISTS `ttask_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ttask_link` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `source` int NOT NULL DEFAULT '0',
  `target` int NOT NULL DEFAULT '0',
  `type` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`,`source`,`target`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttask_track`
--

DROP TABLE IF EXISTS `ttask_track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ttask_track` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_task` int NOT NULL DEFAULT '0',
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `id_external` int unsigned NOT NULL DEFAULT '0',
  `state` tinyint unsigned NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `ttt_idx_1` (`id_task`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `ttask_track_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `ttask_track_ibfk_2` FOREIGN KEY (`id_task`) REFERENCES `ttask` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8995 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttemporal`
--

DROP TABLE IF EXISTS `ttemporal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ttemporal` (
  `usuario` varchar(60) NOT NULL DEFAULT '',
  `company` int unsigned DEFAULT '0',
  PRIMARY KEY (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttimetrack`
--

DROP TABLE IF EXISTS `ttimetrack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ttimetrack` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_user` varchar(200) NOT NULL,
  `timestamp` int unsigned NOT NULL DEFAULT '0',
  `tracktype` int unsigned NOT NULL DEFAULT '0',
  `origin` int unsigned NOT NULL DEFAULT '0',
  `manual` int unsigned NOT NULL DEFAULT '0',
  `changelog` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `ttimetrack_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttodo`
--

DROP TABLE IF EXISTS `ttodo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ttodo` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` tinytext,
  `progress` int NOT NULL,
  `assigned_user` varchar(60) NOT NULL DEFAULT '',
  `created_by_user` varchar(60) NOT NULL DEFAULT '',
  `priority` int NOT NULL,
  `description` mediumtext,
  `last_update` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `id_task` int DEFAULT NULL,
  `start_date` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `end_date` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `validation_date` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `need_external_validation` tinyint unsigned NOT NULL DEFAULT '0',
  `id_wo_category` int DEFAULT NULL,
  `email_notify` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `tt_idx_1` (`assigned_user`),
  KEY `tt_idx_2` (`created_by_user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttodo_notes`
--

DROP TABLE IF EXISTS `ttodo_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ttodo_notes` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `id_todo` int unsigned NOT NULL,
  `written_by` mediumtext,
  `description` mediumtext,
  `creation` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `id_todo_idx` (`id_todo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ttranslate_string`
--

DROP TABLE IF EXISTS `ttranslate_string`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ttranslate_string` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `lang` tinytext NOT NULL,
  `string` text NOT NULL,
  `translation` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tupdate_settings`
--

DROP TABLE IF EXISTS `tupdate_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tupdate_settings` (
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(255) DEFAULT '',
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tuser_field`
--

DROP TABLE IF EXISTS `tuser_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tuser_field` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(100) NOT NULL DEFAULT '',
  `type` enum('textarea','text','combo','linked','checkbox') DEFAULT 'text',
  `combo_value` text,
  `field_order` int NOT NULL DEFAULT '0',
  `linked_value` varchar(4096) DEFAULT NULL,
  `parent` mediumint unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tuser_field_data`
--

DROP TABLE IF EXISTS `tuser_field_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tuser_field_data` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `id_user_field` mediumint unsigned NOT NULL,
  `data` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=533063 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tuser_report`
--

DROP TABLE IF EXISTS `tuser_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tuser_report` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_user` varchar(60) NOT NULL DEFAULT '',
  `name` text,
  `email` varchar(100) NOT NULL,
  `report_type` mediumint unsigned DEFAULT '0',
  `interval_days` int unsigned NOT NULL DEFAULT '7',
  `lenght` int unsigned NOT NULL DEFAULT '7',
  `last_executed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_external` mediumint unsigned NOT NULL,
  `id_project` int DEFAULT '0',
  `id_incidents_custom_search` mediumint unsigned DEFAULT '0',
  `id_leads_custom_search` mediumint unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_user` (`id_user`),
  CONSTRAINT `tuser_report_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tusuario`
--

DROP TABLE IF EXISTS `tusuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tusuario` (
  `id_usuario` varchar(60) NOT NULL DEFAULT '',
  `nombre_real` varchar(125) NOT NULL DEFAULT '',
  `password` varchar(45) DEFAULT NULL,
  `comentarios` varchar(200) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `direccion` varchar(100) DEFAULT '',
  `telefono` varchar(100) DEFAULT '',
  `nivel` tinyint(1) NOT NULL DEFAULT '0',
  `avatar` varchar(100) DEFAULT 'moustache4',
  `lang` varchar(10) DEFAULT '',
  `pwdhash` varchar(100) DEFAULT '',
  `disabled` int DEFAULT '0',
  `id_company` int unsigned DEFAULT '0',
  `simple_mode` tinyint unsigned NOT NULL DEFAULT '0',
  `force_change_pass` tinyint unsigned NOT NULL DEFAULT '0',
  `last_pass_change` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_failed_login` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `failed_attempt` int NOT NULL DEFAULT '0',
  `login_blocked` tinyint unsigned NOT NULL DEFAULT '0',
  `num_employee` varchar(125) NOT NULL DEFAULT '',
  `enable_login` tinyint(1) NOT NULL DEFAULT '1',
  `location` tinytext NOT NULL,
  `disabled_login_by_license` tinyint(1) NOT NULL DEFAULT '0',
  `user_incidents_filter` int NOT NULL DEFAULT '0',
  `status_track` int unsigned NOT NULL DEFAULT '0',
  `origin_track` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tusuario_perfil`
--

DROP TABLE IF EXISTS `tusuario_perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tusuario_perfil` (
  `id_up` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` varchar(60) NOT NULL DEFAULT '',
  `id_perfil` int unsigned NOT NULL DEFAULT '0',
  `id_grupo` mediumint unsigned NOT NULL DEFAULT '0',
  `assigned_by` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_up`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_grupo` (`id_grupo`),
  KEY `id_perfil` (`id_perfil`),
  CONSTRAINT `tusuario_perfil_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `tusuario` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `tusuario_perfil_ibfk_2` FOREIGN KEY (`id_grupo`) REFERENCES `tgrupo` (`id_grupo`) ON DELETE CASCADE,
  CONSTRAINT `tusuario_perfil_ibfk_3` FOREIGN KEY (`id_perfil`) REFERENCES `tprofile` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=70100 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tvacationday`
--

DROP TABLE IF EXISTS `tvacationday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvacationday` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `day` int unsigned NOT NULL DEFAULT '0',
  `month` int unsigned NOT NULL DEFAULT '0',
  `name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `twiki_acl`
--

DROP TABLE IF EXISTS `twiki_acl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `twiki_acl` (
  `page` varchar(200) NOT NULL DEFAULT '',
  `read_page` varchar(200) NOT NULL DEFAULT '',
  `write_page` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`page`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `twizard`
--

DROP TABLE IF EXISTS `twizard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `twizard` (
  `id` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `two_category`
--

DROP TABLE IF EXISTS `two_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `two_category` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` text,
  `icon` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tworkflow_action`
--

DROP TABLE IF EXISTS `tworkflow_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tworkflow_action` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `description` mediumtext,
  `id_rule` bigint unsigned NOT NULL,
  `action_type` int NOT NULL DEFAULT '0',
  `action_data` mediumtext,
  `action_data2` text,
  `action_data3` text,
  PRIMARY KEY (`id`),
  KEY `id_rule` (`id_rule`),
  CONSTRAINT `tworkflow_action_ibfk_1` FOREIGN KEY (`id_rule`) REFERENCES `tworkflow_rule` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tworkflow_condition`
--

DROP TABLE IF EXISTS `tworkflow_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tworkflow_condition` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `description` mediumtext,
  `id_rule` bigint unsigned NOT NULL,
  `operator` int DEFAULT '0',
  `time_creation` bigint NOT NULL DEFAULT '0',
  `time_update` bigint NOT NULL DEFAULT '0',
  `id_group` int NOT NULL DEFAULT '0',
  `id_owner` varchar(200) NOT NULL DEFAULT '',
  `status` int unsigned NOT NULL DEFAULT '0',
  `priority` int NOT NULL,
  `sla` int NOT NULL DEFAULT '0',
  `string_match` varchar(250) NOT NULL DEFAULT '',
  `resolution` int NOT NULL DEFAULT '0',
  `id_task` int NOT NULL DEFAULT '0',
  `id_ticket_type` int NOT NULL DEFAULT '0',
  `type_fields` varchar(300) NOT NULL DEFAULT '',
  `percent_sla` int unsigned NOT NULL DEFAULT '0',
  `creation_in_vac` tinyint unsigned NOT NULL DEFAULT '0',
  `creation_in_weekends` tinyint unsigned NOT NULL DEFAULT '0',
  `creation_from` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `creation_to` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_company` int NOT NULL DEFAULT '0',
  `id_inventory` int NOT NULL DEFAULT '0',
  `field_order` mediumint unsigned DEFAULT '0',
  `operation` mediumint unsigned DEFAULT '1',
  `time_creation_operator` int DEFAULT '0',
  `time_update_operator` int DEFAULT '0',
  `id_creator` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `id_rule` (`id_rule`),
  CONSTRAINT `tworkflow_condition_ibfk_1` FOREIGN KEY (`id_rule`) REFERENCES `tworkflow_rule` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tworkflow_rule`
--

DROP TABLE IF EXISTS `tworkflow_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tworkflow_rule` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `type` int NOT NULL DEFAULT '0',
  `disabled` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tworkflow_status_mapping`
--

DROP TABLE IF EXISTS `tworkflow_status_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tworkflow_status_mapping` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `origin_id` int unsigned NOT NULL,
  `destination_id` int unsigned NOT NULL,
  `resolution_destination_id` int unsigned NOT NULL,
  `initial` int DEFAULT '0',
  `resolution_origin_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tworkunit`
--

DROP TABLE IF EXISTS `tworkunit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tworkunit` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `duration` float(10,2) unsigned NOT NULL DEFAULT '0.00',
  `id_user` varchar(125) DEFAULT NULL,
  `description` mediumtext NOT NULL,
  `have_cost` tinyint unsigned NOT NULL DEFAULT '0',
  `id_profile` int NOT NULL DEFAULT '0',
  `locked` varchar(125) DEFAULT '',
  `public` tinyint unsigned NOT NULL DEFAULT '1',
  `work_home` tinyint unsigned NOT NULL DEFAULT '0',
  `internal` tinyint unsigned NOT NULL DEFAULT '0',
  `realization_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `id_user_secondary` varchar(100) DEFAULT '',
  `is_visible` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `tw_idx_1` (`id_user`),
  KEY `id_user_secondary_index` (`id_user_secondary`)
) ENGINE=InnoDB AUTO_INCREMENT=125070 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tworkunit_incident`
--

DROP TABLE IF EXISTS `tworkunit_incident`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tworkunit_incident` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_incident` int unsigned NOT NULL DEFAULT '0',
  `id_workunit` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `twi_idx_1` (`id_incident`),
  KEY `twi_idx_2` (`id_workunit`),
  CONSTRAINT `tworkunit_incident_ibfk_1` FOREIGN KEY (`id_workunit`) REFERENCES `tworkunit` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=125389 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tworkunit_task`
--

DROP TABLE IF EXISTS `tworkunit_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tworkunit_task` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `id_task` int NOT NULL DEFAULT '0',
  `id_workunit` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `twt_idx_1` (`id_task`),
  KEY `id_workunit` (`id_workunit`),
  CONSTRAINT `tworkunit_task_ibfk_1` FOREIGN KEY (`id_workunit`) REFERENCES `tworkunit` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Volver a activar restricciones de clave externa
SET FOREIGN_KEY_CHECKS = 1;

--
-- Dumping events for database 'integria'
--

--
-- Dumping routines for database 'integria'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-15 17:05:34
