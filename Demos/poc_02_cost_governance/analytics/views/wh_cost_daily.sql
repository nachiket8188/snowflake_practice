USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

CREATE VIEW wh_daily_cost AS
SELECT
    TO_DATE(start_time) date,
    warehouse_id,
    warehouse_name,
    SUM(credits_used) credits_used,
    SUM(credits_used_compute) credits_used_compute,
    SUM(credits_used_cloud_services) credits_used_cloud_services,
    SUM(credits_attributed_compute_queries) credits_attributed_compute_queries
FROM
    SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
GROUP BY
    date,
    warehouse_id,
    warehouse_name
ORDER BY
    date,
    credits_used desc;

select
    date,
    warehouse_id,
    warehouse_name,
    credits_used,
    credits_used_compute,
    credits_used_cloud_services,
    credits_attributed_compute_queries
from
    wh_daily_cost;