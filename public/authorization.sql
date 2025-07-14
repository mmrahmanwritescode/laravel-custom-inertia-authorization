-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.42 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for laravel_authorization
CREATE DATABASE IF NOT EXISTS `laravel_authorization` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `laravel_authorization`;

-- Dumping structure for table laravel_authorization.cache
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.cache: ~0 rows (approximately)

-- Dumping structure for table laravel_authorization.cache_locks
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.cache_locks: ~0 rows (approximately)

-- Dumping structure for table laravel_authorization.failed_jobs
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.failed_jobs: ~0 rows (approximately)

-- Dumping structure for table laravel_authorization.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.jobs: ~0 rows (approximately)

-- Dumping structure for table laravel_authorization.job_batches
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.job_batches: ~0 rows (approximately)

-- Dumping structure for table laravel_authorization.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.migrations: ~8 rows (approximately)
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
	(1, '0001_01_01_000000_create_users_table', 1),
	(2, '0001_01_01_000001_create_cache_table', 1),
	(3, '0001_01_01_000002_create_jobs_table', 1),
	(4, '2025_07_10_135747_create_roles_table', 1),
	(5, '2025_07_10_135755_create_permissions_table', 1),
	(6, '2025_07_10_135803_create_role_user_table', 1),
	(7, '2025_07_10_135811_create_permission_role_table', 1),
	(8, '2025_07_10_135819_create_products_table', 1);

-- Dumping structure for table laravel_authorization.password_reset_tokens
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.password_reset_tokens: ~0 rows (approximately)

-- Dumping structure for table laravel_authorization.permissions
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.permissions: ~16 rows (approximately)
INSERT INTO `permissions` (`id`, `name`, `created_at`, `updated_at`) VALUES
	(1, 'view-user', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(2, 'create-user', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(3, 'edit-user', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(4, 'delete-user', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(5, 'view-product', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(6, 'create-product', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(7, 'edit-product', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(8, 'delete-product', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(9, 'view-role', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(10, 'create-role', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(11, 'edit-role', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(12, 'delete-role', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(13, 'view-permission', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(14, 'create-permission', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(15, 'edit-permission', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(16, 'delete-permission', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(20, 'edit-loan', '2025-07-14 05:13:17', '2025-07-14 05:17:12');

-- Dumping structure for table laravel_authorization.permission_role
CREATE TABLE IF NOT EXISTS `permission_role` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permission_role_permission_id_role_id_unique` (`permission_id`,`role_id`),
  KEY `permission_role_role_id_foreign` (`role_id`),
  CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.permission_role: ~18 rows (approximately)
INSERT INTO `permission_role` (`id`, `permission_id`, `role_id`, `created_at`, `updated_at`) VALUES
	(1, 1, 1, NULL, NULL),
	(2, 2, 1, NULL, NULL),
	(3, 3, 1, NULL, NULL),
	(4, 4, 1, NULL, NULL),
	(5, 5, 1, NULL, NULL),
	(6, 6, 1, NULL, NULL),
	(7, 7, 1, NULL, NULL),
	(8, 8, 1, NULL, NULL),
	(9, 9, 1, NULL, NULL),
	(10, 10, 1, NULL, NULL),
	(11, 11, 1, NULL, NULL),
	(12, 12, 1, NULL, NULL),
	(13, 13, 1, NULL, NULL),
	(14, 14, 1, NULL, NULL),
	(15, 15, 1, NULL, NULL),
	(16, 16, 1, NULL, NULL),
	(17, 6, 2, NULL, NULL),
	(19, 5, 2, NULL, NULL);

-- Dumping structure for table laravel_authorization.products
CREATE TABLE IF NOT EXISTS `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_sku_unique` (`sku`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.products: ~4 rows (approximately)
INSERT INTO `products` (`id`, `name`, `sku`, `price`, `stock`, `created_at`, `updated_at`) VALUES
	(1, 'Laptop', 'LP001', 999.99, 50, '2025-07-11 09:09:01', '2025-07-11 09:09:01'),
	(2, 'Mouse', 'MS001', 29.99, 100, '2025-07-11 09:09:02', '2025-07-11 09:09:02'),
	(3, 'Keyboard', 'KB001', 79.99, 75, '2025-07-11 09:09:02', '2025-07-11 09:09:02'),
	(4, 'Monitor', 'MN001', 299.99, 30, '2025-07-11 09:09:02', '2025-07-11 09:09:02');

-- Dumping structure for table laravel_authorization.roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.roles: ~2 rows (approximately)
INSERT INTO `roles` (`id`, `name`, `created_at`, `updated_at`) VALUES
	(1, 'admin', '2025-07-11 09:08:59', '2025-07-11 09:08:59'),
	(2, 'staff', '2025-07-11 09:08:59', '2025-07-11 09:08:59');

-- Dumping structure for table laravel_authorization.role_user
CREATE TABLE IF NOT EXISTS `role_user` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_user_user_id_role_id_unique` (`user_id`,`role_id`),
  KEY `role_user_role_id_foreign` (`role_id`),
  CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.role_user: ~3 rows (approximately)
INSERT INTO `role_user` (`id`, `user_id`, `role_id`, `created_at`, `updated_at`) VALUES
	(1, 1, 1, NULL, NULL),
	(2, 2, 2, NULL, NULL),
	(14, 10, 2, NULL, NULL);

-- Dumping structure for table laravel_authorization.sessions
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.sessions: ~4 rows (approximately)
INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
	('l4mw4Qr5FKxmIsDJFlM4WxEs3AP2FmhvfGqHuGD8', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0', 'YTo3OntzOjY6Il90b2tlbiI7czo0MDoiWEFLUk1pZnF4VjBTVHRkQmVYeHNLdVFRYUdpakFUM2RRUGcyOTFRRiI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1OiJlbWFpbCI7czoxNzoic3RhZmZAZXhhbXBsZS5jb20iO3M6NzoidXNlcl9pZCI7aToyO3M6NDoibmFtZSI7czoxMDoiU3RhZmYgVXNlciI7czo0OiJyb2xlIjtOO3M6OToiX3ByZXZpb3VzIjthOjE6e3M6MzoidXJsIjtzOjM5OiJodHRwOi8vYXV0aG9yaXphdGlvbi1kZW1vLnRlc3QvcHJvZHVjdHMiO319', 1752495236),
	('LmjdrwjMLMKFNryMVcMiNKjcYjz6Ix3rDeOdk7Yb', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoieHFueDgzanN5UTNWcTFxMmtLMHpSZGU5aVpDSjJpV25YYzkwbk4wQyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1752491862),
	('QX78Eb4VB8KabN1QEKz8VnO5J2g7ryw7Lr5sddvt', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Herd/1.20.0 Chrome/120.0.6099.291 Electron/28.2.5 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRnJaM1hEaUJtaU5IVkJBdTJCeWliUE1qZkZrRnQxU0pQOU5COFVUeiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzY6Imh0dHA6Ly9hdXRob3JpemF0aW9uLWRlbW8udGVzdC9sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1752487870);

-- Dumping structure for table laravel_authorization.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table laravel_authorization.users: ~4 rows (approximately)
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
	(1, 'Admin User', 'admin@example.com', NULL, '$2y$12$4s/VoHzbamzzfVrh9MgsbuZhN4fnWi3LYec5p0uKcl9unYevKwQvK', NULL, '2025-07-11 09:09:01', '2025-07-11 09:09:01'),
	(2, 'Staff User', 'staff@example.com', NULL, '$2y$12$hElQAsIFAolGbQs8i5vdVeWvH4a9ha0y6msoUDtJi0.E6qKMl.4AS', NULL, '2025-07-11 09:09:01', '2025-07-11 09:09:01'),
	(3, 'Regular User', 'user@example.com', NULL, '$2y$12$mjSZ0SOdQzh.x/UOgOCYyeTdgJAzkZUY1LeHmVGJ00Y9XgjyZkKsS', NULL, '2025-07-11 09:09:01', '2025-07-11 09:09:01'),
	(10, 'saba karim', 'karim@karim.com', NULL, '$2y$12$HmxTVa70ba3p5sP1L/gap.T5NsAyJh.CUQNwMS.qdcfmFYM7Qo2TC', NULL, '2025-07-14 01:50:11', '2025-07-14 01:50:11');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
