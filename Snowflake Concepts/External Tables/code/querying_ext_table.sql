show stages;

USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

create or replace storage integration S3_INTEGRATION_FOR_POC_01
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::203918842190:role/role_for_snowflake_to_access_s3_location'
ENABLED = TRUE
STORAGE_ALLOWED_LOCATIONS = ('s3://snowflakeloadingpurposes/external_table_demo/');

describe integration S3_INTEGRATION_FOR_POC_01;

create or replace stage EXTERNAL_TABLE_DEMO_STAGE
URL='s3://snowflakeloadingpurposes/external_table_demo/'
STORAGE_INTEGRATION=S3_INTEGRATION_FOR_POC_01
DIRECTORY = (
    ENABLE = true
    AUTO_REFRESH = true
  )
;

list @EXTERNAL_TABLE_DEMO_STAGE;

create or replace external table ipl_data_external_table with location = @EXTERNAL_TABLE_DEMO_STAGE FILE_FORMAT = (TYPE=CSV SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"') PATTERN='.*[A-Za-z0-9_]+\.csv';

select * from IPL_DATA_EXTERNAL_TABLE;

describe table IPL_DATA_EXTERNAL_TABLE;

select value:c11::varchar from IPL_DATA_EXTERNAL_TABLE;

select COUNT(*) from IPL_DATA_EXTERNAL_TABLE;

create or replace external table extracted_ipl_data_external_table 
(
    id int as (value:c1::number),
    season int as (value:c2::number),
    city varchar as (value:c3::varchar),
    date date as to_date(value:c4::varchar, 'DD-MM-YYYY'), --
    team1 varchar as (value:c5::varchar),
    team2 varchar as (value:c6::varchar),
    toss_winner varchar as (value:c7::varchar),
    toss_decision varchar as (value:c8::varchar),
    result varchar as (value:c9::varchar),
    dl_applied varchar as (value:c10::varchar),
    winner varchar as (value:c11::varchar),
    win_by_runs varchar as (value:c12::varchar),
    win_by_wickets varchar as (value:c13::varchar),
    player_of_match varchar as (value:c14::varchar),
    venue varchar as (value:c15::varchar),
    umpire1 varchar as (value:c16::varchar),
    umpire2 varchar as (value:c17::varchar),
    umpire3 varchar as (value:c18::varchar)
)
location = @EXTERNAL_TABLE_DEMO_STAGE FILE_FORMAT = (TYPE=CSV SKIP_HEADER=1 FIELD_OPTIONALLY_ENCLOSED_BY='"') PATTERN='.*[A-Za-z0-9_]+\.csv'
AUTO_REFRESH = TRUE;

select * from extracted_ipl_data_external_table;

select 
metadata$filename
,ID
,SEASON
,CITY
,DATE
,TEAM1
,TEAM2
,TOSS_WINNER
,TOSS_DECISION
,RESULT
,DL_APPLIED
,WINNER
,WIN_BY_RUNS
,WIN_BY_WICKETS
,PLAYER_OF_MATCH
,VENUE
,UMPIRE1
,UMPIRE2
,UMPIRE3 from extracted_ipl_data_external_table;

select column_name from information_schema.columns where lower(table_name) = 'extracted_ipl_data_external_table' order by ordinal_position;

SHOW EXTERNAL TABLES;

DESCRIBE STORAGE INTEGRATION S3_INTEGRATION_FOR_POC_01;

ALTER EXTERNAL TABLE EXTRACTED_IPL_DATA_EXTERNAL_TABLE REFRESH;

select COUNT(*) from EXTRACTED_IPL_DATA_EXTERNAL_TABLE;

select 
metadata$filename
,ID
,SEASON
,CITY
,DATE
,TEAM1
,TEAM2
,TOSS_WINNER
,TOSS_DECISION
,RESULT
,DL_APPLIED
,WINNER
,WIN_BY_RUNS
,WIN_BY_WICKETS
,PLAYER_OF_MATCH
,VENUE
,UMPIRE1
,UMPIRE2
,UMPIRE3
from extracted_ipl_data_external_table order by DATE desc;