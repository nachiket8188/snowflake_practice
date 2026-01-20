USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

CREATE OR REPLACE TABLE SNOWFLAKE_PRACTICE_DEV.RAW.INGESTION_CONFIG(
    source_name varchar,
    file_format varchar,
    target_table_name varchar,
    s3_folder_path varchar,
    enabled boolean
);

INSERT INTO SNOWFLAKE_PRACTICE_DEV.RAW.INGESTION_CONFIG (source_name, file_format, target_table_name, s3_folder_path, enabled) 
VALUES
('customers', 'FF_CSV_CUSTOMERS', 'RAW.CUSTOMERS', 's3://snowflakeloadingpurposes/poc_01_metadata_driven_ingestion/raw/customers/', TRUE),
('orders', 'FF_CSV_ORDERS', 'RAW.ORDERS', 's3://snowflakeloadingpurposes/poc_01_metadata_driven_ingestion/raw/orders/', TRUE),
('payments', 'FF_CSV_PAYMENTS', 'RAW.PAYMENTS', 's3://snowflakeloadingpurposes/poc_01_metadata_driven_ingestion/raw/payments/', TRUE),
('products', 'FF_CSV_products', 'RAW.PRODUCTS', 's3://snowflakeloadingpurposes/poc_01_metadata_driven_ingestion/raw/products/', TRUE),
('shipments', 'FF_CSV_SHIPMENTS', 'RAW.SHIPMENTS', 's3://snowflakeloadingpurposes/poc_01_metadata_driven_ingestion/raw/shipments/', TRUE);
