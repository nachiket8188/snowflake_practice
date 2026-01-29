USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

/* ACCOUNT_USAGE.QUERY_HISTORY won't cut it as it won't have any entries for currently running queries. HENCE, using INFORMATION_SCHEMA.QUERY_HISTORY() function. This function returns a table. */

select
    query_id,
    query_text,
    database_name,
    schema_name,
    query_type,
    user_name,
    role_name,
    warehouse_name,
    warehouse_size,
    warehouse_type,
    execution_status,
    start_time,
    end_time,
    total_elapsed_time,
    execution_time
from
    TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
where
    execution_status = 'RUNNING'
order by
    start_time desc;