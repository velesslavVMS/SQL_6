DROP DATABASE IF EXISTS hometask_6;
CREATE DATABASE hometask_6;
USE hometask_6;

-- пользователи
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

INSERT INTO users (id, firstname, lastname, email) VALUES 
(1, 'Reuben', 'Nienow', 'arlo50@example.org'),
(2, 'Frederik', 'Upton', 'terrence.cartwright@example.org'),
(3, 'Unique', 'Windler', 'rupert55@example.org'),
(4, 'Norene', 'West', 'rebekah29@example.net'),
(5, 'Frederick', 'Effertz', 'von.bridget@example.net'),
(6, 'Victoria', 'Medhurst', 'sstehr@example.net'),
(7, 'Austyn', 'Braun', 'itzel.beahan@example.com'),
(8, 'Jaida', 'Kilback', 'johnathan.wisozk@example.com'),
(9, 'Mireya', 'Orn', 'missouri87@example.org'),
(10, 'Jordyn', 'Jerde', 'edach@example.com');

-- 1. Создайте таблицу users_old, аналогичную таблице users. 
-- Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old.

DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old(
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);
SELECT * FROM users_old;

DROP PROCEDURE IF EXISTS pr_users_old;
DELIMITER //
CREATE PROCEDURE pr_users_old()
BEGIN
START TRANSACTION;

SET@users_old.id = 3;

INSERT INTO users_old (id, firstname, lastname, email)
SELECT id, firstname, lastname, email
FROM users
WHERE users.id = @users_old.id;
DELETE FROM users WHERE id = @users_old.id;
COMMIT;

END//
DELIMITER ;

CALL pr_users_old();

SELECT * FROM users_old;
SELECT * FROM users;

-- 2.Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
DECLARE hello VARCHAR(30);
	    SET hello = 
  	    IF(TIME(NOW) BETWEEN '06:00:00' AND '11:59:59', 'Доброе утро',
   ( IF(TIME(NOW) BETWEEN '12:00:00' AND '17:59:59', 'Добрый день',
( IF(TIME(NOW) BETWEEN '18:00:00' AND '23:59:59', 'Добрый вечер', 'Доброй ночи') ) ) ) );
RETURN hello;
      END//
DELIMITER ;

