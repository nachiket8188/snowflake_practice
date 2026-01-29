/*
So basically, this stored procedure will only get executed if at all there are any queries that are marked for abortion because they have been identified as long-running queries, and the CALL statement for this particular stored procedure is within a child task, the execution of which is dependent on the root task.
*/

USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

CREATE OR REPLACE PROCEDURE SP_KILL_QUERY()
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
EXECUTE AS CALLER
AS
DECLARE
    rs RESULTSET DEFAULT (select 
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
                            actual_execution_time,
                            MARKED_FLAG
                        from marked_running_queries
                        where MARKED_FLAG = 'Y'
                        );
    query_id varchar(400);
BEGIN
    FOR record IN rs DO
        query_id := record.query_id;
        SELECT SYSTEM$CANCEL_QUERY(:query_id);
    END FOR;
RETURN 'Success !!';
END;
