CREATE TABLE `outfit_codes` (
  `identifier` varchar(255) NOT NULL,
  `code` varchar(20) NOT NULL,
  `label` varchar(255) NOT NULL,
  `skin` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `outfit_codes`
  ADD PRIMARY KEY (`code`);
COMMIT;