/* This worksheet contains all the initial scripts that need to be run in order to set up and properly configure basic and commonly used objects (for different projects) such as setting default Virtual Warehouse, Timezone etc. */

CREATE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE DATABASE SNOWFLAKE_PRACTICE_DEV;

CREATE SCHEMA RAW;

USE SCHEMA RAW;

/* Create a VW */
CREATE OR REPLACE WAREHOUSE COMPUTE_LEARNING WITH WAREHOUSE_SIZE = 'XSMALL' AUTO_SUSPEND = 60 AUTO_RESUME = TRUE INITIALLY_SUSPENDED = TRUE
comment = 'Use this warehouse for Personal Snowflake Project Tasks';

USE WAREHOUSE COMPUTE_WH;

/* Set default warehouse for user. */
ALTER USER SET DEFAULT_WAREHOUSE = COMPUTE_WH;

SHOW USERS;

/* Configure and enable Github Repo. access to replicate work from previous Snowflake Trial Account. */

CREATE OR REPLACE SECRET SNOWFLAKE_PRACTICE_DEV.RAW.my_git_secret
  TYPE = password
  USERNAME = 'nachiket8188'
  PASSWORD = '*****************';
  /* 
  The password is not password to the Github account rather a PAT (Personal Access Token) you generate for that account. The PAT from previous usage might not work and may result in "Failed to access the Git Repository. Operation 'clone' is not authorized." error. If that happens, generate a new PAT in Github Developer Settings and use that one.
  */
  
create or replace API INTEGRATION SNOWFLAKE_PRACTICE_DEV.RAW.git_api_integration
    API_PROVIDER = git_https_api
    API_ALLOWED_PREFIXES = ('https://github.com/nachiket8188')
    ALLOWED_AUTHENTICATION_SECRETS = (my_git_secret)
    ENABLED = TRUE;

CREATE OR REPLACE GIT REPOSITORY SNOWFLAKE_PRACTICE_DEV.RAW.snowflake_practice
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

/* Creation of Resource Monitor at Account Level and configuring it for Trial Acct Credits. */

/*
According to Google Gemini, 

In your Snowflake trial account with the Enterprise Edition on AWS in the Asia Pacific (Singapore) region, you get 142 credits for your initial $400 in trial usage. 
A trial account is generally an On-Demand account, meaning you pay the list price per credit without an upfront capacity commitment. The On-Demand rate for the Enterprise Edition in the Asia Pacific (Singapore) region on AWS is approximately $2.80 per credit. 
Here is the breakdown of how many credits you receive:
Total Credits: $400 (trial credit) / $2.80 (cost per credit) = ~142 credits. 
This amount of credit can be used across compute (virtual warehouses) and storage during your 30-day trial period.  
*/

/* Thus, creating a Resource Monitor using SQL Script that keeps credit consumption in check and notifies me as soon as certain thresholds are reached (so that I am aware of Credit Consumption and do not find myself in a situation where I run out of trial credits and then am unable to retrieve any data/SQL scripts in Snowsight) */

USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE RESOURCE MONITOR account_wide_monitoring
with credit_quota = 140
frequency = NEVER /* If you specify NEVER for the frequency, the credit usage for the warehouse does not reset. */
start_timestamp = IMMEDIATELY /* Make sure you've changed the Timezone of the Account to Asia/Kolkata */
NOTIFY_USERS = (THEDARKPRINCE)
TRIGGERS ON 50 PERCENT DO NOTIFY
           ON 75 PERCENT DO NOTIFY
           ON 90 PERCENT DO SUSPEND
           ON 95 PERCENT DO SUSPEND_IMMEDIATE;

SHOW RESOURCE MONITORS;

ALTER ACCOUNT SET RESOURCE_MONITOR = account_wide_monitoring;