/* All scripts in this file are for the purpose of demonstrating understanding of TASKS & STREAMS features in Snowflake. */

/* Initial script I ran to check if salesorderid is indeed Primary Key for salesOrderHeader table */
select top 10 * from sales.salesorderheader order by salesorderid desc
where salesorderid = 75084;

/* To check that there can be multiple occurrences of same salesorderid in salesOrderDetail table */
select top 10 * from sales.salesorderdetail
where salesorderid = 75084;

/* Below query will work with any DB. I used this query in the definition of Stored Procedure that is being created down below. */
with
    salespeople as (
        select
            soh.salespersonid,
            p.firstname || ' ' || p.lastname as full_name,
            SUM(totaldue) total_due
        from
            sales.salesorderheader soh
            inner join sales.salesperson sp on soh.salespersonid = sp.businessentityid
            inner join humanresources.employee emp on sp.businessentityid = emp.businessentityid
            inner join Person.BUSINESSENTITY be on emp.businessentityid = be.businessentityid
            inner join PERSON.PERSON p on be.businessentityid = p.businessentityid
        where
            DATE_PART (YEAR, soh.orderdate) = 2014
            and soh.salespersonid is not null
        group by
            soh.salespersonid,
            p.firstname || ' ' || p.lastname
    ),
    ranked_salespeople as (
        select
            salespeople.salespersonid,
            salespeople.full_name,
            total_due,
            RANK() OVER (
                ORDER BY
                    total_due desc
            ) as salesperson_rank
        from
            salespeople
    )
select
    salespersonid,
    full_name,
    total_due,
    salesperson_rank
from
    ranked_salespeople
where
    salesperson_rank <= 10;

/* Alternate Approach by leveraging QUALIFY clause in Snowflake. QUALIFY does seem to do the same thing with less code but it did not run the query successfully. Rather it ran into an error which points to running out of resources. Maybe. for this specific scenaio, it was not able to optimize the execution.
SQL execution internal error: Processing aborted due to error 300010:391167117; incident 8611483. 
*/

select soh.salespersonid, SUM(totaldue) as total_due, RANK() OVER(ORDER BY SUM(total_due)) as rank_salesperson
from sales.salesorderheader soh
where DATE_PART(YEAR, soh.orderdate) = 2014 and soh.salespersonid is not null
group by soh.salespersonid
QUALIFY rank_salesperson <= 10;

/* 
Creating Stored procedure that uses above SQL script to populate a summary table with top 10 SalesPeople ranking highest in sales. Every time a record gets inserted into the Sales.SalesOrderHeader table, this SP will get invoked and then the summary table will get re-populated.
*/

CREATE OR REPLACE PROCEDURE update_2014_top_salespeople()
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
    CREATE OR REPLACE TABLE "2014_top_salespeople" AS 
    with
    salespeople as (
        select
            soh.salespersonid,
            p.firstname || ' ' || p.lastname as full_name,
            SUM(totaldue) total_due
        from
            sales.salesorderheader soh
            inner join sales.salesperson sp on soh.salespersonid = sp.businessentityid
            inner join humanresources.employee emp on sp.businessentityid = emp.businessentityid
            inner join Person.BUSINESSENTITY be on emp.businessentityid = be.businessentityid
            inner join PERSON.PERSON p on be.businessentityid = p.businessentityid
        where
            DATE_PART (YEAR, soh.orderdate) = 2014
            and soh.salespersonid is not null
        group by
            soh.salespersonid,
            p.firstname || ' ' || p.lastname
    ),
    ranked_salespeople as (
        select
            salespeople.salespersonid,
            salespeople.full_name,
            total_due,
            RANK() OVER (
                ORDER BY
                    total_due desc
            ) as salesperson_rank
        from
            salespeople
    )
select
    salespersonid,
    full_name,
    total_due,
    salesperson_rank
from
    ranked_salespeople
where
    salesperson_rank <= 10;
    RETURN 'Success';
END;

/* Testing Stored Procedure */
call update_2014_top_salespeople();

/* Creating STREAM object on table salesOrderHeader to detect CDC */
CREATE OR REPLACE STREAM sales_order_header_stream ON TABLE SALES.SALESORDERHEADER;

/* Creating TASK to monitor STREAM and call Stored Procedure when desired condition is met. */
CREATE OR REPLACE TASK TRIGGERED_BY_STREAM_TASK 
WAREHOUSE = 'COMPUTE_LEARNING'
WHEN SYSTEM$STREAM_HAS_DATA('sales_order_header_stream')
AS
    call update_2014_top_salespeople();

/* By default, when a TASK is created, it's in SUSPENDED state. It needs to be RESUMEd. */

show tasks;

ALTER TASK TRIGGERED_BY_STREAM_TASK RESUME;

/* Check before CDC, whether the TASK has been triggered so far or not. Ideally, NOT. */

select * from table(INFORMATION_SCHEMA.TASK_HISTORY()) order by completed_time desc;

/* Check rankings of  Salespeople in the summary table. This will change after INSERT is successful and TASK is triggered.*/

select * from "2014_top_salespeople" order by salesperson_rank;

/* To get list of columns in salesOrderHeader table (to use in the INSERT statement below) order by their Ordinal Position */
select * from information_schema.columns where lower(table_name) = 'salesorderheader';

/* INSERTing this particular record changes the order of Salespeople in the TOP 10 list. The amount_due number has been specifically inflated to simulate that change. */

INSERT INTO
    sales.salesorderheader (
        SALESORDERID,
        REVISIONNUMBER,
        ORDERDATE,
        DUEDATE,
        SHIPDATE,
        STATUS,
        ONLINEORDERFLAG,
        SALESORDERNUMBER,
        PURCHASEORDERNUMBER,
        ACCOUNTNUMBER,
        CUSTOMERID,
        SALESPERSONID,
        TERRITORYID,
        BILLTOADDRESSID,
        SHIPTOADDRESSID,
        SHIPMETHODID,
        CREDITCARDID,
        CREDITCARDAPPROVALCODE,
        CURRENCYRATEID,
        SUBTOTAL,
        TAXAMT,
        FREIGHT,
        TOTALDUE,
        COMMENT,
        ROWGUID,
        MODIFIEDDATE
    )
values
    (
        75124,
        8,
        '2014-05-31',
        '2014-06-12',
        '2014-06-07',
        5,
        FALSE,
        'SO43659',
        'PO522145787',
        '10-4020-000676',
        '29825',
        276,
        5,
        985,
        985,
        5,
        16281,
        '105041Vi84182',
        NULL,
        189.9700,
        20565.6206,
        1971.5149,
        125000,
        NULL,
        '79b65321-39ca-4115-9cba-8fe0903e12e6',
        '2011-06-07'
    );

/* Used this a few times when I had to test INSERTion effects again-and-again */
/* delete from sales.salesorderheader where salesorderid = '75124'; */

/* Run following commands to check and confirm that the TASK, in fact, ran as a result of CDC in the salesOrderHeader table. */

select * from table(INFORMATION_SCHEMA.TASK_HISTORY()) order by completed_time desc;

select * from "2014_top_salespeople" order by salesperson_rank;