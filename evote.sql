-- MySQL dump 10.13  Distrib 8.0.25, for Win64 (x86_64)
--
-- Host: localhost    Database: evoting
-- ------------------------------------------------------
-- Server version	8.0.25

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

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `AddressID` int NOT NULL AUTO_INCREMENT,
  `District` varchar(20) NOT NULL,
  `Municipality` varchar(20) NOT NULL,
  `WardNo` int NOT NULL,
  `Province` int NOT NULL,
  PRIMARY KEY (`AddressID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (1,'Kathmandu','Chandragiri',5,3),(2,'Lalitpur','Mahalaxmi',9,3);
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adrress`
--

DROP TABLE IF EXISTS `adrress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adrress` (
  `AddressID` int NOT NULL AUTO_INCREMENT,
  `District` char(20) NOT NULL,
  `Municiplaity` char(20) NOT NULL,
  `WardNo` int NOT NULL,
  PRIMARY KEY (`AddressID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adrress`
--

LOCK TABLES `adrress` WRITE;
/*!40000 ALTER TABLE `adrress` DISABLE KEYS */;
/*!40000 ALTER TABLE `adrress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate_identity`
--

DROP TABLE IF EXISTS `candidate_identity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate_identity` (
  `CandidateID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(45) NOT NULL,
  `MiddleName` varchar(45) DEFAULT NULL,
  `LastName` varchar(45) NOT NULL,
  `DOB` date NOT NULL,
  `Age` int NOT NULL,
  `Email` varchar(45) NOT NULL,
  `PhoneNo` int NOT NULL,
  `Sex` tinyint(1) NOT NULL,
  `CitizenshipID` varchar(15) NOT NULL,
  `EducationID` int DEFAULT NULL,
  `AddressID` int NOT NULL,
  `PartyID` varchar(45) NOT NULL,
  PRIMARY KEY (`CandidateID`),
  UNIQUE KEY `Email_UNIQUE` (`Email`),
  UNIQUE KEY `PhoneNo_UNIQUE` (`PhoneNo`),
  UNIQUE KEY `CitizenshipID_UNIQUE` (`CitizenshipID`),
  KEY `Address_idx` (`AddressID`),
  KEY `Education_idx` (`EducationID`),
  CONSTRAINT `AddressID` FOREIGN KEY (`AddressID`) REFERENCES `address` (`AddressID`),
  CONSTRAINT `EducationID` FOREIGN KEY (`EducationID`) REFERENCES `education` (`EducationID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate_identity`
--

LOCK TABLES `candidate_identity` WRITE;
/*!40000 ALTER TABLE `candidate_identity` DISABLE KEYS */;
INSERT INTO `candidate_identity` VALUES (1,'X','Y','Z','2000-12-23',21,'XYZ@gmail.com',98,0,'12-32-5555',1,1,'A');
/*!40000 ALTER TABLE `candidate_identity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `education`
--

DROP TABLE IF EXISTS `education`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `education` (
  `EducationID` int NOT NULL AUTO_INCREMENT,
  `DegreeLevel` varchar(25) NOT NULL,
  PRIMARY KEY (`EducationID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `education`
--

LOCK TABLES `education` WRITE;
/*!40000 ALTER TABLE `education` DISABLE KEYS */;
INSERT INTO `education` VALUES (1,'High School'),(2,'Bachelor\'s'),(3,'Master\'s'),(4,'PHD');
/*!40000 ALTER TABLE `education` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vote`
--

DROP TABLE IF EXISTS `vote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vote` (
  `VoteID` int NOT NULL AUTO_INCREMENT,
  `VoterID` int NOT NULL,
  `CandidateID` int NOT NULL,
  `VoteTime` timestamp NOT NULL,
  PRIMARY KEY (`VoteID`),
  UNIQUE KEY `VoterID_UNIQUE` (`VoterID`),
  KEY `CandidateID_idx` (`CandidateID`),
  CONSTRAINT `CandidateID` FOREIGN KEY (`CandidateID`) REFERENCES `candidate_identity` (`CandidateID`),
  CONSTRAINT `VoterID` FOREIGN KEY (`VoterID`) REFERENCES `voter_identity` (`VoterID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vote`
--

LOCK TABLES `vote` WRITE;
/*!40000 ALTER TABLE `vote` DISABLE KEYS */;
/*!40000 ALTER TABLE `vote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voter_identity`
--

DROP TABLE IF EXISTS `voter_identity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `voter_identity` (
  `VoterID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(45) NOT NULL,
  `MiddleName` varchar(45) DEFAULT NULL,
  `LastName` varchar(45) NOT NULL,
  `DOB` date NOT NULL,
  `Age` int DEFAULT NULL,
  `Email` varchar(45) NOT NULL,
  `PhoneNo.` int NOT NULL,
  `Sex` tinyint(1) NOT NULL,
  `CitizenshipNo` varchar(15) NOT NULL,
  `AddressID` int NOT NULL,
  PRIMARY KEY (`VoterID`),
  UNIQUE KEY `Email_UNIQUE` (`Email`),
  UNIQUE KEY `CitizenshipNo_UNIQUE` (`CitizenshipNo`),
  UNIQUE KEY `PhoneNo._UNIQUE` (`PhoneNo.`),
  KEY `Address_idx` (`AddressID`),
  CONSTRAINT `Address` FOREIGN KEY (`AddressID`) REFERENCES `address` (`AddressID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voter_identity`
--

LOCK TABLES `voter_identity` WRITE;
/*!40000 ALTER TABLE `voter_identity` DISABLE KEYS */;
/*!40000 ALTER TABLE `voter_identity` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-15 20:05:14
