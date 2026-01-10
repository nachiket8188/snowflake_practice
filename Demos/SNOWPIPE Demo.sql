USE ROLE ACCOUNTADMIN;

USE WAREHOUSE COMPUTE_WH;

USE DATABASE SNOWFLAKE_PRACTICE;

USE SCHEMA PUBLIC;

/* CSV file used for this PoC was picked from Kaggle - 
https://www.kaggle.com/datasets/rohitsahoo/sales-forecasting
*/

CREATE
OR REPLACE TABLE SNOWFLAKE_PRACTICE.PUBLIC.SUPERSTORE_SALES (
    ROW_ID NUMBER,
    ORDER_ID VARCHAR,
    ORDER_DATE DATE,
    SHIP_DATE DATE,
    SHIP_MODE VARCHAR,
    CUSTOMER_ID VARCHAR,
    CUSTOMER_NAME VARCHAR,
    SEGMENT VARCHAR,
    COUNTRY VARCHAR,
    CITY VARCHAR,
    STATE VARCHAR,
    POSTAL_CODE NUMBER,
    "REGION" VARCHAR,
    PRODUCT_ID VARCHAR,
    CATEGORY VARCHAR,
    SUB_CATEGORY VARCHAR,
    PRODUCT_NAME VARCHAR,
    SALES NUMBER
);

CREATE STORAGE INTEGRATION s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  STORAGE_AWS_ROLE_ARN = '_REMOVED'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://snowflakeloadingpurposes/snowflake_snowpipe_learning/');

DESCRIBE INTEGRATION s3_integration;
/* noting down required parameters for further steps to be performed in AWS Console (specifically, updating the IAM Role's Trust Policy in the AWS Console (under the Trust relationships tab for the role you created). 
Modify the policy document using the STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID) */
/* STORAGE_AWS_IAM_USER_ARN = _REMOVED */
/* STORAGE_AWS_EXTERNAL_ID = _REMOVED */

/* While trying to create a stage using command below, if I use PARSE_HEADER = TRUE for FILE_FORMAT configuration, it works fine 
BUT it runs into a error while executing the subsequent line which is for creation of PIPE object. In that case, it'll generate error as below - 
SQL compilation error: Invalid file format "PARSE_HEADER" is only allowed for CSV INFER_SCHEMA and MATCH_BY_COLUMN_NAME

KEEP IN MIND - YOU'RE DEALING WITH AN EXTERNAL STAGE HERE.
*/

CREATE OR REPLACE STAGE s2_stage_for_snowpipe
  URL = 's3://snowflakeloadingpurposes/snowflake_snowpipe_learning/'
  STORAGE_INTEGRATION = s3_integration
  FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1, FIELD_DELIMITER = ','
    RECORD_DELIMITER = '\n', FIELD_OPTIONALLY_ENCLOSED_BY = '"', DATE_FORMAT = 'DD/MM/YYYY'
);

CREATE OR REPLACE PIPE mypipe_for_snowpipe_demo AUTO_INGEST = TRUE AS
  COPY INTO SNOWFLAKE_PRACTICE.PUBLIC.SUPERSTORE_SALES
  FROM @s2_stage_for_snowpipe;

SHOW PIPES;
/* Copy the ARN from the 'notification_channel' column, to use in next step. */

select * from SNOWFLAKE_PRACTICE.PUBLIC.SUPERSTORE_SALES;

select * from snowflake.account_usage.pipe_usage_history order by start_time desc;

select * from snowflake.account_usage.pipes;

/* If at all you run into an error during Auto-Ingest, this query can be used to debug. */
SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'SNOWFLAKE_PRACTICE.PUBLIC.SUPERSTORE_SALES',
    START_TIME => DATEADD(hours, -4, CURRENT_TIMESTAMP()) -- Adjust time range here
))
ORDER BY LAST_LOAD_TIME DESC;

select * from information_schema.columns where UPPER(table_name) = 'SUPERSTORE_SALES' order by ordinal_position;

/* 
New learning - So what happened was, for some reason, the initial data load into the Snowflake table through Snowpipe failed because the table structure was missing a column, meaning the CSV file had one additional column. I altered the table structure by adding the column to its definition, deleted the file from S3 bucket, re-uploaded it there, but Snowpipe did not automatically load it into the table. Reason being, Snowpipe maintains the history of the files loaded, and since the name of the file was same (even though the file load had failed in the first attempt) Since the same file name was there, it did not attempt to load the file again. 

So two options here -
1. Either rename the file in S3 bucket to something else or 
2. refresh the pipe. I went with second option.
*/
ALTER PIPE mypipe_for_snowpipe_demo REFRESH;

SELECT SYSTEM$PIPE_STATUS('mypipe_for_snowpipe_demo'); /* Generates JSON Doc */

/* After the PoC is done successfully, pausing the PIPE so that there's no potential for additional Compute Services (formerly the Cloud Services layer) Costs. */
ALTER PIPE mypipe_for_snowpipe_demo SET PIPE_EXECUTION_PAUSED = true;