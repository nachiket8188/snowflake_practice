USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

create storage integration S3_INTEGRATION_FOR_POC_01
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
STORAGE_AWS_ROLE_ARN = '_REMOVED'
ENABLED = TRUE
STORAGE_ALLOWED_LOCATIONS = ('s3://snowflakeloadingpurposes/poc_01_metadata_driven_ingestion/raw/');

describe integration S3_INTEGRATION_FOR_POC_01;

create or replace stage EXT_STAGE_FOR_POC_01
URL='s3://snowflakeloadingpurposes/poc_01_metadata_driven_ingestion/raw/'
STORAGE_INTEGRATION=S3_INTEGRATION_FOR_POC_01
DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
  )
;

list @EXT_STAGE_FOR_POC_01;