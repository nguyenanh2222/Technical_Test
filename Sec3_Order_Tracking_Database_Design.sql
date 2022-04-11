-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 11, 2022 at 12:03 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `order_tracking_database`
--

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_first_name` varchar(20) NOT NULL,
  `customer_last_name` varchar(20) NOT NULL,
  `customer_email` varchar(200) NOT NULL,
  `customer_address` varchar(200) NOT NULL,
  `customer_phone` int(11) NOT NULL,
  `customer_code` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `orders_id`
--

CREATE TABLE `orders_id` (
  `order_id` int(11) NOT NULL,
  `date_added` date NOT NULL,
  `product_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `storehouse` varchar(500) NOT NULL,
  `tracking_no` int(11) NOT NULL,
  `payment` varchar(50) DEFAULT NULL,
  `customer_name` varchar(20) DEFAULT NULL,
  `customer_code` varchar(20) DEFAULT NULL,
  `product_name` varchar(20) DEFAULT NULL,
  `product_code` varchar(20) DEFAULT NULL,
  `quality` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(500) NOT NULL,
  `price` int(11) NOT NULL,
  `product_code` int(11) DEFAULT NULL,
  `decription` varchar(400) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `storehouse`
--

CREATE TABLE `storehouse` (
  `storehouse_id` int(11) NOT NULL,
  `storehouse_name` varchar(500) NOT NULL,
  `storehouse_adress` varchar(500) NOT NULL,
  `storehouse_code` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `tracking_details`
--

CREATE TABLE `tracking_details` (
  `tracking_id` int(11) NOT NULL,
  `tracking_no` int(11) NOT NULL,
  `storehouse_id` int(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `orders_id`
--
ALTER TABLE `orders_id`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `tracking_no` (`tracking_no`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `storehouse`
--
ALTER TABLE `storehouse`
  ADD PRIMARY KEY (`storehouse_id`);

--
-- Indexes for table `tracking_details`
--
ALTER TABLE `tracking_details`
  ADD PRIMARY KEY (`tracking_id`),
  ADD UNIQUE KEY `tracking_no` (`tracking_no`),
  ADD UNIQUE KEY `tracking_no_2` (`tracking_no`),
  ADD UNIQUE KEY `tracking_no_3` (`tracking_no`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders_id`
--
ALTER TABLE `orders_id`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `storehouse`
--
ALTER TABLE `storehouse`
  MODIFY `storehouse_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tracking_details`
--
ALTER TABLE `tracking_details`
  MODIFY `tracking_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `tracking_no` FOREIGN KEY (`tracking_no`) REFERENCES `tracking_details` (`tracking_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
