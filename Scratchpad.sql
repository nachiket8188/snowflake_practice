list @EXT_STAGE_FOR_POC_01;

show stages;

drop stage ;

show integrations;

describe integration S3_INTEGRATION_FOR_POC_01;

SELECT * FROM customers_raw AT(OFFSET => -60*10);

select 
    * 
from snowflake.account_usage.copy_history
order by last_load_time desc;

SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
   TABLE_NAME => 'CUSTOMERS_RAW',
   START_TIME => DATEADD(hours, -5, CURRENT_TIMESTAMP())
));
