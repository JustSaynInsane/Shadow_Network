-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 04, 2026 at 08:15 PM
-- Server version: 11.4.5-MariaDB-ubu2404
-- PHP Version: 8.1.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `s1839518_Qbox1768252889`
--
CREATE DATABASE IF NOT EXISTS `s1839518_Qbox1768252889` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `s1839518_Qbox1768252889`;

-- --------------------------------------------------------

--
-- Table structure for table `active_heists`
--

DROP TABLE IF EXISTS `active_heists`;
CREATE TABLE `active_heists` (
  `id` int(11) NOT NULL,
  `crew_id` int(11) NOT NULL,
  `heist_type` varchar(50) NOT NULL,
  `status` enum('pending','active','completed','failed','cancelled') NOT NULL DEFAULT 'pending',
  `activated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL,
  `started_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `criminal_crews`
--

DROP TABLE IF EXISTS `criminal_crews`;
CREATE TABLE `criminal_crews` (
  `id` int(11) NOT NULL,
  `crew_name` varchar(50) NOT NULL,
  `leader_identifier` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_heist` timestamp NULL DEFAULT NULL,
  `total_heists` int(11) DEFAULT 0,
  `total_earnings` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `criminal_crews`
--

INSERT INTO `criminal_crews` (`id`, `crew_name`, `leader_identifier`, `created_at`, `last_heist`, `total_heists`, `total_earnings`) VALUES
(3, 'shadow', 'ZG3F305J', '2026-01-25 18:32:03', NULL, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `criminal_crew_invitations`
--

DROP TABLE IF EXISTS `criminal_crew_invitations`;
CREATE TABLE `criminal_crew_invitations` (
  `id` int(11) NOT NULL,
  `crew_id` int(11) NOT NULL,
  `inviter_identifier` varchar(50) NOT NULL,
  `invitee_identifier` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `criminal_crew_members`
--

DROP TABLE IF EXISTS `criminal_crew_members`;
CREATE TABLE `criminal_crew_members` (
  `id` int(11) NOT NULL,
  `crew_id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `rank` enum('leader','member') DEFAULT 'member',
  `joined_at` timestamp NULL DEFAULT current_timestamp(),
  `heists_participated` int(11) DEFAULT 0,
  `role` varchar(50) NOT NULL DEFAULT 'member'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `criminal_crew_members`
--

INSERT INTO `criminal_crew_members` (`id`, `crew_id`, `identifier`, `rank`, `joined_at`, `heists_participated`, `role`) VALUES
(3, 3, 'ZG3F305J', 'leader', '2026-01-25 18:32:03', 0, 'member');

-- --------------------------------------------------------

--
-- Table structure for table `criminal_heist_activations`
--

DROP TABLE IF EXISTS `criminal_heist_activations`;
CREATE TABLE `criminal_heist_activations` (
  `id` int(11) NOT NULL,
  `crew_id` int(11) NOT NULL,
  `heist_type` varchar(50) NOT NULL,
  `activated_by` varchar(50) NOT NULL,
  `activated_at` timestamp NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NULL DEFAULT NULL,
  `started` tinyint(1) DEFAULT 0,
  `completed` tinyint(1) DEFAULT 0,
  `successful` tinyint(1) DEFAULT 0,
  `cancelled` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `criminal_progression`
--

DROP TABLE IF EXISTS `criminal_progression`;
CREATE TABLE `criminal_progression` (
  `identifier` varchar(50) NOT NULL,
  `narcotics_xp` int(11) NOT NULL DEFAULT 0,
  `narcotics_level` int(11) NOT NULL DEFAULT 0,
  `narcotics_skill_points` int(11) NOT NULL DEFAULT 0,
  `organized_xp` int(11) NOT NULL DEFAULT 0,
  `organized_level` int(11) NOT NULL DEFAULT 0,
  `organized_skill_points` int(11) NOT NULL DEFAULT 0,
  `auto_theft_xp` int(11) NOT NULL DEFAULT 0,
  `auto_theft_level` int(11) NOT NULL DEFAULT 0,
  `auto_theft_skill_points` int(11) NOT NULL DEFAULT 0,
  `reached_level_10_narcotics` tinyint(1) NOT NULL DEFAULT 0,
  `reached_level_10_organized` tinyint(1) NOT NULL DEFAULT 0,
  `reached_level_10_auto_theft` tinyint(1) NOT NULL DEFAULT 0,
  `shadow_network_unlocked` tinyint(1) NOT NULL DEFAULT 0,
  `heist_completions_fleeca_bank` int(11) NOT NULL DEFAULT 0,
  `heist_completions_jewelry_store` int(11) NOT NULL DEFAULT 0,
  `heist_completions_pacific_standard` int(11) NOT NULL DEFAULT 0,
  `heist_completions_humane_labs` int(11) NOT NULL DEFAULT 0,
  `heist_completions_casino` int(11) NOT NULL DEFAULT 0,
  `shadow_unlocked_pacific_standard` tinyint(1) NOT NULL DEFAULT 0,
  `shadow_unlocked_humane_labs` tinyint(1) NOT NULL DEFAULT 0,
  `shadow_unlocked_casino` tinyint(1) NOT NULL DEFAULT 0,
  `total_drug_sales` int(11) NOT NULL DEFAULT 0,
  `total_heists_completed` int(11) NOT NULL DEFAULT 0,
  `total_cars_boosted` int(11) NOT NULL DEFAULT 0,
  `total_houses_robbed` int(11) NOT NULL DEFAULT 0,
  `total_money_laundered` bigint(20) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_activity` timestamp NOT NULL DEFAULT current_timestamp(),
  `fleeca_bank_successful` int(11) DEFAULT 0,
  `jewelry_store_successful` int(11) DEFAULT 0,
  `pacific_standard_successful` int(11) DEFAULT 0,
  `shadow_met_jewelry` tinyint(1) DEFAULT 0,
  `shadow_met_pacific` tinyint(1) DEFAULT 0,
  `total_earnings` decimal(15,2) DEFAULT 0.00,
  `total_drugs_sold` int(11) DEFAULT 0,
  `total_vehicles_boosted` int(11) DEFAULT 0,
  `total_combat_encounters` int(11) DEFAULT 0,
  `total_businesses_owned` int(11) DEFAULT 0,
  `legendary_status` tinyint(1) DEFAULT 0,
  `legendary_achieved_at` int(11) DEFAULT NULL,
  `bank_truck_successful` int(11) DEFAULT 0,
  `fleeca_unlocked` tinyint(1) DEFAULT 0,
  `paleto_unlocked` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `criminal_progression`
--

INSERT INTO `criminal_progression` (`identifier`, `narcotics_xp`, `narcotics_level`, `narcotics_skill_points`, `organized_xp`, `organized_level`, `organized_skill_points`, `auto_theft_xp`, `auto_theft_level`, `auto_theft_skill_points`, `reached_level_10_narcotics`, `reached_level_10_organized`, `reached_level_10_auto_theft`, `shadow_network_unlocked`, `heist_completions_fleeca_bank`, `heist_completions_jewelry_store`, `heist_completions_pacific_standard`, `heist_completions_humane_labs`, `heist_completions_casino`, `shadow_unlocked_pacific_standard`, `shadow_unlocked_humane_labs`, `shadow_unlocked_casino`, `total_drug_sales`, `total_heists_completed`, `total_cars_boosted`, `total_houses_robbed`, `total_money_laundered`, `created_at`, `updated_at`, `last_activity`, `fleeca_bank_successful`, `jewelry_store_successful`, `pacific_standard_successful`, `shadow_met_jewelry`, `shadow_met_pacific`, `total_earnings`, `total_drugs_sold`, `total_vehicles_boosted`, `total_combat_encounters`, `total_businesses_owned`, `legendary_status`, `legendary_achieved_at`, `bank_truck_successful`, `fleeca_unlocked`, `paleto_unlocked`) VALUES
('DQ17UMUF', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2026-01-24 19:46:55', '2026-01-26 18:37:07', '2026-01-25 19:45:12', 0, 0, 0, 0, 0, 0.00, 0, 0, 0, 0, 0, NULL, 0, 0, 0),
('K1V1060Q', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2026-01-21 20:21:03', '2026-01-31 21:50:20', '2026-01-31 21:50:20', 0, 0, 0, 0, 0, 0.00, 0, 0, 0, 0, 0, NULL, 0, 0, 0),
('P59ID521', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2026-01-24 15:15:51', '2026-01-26 03:12:09', '2026-01-26 03:12:09', 0, 0, 0, 0, 0, 0.00, 0, 0, 0, 0, 0, NULL, 0, 0, 0),
('Q1TAQ2J7', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2026-01-23 20:46:28', '2026-01-23 22:03:10', '2026-01-23 21:57:03', 0, 0, 0, 0, 0, 0.00, 0, 0, 0, 0, 0, NULL, 0, 0, 0),
('ZG3F305J', 0, 0, 0, 6500, 5, 5, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2026-01-21 18:20:07', '2026-02-03 22:04:26', '2026-02-03 22:04:26', 0, 0, 0, 0, 0, 0.00, 0, 0, 0, 0, 0, NULL, 0, 0, 0),
('ZL7V340O', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '2026-01-24 23:33:21', '2026-01-25 20:25:12', '2026-01-25 20:25:12', 0, 0, 0, 0, 0, 0.00, 0, 0, 0, 0, 0, NULL, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `dealers`
--

DROP TABLE IF EXISTS `dealers`;
CREATE TABLE `dealers` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `createdby` varchar(50) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `front_businesses`
--

DROP TABLE IF EXISTS `front_businesses`;
CREATE TABLE `front_businesses` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `business_type` enum('car_wash','laundromat','taxi_company') NOT NULL,
  `business_name` varchar(100) DEFAULT NULL,
  `location_coords` text DEFAULT NULL,
  `total_laundered` bigint(20) NOT NULL DEFAULT 0,
  `times_used` int(11) NOT NULL DEFAULT 0,
  `purchase_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `heist_cooldowns`
--

DROP TABLE IF EXISTS `heist_cooldowns`;
CREATE TABLE `heist_cooldowns` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `heist_type` varchar(50) NOT NULL,
  `cooldown_until` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `laundering_operations`
--

DROP TABLE IF EXISTS `laundering_operations`;
CREATE TABLE `laundering_operations` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `method` enum('washing_machine','front_business','offshore','bulk_drop') NOT NULL,
  `input_type` enum('black_money','markedbills') NOT NULL,
  `input_amount` int(11) NOT NULL,
  `output_amount` int(11) NOT NULL,
  `status` enum('in_progress','completed','cancelled') NOT NULL DEFAULT 'in_progress',
  `start_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `complete_time` timestamp NULL DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shadow_blackmarket_purchases`
--

DROP TABLE IF EXISTS `shadow_blackmarket_purchases`;
CREATE TABLE `shadow_blackmarket_purchases` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `item` varchar(50) NOT NULL,
  `amount` int(11) DEFAULT 1,
  `price` int(11) NOT NULL,
  `currency_type` enum('black_money','markedbills','mixed') NOT NULL,
  `black_money_used` int(11) DEFAULT 0,
  `markedbills_used` int(11) DEFAULT 0,
  `purchased_at` timestamp NULL DEFAULT current_timestamp(),
  `pickup_claimed` tinyint(1) DEFAULT 0,
  `claimed_at` timestamp NULL DEFAULT NULL,
  `pickup_expired` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shadow_business_fronts`
--

DROP TABLE IF EXISTS `shadow_business_fronts`;
CREATE TABLE `shadow_business_fronts` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  `business_type` varchar(50) NOT NULL,
  `business_name` varchar(100) NOT NULL,
  `location` varchar(100) DEFAULT NULL,
  `investment` decimal(15,2) DEFAULT 0.00,
  `revenue_generated` decimal(15,2) DEFAULT 0.00,
  `purchased_at` int(11) NOT NULL,
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shadow_crypto_market`
--

DROP TABLE IF EXISTS `shadow_crypto_market`;
CREATE TABLE `shadow_crypto_market` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `base_price` decimal(10,4) DEFAULT 1.0000,
  `current_price` decimal(10,4) NOT NULL,
  `daily_change` decimal(6,4) DEFAULT 0.0000,
  `volume` decimal(15,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shadow_crypto_market`
--

INSERT INTO `shadow_crypto_market` (`id`, `date`, `base_price`, `current_price`, `daily_change`, `volume`) VALUES
(1, '2026-02-02', 1.0000, 1.0000, 0.0000, 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `shadow_crypto_transactions`
--

DROP TABLE IF EXISTS `shadow_crypto_transactions`;
CREATE TABLE `shadow_crypto_transactions` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  `transaction_type` varchar(20) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `conversion_rate` decimal(10,4) DEFAULT NULL,
  `cash_amount` decimal(15,2) DEFAULT NULL,
  `timestamp` int(11) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shadow_crypto_wallets`
--

DROP TABLE IF EXISTS `shadow_crypto_wallets`;
CREATE TABLE `shadow_crypto_wallets` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  `wallet_address` varchar(100) NOT NULL,
  `balance` decimal(15,2) DEFAULT 0.00,
  `created_at` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shadow_network_messages`
--

DROP TABLE IF EXISTS `shadow_network_messages`;
CREATE TABLE `shadow_network_messages` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `contact_id` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `timestamp` timestamp NULL DEFAULT current_timestamp(),
  `read` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shadow_pickups`
--

DROP TABLE IF EXISTS `shadow_pickups`;
CREATE TABLE `shadow_pickups` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `item` varchar(50) NOT NULL,
  `amount` int(11) DEFAULT 1,
  `coords` text NOT NULL,
  `location_name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL,
  `claimed` tinyint(1) DEFAULT 0,
  `claimed_at` timestamp NULL DEFAULT NULL,
  `expired` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shadow_sins`
--

DROP TABLE IF EXISTS `shadow_sins`;
CREATE TABLE `shadow_sins` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  `player_name` varchar(100) NOT NULL,
  `sin_name` varchar(20) NOT NULL,
  `promoted_at` int(11) NOT NULL,
  `promoted_by` varchar(50) NOT NULL,
  `demoted_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shadow_sin_trials`
--

DROP TABLE IF EXISTS `shadow_sin_trials`;
CREATE TABLE `shadow_sin_trials` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  `completion_time` int(11) NOT NULL,
  `stats` text DEFAULT NULL,
  `approved` tinyint(1) DEFAULT 0,
  `approved_by` varchar(50) DEFAULT NULL,
  `approved_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shadow_tablet_access_logs`
--

DROP TABLE IF EXISTS `shadow_tablet_access_logs`;
CREATE TABLE `shadow_tablet_access_logs` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `success` tinyint(1) NOT NULL DEFAULT 0,
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'For RP purposes',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shadow_tablet_pins`
--

DROP TABLE IF EXISTS `shadow_tablet_pins`;
CREATE TABLE `shadow_tablet_pins` (
  `id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL COMMENT 'Player citizenid',
  `pin` varchar(255) NOT NULL COMMENT 'Hashed PIN code',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_access` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `shadow_tablet_pins`
--

INSERT INTO `shadow_tablet_pins` (`id`, `identifier`, `pin`, `created_at`, `last_access`) VALUES
(3, 'ZG3F305J', '1511963750', '2026-01-29 22:46:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `skill_purchases`
--

DROP TABLE IF EXISTS `skill_purchases`;
CREATE TABLE `skill_purchases` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) NOT NULL,
  `skill_tree` varchar(50) NOT NULL,
  `skill_name` varchar(100) NOT NULL,
  `purchased_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `weed_plants`
--

DROP TABLE IF EXISTS `weed_plants`;
CREATE TABLE `weed_plants` (
  `id` int(11) NOT NULL,
  `property` varchar(30) DEFAULT NULL,
  `stage` tinyint(4) NOT NULL DEFAULT 1,
  `sort` varchar(30) NOT NULL,
  `gender` enum('male','female') NOT NULL,
  `food` tinyint(4) NOT NULL DEFAULT 100,
  `health` tinyint(4) NOT NULL DEFAULT 100,
  `stageProgress` tinyint(4) NOT NULL DEFAULT 0,
  `coords` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `active_heists`
--
ALTER TABLE `active_heists`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_crew` (`crew_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_heist_type` (`heist_type`);

--
-- Indexes for table `criminal_crews`
--
ALTER TABLE `criminal_crews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `crew_name` (`crew_name`),
  ADD KEY `leader_identifier` (`leader_identifier`);

--
-- Indexes for table `criminal_crew_invitations`
--
ALTER TABLE `criminal_crew_invitations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `crew_id` (`crew_id`),
  ADD KEY `invitee_identifier` (`invitee_identifier`);

--
-- Indexes for table `criminal_crew_members`
--
ALTER TABLE `criminal_crew_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_member` (`crew_id`,`identifier`),
  ADD KEY `identifier` (`identifier`),
  ADD KEY `crew_id` (`crew_id`);

--
-- Indexes for table `criminal_heist_activations`
--
ALTER TABLE `criminal_heist_activations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `crew_id` (`crew_id`),
  ADD KEY `heist_type` (`heist_type`),
  ADD KEY `activated_at` (`activated_at`);

--
-- Indexes for table `criminal_progression`
--
ALTER TABLE `criminal_progression`
  ADD PRIMARY KEY (`identifier`),
  ADD KEY `idx_narcotics` (`narcotics_level`),
  ADD KEY `idx_organized` (`organized_level`),
  ADD KEY `idx_auto_theft` (`auto_theft_level`),
  ADD KEY `idx_identifier` (`identifier`),
  ADD KEY `idx_shadow_unlocked` (`shadow_network_unlocked`);

--
-- Indexes for table `dealers`
--
ALTER TABLE `dealers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `front_businesses`
--
ALTER TABLE `front_businesses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_owner` (`identifier`);

--
-- Indexes for table `heist_cooldowns`
--
ALTER TABLE `heist_cooldowns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_player_heist` (`identifier`,`heist_type`);

--
-- Indexes for table `laundering_operations`
--
ALTER TABLE `laundering_operations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_player` (`identifier`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `shadow_blackmarket_purchases`
--
ALTER TABLE `shadow_blackmarket_purchases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_identifier` (`identifier`),
  ADD KEY `idx_purchased_at` (`purchased_at`);

--
-- Indexes for table `shadow_business_fronts`
--
ALTER TABLE `shadow_business_fronts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexes for table `shadow_crypto_market`
--
ALTER TABLE `shadow_crypto_market`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `date` (`date`),
  ADD KEY `idx_date` (`date`);

--
-- Indexes for table `shadow_crypto_transactions`
--
ALTER TABLE `shadow_crypto_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `transaction_type` (`transaction_type`);

--
-- Indexes for table `shadow_crypto_wallets`
--
ALTER TABLE `shadow_crypto_wallets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `wallet_address` (`wallet_address`),
  ADD KEY `idx_citizenid` (`citizenid`),
  ADD KEY `idx_wallet` (`wallet_address`);

--
-- Indexes for table `shadow_network_messages`
--
ALTER TABLE `shadow_network_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `identifier` (`identifier`),
  ADD KEY `contact_id` (`contact_id`);

--
-- Indexes for table `shadow_pickups`
--
ALTER TABLE `shadow_pickups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_identifier` (`identifier`),
  ADD KEY `idx_expires_at` (`expires_at`),
  ADD KEY `idx_purchase_id` (`purchase_id`);

--
-- Indexes for table `shadow_sins`
--
ALTER TABLE `shadow_sins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `sin_name` (`sin_name`);

--
-- Indexes for table `shadow_sin_trials`
--
ALTER TABLE `shadow_sin_trials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexes for table `shadow_tablet_access_logs`
--
ALTER TABLE `shadow_tablet_access_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_identifier` (`identifier`),
  ADD KEY `idx_timestamp` (`timestamp`);

--
-- Indexes for table `shadow_tablet_pins`
--
ALTER TABLE `shadow_tablet_pins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `identifier` (`identifier`),
  ADD KEY `idx_identifier` (`identifier`);

--
-- Indexes for table `skill_purchases`
--
ALTER TABLE `skill_purchases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `skill_tree` (`skill_tree`);

--
-- Indexes for table `weed_plants`
--
ALTER TABLE `weed_plants`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `active_heists`
--
ALTER TABLE `active_heists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `criminal_crews`
--
ALTER TABLE `criminal_crews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `criminal_crew_invitations`
--
ALTER TABLE `criminal_crew_invitations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `criminal_crew_members`
--
ALTER TABLE `criminal_crew_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `criminal_heist_activations`
--
ALTER TABLE `criminal_heist_activations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dealers`
--
ALTER TABLE `dealers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `front_businesses`
--
ALTER TABLE `front_businesses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `heist_cooldowns`
--
ALTER TABLE `heist_cooldowns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `laundering_operations`
--
ALTER TABLE `laundering_operations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shadow_blackmarket_purchases`
--
ALTER TABLE `shadow_blackmarket_purchases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shadow_business_fronts`
--
ALTER TABLE `shadow_business_fronts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shadow_crypto_market`
--
ALTER TABLE `shadow_crypto_market`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `shadow_crypto_transactions`
--
ALTER TABLE `shadow_crypto_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shadow_crypto_wallets`
--
ALTER TABLE `shadow_crypto_wallets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shadow_network_messages`
--
ALTER TABLE `shadow_network_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shadow_pickups`
--
ALTER TABLE `shadow_pickups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shadow_sins`
--
ALTER TABLE `shadow_sins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shadow_sin_trials`
--
ALTER TABLE `shadow_sin_trials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shadow_tablet_access_logs`
--
ALTER TABLE `shadow_tablet_access_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shadow_tablet_pins`
--
ALTER TABLE `shadow_tablet_pins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `skill_purchases`
--
ALTER TABLE `skill_purchases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `weed_plants`
--
ALTER TABLE `weed_plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `shadow_pickups`
--
ALTER TABLE `shadow_pickups`
  ADD CONSTRAINT `shadow_pickups_ibfk_1` FOREIGN KEY (`purchase_id`) REFERENCES `shadow_blackmarket_purchases` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
