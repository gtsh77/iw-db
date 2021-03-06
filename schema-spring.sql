-- MySQL Script generated by MySQL Workbench
-- 03/10/17 23:03:57
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema iwstats
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `iwstats` ;

-- -----------------------------------------------------
-- Schema iwstats
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `iwstats` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `iwstats` ;

-- -----------------------------------------------------
-- Table `iwstats`.`players`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`players` (
  `id` MEDIUMINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `steamId` VARCHAR(25) NOT NULL,
  `hash` CHAR(6) NULL,
  `state` TINYINT(2) UNSIGNED NULL DEFAULT 0,
  `createdAt` TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `steamId_UNIQUE` (`steamId` ASC),
  UNIQUE INDEX `hash_UNIQUE` (`hash` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`maps`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`maps` (
  `id` TINYINT(2) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`servers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`servers` (
  `id` TINYINT(1) UNSIGNED NOT NULL AUTO_INCREMENT,
  `address_ip` VARCHAR(15) NOT NULL,
  `address_port` CHAR(5) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`rounds`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`rounds` (
  `id` MEDIUMINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `hash` CHAR(6) NOT NULL,
  `createdAt` TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `endedAt` TIMESTAMP(3) NULL,
  `mapId` TINYINT(2) UNSIGNED NOT NULL,
  `serverId` TINYINT(1) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `hash_UNIQUE` (`hash` ASC),
  INDEX `fk_rounds_maps1_idx` (`mapId` ASC),
  INDEX `fk_rounds_servers1_idx` (`serverId` ASC),
  CONSTRAINT `fk_rounds_maps1`
    FOREIGN KEY (`mapId`)
    REFERENCES `iwstats`.`maps` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rounds_servers1`
    FOREIGN KEY (`serverId`)
    REFERENCES `iwstats`.`servers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`messages` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(128) NOT NULL,
  `createdAt` TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `playerId` MEDIUMINT(8) UNSIGNED NOT NULL,
  `roundId` MEDIUMINT(8) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_chatList_players1_idx` (`playerId` ASC),
  INDEX `fk_messages_rounds1_idx` (`roundId` ASC),
  CONSTRAINT `fk_chatList_players1`
    FOREIGN KEY (`playerId`)
    REFERENCES `iwstats`.`players` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_messages_rounds1`
    FOREIGN KEY (`roundId`)
    REFERENCES `iwstats`.`rounds` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`sessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`sessions` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `hash` CHAR(8) NULL,
  `createdAt` TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `endedAt` TIMESTAMP(3) NULL,
  `playerId` MEDIUMINT(8) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `hash_UNIQUE` (`hash` ASC),
  INDEX `fk_sessions_players1_idx` (`playerId` ASC),
  CONSTRAINT `fk_sessions_players1`
    FOREIGN KEY (`playerId`)
    REFERENCES `iwstats`.`players` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`nicknames`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`nicknames` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(32) NOT NULL,
  `playerId` MEDIUMINT(8) UNSIGNED NOT NULL,
  `roundId` MEDIUMINT(8) UNSIGNED NOT NULL,
  `sessionId` INT(10) UNSIGNED NOT NULL,
  `createdAt` TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_nickNameList_players1_idx` (`playerId` ASC),
  INDEX `fk_nicknames_rounds1_idx` (`roundId` ASC),
  INDEX `fk_nicknames_sessions1_idx` (`sessionId` ASC),
  CONSTRAINT `fk_nickNameList_players1`
    FOREIGN KEY (`playerId`)
    REFERENCES `iwstats`.`players` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_nicknames_rounds1`
    FOREIGN KEY (`roundId`)
    REFERENCES `iwstats`.`rounds` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_nicknames_sessions1`
    FOREIGN KEY (`sessionId`)
    REFERENCES `iwstats`.`sessions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`weapons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`weapons` (
  `id` TINYINT(2) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`interactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`interactions` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `hash` CHAR(10) NOT NULL,
  `weaponId` TINYINT(2) UNSIGNED NOT NULL,
  `srcId` MEDIUMINT(8) UNSIGNED NOT NULL,
  `srcSessionId` INT(10) UNSIGNED NOT NULL,
  `destId` MEDIUMINT(8) UNSIGNED NOT NULL,
  `destSessionId` INT(10) UNSIGNED NOT NULL,
  `roundId` MEDIUMINT(8) UNSIGNED NOT NULL,
  `damage` TINYINT(3) UNSIGNED ZEROFILL NOT NULL,
  `rHealth` TINYINT(3) UNSIGNED NOT NULL,
  `hitgroup` VARCHAR(10) NOT NULL,
  `createdAt` TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_interactions_players1_idx` (`srcId` ASC),
  INDEX `fk_interactions_players2_idx` (`destId` ASC),
  UNIQUE INDEX `hash_UNIQUE` (`hash` ASC),
  INDEX `fk_interactions_rounds1_idx` (`roundId` ASC),
  INDEX `fk_interactions_sessions1_idx` (`srcSessionId` ASC),
  INDEX `fk_interactions_sessions2_idx` (`destSessionId` ASC),
  INDEX `fk_interactions_weapons1_idx` (`weaponId` ASC),
  CONSTRAINT `fk_interactions_players1`
    FOREIGN KEY (`srcId`)
    REFERENCES `iwstats`.`players` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_interactions_players2`
    FOREIGN KEY (`destId`)
    REFERENCES `iwstats`.`players` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_interactions_rounds1`
    FOREIGN KEY (`roundId`)
    REFERENCES `iwstats`.`rounds` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_interactions_sessions1`
    FOREIGN KEY (`srcSessionId`)
    REFERENCES `iwstats`.`sessions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_interactions_sessions2`
    FOREIGN KEY (`destSessionId`)
    REFERENCES `iwstats`.`sessions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_interactions_weapons1`
    FOREIGN KEY (`weaponId`)
    REFERENCES `iwstats`.`weapons` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`profiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`profiles` (
  `playerId` MEDIUMINT(8) UNSIGNED NOT NULL,
  `nickName` VARCHAR(32) NOT NULL DEFAULT 'unnamed',
  `points` MEDIUMINT(8) NOT NULL DEFAULT 0,
  `wins` MEDIUMINT(8) NOT NULL DEFAULT 0,
  `assists` MEDIUMINT(8) NOT NULL DEFAULT 0,
  `losses` MEDIUMINT(8) NOT NULL DEFAULT 0,
  `ratio` FLOAT(7,4) NOT NULL DEFAULT 0,
  INDEX `ixWins` (`assists` DESC),
  INDEX `ixLosses` (`points` DESC),
  INDEX `ixRatio` (`ratio` DESC),
  PRIMARY KEY (`playerId`),
  INDEX `ixPoints` (`points` DESC),
  INDEX `ixAssists` (`assists` DESC),
  CONSTRAINT `fk_profiles_players1`
    FOREIGN KEY (`playerId`)
    REFERENCES `iwstats`.`players` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`roundprofiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`roundprofiles` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `roundId` MEDIUMINT(8) UNSIGNED NOT NULL,
  `playerId` MEDIUMINT(8) UNSIGNED NOT NULL,
  `wins` SMALLINT(3) NOT NULL DEFAULT 0,
  `assists` SMALLINT(3) NOT NULL DEFAULT 0,
  `losses` SMALLINT(3) NOT NULL DEFAULT 0,
  `points` SMALLINT(3) NOT NULL DEFAULT 0,
  `ratio` FLOAT(7,4) NOT NULL DEFAULT 0,
  INDEX `fk_roundstats_players1_idx` (`playerId` ASC),
  PRIMARY KEY (`id`),
  INDEX `fk_roundstats_rounds1_idx` (`roundId` ASC),
  UNIQUE INDEX `ixRoundPlayer` (`roundId` ASC, `playerId` ASC),
  INDEX `ixWins` (`wins` DESC),
  INDEX `ixAssists` (`assists` DESC),
  INDEX `ixLosses` (`losses` DESC),
  INDEX `ixPoints` (`points` DESC),
  INDEX `ixRatio` (`ratio` DESC),
  CONSTRAINT `fk_roundstats_players1`
    FOREIGN KEY (`playerId`)
    REFERENCES `iwstats`.`players` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_roundstats_rounds1`
    FOREIGN KEY (`roundId`)
    REFERENCES `iwstats`.`rounds` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `iwstats`.`sessionprofiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `iwstats`.`sessionprofiles` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `playerId` MEDIUMINT(8) UNSIGNED NOT NULL,
  `sessionId` INT(10) UNSIGNED NOT NULL,
  `wins` SMALLINT(3) NOT NULL DEFAULT 0,
  `assists` SMALLINT(3) NOT NULL DEFAULT 0,
  `losses` SMALLINT(3) NOT NULL DEFAULT 0,
  `points` SMALLINT(3) NOT NULL DEFAULT 0,
  `ratio` FLOAT(7,4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_sessionprofiles_sessions1_idx` (`sessionId` ASC),
  INDEX `fk_sessionprofiles_players1_idx` (`playerId` ASC),
  UNIQUE INDEX `ixPlayerSession` (`sessionId` ASC, `playerId` ASC),
  INDEX `ixWins` (`wins` DESC),
  INDEX `ixLosses` (`losses` DESC),
  INDEX `ixAssists` (`assists` DESC),
  INDEX `ixPoints` (`points` DESC),
  INDEX `ixRatio` (`ratio` DESC),
  CONSTRAINT `fk_sessionprofiles_sessions1`
    FOREIGN KEY (`sessionId`)
    REFERENCES `iwstats`.`sessions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sessionprofiles_players1`
    FOREIGN KEY (`playerId`)
    REFERENCES `iwstats`.`players` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `iwstats`.`maps`
-- -----------------------------------------------------
START TRANSACTION;
USE `iwstats`;
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_vertigo');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_train');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_sugarcane');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_stmarc');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_shorttrain');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_shortdust');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_safehouse');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_overpass');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_nuke');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_mirage');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_lake');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_inferno');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_dust2');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_dust');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_cbble');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_cache');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_bank');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_bank');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'cs_office');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'cs_militia');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'cs_italy');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'cs_assault');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'de_aztec');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'workshop/208579464/de_castle');
INSERT INTO `iwstats`.`maps` (`id`, `name`) VALUES (DEFAULT, 'workshop/779296053/de_blackgold');

COMMIT;


-- -----------------------------------------------------
-- Data for table `iwstats`.`servers`
-- -----------------------------------------------------
START TRANSACTION;
USE `iwstats`;
INSERT INTO `iwstats`.`servers` (`id`, `address_ip`, `address_port`) VALUES (DEFAULT, '192.168.0.19', '27015');

COMMIT;


-- -----------------------------------------------------
-- Data for table `iwstats`.`rounds`
-- -----------------------------------------------------
START TRANSACTION;
USE `iwstats`;
INSERT INTO `iwstats`.`rounds` (`id`, `hash`, `createdAt`, `endedAt`, `mapId`, `serverId`) VALUES (DEFAULT, 'start', DEFAULT, NULL, 1, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `iwstats`.`weapons`
-- -----------------------------------------------------
START TRANSACTION;
USE `iwstats`;
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'p228');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'glock');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'scout');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'xm1014');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'mac10');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'aug');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'elite');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'fiveseven');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'ump45');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'sg550');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'galil');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'galilar');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'famas');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'usp_silencer');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'awp');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'mp5navy');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'm249');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'nova');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'm4a1');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'm4a1_silencer');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'tmp');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'g3sg1');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'deagle');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'sg552');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'ak47');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'p90');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'bizon');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'mag7');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'negev');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'sawedoff');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'tec9');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'taser');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'hkp2000');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'mp7');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'mp9');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'nova');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'p250');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'scar17');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'scar20');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'sg556');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'ssg08');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'flashbang');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'smokegrenade');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'hegrenade');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'molotov');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'decoy');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'primammo');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'secammo');
INSERT INTO `iwstats`.`weapons` (`id`, `name`) VALUES (DEFAULT, 'knife');

COMMIT;

