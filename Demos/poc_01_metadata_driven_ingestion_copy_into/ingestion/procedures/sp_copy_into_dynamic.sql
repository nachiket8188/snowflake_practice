USE DATABASE SNOWFLAKE_PRACTICE_DEV;

USE SCHEMA RAW;

truncate table t1;

desc table INGESTION_CONFIG;

UPDATE INGESTION_CONFIG SET TARGET_TABLE_NAME = 'SHIPMENTS_RAW' where file_format = 'FF_CSV_SHIPMENTS';

select source_name, file_format, target_table_name, s3_folder_path, enabled from SNOWFLAKE_PRACTICE_DEV.RAW.INGESTION_CONFIG;

select column_name from information_schema.columns where table_catalog = 'SNOWFLAKE_PRACTICE_DEV' and TABLE_SCHEMA = 'RAW'
and table_name = 'CUSTOMERS_RAW' order by ordinal_position;

SELECT LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY ORDINAL_POSITION) AS column_array
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'CUSTOMERS_RAW'
  AND TABLE_SCHEMA = 'RAW';


create or replace procedure sp_copy_into_dynamic(table_list_array ARRAY DEFAULT NULL)
RETURNS STRING
LANGUAGE SQL
AS
DECLARE
        current_db varchar(24);
        current_schem varchar(10);
        temp varchar(200);
        rs RESULTSET := (select value::STRING as val from TABLE(FLATTEN(INPUT => :table_list_array)));
        source_name varchar(500);
        file_format varchar(500);
        enabled boolean;
        target_table_name varchar(500);
        s3_folder_path varchar(500);
        sql_command varchar(2000);
        cur1 CURSOR FOR select source_name, file_format, target_table_name, s3_folder_path, enabled from INGESTION_CONFIG;
BEGIN
    select current_database(), current_schema() into :current_db, :current_schem;
    IF (:table_list_array is NULL) THEN
        FOR record in cur1 DO
           source_name := record.source_name;
           file_format := record.file_format;
           enabled := record.enabled;
           target_table_name := record.target_table_name;
           s3_folder_path := record.s3_folder_path;
           IF (enabled = TRUE) THEN
                sql_command := 'COPY INTO ' || target_table_name || 
                               ' FROM @EXT_STAGE_FOR_POC_01/' || source_name || '/' ||  
                               ' INCLUDE_METADATA = (_FILENAME = METADATA$FILENAME, _INGESTDATE = METADATA$START_SCAN_TIME)
                                 FILE_FORMAT = (FORMAT_NAME = ' || file_format || 
                               ')' || ' MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
                ';
                execute immediate :sql_command;
            ELSE
                RETURN 'Within Else Block.';
            END IF;
        END FOR;
    END IF;
    RETURN 'Something';
END;

call sp_copy_into_dynamic();

select * from information_schema.load_history;

truncate table customers_raw;
truncate table orders_raw;
truncate table payments_raw;
truncate table products_raw;
truncate table shipments_raw;

