/* This is setup script to create DB,Schemas */

-- create the datawarehouse database
CREATE DATABASE IF NOT EXISTS DataWarehouse;

-- create schemas bronze,silver,gold
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;

/** This script is to setup all the needed schema/tables/storage/stages/file formats in bronze layer **/

-- create if not exits customer information table from source CRM
CREATE TABLE IF NOT EXISTS  datawarehouse.bronze.crm_customer_info (
cst_id INT,
cst_key VARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_material_status VARCHAR(50),
cst_gndr VARCHAR(50),
cst_create_date DATE
);

-- create if not exits product table from source CRM
CREATE TABLE IF NOT EXISTS  datawarehouse.bronze.crm_prd_info (
prd_id INT,
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE
);

-- create if not exits sales table from source CRM
CREATE TABLE IF NOT EXISTS  datawarehouse.bronze.crm_sales_details (
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id INT, 
sls_order_dt INT,
sls_ship_dt INT, 
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

-- create if not exits loc table from source ERP
CREATE TABLE IF NOT EXISTS datawarehouse.bronze.erp_loc_a101 (
cid VARCHAR(50),
cntry VARCHAR(50)
);

-- create if not exits Customer table from source ERP
CREATE TABLE IF NOT EXISTS datawarehouse.bronze.erp_cust_az12 (
cid VARCHAR(50),
bdate DATE, 
gen VARCHAR(50)
);

-- create if not exits Catlog/category table from source ERP
CREATE TABLE IF NOT EXISTS  datawarehouse.bronze.erp_px_cat_g1v2 (
id VARCHAR(50),
cat VARCHAR(50),
subcat VARCHAR(50),
maintenance VARCHAR(50)
);

-- create a storge to read from AWS S3 Bucket (Bronze) 
CREATE OR REPLACE STORAGE INTEGRATION bronze_s3_storage
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = S3
    ENABLED = TRUE 
    STORAGE_AWS_ROLE_ARN = $BRONZE_S3_ROLE_ARN
    STORAGE_ALLOWED_LOCATIONS = ('s3://dwhproject-bronze-bucket-s3/');

-- to integrate in AWS (COPY THE EXTERNAL ID INTO AWS IAM)
DESC INTEGRATION bronze_s3_storage;

-- Create a schema only for stages
CREATE SCHEMA IF NOT EXISTS datawarehouse.stages;

-- create a schema for file formats
CREATE SCHEMA IF NOT EXISTS datawarehouse.file_formats;

-- create file format object
CREATE OR REPLACE FILE FORMAT datawarehouse.file_formats.csv_file_format
    TYPE = CSV
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    NULL_IF = ('NULL','null')
    EMPTY_FIELD_AS_NULL = TRUE;

-- create stage to read from the bronze bucket
CREATE OR REPLACE STAGE datawarehouse.stages.bronze_stage
    URL = 's3://dwhproject-bronze-bucket-s3/'
    STORAGE_INTEGRATION = bronze_s3_storage
    FILE_FORMAT = csv_file_format;
    
