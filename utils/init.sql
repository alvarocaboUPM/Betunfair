-- Active: 1677065229253@@127.0.0.1@3306
CREATE DATABASE IF NOT EXISTS betunfair;
CREATE DATABASE IF NOT EXISTS betunfair_test;
CREATE USER 'betunfair'@'localhost' IDENTIFIED BY '9sX5^6a2jJng';
GRANT ALL PRIVILEGES ON betunfair.* TO 'betunfair'@'localhost';
GRANT ALL PRIVILEGES ON betunfair_test.* TO 'betunfair'@'localhost';

FLUSH PRIVILEGES;