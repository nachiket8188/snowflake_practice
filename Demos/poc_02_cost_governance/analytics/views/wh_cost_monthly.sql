USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

CREATE OR REPLACE VIEW wh_monthly_cost AS
SELECT
    TO_CHAR(start_time, 'Mon-YY') Month,
    TO_CHAR(start_time, 'YYYY-MM') month_yyyy_mm,
    warehouse_id,
    warehouse_name,
    SUM(credits_used) credits_used,
    SUM(credits_used_compute) credits_used_compute,
    SUM(credits_used_cloud_services) credits_used_cloud_services,
    SUM(credits_attributed_compute_queries) credits_attributed_compute_queries
FROM
    SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
GROUP BY
    month,
    warehouse_id,
    warehouse_name,
    month_yyyy_mm
ORDER BY
    month_yyyy_mm,
    credits_used desc;

select
    month,
    warehouse_id,
    warehouse_name,
    credits_used,
    credits_used_compute,
    credits_used_cloud_services,
    credits_attributed_compute_queries
from
    wh_monthly_cost;