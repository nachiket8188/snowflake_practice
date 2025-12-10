ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

/* During this BUILD camp, the utility of Cortex Search Service, Cortex Analyst was demonstrated. 

Initially, we built Cortex Search Service to try and get answers to analyis related questions in a chat-like interface.

Next, building on top of that, we created Cortex Analyst which leverages capabilities of Snowflake Intelligence Arctic Model to reason and answers questions based on the data that's been made available to it.

Next step was to create a Scalar function and a UDTF (custom functions), which were made available to the Cortex Analyst Agent as tools for better answering the questions asked by user.

Following GitHub repos were used (completely or partially) as reference points to follow the code-along parts of the camp.

1. https://github.com/Snowflake-Labs/sfguide-getting-started-with-snowflake-intelligence/tree/main
2. https://github.com/MLH/build25-udf-udtf-examples
3. https://github.com/Snowflake-Labs/builder-workshops
4. https://github.com/MLH/build25-snowflake-autograder-scripts


*/

use role accountadmin;

create or replace role snowflake_intelligence_admin;
grant create warehouse on account to role snowflake_intelligence_admin;
grant create database on account to role snowflake_intelligence_admin;
grant create integration on account to role snowflake_intelligence_admin;

set current_user = (select current_user());   
grant role snowflake_intelligence_admin to user identifier($current_user);
alter user set default_role = snowflake_intelligence_admin;
alter user set default_warehouse = nick_wh_si;

use role snowflake_intelligence_admin;
create or replace database nick_db_si;
create or replace schema retail;
create or replace warehouse nick_wh_si with warehouse_size='medium';

create database if not exists snowflake_intelligence;
create schema if not exists snowflake_intelligence.agents;

grant create agent on schema snowflake_intelligence.agents to role snowflake_intelligence_admin;

use database nick_db_si;
use schema retail;
use warehouse nick_wh_si;

create or replace file format swt_csvformat  
  skip_header = 1  
  field_optionally_enclosed_by = '"'  
  type = 'csv';  
  
-- create table marketing_campaign_metrics and load data from s3 bucket
create or replace stage swt_marketing_data_stage  
  file_format = swt_csvformat  
  url = 's3://sfquickstarts/sfguide_getting_started_with_snowflake_intelligence/marketing/'
  DIRECTORY = (ENABLE = TRUE);
;  
  
create or replace table marketing_campaign_metrics (
  date date,
  category varchar(16777216),
  campaign_name varchar(16777216),
  impressions number(38,0),
  clicks number(38,0)
);

copy into marketing_campaign_metrics  
  from @swt_marketing_data_stage;

-- select * from DIRECTORY('@swt_marketing_data_stage'); -- run by me to check content of the Stage

-- create table products and load data from s3 bucket
create or replace stage swt_products_data_stage  
  file_format = swt_csvformat  
  url = 's3://sfquickstarts/sfguide_getting_started_with_snowflake_intelligence/product/'
  DIRECTORY = (ENABLE = TRUE);
;  
  
create or replace table products (
  product_id number(38,0),
  product_name varchar(16777216),
  category varchar(16777216)
);

copy into products  
  from @swt_products_data_stage;

-- create table sales and load data from s3 bucket
create or replace stage swt_sales_data_stage  
  file_format = swt_csvformat  
  url = 's3://sfquickstarts/sfguide_getting_started_with_snowflake_intelligence/sales/'
    DIRECTORY = (ENABLE = TRUE)
;  
  
create or replace table sales (
  date date,
  region varchar(16777216),
  product_id number(38,0),
  units_sold number(38,0),
  sales_amount number(38,2)
);

copy into sales  
  from @swt_sales_data_stage;

-- create table social_media and load data from s3 bucket
create or replace stage swt_social_media_data_stage  
  file_format = swt_csvformat  
  url = 's3://sfquickstarts/sfguide_getting_started_with_snowflake_intelligence/social_media/'
    DIRECTORY = (ENABLE = TRUE);  
  
create or replace table social_media (
  date date,
  category varchar(16777216),
  platform varchar(16777216),
  influencer varchar(16777216),
  mentions number(38,0)
);

copy into social_media  
  from @swt_social_media_data_stage;

-- create table support_cases and load data from s3 bucket
create or replace stage swt_support_data_stage  
  file_format = swt_csvformat  
  url = 's3://sfquickstarts/sfguide_getting_started_with_snowflake_intelligence/support/'
    DIRECTORY = (ENABLE = TRUE);
;  
  
create or replace table support_cases (
  id varchar(16777216),
  title varchar(16777216),
  product varchar(16777216),
  transcript varchar(16777216),
  date date
);


copy into support_cases  
  from @swt_support_data_stage;

create or replace stage semantic_models encryption = (type = 'snowflake_sse') directory = ( enable = true );

/* Below stmts were not run during the workshop. */
-- create or replace notification integration email_integration
--   type=email
--   enabled=true
--   default_subject = 'snowflake intelligence';

-- create or replace procedure send_email(
--     recipient_email varchar,
--     subject varchar,
--     body varchar
-- )
-- returns varchar
-- language python
-- runtime_version = '3.12'
-- packages = ('snowflake-snowpark-python')
-- handler = 'send_email'
-- as
-- $$
-- def send_email(session, recipient_email, subject, body):
--     try:
--         # Escape single quotes in the body
--         escaped_body = body.replace("'", "''")
        
--         # Execute the system procedure call
--         session.sql(f"""
--             CALL SYSTEM$SEND_EMAIL(
--                 'email_integration',
--                 '{recipient_email}',
--                 '{subject}',
--                 '{escaped_body}',
--                 'text/html'
--             )
--         """).collect()
        
--         return "Email sent successfully"
--     except Exception as e:
--         return f"Error sending email: {str(e)}"
-- $$;

ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';

select 'Congratulations! Snowflake Intelligence setup has completed successfully!' as status;

/* 
The next step is used to CREATE a Coretx Search Service using AI & ML Setting in the left-most pane. and to do so the role needs to be changed from that pane to Snowflake_Intelligence_Admin. Then only it'll work. 
*/

DESC STAGE swt_support_data_stage;

SHOW STAGES;

/*
Cortex Analyst is an AI Agent. Agentic AI is different from AI Agent.  
*/

-- UDF and UDTF Example in Snowflake SQL
-- This script was created for workshops in relation to Snowflake's Season of Build 2025.

-- Set the role, database, and schema context
USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE NICK_DB_SI;
USE SCHEMA RETAIL;

-- Display all existing functions
SHOW FUNCTIONS;

-- Create or replace a simple UDF that rounds a FLOAT to the nearest whole number using Python UDF
CREATE OR REPLACE FUNCTION RoundToWhole(value FLOAT)
    RETURNS NUMBER
    LANGUAGE PYTHON
    RUNTIME_VERSION = '3.13'
    HANDLER = 'round_value'
AS $$
def round_value(value):
    if value is None:
        return None
    return round(value, 0)
$$;

-- Show the created python UDF
SHOW FUNCTIONS LIKE 'RoundToWhole';

-- Display the Sales table
SELECT * FROM SALES;

-- Display the Sales table with rounded sales amounts using the RoundToWhole UDF
SELECT 
    DATE,
    REGION,
    PRODUCT_ID,
    UNITS_SOLD,
    RoundToWhole(SALES_AMOUNT) AS rounded_sales_amount
FROM SALES
ORDER BY 
    DATE,
    CASE WHEN UPPER(REGION) = 'NORTH' THEN 0 ELSE 1 END,
    REGION,
    PRODUCT_ID;

-- Create or replace a UDTF that calculates average price per unit of a product for each sale record using SQL UDTF
-- SQL UDTFs are generally more efficient
CREATE OR REPLACE FUNCTION AvgPricePerUnitProductPerSale()
    RETURNS TABLE (
        date DATE,
        region VARCHAR,
        product_id NUMBER,
        units_sold NUMBER,
        sales_amount NUMBER(38,2),
        avg_price_per_unit NUMBER(38,8)
    )
    LANGUAGE SQL
AS $$
    SELECT 
        DATE,
        REGION,
        PRODUCT_ID,
        UNITS_SOLD,
        SALES_AMOUNT,
        SALES_AMOUNT / UNITS_SOLD AS avg_price_per_unit
    FROM SALES
    WHERE UNITS_SOLD > 0
$$;

-- Show the created SQL UDTF
SHOW FUNCTIONS LIKE 'AvgPricePerUnitProductPerSale';

-- Call the UDTF to see average price per unit of a product for each sale record
SELECT * FROM TABLE(AvgPricePerUnitProductPerSale()) ORDER BY PRODUCT_ID, REGION;

-- Using the UDF and the UDTF, create a view with the average price per unit of a product for each sale record rounded to whole number
CREATE OR REPLACE VIEW avg_price_per_unit_product_per_sale AS
SELECT 
    PRODUCT_ID,
    REGION,
    RoundToWhole(avg_price_per_unit) AS rounded_avg_price_per_unit
FROM TABLE(AvgPricePerUnitProductPerSale());

-- Creates a new table PRODUCTS_WITH_AVG_PRICE that enriches the PRODUCTS table with the average of the rounded average prices from the avg_price_per_unit_product_per_sale view.
CREATE OR REPLACE TABLE PRODUCTS_WITH_AVG_PRICE AS
SELECT 
    p.*,
    ROUND(COALESCE(AVG(a.rounded_avg_price_per_unit), 2), 2) AS avg_price
FROM PRODUCTS p
LEFT JOIN avg_price_per_unit_product_per_sale a ON p.PRODUCT_ID = a.PRODUCT_ID
GROUP BY p.PRODUCT_ID, p.PRODUCT_NAME, p.CATEGORY;

-- Completion Message
SELECT 'UDF and UDTF creation and usage completed successfully!' AS status;

/*
Cleaning up compute to ensure that it is not left unchecked and runs any commands in the background hogging up credits. 
*/
DROP WAREHOUSE nick_wh_si;