USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

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
    execution_time,
    TIMEDIFF('MINUTES', start_time, current_timestamp()) as actual_execution_time,
    /* For RUNNING queries, the end_time shows as Shows a UNIX epoch timestamp (e.g., 1970-01-01). Therefore, we need to use current_timestamp() */
    CASE WHEN actual_execution_time >= 15 THEN 'Y' ELSE 'N' END MARKED_FLAG
from
    TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
where
    execution_status = 'RUNNING'
order by
    start_time desc;
