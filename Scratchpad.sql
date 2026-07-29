select
    current_date();

select * from information_schema.tables;

select * from sales.salesterritory; 

-- Overall AI Services cost
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_DAILY_HISTORY
WHERE SERVICE_TYPE = 'AI_SERVICES';

SELECT 
    SERVICE_TYPE, SUM(CREDITS_BILLED)
FROM SNOWFLAKE.ACCOUNT_USAGE.METERING_DAILY_HISTORY
GROUP BY
SERVICE_TYPE
ORDER BY 2 DESC;

-- Cortex AI Functions detail
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_USAGE_HISTORY;

-- Cortex Analyst usage
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_ANALYST_USAGE_HISTORY;

-- Cortex Agents usage  
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_AGENT_USAGE_HISTORY;

-- Cortex Search usage
SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_SEARCH_SERVING_USAGE_HISTORY;

SHOW PIPES;

SELECT SYSTEM$PIPE_STATUS('MYPIPE_FOR_SNOWPIPE_DEMO');

select top 5 * from PERSON.PERSON order by businessentityid desc;

TRUNCATE TABLE PERSON.ADDRESS;

ALTER TABLE PERSON.ADDRESS DROP COLUMN SPATIALLOCATION_NEW;

ALTER TABLE PERSON.ADDRESS ADD COLUMN SPATIALLOCATION varchar;

DESC TABLE HUMANRESOURCES.EMPLOYEE;

select table_schema, table_name, row_count from information_schema.tables
where table_catalog = 'ADVENTUREWORKS'
and row_count > 0
order by table_schema, table_name;

select top 5 * from person.address order by addressid desc;

select * from person.address;

DROP DATABASE ADVENTUREWORKS;

select * from ADVENTUREWORKS.PRODUCTION.PRODUCTPRODUCTPHOTO;

SHOW STAGES;

select * from TABLE(SPLIT_TO_TABLE('How do I look ?', ' '));

SHOW PARAMETERS;

SHOW SECRETS;

SELECT 
    *
FROM snowflake.account_usage.secrets
WHERE secret_name ILIKE '%git%' 
   OR comment ILIKE '%git%';

select * from snowflake.account_usage.access_history
where user_name;

select * from snowflake.account_usage.database_storage_usage_history;