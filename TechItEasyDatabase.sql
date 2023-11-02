--Gelukkig snap ChatGPT de cascades wel, ik begrijp daar (nog) geen fluit van.
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS televisions CASCADE;
DROP TABLE IF EXISTS remote_controllers;
DROP TABLE IF EXISTS ci_modules;
DROP TABLE IF EXISTS wall_brackets CASCADE;
DROP TABLE IF EXISTS television_wall_brackets;

--Tables
CREATE TABLE users
(
	id INT GENERATED ALWAYS AS IDENTITY,
	username VARCHAR(255) NOT NULL UNIQUE,
	password VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	role VARCHAR(255) NOT NULL
);

CREATE TABLE remote_controllers
(
	id INT GENERATED ALWAYS AS IDENTITY UNIQUE,
	name VARCHAR(255) NOT NULL UNIQUE,
	brand VARCHAR(255) NOT NULL,
	price DOUBLE PRECISION NOT NULL,
	current_stock INTEGER NOT NULL,
	sold INTEGER NOT NULL,
	compatible_with VARCHAR(255) NOT NULL,
	battery_type VARCHAR(255) NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE ci_modules
(
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(255) NOT NULL UNIQUE,
	brand VARCHAR(255) NOT NULL,
	price DOUBLE PRECISION NOT NULL,
	current_stock INTEGER NOT NULL,
	sold INTEGER NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE wall_brackets
(
	id INT GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(255) NOT NULL UNIQUE,
	brand VARCHAR(255) NOT NULL,
	price DOUBLE PRECISION NOT NULL,
	current_stock INTEGER NOT NULL,
	sold INTEGER NOT NULL,
	adjustable BOOLEAN NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE televisions
(
	id INT GENERATED ALWAYS AS IDENTITY UNIQUE,
	name VARCHAR(255) NOT NULL UNIQUE,
	type VARCHAR(255) NOT NULL,
	brand VARCHAR(255) NOT NULL,
	price DOUBLE PRECISION NOT NULL,
	current_stock INTEGER NOT NULL,
	sold INTEGER NOT NULL,
	available_size DOUBLE PRECISION NOT NULL,
	refresh_rate DOUBLE PRECISION NOT NULL,
	screentype VARCHAR(255) NOT NULL,
	remote_controller_id INT NOT NULL,
	ci_module_id INT NOT NULL,
	CONSTRAINT fk_remote_controller FOREIGN KEY(remote_controller_id) REFERENCES remote_controllers(id),
	CONSTRAINT fk_ci_module FOREIGN KEY(ci_module_id) REFERENCES ci_modules(id)
);

CREATE TABLE television_wall_brackets
(
	television_id INT,
	wall_bracket_id INT,
	CONSTRAINT fk_television FOREIGN KEY(television_id) REFERENCES televisions(id),
	CONSTRAINT fk_wall_bracket FOREIGN KEY(wall_bracket_id) REFERENCES wall_brackets(id)
);

--Data
INSERT INTO users(username, password, email, role)
VALUES
('Datameester', 'geheim123', 'mark@novi.nl', 'admin'),
('Nakijkmans', 'geheim456', 'nakijkmans@novi.nl', 'user');

INSERT INTO ci_modules(name, brand, price, current_stock, sold)
VALUES
('CI+ 1.3 Interactieve Module', 'Quantis', 69.99, 15, 8),
('CI+ 1.3 Interactieve Ziggo Module', 'SMiT', 79.99, 18, 22);

INSERT INTO remote_controllers(name, brand, price, current_stock, sold, compatible_with, battery_type)
VALUES
('URC4911 Afstandsbediening', 'LG', 22.99, 1892, 1445, 'One For All LG', 'AAA'),
('URC4913 Afstandsbediening', 'Philips', 37.99, 1743, 2008, 'One For All Philips', 'AA'),
('URC4910 Afstandsbediening', 'Samsung', 29.99, 4031, 3811, 'One For All Samsung', 'AAA');

INSERT INTO wall_brackets(name, brand, price, current_stock, sold, adjustable)
VALUES
('lg022', 'LG', 22.99, 518, 313, 'false'),
('lg044', 'LG', 32.99, 228, 143, 'false'),
('ph021', 'Philips', 24.99, 354, 124, 'false'),
('ph048', 'Philips', 38.99, 311, 123, 'true'),
('ss033', 'Samsung', 48.99, 515, 813, 'true'),
('ss066', 'Samsung', 64.99, 811, 678, 'true');


INSERT INTO televisions(name, type, brand, price, current_stock, sold, available_size, refresh_rate, screentype, remote_controller_id, ci_module_id)
VALUES
('Philips 55OLED908/12', 'OLED', 'Philips', 2299, 18, 35, 140, 100, 'OLED', (SELECT id FROM remote_controllers WHERE brand='Philips'), 1),
('Samsung Neo QLED 55QN95B', 'QLED', 'Samsung', 2848, 15, 28, 140, 144, 'QLED', (SELECT id FROM remote_controllers WHERE brand='Samsung'), 2),
('Samsung Crystal UHD 75CU7100', 'LED-LCD', 'Samsung', 999, 16, 33, 140, 50, 'LED-LCD', (SELECT id FROM remote_controllers WHERE brand='Samsung'), 2),
('Philips 65OLED908/12', 'OLED', 'Philips', 3099, 6, 42, 165, 100, 'OLED', (SELECT id FROM remote_controllers WHERE brand='Philips'), 2),
('LG OLED77G36LA', 'OLED', 'LG', 5688, 1, 88, 195, 144, 'OLED', (SELECT id FROM remote_controllers WHERE brand='LG'), 1),
('LG OLED83G36LA', 'OLED', 'LG', 6988, 3, 99, 211, 144, 'OLED', (SELECT id FROM remote_controllers WHERE brand='LG'), 2),
('Philips 77OLED908/12', 'OLED', 'Philips', 4999, 2, 77, 195, 100, 'OLED', (SELECT id FROM remote_controllers WHERE brand='Philips'), 1);

INSERT INTO television_wall_brackets(television_id, wall_bracket_id)
VALUES
(1, 3),
(1, 4),
(2, 5),
(2, 6),
(3, 5),
(3, 6),
(4, 3),
(4, 4),
(5, 1),
(5, 2),
(6, 1),
(6, 2),
(7, 3),
(7, 4);

--Data ophalen
SELECT t.name, wb.name
FROM televisions AS t
JOIN television_wall_brackets AS twb ON twb.television_id=t.id
JOIN wall_brackets AS wb ON twb.wall_bracket_id=wb.id;