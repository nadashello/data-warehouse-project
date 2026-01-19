/* This is setup script to create DB,Schemas */

-- create the datawarehouse database
CREATE DATABASE IF NOT EXISTS DataWarehouse;

-- create schemas bronze,silver,gold
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
