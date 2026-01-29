USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

WITH base_cte AS (
    SELECT
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
        total_elapsed_time AS total_elapsed_time_in_milisec,
        execution_time,
        TIMEDIFF('MINUTES', start_time, end_time) AS actual_execution_time_in_min,
        DENSE_RANK() OVER(
            PARTITION BY warehouse_name
            ORDER BY
                total_elapsed_time_in_milisec DESC
        ) QUERY_RNK_WITHIN_WH
    FROM
        TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
    WHERE
        schema_name NOT IN ('TRUST_CENTER_STATE')
        AND execution_status <> 'RUNNING' QUALIFY QUERY_RNK_WITHIN_WH < 6
)
SELECT
    warehouse_name,
    query_id,
    query_text,
    database_name,
    query_type,
    schema_name,
    user_name,
    role_name,
    execution_status,
    start_time,
    end_time,
    total_elapsed_time_in_milisec,
    actual_execution_time_in_min,
    QUERY_RNK_WITHIN_WH
FROM
    base_cte
ORDER BY
    warehouse_name,
    actual_execution_time_in_min DESC;

