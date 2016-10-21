-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb2+deb7u2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 21, 2016 at 08:17 PM
-- Server version: 5.5.46
-- PHP Version: 5.4.45-0+deb7u2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `esp`
--

-- --------------------------------------------------------

--
-- Table structure for table `data`
--

CREATE TABLE IF NOT EXISTS `data` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `folder` varchar(50) COLLATE utf8_bin NOT NULL,
  `filename` varchar(50) COLLATE utf8_bin NOT NULL,
  `esp_id` int(10) NOT NULL,
  `boot` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=2 ;

--
-- Dumping data for table `data`
--

INSERT INTO `data` (`id`, `folder`, `filename`, `esp_id`, `boot`) VALUES
(1, '8775412', 'script2.lua', 18, 1);

-- --------------------------------------------------------

--
-- Table structure for table `esp`
--

CREATE TABLE IF NOT EXISTS `esp` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8_bin NOT NULL,
  `chip_id` varchar(20) COLLATE utf8_bin NOT NULL,
  `description` varchar(500) COLLATE utf8_bin NOT NULL,
  `update` int(11) NOT NULL DEFAULT '0',
  `heartbeat` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=19 ;

--
-- Dumping data for table `esp`
--

INSERT INTO `esp` (`id`, `name`, `chip_id`, `description`, `update`, `heartbeat`) VALUES
(18, 'testing node', '8775412', 'very first testing node', 0, '2016-10-21 18:07:43');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
