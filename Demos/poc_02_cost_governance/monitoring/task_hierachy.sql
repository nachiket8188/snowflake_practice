/*
1. Initially, the thought was to create a single procedure which will handle the conditional logic about whether there are any running queries marked for abortion. 
2. Although, later I got an idea by searching online about separating the logic of checking whether there are any such queries qualifying this criteria at all and the logic of actually terminating them. 
3. This allowed me to learn about creating a task hierarchy in Snowflake and some details surrounding it. And it's also a good idea to isolate the logic, so if in the future the criteria which determines whether a query should be killed or not changes, it will require changes only in one place. The file is easier to maintain also. 
4. Also, for the actual termination of queries, I wanted to use a user maintained warehouse, which will get spun up for this particular task if and only if the root task returns a predefined value. 
5. The root task itself is taken care of or monitored by Snowflakes' serverless compute. Thus, for the execution of the root task, there are no user managed warehouses that are needed to spin up because even if for the root task, so let's say the root task, all it does is check if some queries need termination or not. For that, if it takes five seconds and if I use a user managed warehouse for that, then I will be charged for the whole 60 seconds because that's the minimum charge window by Snowflake for any user managed warehouse. So this way I save a little bit of cost also.
*/

USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

CREATE OR REPLACE TASK T_CHECK_MARKED_QUERIES
SCHEDULE = '30 MINUTES'
AS
    CALL sp_check_for_queries();


CREATE OR REPLACE TASK T_EXECUTE_QUERY_KILL
WAREHOUSE = 'COMPUTE_WH'
AFTER T_CHECK_MARKED_QUERIES
    WHEN SYSTEM$GET_PREDECESSOR_RETURN_VALUE('SP_CHECK_FOR_QUERIES') = 'RUN_KILL'
AS
    CALL SP_KILL_QUERY();

ALTER TASK T_CHECK_MARKED_QUERIES RESUME;

ALTER TASK T_EXECUTE_QUERY_KILL RESUME;
