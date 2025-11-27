select distinct salespersonid
from sales.salesorderheader
order by 1 desc;

select SalesPersonID, COUNT(*) Count from Sales.SalesOrderHeader
-- where SalesPersonID is NULL 
-- where SalesOrderID = 75084
-- order by OrderDate desc
group by SalesPersonID
order by 2 DESC
;

select * from information_schema.columns where lower(table_name) = 'salesorderheader';

INSERT INTO sales.salesorderheader (SALESORDERID
,REVISIONNUMBER
,ORDERDATE
,DUEDATE
,SHIPDATE
,STATUS
,ONLINEORDERFLAG
,SALESORDERNUMBER
,PURCHASEORDERNUMBER
,ACCOUNTNUMBER
,CUSTOMERID
,SALESPERSONID
,TERRITORYID
,BILLTOADDRESSID
,SHIPTOADDRESSID
,SHIPMETHODID
,CREDITCARDID
,CREDITCARDAPPROVALCODE
,CURRENCYRATEID
,SUBTOTAL
,TAXAMT
,FREIGHT
,TOTALDUE
,COMMENT
,ROWGUID
,MODIFIEDDATE) values
(75124,	8,	'2014-05-31',	'2014-06-12', '2014-06-07', 5,	FALSE,	'SO43659',	'PO522145787',	'10-4020-000676',	'29825', 	276,	5,	985,	985,	5,	16281,	'105041Vi84182',NULL,189.9700,	20565.6206,	1971.5149,	125000,NULL,		'79b65321-39ca-4115-9cba-8fe0903e12e6',	'2011-06-07');

select * from table(INFORMATION_SCHEMA.TASK_HISTORY()) order by completed_time desc;

delete from sales.salesorderheader where salesorderid = '75124';

select top 10 * from sales.salesorderheader order by salesorderid desc
where salesorderid = 75084;

select top 10 * from sales.salesorderdetail
where salesorderid = 75084;

ALTER WAREHOUSE compute_learning SET WAREHOUSE_SIZE = xsmall;

select top 10 * from sales.salesperson;

select top 10 * from HUMANRESOURCES.EMPLOYEE;

/* Below query will work with any DB. */
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

call update_2014_top_salespeople();

select * from "2014_top_salespeople" order by salesperson_rank;

CREATE OR REPLACE STREAM sales_order_header_stream ON TABLE SALES.SALESORDERHEADER;

show tasks;

ALTER TASK TRIGGERED_BY_STREAM_TASK RESUME;

CREATE OR REPLACE TASK TRIGGERED_BY_STREAM_TASK 
WAREHOUSE = 'COMPUTE_LEARNING'
WHEN SYSTEM$STREAM_HAS_DATA('sales_order_header_stream')
AS
    call update_2014_top_salespeople();

SELECT salespersonid, SUM(totaldue) as total_due
FROM sales.salesorderheader
WHERE DATE_PART(YEAR, orderdate) = 2014
GROUP BY salespersonid
ORDER BY total_due DESC
LIMIT 10;

ALTER WAREHOUSE COMPUTE_LEARNING SET WAREHOUSE_SIZE = '2x-large';

select MAX(orderdate) from sales.salesorderheader
where salespersonid = 280 and DATE_PART(YEAR, orderdate) = 2014;