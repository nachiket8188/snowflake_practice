/* This worksheet contains all the initial scripts that need to be run in order to set up and properly configure basic and commonly used objects (for different projects) such as setting default Virtual Warehouse, Timezone etc. */

USE DATABASE SNOWFLAKE_LEARNING_DB;

USE SCHEMA PUBLIC;

CREATE DATABASE SNOWFLAKE_PRACTICE;

USE DATABASE SNOWFLAKE_PRACTICE;

CREATE SCHEMA S3_TO_SNOWFLAKE;

USE SCHEMA S3_TO_SNOWFLAKE;

/* Create a VW */
CREATE OR REPLACE WAREHOUSE COMPUTE_LEARNING WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE INITIALLY_SUSPENDED = TRUE
comment = 'Use this warehouse for Personal Snowflake Project Tasks';

USE WAREHOUSE COMPUTE_LEARNING;

/* Set default warehouse for user. */
ALTER USER SET DEFAULT_WAREHOUSE = COMPUTE_LEARNING ;

SHOW USERS;

/* Configure and enable Github Repo. access to replicate work from previous Snowflake Trial Account. */

CREATE OR REPLACE SECRET SNOWFLAKE_PRACTICE.PUBLIC.my_git_secret
  TYPE = password
  USERNAME = 'nachiket8188'
  PASSWORD = '*****************';
  /* 
  The password is not password to the Github account rather a PAT (Personal Access Token) you generate for that account. The PAT from previous usage might not work and may result in "Failed to access the Git Repository. Operation 'clone' is not authorized." error. If that happens, generate a new PAT in Github Developer Settings and use that one.
  */
  
create or replace API INTEGRATION git_api_integration
    API_PROVIDER = git_https_api
    API_ALLOWED_PREFIXES = ('https://github.com/nachiket8188')
    ALLOWED_AUTHENTICATION_SECRETS = (my_git_secret)
    ENABLED = TRUE;

CREATE OR REPLACE GIT REPOSITORY SNOWFLAKE_PRACTICE.PUBLIC.snowflake_practice
    API_INTEGRATION = git_api_integration
    ORIGIN = 'https://github.com/nachiket8188/snowflake_practice.git'
    GIT_CREDENTIALS = my_git_secret;

select getdate();

select localtime();
/* 
By default, Snowflake accounts have their timezone set to 'US/Pacific'.
*/

/* To find out the current timezone for you, create and use following function. */
create or replace function GET_CURRENT_TIMEZONE()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
AS
$$
    const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
    return timezone;
$$
;

select get_current_timezone();

/* To change the timezone for current session. */
/* To check acceptable values for TIMEZONE, check out - https://data.iana.org/time-zones/tzdb-2025b/zone1970.tab */
ALTER SESSION SET TIMEZONE = 'Asia/Kolkata';

select get_current_timezone();

select localtime();

/* To change the timezone for account (for good). */
ALTER ACCOUNT SET TIMEZONE = 'Asia/Kolkata';

select get_current_timezone();

select localtime();

