
INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES ('society_mosley', 'Mosley', 1);
INSERT INTO `addon_account_data` (`account_name`, `money`, `owner`) VALUES ('society_mosley', 0, NULL);
INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES ('society_mosley', 'Mosley', 1);
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES ('society_mosley', 'Mosley', 1);
INSERT INTO `datastore_data` (`name`, `owner`, `data`) VALUES ('society_mosley', NULL, '{}');
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('mosley', 'Mosley', 1);

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('mosley', 0, 'recruit', 'Apprentis', 300, '{}', '{}'),
('mosley', 1, 'employed', 'Cuisinier', 300, '{}', '{}'),
('mosley', 2, 'viceboss', 'Co-gérant', 500, '{}', '{}'),
('mosley', 3, 'boss', 'Gérant', 600, '{}', '{}');

