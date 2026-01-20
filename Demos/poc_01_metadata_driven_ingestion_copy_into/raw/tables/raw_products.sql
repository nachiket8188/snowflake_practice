USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

CREATE TABLE SNOWFLAKE_PRACTICE_DEV.RAW.PRODUCTS_RAW(
    product_id string,
    product_name string,
    category string,
    price string,
    _filename string,
    _ingestdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

