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