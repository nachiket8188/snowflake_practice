USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

call sp_copy_into_dynamic();

select * from information_schema.load_history;

truncate table customers_raw;
truncate table orders_raw;
truncate table payments_raw;
truncate table products_raw;
truncate table shipments_raw;

select TABLE_NAME, row_count from information_schema.tables
WHERE TABLE_CATALOG = 'SNOWFLAKE_PRACTICE_DEV'
  AND TABLE_SCHEMA = 'RAW';

select source_name, file_format, target_table_name, s3_folder_path, enabled from INGESTION_CONFIG
        where source_name IN (
        (select value::string from TABLE(FLATTEN(INPUT => ['customers', 'orders', 'payments']))));

select * from ingestion_config;