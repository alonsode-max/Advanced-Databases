CREATE DATABASE  IF NOT EXISTS `databases` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `databases`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: databases
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `base_stats`
--

DROP TABLE IF EXISTS `base_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `base_stats` (
  `id_base_stats` int NOT NULL AUTO_INCREMENT,
  `ataque` int NOT NULL,
  `defensa` int NOT NULL,
  `velocidad` int NOT NULL,
  `magia` int NOT NULL,
  PRIMARY KEY (`id_base_stats`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `base_stats`
--

LOCK TABLES `base_stats` WRITE;
/*!40000 ALTER TABLE `base_stats` DISABLE KEYS */;
INSERT INTO `base_stats` VALUES (1,120,80,50,20),(2,60,100,40,50),(3,30,40,60,150),(4,90,70,70,70);
/*!40000 ALTER TABLE `base_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clase`
--

DROP TABLE IF EXISTS `clase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clase` (
  `id_clase` int NOT NULL AUTO_INCREMENT,
  `descripcion` text NOT NULL,
  `atributos` text NOT NULL,
  PRIMARY KEY (`id_clase`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clase`
--

LOCK TABLES `clase` WRITE;
/*!40000 ALTER TABLE `clase` DISABLE KEYS */;
INSERT INTO `clase` VALUES (1,'Guerrero enfocado en el combate cuerpo a cuerpo.','Fuerza, Vitalidad'),(2,'Mago especializado en hechizos ofensivos.','Intelecto, Maná'),(3,'Pícaro ágil, experto en evasión y golpes críticos.','Agilidad, Suerte'),(4,'Sanador de apoyo con hechizos de protección.','Espíritu, Resistencia');
/*!40000 ALTER TABLE `clase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `combate`
--

DROP TABLE IF EXISTS `combate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `combate` (
  `id_personaje` int NOT NULL,
  `id_enemigo` int NOT NULL,
  `fecha` datetime NOT NULL,
  `habilidades_id_habilidades` int NOT NULL,
  `daño` int NOT NULL,
  `ataque_enemigo` tinyint NOT NULL DEFAULT '0',
  KEY `fk_personaje_has_enemigo_enemigo1_idx` (`id_enemigo`),
  KEY `fk_personaje_has_enemigo_personaje1_idx` (`id_personaje`),
  KEY `fk_personaje_has_enemigo_habilidades1_idx` (`habilidades_id_habilidades`),
  CONSTRAINT `fk_personaje_has_enemigo_habilidades1` FOREIGN KEY (`habilidades_id_habilidades`) REFERENCES `habilidades` (`id_habilidades`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `combate`
--

LOCK TABLES `combate` WRITE;
/*!40000 ALTER TABLE `combate` DISABLE KEYS */;
INSERT INTO `combate` VALUES (1,1,'2025-11-25 19:00:00',1,150,0),(1,2,'2025-11-25 19:05:00',2,500,0),(1,3,'2025-11-25 19:05:00',1,2500,0),(2,1,'2025-11-25 19:05:00',2,200,0),(2,3,'2025-11-25 22:03:00',1,1,0);
/*!40000 ALTER TABLE `combate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enemigo`
--

DROP TABLE IF EXISTS `enemigo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enemigo` (
  `id_enemigo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `nivel` int NOT NULL,
  `fk_region` int NOT NULL,
  `fk_rango` int NOT NULL,
  `fk_base_stats` int NOT NULL,
  `vida` int NOT NULL,
  `vida_base` int NOT NULL,
  PRIMARY KEY (`id_enemigo`),
  KEY `fk_enemigo_region1_idx` (`fk_region`),
  KEY `fk_enemigo_rango_enemigos1_idx` (`fk_rango`),
  KEY `fk_enemigo_base_stats1_idx` (`fk_base_stats`),
  CONSTRAINT `fk_enemigo_base_stats1` FOREIGN KEY (`fk_base_stats`) REFERENCES `base_stats` (`id_base_stats`),
  CONSTRAINT `fk_enemigo_rango_enemigos1` FOREIGN KEY (`fk_rango`) REFERENCES `rango_enemigos` (`id_rango_enemigos`),
  CONSTRAINT `fk_enemigo_region1` FOREIGN KEY (`fk_region`) REFERENCES `region` (`id_region`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enemigo`
--

LOCK TABLES `enemigo` WRITE;
/*!40000 ALTER TABLE `enemigo` DISABLE KEYS */;
INSERT INTO `enemigo` VALUES (1,'Lobo Joven',2,1,1,4,500,500),(2,'Golem de Piedra',15,2,2,2,500,1000),(3,'Dragón de Fuego',50,3,3,1,2500,2500);
/*!40000 ALTER TABLE `enemigo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evento`
--

DROP TABLE IF EXISTS `evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evento` (
  `id_evento` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `bonificaciones` varchar(255) DEFAULT NULL,
  `descripcion` text,
  PRIMARY KEY (`id_evento`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evento`
--

LOCK TABLES `evento` WRITE;
/*!40000 ALTER TABLE `evento` DISABLE KEYS */;
INSERT INTO `evento` VALUES (1,'Festival de la Cosecha','2025-11-20','2025-11-30','Doble de Oro','Evento anual con misiones y recompensas especiales.'),(2,'Invasión de Goblins','2025-12-05','2025-12-15','Drop de materiales raros','Los Goblins atacan las Praderas de Inicio.');
/*!40000 ALTER TABLE `evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fuente`
--

DROP TABLE IF EXISTS `fuente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fuente` (
  `id_fuente` int NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `fk_enemigo` int DEFAULT NULL,
  PRIMARY KEY (`id_fuente`),
  KEY `fk_enemigo_idx` (`fk_enemigo`),
  CONSTRAINT `fk_enemigo` FOREIGN KEY (`fk_enemigo`) REFERENCES `enemigo` (`id_enemigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fuente`
--

LOCK TABLES `fuente` WRITE;
/*!40000 ALTER TABLE `fuente` DISABLE KEYS */;
INSERT INTO `fuente` VALUES (1,'Dropeado por dragon',3),(2,'Venta en Mercado',NULL),(3,'Recompensa de Misión',NULL),(4,'Evento Especial',NULL);
/*!40000 ALTER TABLE `fuente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gremio`
--

DROP TABLE IF EXISTS `gremio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gremio` (
  `id_gremio` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `fecha_creación` date NOT NULL,
  `trofeos` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_gremio`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gremio`
--

LOCK TABLES `gremio` WRITE;
/*!40000 ALTER TABLE `gremio` DISABLE KEYS */;
INSERT INTO `gremio` VALUES (1,'Los Dragones Rojos','2025-01-15',500),(2,'La Hermandad de Acero','2025-05-20',1200);
/*!40000 ALTER TABLE `gremio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `habilidades`
--

DROP TABLE IF EXISTS `habilidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `habilidades` (
  `id_habilidades` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `rango` int NOT NULL,
  `nivel` int NOT NULL,
  `fk_tipo` int NOT NULL,
  `clase_id_clase` int NOT NULL,
  PRIMARY KEY (`id_habilidades`),
  KEY `fk_habilidades_tipo_habilidad1_idx` (`fk_tipo`),
  KEY `fk_habilidades_clase1_idx` (`clase_id_clase`),
  CONSTRAINT `fk_habilidades_clase1` FOREIGN KEY (`clase_id_clase`) REFERENCES `clase` (`id_clase`),
  CONSTRAINT `fk_habilidades_tipo_habilidad1` FOREIGN KEY (`fk_tipo`) REFERENCES `tipo_habilidad` (`id_tipo_habilidad`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `habilidades`
--

LOCK TABLES `habilidades` WRITE;
/*!40000 ALTER TABLE `habilidades` DISABLE KEYS */;
INSERT INTO `habilidades` VALUES (1,'Corte Poderoso','Ataque cuerpo a cuerpo potente.',1,1,1,1),(2,'Bola de Fuego','Lanza un proyectil mágico de fuego.',5,5,2,2),(3,'Curación Menor','Restaura una pequeña cantidad de salud.',4,1,3,4);
/*!40000 ALTER TABLE `habilidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jugador`
--

DROP TABLE IF EXISTS `jugador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jugador` (
  `id_jugador` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `fecha_registro` date NOT NULL,
  `horas_jugadas` int NOT NULL DEFAULT '0',
  `fk_pais` int NOT NULL,
  PRIMARY KEY (`id_jugador`),
  KEY `fk_jugador_pais_idx` (`fk_pais`),
  CONSTRAINT `fk_jugador_pais` FOREIGN KEY (`fk_pais`) REFERENCES `pais` (`id_pais`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jugador`
--

LOCK TABLES `jugador` WRITE;
/*!40000 ALTER TABLE `jugador` DISABLE KEYS */;
INSERT INTO `jugador` VALUES (1,'Alice','2025-10-01',150,1),(2,'Bob','2025-10-05',200,2),(3,'Charlie','2025-11-10',50,3);
/*!40000 ALTER TABLE `jugador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logro`
--

DROP TABLE IF EXISTS `logro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logro` (
  `id_logro` int NOT NULL AUTO_INCREMENT,
  `fk_rareza` int NOT NULL,
  PRIMARY KEY (`id_logro`),
  KEY `fk_logro_rareza1_idx` (`fk_rareza`),
  CONSTRAINT `fk_logro_rareza1` FOREIGN KEY (`fk_rareza`) REFERENCES `rareza` (`id_rareza`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logro`
--

LOCK TABLES `logro` WRITE;
/*!40000 ALTER TABLE `logro` DISABLE KEYS */;
INSERT INTO `logro` VALUES (1,1),(2,2),(3,3);
/*!40000 ALTER TABLE `logro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logro_has_personaje`
--

DROP TABLE IF EXISTS `logro_has_personaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logro_has_personaje` (
  `logro_id_logro` int NOT NULL,
  `personaje_id_personaje` int NOT NULL,
  `fecha` datetime NOT NULL,
  PRIMARY KEY (`logro_id_logro`,`personaje_id_personaje`),
  KEY `fk_logro_has_personaje_personaje1_idx` (`personaje_id_personaje`),
  KEY `fk_logro_has_personaje_logro1_idx` (`logro_id_logro`),
  CONSTRAINT `fk_logro_has_personaje_logro1` FOREIGN KEY (`logro_id_logro`) REFERENCES `logro` (`id_logro`),
  CONSTRAINT `fk_logro_has_personaje_personaje1` FOREIGN KEY (`personaje_id_personaje`) REFERENCES `personaje` (`id_personaje`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logro_has_personaje`
--

LOCK TABLES `logro_has_personaje` WRITE;
/*!40000 ALTER TABLE `logro_has_personaje` DISABLE KEYS */;
INSERT INTO `logro_has_personaje` VALUES (1,1,'2025-11-20 09:00:00'),(1,2,'2025-11-21 11:00:00');
/*!40000 ALTER TABLE `logro_has_personaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mercado`
--

DROP TABLE IF EXISTS `mercado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mercado` (
  `id_mercado` int NOT NULL AUTO_INCREMENT,
  `fk_npc` int NOT NULL,
  PRIMARY KEY (`id_mercado`),
  KEY `fk_mercado_npc1_idx` (`fk_npc`),
  CONSTRAINT `fk_mercado_npc1` FOREIGN KEY (`fk_npc`) REFERENCES `npc` (`id_npc`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mercado`
--

LOCK TABLES `mercado` WRITE;
/*!40000 ALTER TABLE `mercado` DISABLE KEYS */;
INSERT INTO `mercado` VALUES (1,1);
/*!40000 ALTER TABLE `mercado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `miembro_gremio`
--

DROP TABLE IF EXISTS `miembro_gremio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `miembro_gremio` (
  `id_miembro_gremio` int NOT NULL AUTO_INCREMENT,
  `fecha_ingreso` date NOT NULL,
  `rango` varchar(255) NOT NULL,
  `fk_personaje` int NOT NULL,
  `fk_gremio` int NOT NULL,
  `fk_rango_gremio` int NOT NULL,
  PRIMARY KEY (`id_miembro_gremio`),
  KEY `fk_miembro_gremio_personaje1_idx` (`fk_personaje`),
  KEY `fk_miembro_gremio_gremio1_idx` (`fk_gremio`),
  KEY `fk_miembro_gremio_rango_gremio1_idx` (`fk_rango_gremio`),
  CONSTRAINT `fk_miembro_gremio_gremio1` FOREIGN KEY (`fk_gremio`) REFERENCES `gremio` (`id_gremio`),
  CONSTRAINT `fk_miembro_gremio_personaje1` FOREIGN KEY (`fk_personaje`) REFERENCES `personaje` (`id_personaje`),
  CONSTRAINT `fk_miembro_gremio_rango_gremio1` FOREIGN KEY (`fk_rango_gremio`) REFERENCES `rango_gremio` (`id_rango_gremio`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `miembro_gremio`
--

LOCK TABLES `miembro_gremio` WRITE;
/*!40000 ALTER TABLE `miembro_gremio` DISABLE KEYS */;
INSERT INTO `miembro_gremio` VALUES (1,'2025-10-02','Líder',1,1,3),(2,'2025-10-06','Miembro',2,1,1),(3,'2025-11-12','Oficial',3,2,2);
/*!40000 ALTER TABLE `miembro_gremio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mision`
--

DROP TABLE IF EXISTS `mision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mision` (
  `id_mision` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `tipo` varchar(255) NOT NULL,
  `nivel_recomendad` int NOT NULL,
  `fk_npc` int NOT NULL,
  PRIMARY KEY (`id_mision`),
  KEY `fk_mision_npc1_idx` (`fk_npc`),
  CONSTRAINT `fk_mision_npc1` FOREIGN KEY (`fk_npc`) REFERENCES `npc` (`id_npc`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mision`
--

LOCK TABLES `mision` WRITE;
/*!40000 ALTER TABLE `mision` DISABLE KEYS */;
INSERT INTO `mision` VALUES (1,'Recolección de Bayas','Recolección',1,1),(2,'Eliminar Goblins','Combate',10,2);
/*!40000 ALTER TABLE `mision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mision_completada`
--

DROP TABLE IF EXISTS `mision_completada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mision_completada` (
  `mision_id_mision` int NOT NULL,
  `personaje_id_personaje` int NOT NULL,
  `fecha` date NOT NULL,
  `tiempo_empleado` time NOT NULL,
  PRIMARY KEY (`mision_id_mision`,`personaje_id_personaje`),
  KEY `fk_mision_has_personaje_personaje1_idx` (`personaje_id_personaje`),
  KEY `fk_mision_has_personaje_mision1_idx` (`mision_id_mision`),
  CONSTRAINT `fk_mision_has_personaje_mision1` FOREIGN KEY (`mision_id_mision`) REFERENCES `mision` (`id_mision`),
  CONSTRAINT `fk_mision_has_personaje_personaje1` FOREIGN KEY (`personaje_id_personaje`) REFERENCES `personaje` (`id_personaje`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mision_completada`
--

LOCK TABLES `mision_completada` WRITE;
/*!40000 ALTER TABLE `mision_completada` DISABLE KEYS */;
INSERT INTO `mision_completada` VALUES (1,1,'2025-11-24','00:15:00'),(1,2,'2025-11-25','00:10:00');
/*!40000 ALTER TABLE `mision_completada` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `npc`
--

DROP TABLE IF EXISTS `npc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `npc` (
  `id_npc` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `texto` text NOT NULL,
  `fk_region` int NOT NULL,
  PRIMARY KEY (`id_npc`),
  KEY `fk_npc_region1_idx` (`fk_region`),
  CONSTRAINT `fk_npc_region1` FOREIGN KEY (`fk_region`) REFERENCES `region` (`id_region`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `npc`
--

LOCK TABLES `npc` WRITE;
/*!40000 ALTER TABLE `npc` DISABLE KEYS */;
INSERT INTO `npc` VALUES (1,'Mercader Tom','Bienvenido, ¿qué deseas comprar?',1),(2,'Líder de la Guardia','Necesito ayuda en el Bosque Oscuro.',2);
/*!40000 ALTER TABLE `npc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objeto`
--

DROP TABLE IF EXISTS `objeto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objeto` (
  `id_objeto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `nivel_requerido` int NOT NULL,
  `precio` float NOT NULL,
  `efecto` text,
  `fk_idtipo` int NOT NULL,
  `fk_idrareza` int NOT NULL,
  `fk_idfuente` int NOT NULL,
  `fk_idmercado` int DEFAULT NULL,
  PRIMARY KEY (`id_objeto`),
  KEY `fk_objeto_tipo1_idx` (`fk_idtipo`),
  KEY `fk_objeto_rareza1_idx` (`fk_idrareza`),
  KEY `fk_objeto_fuente1_idx` (`fk_idfuente`),
  KEY `fk_objeto_mercado1_idx` (`fk_idmercado`),
  CONSTRAINT `fk_objeto_fuente1` FOREIGN KEY (`fk_idfuente`) REFERENCES `fuente` (`id_fuente`),
  CONSTRAINT `fk_objeto_mercado1` FOREIGN KEY (`fk_idmercado`) REFERENCES `mercado` (`id_mercado`),
  CONSTRAINT `fk_objeto_rareza1` FOREIGN KEY (`fk_idrareza`) REFERENCES `rareza` (`id_rareza`),
  CONSTRAINT `fk_objeto_tipo1` FOREIGN KEY (`fk_idtipo`) REFERENCES `tipo` (`id_tipo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objeto`
--

LOCK TABLES `objeto` WRITE;
/*!40000 ALTER TABLE `objeto` DISABLE KEYS */;
INSERT INTO `objeto` VALUES (1,'Espada de Hierro',1,10.5,'Ataque +5',1,1,2,1),(2,'Poción de Vida',1,5,'Restaura 100 Vida',3,1,2,1),(3,'Armadura Épica',20,500,'Defensa +50',2,3,3,NULL),(4,'Fragmento Mágico',5,2,'Material de crafteo',4,2,1,1);
/*!40000 ALTER TABLE `objeto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objeto_obtenido`
--

DROP TABLE IF EXISTS `objeto_obtenido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `objeto_obtenido` (
  `fk_objeto` int NOT NULL,
  `fk_personaje` int NOT NULL,
  `fecha` datetime NOT NULL,
  KEY `fk_objeto_has_personaje_personaje1_idx` (`fk_personaje`),
  KEY `fk_objeto_has_personaje_objeto1_idx` (`fk_objeto`),
  CONSTRAINT `fk_objeto_has_personaje_objeto1` FOREIGN KEY (`fk_objeto`) REFERENCES `objeto` (`id_objeto`),
  CONSTRAINT `fk_objeto_has_personaje_personaje1` FOREIGN KEY (`fk_personaje`) REFERENCES `personaje` (`id_personaje`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objeto_obtenido`
--

LOCK TABLES `objeto_obtenido` WRITE;
/*!40000 ALTER TABLE `objeto_obtenido` DISABLE KEYS */;
INSERT INTO `objeto_obtenido` VALUES (3,1,'2025-11-24 10:00:00'),(4,1,'2025-11-30 13:59:25'),(4,2,'2025-11-25 15:30:00'),(4,2,'2025-11-30 14:06:11');
/*!40000 ALTER TABLE `objeto_obtenido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pais`
--

DROP TABLE IF EXISTS `pais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pais` (
  `id_pais` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  PRIMARY KEY (`id_pais`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pais`
--

LOCK TABLES `pais` WRITE;
/*!40000 ALTER TABLE `pais` DISABLE KEYS */;
INSERT INTO `pais` VALUES (1,'España'),(2,'México'),(3,'Argentina'),(4,'Colombia');
/*!40000 ALTER TABLE `pais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participacion_evento`
--

DROP TABLE IF EXISTS `participacion_evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `participacion_evento` (
  `fk_evento` int NOT NULL,
  `fk_personaje` int NOT NULL,
  `puntos` double DEFAULT NULL,
  PRIMARY KEY (`fk_evento`,`fk_personaje`),
  KEY `fk_evento_has_personaje_personaje1_idx` (`fk_personaje`),
  KEY `fk_evento_has_personaje_evento1_idx` (`fk_evento`),
  CONSTRAINT `fk_evento_has_personaje_evento1` FOREIGN KEY (`fk_evento`) REFERENCES `evento` (`id_evento`),
  CONSTRAINT `fk_evento_has_personaje_personaje1` FOREIGN KEY (`fk_personaje`) REFERENCES `personaje` (`id_personaje`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participacion_evento`
--

LOCK TABLES `participacion_evento` WRITE;
/*!40000 ALTER TABLE `participacion_evento` DISABLE KEYS */;
INSERT INTO `participacion_evento` VALUES (1,1,150),(1,2,200.5),(2,1,50);
/*!40000 ALTER TABLE `participacion_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personaje`
--

DROP TABLE IF EXISTS `personaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personaje` (
  `id_personaje` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `nivel` int NOT NULL DEFAULT '1',
  `vida` double NOT NULL DEFAULT '500',
  `mana` double NOT NULL DEFAULT '100',
  `fk_jugador` int NOT NULL,
  `fk_clase` int NOT NULL,
  `fk_base_stats` int NOT NULL,
  PRIMARY KEY (`id_personaje`),
  KEY `fk_personaje_jugador1_idx` (`fk_jugador`),
  KEY `fk_personaje_clase1_idx` (`fk_clase`),
  KEY `fk_personaje_base_stats1_idx` (`fk_base_stats`),
  CONSTRAINT `fk_personaje_base_stats1` FOREIGN KEY (`fk_base_stats`) REFERENCES `base_stats` (`id_base_stats`),
  CONSTRAINT `fk_personaje_clase1` FOREIGN KEY (`fk_clase`) REFERENCES `clase` (`id_clase`),
  CONSTRAINT `fk_personaje_jugador1` FOREIGN KEY (`fk_jugador`) REFERENCES `jugador` (`id_jugador`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personaje`
--

LOCK TABLES `personaje` WRITE;
/*!40000 ALTER TABLE `personaje` DISABLE KEYS */;
INSERT INTO `personaje` VALUES (1,'Aric el Guerrero',10,800,50,1,1,1),(2,'Magus Bob',12,450,250,2,2,3),(3,'Charly Ágil',5,600,100,3,3,4);
/*!40000 ALTER TABLE `personaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rango_enemigos`
--

DROP TABLE IF EXISTS `rango_enemigos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rango_enemigos` (
  `id_rango_enemigos` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `tamaño` float NOT NULL,
  `buff` float NOT NULL,
  PRIMARY KEY (`id_rango_enemigos`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rango_enemigos`
--

LOCK TABLES `rango_enemigos` WRITE;
/*!40000 ALTER TABLE `rango_enemigos` DISABLE KEYS */;
INSERT INTO `rango_enemigos` VALUES (1,'Normal',1,1),(2,'Elite',1.5,1.5),(3,'Jefe',3,2.5);
/*!40000 ALTER TABLE `rango_enemigos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rango_gremio`
--

DROP TABLE IF EXISTS `rango_gremio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rango_gremio` (
  `id_rango_gremio` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_rango_gremio`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rango_gremio`
--

LOCK TABLES `rango_gremio` WRITE;
/*!40000 ALTER TABLE `rango_gremio` DISABLE KEYS */;
INSERT INTO `rango_gremio` VALUES (1,'Miembro'),(2,'Oficial'),(3,'Líder');
/*!40000 ALTER TABLE `rango_gremio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rareza`
--

DROP TABLE IF EXISTS `rareza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rareza` (
  `id_rareza` int NOT NULL AUTO_INCREMENT,
  `nombre_rareza` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_rareza`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rareza`
--

LOCK TABLES `rareza` WRITE;
/*!40000 ALTER TABLE `rareza` DISABLE KEYS */;
INSERT INTO `rareza` VALUES (1,'Común'),(2,'Raro'),(3,'Épico'),(4,'Legendario');
/*!40000 ALTER TABLE `rareza` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `region`
--

DROP TABLE IF EXISTS `region`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `region` (
  `id_region` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `nivel_minimo` int NOT NULL,
  PRIMARY KEY (`id_region`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `region`
--

LOCK TABLES `region` WRITE;
/*!40000 ALTER TABLE `region` DISABLE KEYS */;
INSERT INTO `region` VALUES (1,'Praderas de Inicio',1),(2,'Bosque Oscuro',10),(3,'Montañas de Fuego',30);
/*!40000 ALTER TABLE `region` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo`
--

DROP TABLE IF EXISTS `tipo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo` (
  `id_tipo` int NOT NULL AUTO_INCREMENT,
  `tipo_nombre` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_tipo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo`
--

LOCK TABLES `tipo` WRITE;
/*!40000 ALTER TABLE `tipo` DISABLE KEYS */;
INSERT INTO `tipo` VALUES (1,'Arma'),(2,'Armadura'),(3,'Poción'),(4,'Material');
/*!40000 ALTER TABLE `tipo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_habilidad`
--

DROP TABLE IF EXISTS `tipo_habilidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_habilidad` (
  `id_tipo_habilidad` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `poder` int DEFAULT NULL,
  `rango` int DEFAULT NULL,
  PRIMARY KEY (`id_tipo_habilidad`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_habilidad`
--

LOCK TABLES `tipo_habilidad` WRITE;
/*!40000 ALTER TABLE `tipo_habilidad` DISABLE KEYS */;
INSERT INTO `tipo_habilidad` VALUES (1,'Cuerpo a Cuerpo',10,1),(2,'Hechizo de Fuego',15,5),(3,'Hechizo de Curación',0,4),(4,'Ataque Rápido',8,2);
/*!40000 ALTER TABLE `tipo_habilidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaccion`
--

DROP TABLE IF EXISTS `transaccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaccion` (
  `mercado_idmercado` int NOT NULL,
  `personaje_id_personaje` int NOT NULL,
  `precio` float NOT NULL,
  `fecha` datetime NOT NULL,
  `fk_idobjeto` int NOT NULL,
  PRIMARY KEY (`mercado_idmercado`,`personaje_id_personaje`),
  KEY `fk_mercado_has_personaje_personaje1_idx` (`personaje_id_personaje`),
  KEY `fk_mercado_has_personaje_mercado1_idx` (`mercado_idmercado`),
  KEY `fk_transaccion_objeto1_idx` (`fk_idobjeto`),
  CONSTRAINT `fk_mercado_has_personaje_mercado1` FOREIGN KEY (`mercado_idmercado`) REFERENCES `mercado` (`id_mercado`),
  CONSTRAINT `fk_mercado_has_personaje_personaje1` FOREIGN KEY (`personaje_id_personaje`) REFERENCES `personaje` (`id_personaje`),
  CONSTRAINT `fk_transaccion_objeto1` FOREIGN KEY (`fk_idobjeto`) REFERENCES `objeto` (`id_objeto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaccion`
--

LOCK TABLES `transaccion` WRITE;
/*!40000 ALTER TABLE `transaccion` DISABLE KEYS */;
INSERT INTO `transaccion` VALUES (1,1,10.5,'2025-11-25 18:00:00',1),(1,3,5,'2025-11-25 18:05:00',2);
/*!40000 ALTER TABLE `transaccion` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-30 14:08:19
