/* 
    The DYNAMIC Stored Procedure defined in this file takes as optional input an array which contains the business names of tables into which we wish to load        data.
    
    This data initially resides within CSV files which themselevs reside within a folder per business entity, within a designated S3 bucket.
    For example, within the S3 bucket path, there's a folder named customers which contains CSV file holding customer-related data, a folder names orders which      contains CSV file holding orders-related data and so on.

    If there is no input provided to the SP while calling it, it'll iterate through ALL the sources mentioned in ingestion_config table with ENABLED flag set to     TRUE and laod data from their corresponding S3 folder to their respective RAW table.
    If a valid input is provided, it'll ONLY load the sources mentioned in the INPUT ARRAY.

    Some explanations about choices of configuration for creation of this metadata_driven_ingestion PoC - 
    1. In Snowflake Scripting, you do not use the colon (:) prefix when assigning a value to a variable. The colon is only used to bind a           variable inside a SQL statement (like SELECT or INSERT).
    2. In Snowflake Scripting, you do not use the FETCH command inside a FOR loop to retrieve values. A FOR loop over a cursor automatically        fetches the next row and provides it to you as a record object. 
       To access multiple columns, you use dot notation on the loop's row variable.
    3. Room for improvement : If the target table has columns specifically for _FILENAME and _INGESTDATE, we can define them as Default             Values in the table definition (e.g., _FILENAME VARCHAR DEFAULT METADATA$FILENAME). This allows us to use a simple COPY INTO with            MATCH_BY_COLUMN_NAME. If you can't change the table, you must build a much more complex SELECT statement in the sql_command.
    4. I had to also alter the target table to enable SCHEMA_EVOLUTION to avoid manual positional mapping within the dynamic COPY INTO               command I created. 
    5. By default, Snowflake throws an error if the number of columns in the file doesn't match the table. Setting this to FALSE allows the          load to proceed even if the file has more or fewer columns than the table.
    6. Ensure the role executing the load has the EVOLVE SCHEMA or OWNERSHIP privilege on the target table. 
    7. Other learnings related to File Format and stages are documented in their respective files within the PoC folder
*/

USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

create or replace procedure sp_copy_into_dynamic(table_list_array ARRAY DEFAULT NULL)
RETURNS STRING
LANGUAGE SQL
AS
DECLARE
        current_db varchar(24);
        current_schem varchar(10);
        res RESULTSET;
        source_name varchar(500);
        file_format varchar(500);
        enabled boolean;
        target_table_name varchar(500);
        s3_folder_path varchar(500);
        sql_command varchar(2000);
        /* invalid_ip_exception EXCEPTION (-20002, 'Raised invalid_ip_exception.'); */
        /* Commenting line above as the EXCEPTION is not used below. */
BEGIN
    select current_database(), current_schema() into :current_db, :current_schem; /* Not really required as I am setting the context at the beginning of the script itself. */
    IF (:table_list_array is NULL) THEN /* Load into ALL ENABLEd sources within INGESTION_CONFIG. */
        let cur1 CURSOR FOR select source_name, file_format, target_table_name, s3_folder_path, enabled from INGESTION_CONFIG; --
        FOR record in cur1 DO
           source_name := record.source_name;
           file_format := record.file_format;
           enabled := record.enabled;
           target_table_name := record.target_table_name;
           s3_folder_path := record.s3_folder_path;
           IF (enabled = TRUE) THEN 
           /* Creating a Dynamic SQL statement is more generic and need not be Snowflake-specific. Also, binding variables was causing one              issue after another. Dynamic SQL took less time to implement. */
                sql_command := 'COPY INTO ' || target_table_name || 
                               ' FROM @EXT_STAGE_FOR_POC_01/' || source_name || '/' ||  
                               ' INCLUDE_METADATA = (_FILENAME = METADATA$FILENAME, _INGESTDATE = METADATA$START_SCAN_TIME)
                                 FILE_FORMAT = (FORMAT_NAME = ' || file_format || 
                               ')' || ' MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
                ';
                execute immediate :sql_command;
            ELSE
                CONTINUE;
            END IF;
        END FOR;
        CLOSE cur1;
    ELSE /* Load into ONLY REQUESTED ENABLEd sources within INGESTION_CONFIG. */
        /* IF(IS_ARRAY(table_list_array::VARIANT) = FALSE) THEN
            RAISE invalid_ip_exception;
        END IF;
        */
        /* No need to handle this particular type of EXCEPTION as checking the type of INPUT parameter is taken care of in the declaration part of SP itself.*/
        res := (SELECT source_name, file_format, target_table_name, enabled 
                FROM INGESTION_CONFIG
                WHERE source_name IN (SELECT value::string FROM TABLE(FLATTEN(INPUT => :table_list_array))));
        FOR record in res DO
           source_name := record.source_name;
           file_format := record.file_format;
           enabled := record.enabled;
           target_table_name := record.target_table_name;
           IF (enabled = TRUE) THEN
                    sql_command := 'COPY INTO ' || target_table_name || 
                                   ' FROM @EXT_STAGE_FOR_POC_01/' || source_name || '/' ||  
                                   ' INCLUDE_METADATA = (_FILENAME = METADATA$FILENAME, _INGESTDATE = METADATA$START_SCAN_TIME)
                                     FILE_FORMAT = (FORMAT_NAME = ' || file_format || 
                                   ')' || ' MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
                    ';
                execute immediate :sql_command;
            ELSE
                CONTINUE;
            END IF;
        END FOR;
    END IF;
    RETURN 'Success !!';
END;

