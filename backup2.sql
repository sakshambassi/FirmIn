-- MySQL dump 10.13  Distrib 5.7.19, for osx10.12 (x86_64)
--
-- Host: localhost    Database: FirmIn2
-- ------------------------------------------------------
-- Server version	5.7.19

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
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client` (
  `client_id` int(11) NOT NULL,
  `client_name` varchar(255) DEFAULT NULL,
  `client_address` varchar(255) DEFAULT NULL,
  `client_phone` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
INSERT INTO `client` VALUES (1,'Colt Tech','London',2073903900),(2,'Blue Source','San Francisco',55473903900),(3,'Clarke Power','Gurgaun',9945634523),(4,'DataCom','New Zealand',3443577867),(5,'Ensono','New York',5554324243764),(6,'Inter Media','Mumbai',9898343824),(7,'KCC engineering','Bangalore',9024336556),(8,'Sky Tech','Berlin',78776345656),(9,'White Star','San Francisco',554734345900),(10,'Munich RE','Munich',43734345900);
/*!40000 ALTER TABLE `client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_goal`
--

DROP TABLE IF EXISTS `company_goal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_goal` (
  `goal_id` int(11) NOT NULL,
  `goal_description` varchar(255) DEFAULT NULL,
  `goal_status` varchar(25) DEFAULT NULL,
  `funds_needed` bigint(20) DEFAULT NULL,
  `goal_profits` bigint(20) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`goal_id`),
  KEY `team_id` (`team_id`),
  CONSTRAINT `company_goal_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `team_info` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_goal`
--

LOCK TABLES `company_goal` WRITE;
/*!40000 ALTER TABLE `company_goal` DISABLE KEYS */;
INSERT INTO `company_goal` VALUES (1,'Market FirmIn to increase customers.','incomplete',1500000,0,1),(2,'Analyze previous data to predict share market.','incomplete',2000000,0,2),(3,'Give client offers and develop after-sales services.','incomplete',1300000,0,3),(4,'Develop and add Big-data tasks to software developers.','incomplete',1550000,0,4),(5,'Review products and services, solve bugs and errors stated by customer\'s feedback.','incomplete',524000,0,5),(6,'Hire HR based employees','incomplete',2300000,0,6);
/*!40000 ALTER TABLE `company_goal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_conduct`
--

DROP TABLE IF EXISTS `employee_conduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employee_conduct` (
  `emp_id` int(11) DEFAULT NULL,
  `employee_grade` int(11) DEFAULT NULL,
  `base_salary` bigint(20) DEFAULT NULL,
  `employee_designation` varchar(30) DEFAULT NULL,
  `employee_DA` bigint(20) DEFAULT NULL,
  `employee_HRA` bigint(20) DEFAULT NULL,
  `professional_tax` int(11) DEFAULT NULL,
  `providend_fund` int(11) DEFAULT NULL,
  `employee_salary` bigint(20) DEFAULT NULL,
  `progress` int(11) DEFAULT NULL,
  KEY `emp_id` (`emp_id`),
  CONSTRAINT `employee_conduct_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `employee_info` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_conduct`
--

LOCK TABLES `employee_conduct` WRITE;
/*!40000 ALTER TABLE `employee_conduct` DISABLE KEYS */;
INSERT INTO `employee_conduct` VALUES (1,2,44500,'CEO',2000,2500,10,12,0,0),(2,3,42500,'CTO',2000,2500,10,12,0,0),(3,4,42000,'Director',2000,2500,10,12,0,0),(4,5,41500,'Product Manager',2000,2500,10,12,0,0),(5,3,40500,'Project Manager',2000,2500,10,12,0,0),(6,3,40500,'Project Manager',2000,2500,10,12,0,0),(7,3,40000,'Project Lead',2000,2500,10,12,0,0),(8,3,40000,'Project Lead',2000,2500,10,12,0,0),(9,3,40000,'Project Lead',2000,2500,10,12,0,0),(10,3,40000,'Project Lead',2000,2500,10,12,0,0),(12,3,40000,'Project Lead',2000,2500,10,12,0,0),(13,2,37500,'Software Engineer',2000,2500,10,12,0,0),(14,2,37500,'Software Engineer',2000,2500,10,12,0,0),(15,2,37500,'Software Engineer',2000,2500,10,12,0,0),(16,2,37500,'Software Engineer',2000,2500,10,12,0,0),(17,2,37500,'Software Engineer',2000,2500,10,12,0,0),(18,2,37500,'Software Engineer',2000,2500,10,12,0,0),(19,2,38500,'Senior Software Engineer',2000,2500,10,12,0,0),(20,2,38500,'Senior Software Engineer',2000,2500,10,12,0,0);
/*!40000 ALTER TABLE `employee_conduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_info`
--

DROP TABLE IF EXISTS `employee_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employee_info` (
  `emp_id` int(11) NOT NULL,
  `emp_name` varchar(25) DEFAULT NULL,
  `phone_no` bigint(20) DEFAULT NULL,
  `emp_address` varchar(25) DEFAULT NULL,
  `email_id` varchar(320) DEFAULT NULL,
  `emp_gender` varchar(25) DEFAULT NULL,
  `emp_department` varchar(25) DEFAULT NULL,
  `emp_birthdate` date DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_info`
--

LOCK TABLES `employee_info` WRITE;
/*!40000 ALTER TABLE `employee_info` DISABLE KEYS */;
INSERT INTO `employee_info` VALUES (1,'Manasi',7894563210,'Pune','manasi@gmail.com','Female','HR','1998-03-10',5),(2,'Saksham Bassi',7894563211,'Poona','saksham@gmail.com','Male','HR','1997-03-10',4),(3,'Tushar Shelar',8806210990,'Nasik','tusharshelar002@gmail.com','Male','HR','1997-03-28',0),(4,'Shraddha Patil',9874586321,'Raigad','shraddha@gmail.com','Female','HR','1997-02-28',6),(5,'Ashutosh Shinde',8569741230,'Nagar','ashutosh@gmail.com','Male','HR','1997-06-12',0),(6,'Onkar Ingale',8547963210,'Baramati','ionkar7701@gmail.com','Male','Marketing','1997-03-12',9),(7,'Atharva Rajurkar',8595674859,'Pimpri','atharva@gmail.com','Male','Marketing','1997-04-12',0),(8,'Rajat Raghuvanshi',8457693215,'Amravati','rajat@gmail.com','Male','Marketing','1997-01-24',7),(9,'Rajat Paliwal',8529637410,'Dangechowk','paliwal@gmail.com','Male','Marketing','1997-04-05',0),(10,'Pranit Bagmar',8574961232,'Lasalgaon','prbagmar@gmail.com','Male','Marketing','1997-05-11',8),(11,'Onkara Singh',8547963210,'Bangalore','onkaraaa@gmail.com','Male','R&D','1997-03-12',0),(12,'Saurabh Sharma',8555553625,'Delhi','saurabhshar@gmail.com','Male','R&D','1997-04-12',3),(13,'Raj Mehta',8555553626,'Mumbai','raj@gmail.com','Male','R&D','1997-01-24',0),(14,'Rami Singh',8529637770,'Bhopal','rami@gmail.com','Female','R&D','1997-04-05',1),(15,'Pranita Bose',8554553626,'Ahmedabad','pranita@gmail.com','Female','R&D','1997-05-11',0),(16,'Dipak Shinde',9156287345,'Pondicherry','dipak@gmail.com','Male','Tech','1997-08-15',0),(17,'Gaurang Londhe',9835621478,'Latur','gaurang@gmail.com','Male','Tech','1998-02-24',0),(18,'Sameer Kulkarni',8252634145,'Tiruvananthapuram','sameer@gmail.com','Male','Tech','1997-03-19',0),(19,'Saurabh Jadhav',9777798558,'Malegaon','saurabh@gmail.com','Male','Tech','1996-06-24',0),(20,'Harshal Nimade',9513578462,'New York','harshal@gmail.com','Male','Tech','1997-11-19',0),(21,'Abhishek Kumar',8080334400,'Mumbai','abhishek1212@yahoo.com','Male','Finance','1990-12-01',2),(22,'Asha Das',9803341400,'Agra','ashadas@rediffmail.com','Female','Finance','1989-12-01',0),(23,'Ritika Singh',9824361400,'Manali','ritikasingh@gmail.com','Female','Finance','1989-10-02',0),(24,'Aishwarya Bhosle',7024361456,'Kolkata','aishbh@gmail.com','Female','Finance','1994-04-02',0),(25,'Vishrut Desai',9024544456,'Baroda','vdesai@gmail.com','Male','Finance','1996-04-30',0);
/*!40000 ALTER TABLE `employee_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `investors`
--

DROP TABLE IF EXISTS `investors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `investors` (
  `investor_id` int(11) NOT NULL,
  `investor_name` varchar(25) DEFAULT NULL,
  `goal_id` int(11) DEFAULT NULL,
  `funds_allocated` bigint(20) DEFAULT NULL,
  `profit_percent` int(11) DEFAULT NULL,
  PRIMARY KEY (`investor_id`),
  KEY `goal_id` (`goal_id`),
  CONSTRAINT `investors_ibfk_1` FOREIGN KEY (`goal_id`) REFERENCES `company_goal` (`goal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `investors`
--

LOCK TABLES `investors` WRITE;
/*!40000 ALTER TABLE `investors` DISABLE KEYS */;
INSERT INTO `investors` VALUES (1,'Manoj Sharma',1,150000,5),(2,'Sanjeev Kumar',2,70000,2),(3,'Rajiv Sharma',1,85000,3),(4,'Vijay Mehta',3,400000,10),(5,'Raj Mehta',4,800000,16),(6,'Seetha Raman ',5,400000,12),(7,'Rakesh Sharma ',6,1000000,22),(8,'Varun Kumar ',6,500000,11);
/*!40000 ALTER TABLE `investors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_info`
--

DROP TABLE IF EXISTS `project_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_info` (
  `project_id` int(11) NOT NULL,
  `team_id` int(11) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `project_description` varchar(255) DEFAULT NULL,
  `deadline` date DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `project_cost` bigint(20) DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`project_id`),
  KEY `team_id` (`team_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `project_info_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `team_info` (`team_id`),
  CONSTRAINT `project_info_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_info`
--

LOCK TABLES `project_info` WRITE;
/*!40000 ALTER TABLE `project_info` DISABLE KEYS */;
INSERT INTO `project_info` VALUES (1,1,'A.I.','Jarvis uses several AI techniques, including natural language processing, speech and face recognition, and reinforcement learning','2017-09-15','In progress',200000,8),(2,3,'Cloud','.Net-based credit card payment processing system tapping high-performance cloud-based services ','2017-09-15','In progress',153000,7),(3,2,'Web','Web 2.0-based collaboration and knowledge management platform based on Microsoft SharePoint, combining structured and unstructured data in the form of blogs and wikis','2017-09-15','completed',175000,2),(4,5,'DBMS','Plan some team-building','2017-09-15','completed',210000,1),(5,4,'Robotics','Root is a robot that is ready to draw, erase, play music, and explore its world using over 50 sensors and actuators — making coding relevant to many age groups and experience levels.','2017-09-15','completed',332000,4),(6,5,'Software','etos is a new software tool','2018-05-04','completed',30000,6),(7,0,'Telecom','Telecom service','2017-10-31','disapproved',5000,1),(8,5,'Web','test service for graph and quality assurance','2017-11-02','completed',30000,4),(9,4,'A.I.','testtest','2017-11-25','completed',20000,5),(10,2,'DBMS','aeae','2017-11-24','In progress',30000,3);
/*!40000 ALTER TABLE `project_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger aptrig
after update on project_info
for each row
begin
if(new.status = 'completed')
then

update team_task set status = 'Finished' where project_id = new.project_id;

end if;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 trigger approveteam
after update on project_info
for each row
begin
if(new.status = 'completed')
then

update employee_info set team_id = 0 where team_id in(select team_id from project_info where project_id = new.project_id) and emp_id not in(select teamleader_id from team_info where team_id in (select team_id from project_info where project_id = new.project_id));

end if;

end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `team_info`
--

DROP TABLE IF EXISTS `team_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_info` (
  `team_id` int(11) NOT NULL,
  `team_name` varchar(255) DEFAULT NULL,
  `teamleader_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_info`
--

LOCK TABLES `team_info` WRITE;
/*!40000 ALTER TABLE `team_info` DISABLE KEYS */;
INSERT INTO `team_info` VALUES (1,'Mind_benders',14),(2,'Technical_knockouts',21),(3,'Innovation_geeks',12),(4,'Tax manion_devils',2),(5,'Accrual_World',1),(6,'Kicking_assets',4),(7,'Marketing_maestros',8),(8,'The Think_tank',10),(9,'Image_makers',6);
/*!40000 ALTER TABLE `team_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_task`
--

DROP TABLE IF EXISTS `team_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_task` (
  `status` varchar(25) DEFAULT NULL,
  `task_description` varchar(255) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  KEY `project_id` (`project_id`),
  KEY `emp_id` (`emp_id`),
  CONSTRAINT `team_task_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project_info` (`project_id`),
  CONSTRAINT `team_task_ibfk_2` FOREIGN KEY (`emp_id`) REFERENCES `employee_info` (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_task`
--

LOCK TABLES `team_task` WRITE;
/*!40000 ALTER TABLE `team_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `team_task` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-11-04 12:12:43
