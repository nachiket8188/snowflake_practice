USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

CREATE OR REPLACE TABLE SNOWFLAKE_PRACTICE_DEV.RAW.CUSTOMERS_RAW(
    customer_id string,
    customer_name string,
    email string,
    country string,
    created_date string,
    _filename string,
    _ingestdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)ENABLE_SCHEMA_EVOLUTION = TRUE;

