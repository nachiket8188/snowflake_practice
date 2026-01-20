USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

CREATE TABLE SNOWFLAKE_PRACTICE_DEV.RAW._RAW(
    payment_id string,
    order_id string,
    payment_date string,
    payment_method string,
    amount string,
    _filename string,
    _ingestdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

