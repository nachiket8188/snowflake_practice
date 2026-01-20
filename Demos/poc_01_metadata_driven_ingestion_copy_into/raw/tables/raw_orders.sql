USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

CREATE TABLE SNOWFLAKE_PRACTICE_DEV.RAW.ORDERS_RAW(
    order_id string,
    customer_id string,
    order_date string,
    order_amount string,
    status string,
    _filename string,
    _ingestdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

