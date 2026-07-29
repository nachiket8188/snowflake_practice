CREATE SHARE TRIAL_1;

select * from adventureworks.sales.currency;

select * from snowflake.account_usage.tables where row_count > 1 order by row_count desc;

GRANT USAGE ON DATABASE ADVENTUREWORKS TO SHARE TRIAL_1;

GRANT USAGE ON SCHEMA SALES TO SHARE TRIAL_1;

GRANT SELECT ON TABLE SALES.CURRENCY TO SHARE TRIAL_1;

ALTER SHARE TRIAL_1 ADD ACCOUNTS = FSRWGOB.JZC45830;

