USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

CREATE TABLE SNOWFLAKE_PRACTICE_DEV.RAW.SHIPMENTS_RAW(
    shipment_id string,
    order_id string,
    shipment_date string,
    status string,
    _filename string,
    _ingestdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

