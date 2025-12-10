show stages;

select distinct event_timestamp from snowflake.account_usage.login_history order by event_timestamp desc;

select top 10 * from snowflake.account_usage.metering_history;

select SUM(credits_used) Credits from snowflake.account_usage.metering_history
where DATE_TRUNC(DAY, start_time) = '2025-11-29';

select * from ADVENTUREWORKS.HUMANRESOURCES.DEPARTMENT;

select * from information_schema.tables
where table_catalog = 'ADVENTUREWORKS'
and ROW_COUNT is not null;

select current_region();

show network policies;

show organization accounts;

show stages;

LIST @%Employee;

PUT 'file:///Users/nachiket/Projects/SQL Scripts/AdventureWorks Tables CSVs/HumanResources/Employee.csv' @HUMA
                                                       NRESOURCES.%Employee;
CREATE OR REPLACE FILE FORMAT ff_employee_csv 
TYPE = CSV,
FIELD_DELIMITER = ',',
RECORD_DELIMITER = '\n',
SKIP_HEADER = 1,
DATE_FORMAT = 'YYYY-MM-DD',
COMMENT = 'To be used while moving data from the Table Stage @HumanResources.%Employee to corresponding table';

show file formats;

COPY INTO HUMANRESOURCES.EMPLOYEE FROM @HUMANRESOURCES.%EMPLOYEE PURGE = TRUE FILE_FORMAT = 'ff_employee_csv';

select * from employee
order by vacationhours desc
limit 1 offset 4;

select * from information_schema.columns where
UPPER(table_name) = 'EMPLOYEE';

select * from snowflake.account_usage.load_history;

select * from snowflake.account_usage.copy_history;
/* not getting rows for Employee table due to lag for this particular ACCOUNT_USAGE schema view*/

select * from information_schema.load_history;

select * from snowflake.account_usage.query_history 
where query_type = 'COPY' -- and execution_status = 'SUCCESS'
order by start_time desc;

select * from snowflake.account_usage.table;

select * from TABLE(VALIDATE(AdventureWorks.HumanResources.Employee, JOB_ID=>'01c0d224-3202-2803-0011-cefe0001f332'));

select * from department;

SELECT *
 FROM TABLE(
   INFER_SCHEMA(
     LOCATION=>'@%Employee'
     , FILE_FORMAT=>'ff_employee_csv'
     )
   );

   