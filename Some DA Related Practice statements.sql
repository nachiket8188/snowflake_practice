create database interview_prep;

use database interview_prep;

create schema data_analysis;

use schema data_analysis;

-- https://datalemur.com/blog/snowflake-sql-interview-questions

-- Question 1

create table marketing_touches (event_id integer, contact_id integer, event_type varchar, 
event_date date);

insert into marketing_touches values(1,	1,	'webinar',	'4/17/2022'),
(2,	1,	'trial_request',	'4/23/2022'),
(3,	1,	'whitepaper_download',	'4/30/2022'),
(4,	2,	'handson_lab',	'4/19/2022'),
(5,	2,	'trial_request',	'4/23/2022'),
(6,	2,	'conference_registration',	'4/24/2022'),
(7,	3,	'whitepaper_download',	'4/30/2022'),
(8,	4,	'trial_request',	'4/30/2022'),
(9,	4,	'webinar',	'5/14/2022');

select * from marketing_touches;

create table crm_contacts (contact_id integer, email varchar);

insert into crm_contacts values(1, 'andy.markus@att.net'),
(2, 'rajan.bhatt@capitalone.com'),
(3, 'lissa_rogers@jetblue.com'),
(4, 'kevinliu@square.com');

select * from crm_contacts;

select * from crm_contacts cc where exists 
(select 1 from marketing_touches mt where mt.contact_id = cc.contact_id
and mt.event_type = 'trial_request'
); -- practice query

-- My Attempt
with first_cte as (
    select event_id,
        contact_id,
        event_type,
        event_date,
        LAG(event_date) IGNORE NULLS OVER (
            PARTITION BY contact_id
            ORDER BY event_date
        ) previous_date
    from marketing_touches mt
    order by contact_id,
        event_date
),
second_cte as (
    select event_id,
        contact_id,
        event_type,
        event_date,
        previous_date,
        datediff('week', event_date, previous_date) week_diff
    from first_cte
),
-- select * from second_cte;
third_cte as (
    select contact_id,
        event_type,
        event_date,
        previous_date,
        week_diff,
        COUNT_IF(week_diff = -1) OVER(PARTITION BY contact_id) contact_ids_with_3_consecutive_week_dates
    from second_cte
)
select distinct cc.email
from third_cte
    inner join crm_contacts cc on third_cte.contact_id = cc.contact_id
where contact_ids_with_3_consecutive_week_dates = 2
    and EXISTS (
        select 1
        from marketing_touches mt
        where third_cte.contact_id = mt.contact_id
            and mt.event_type = 'trial_request'
    );

-- answer from the website
WITH consecutive_events_cte AS (
  SELECT
    event_id,
    contact_id, 
    event_type, 
    DATE_TRUNC('week', event_date) AS current_week,
    LAG(DATE_TRUNC('week', event_date)) OVER (
      PARTITION BY contact_id 
      ORDER BY DATE_TRUNC('week', event_date)) AS lag_week,
    LEAD(DATE_TRUNC('week', event_date)) OVER (
      PARTITION BY contact_id 
      ORDER BY DATE_TRUNC('week', event_date)) AS lead_week
FROM marketing_touches)

SELECT DISTINCT contacts.email
FROM consecutive_events_cte AS events
INNER JOIN crm_contacts AS contacts
  ON events.contact_id = contacts.contact_id
WHERE events.lag_week = events.current_week - INTERVAL '1 week'
  OR events.lead_week = events.current_week + INTERVAL '1 week'
  AND events.contact_id IN (
    SELECT contact_id 
    FROM marketing_touches 
    WHERE event_type = 'trial_request'
  );

-- =====================================================================================================================
  
-- Question 2

create table reviews (review_id integer, user_id integer, submit_date date, product_id integer, stars integer);

insert into reviews values (6171,	123,	'06/08/2022 00:00:00',	50001,	4),
(7802,	265,	'06/10/2022 00:00:00',	69852,	4),
(5293,	362,	'06/18/2022 00:00:00',	50001,	3),
(6352,	192,	'07/26/2022 00:00:00',	69852,	3),
(4517,	981,	'07/05/2022 00:00:00',	69852,	2);

select product_id, submit_date, review_id, user_id, stars from reviews order by product_id, submit_date;

-- My attempt

select distinct product_id, MONTHNAME(submit_date) month,
AVG(stars) OVER(PARTITION BY product_id, MONTHNAME(submit_date)) Avergae_Rating
from reviews
order by product_id, MONTHNAME(submit_date);

-- Answer from Website (same as my attempt)

-- =====================================================================================================================

-- Question 3

-- My Attempt

select event_id, event_type, event_date, TO_CHAR(event_date, 'Mon-YY')
from marketing_touches
where TO_CHAR(event_date, 'Mon-YY') = 'Apr-22'
and event_type = 'webinar';

select ROUND( ( COUNT_IF(event_type='webinar') / COUNT(*) ) * 100 ) Prct
from marketing_touches mt
where TO_CHAR(event_date, 'Mon-YY') = 'Apr-22';
-- and event_type = 'webinar';

-- Answer from website

SELECT 
  ROUND(100 *
    SUM(CASE WHEN event_type='webinar' THEN 1 ELSE 0 END)/
    COUNT(*)) as webinar_pct
FROM marketing_touches
WHERE DATE_TRUNC('month', event_date) = '04/01/2022';

-- =====================================================================================================================

-- Question 4

create table product_usage (log_id integer, user_id integer, product_id integer, usage_date date, usage_time time);


describe table product_usage;

insert into product_usage values
(1021,	203,	3001,	'06/01/2022',	'05:30:00'),
(1078,	254,	5001,	'07/01/2022',	'18:45:00'),
(1033,	420,	5001,	'08/01/2022',	'10:10:00'),
(1050,	203,	3001,	'09/01/2022',	'14:55:00'),
(1105,	642,	7001,	'10/01/2022',	'19:30:00')
;

select * from product_usage;

-- my attempt

select product_id, COUNT(*) No_Of_times_used, COUNT(distinct user_id) distinct_users from product_usage
group by product_id
order by product_id;

-- Answer from website

-- =====================================================================================================================

-- Question 6

create table purchases (purchase_id integer, customer_id integer, purchase_date date, purchase_amount integer);

insert into purchases values
(6213,	154,	'06/15/2022',	750),
(8505,	896,	'05/08/2022',	300),
(3846,	697,	'07/25/2022',	600),
(2910,	540,	'08/12/2022',	450)
;

select * from purchases;

create table customers (customer_id integer, first_name varchar, last_name varchar, country varchar, last_login_date date);

insert into customers values
(154,	'John',	'Smith',	'USA',	'07/15/2022'),
(896,	'Maria',	'Johnson',	'USA',	'08/10/2021'),
(697,	'Sarah',	'Davis',	'CAN',	'06/30/2022'),
(540,	'David',	'Brown',	'USA',	'08/12/2019')
;

select * from customers;

select * from customers c inner join purchases p on c.customer_id = p.customer_id
where ;

WITH Src AS
(
    SELECT * FROM (VALUES
    ('CAT', 'ACT'),
    ('CAR', 'RAC'),
    ('BUZ', 'BUS'),
    ('FUZZY', 'MUZZY'),
    ('PACK', 'PACKS'),
    ('AA', 'AA'),
    ('ABCDEFG', 'GFEDCBA')) T(W1, W2)
), Numbered AS
(
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) Num
    FROM Src
)
-- select * from NUMBERED;
, Splitted AS
(
    SELECT Num, W1 Word1, W2 Word2, LEFT(W1, 1) L1, LEFT(W2, 1) L2, SUBSTRING(W1, 2, LEN(W1)) W1, SUBSTRING(W2, 2, LEN(W2)) W2
    FROM Numbered
    UNION ALL
    SELECT Num, Word1, Word2, LEFT(W1, 1) L1, LEFT(W2, 1) L2, SUBSTRING(W1, 2, LEN(W1)) W1, SUBSTRING(W2, 2, LEN(W2)) W2
    FROM Splitted
    WHERE LEN(W1)>0 AND LEN(W2)>0
)
-- select * from SPLITTED;
, SplitOrdered AS
(
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY Num ORDER BY L1) LNum1,
        ROW_NUMBER() OVER (PARTITION BY Num ORDER BY L2) LNum2
    FROM Splitted
)
SELECT S1.Num, S1.Word1, S1.Word2, CASE WHEN COUNT(*)=LEN(S1.Word1) AND COUNT(*)=LEN(S1.Word2) THEN 1 ELSE 0 END Test
FROM SplitOrdered S1
JOIN SplitOrdered S2 ON S1.L1=S2.L2 AND S1.Num=S2.Num AND S1.LNum1=S2.LNum2
GROUP BY S1.Num, S1.Word1, S1.Word2;

-- ======================================= Semi-Structured Data Practice ============================================================

create or replace transient table json_demo (v variant);

insert into json_demo
 select
 parse_json(
 '{
 "fullName": "Johnny Appleseed",
 "age": 42,
 "gender": "Male",
 "phoneNumber": {
 "areaCode": "415",
 "subscriberNumber": "5551234"
 },
 "children": [
 { "name": "Jayden", "gender": "Male", "age": "10" },
 { "name": "Emma", "gender": "Female", "age": "8" },
 { "name": "Madelyn", "gender": "Female", "age": "6" }
 ],
 "citiesLived": [
 { "cityName": "London",
 "yearsLived": [ "1989", "1993", "1998", "2002" ]
 },
 { "cityName": "San Francisco",
 "yearsLived": [ "1990", "1993", "1998", "2008" ]
 },
 { "cityName": "Portland",
 "yearsLived": [ "1993", "1998", "2003", "2005" ]
 },
 { "cityName": "Austin",
 "yearsLived": [ "1973", "1998", "2001", "2005" ]
 }
 ]
 }');

select * from json_demo;

select v:fullName::string as full_name,
v:age::integer as age,
v:gender::string as gender
from json_demo;

select 
v:phoneNumber.areaCode::string as area_code,
v:phoneNumber.subscriberNumber::string as sub_number
from json_demo;

select array_size(v:children) from json_demo;

select 
f.value:name::string as child_name,
f.value:age::int as child_age,
f.value:name::string as child_name,
from json_demo, table(flatten(v:children)) as f;

select 
f.value:name::string as child_name,
f.value:age::int as child_age,
f.value:gender::string as child_gender
from json_demo, lateral flatten(v:children) as f;
-- same output

/*
PIVOT in Snowflake - Simple Demo.
*/

create table monthly_sales (empid number, amount number, month varchar(3));

INSERT INTO monthly_sales
 (empid, amount, month) VALUES
    (1, 10000, 'JAN'), 
    (1, 400, 'JAN'),
    (2, 4500, 'JAN'),
    (2, 35000, 'JAN'),
    (1, 5000, 'FEB'),
    (1, 3000, 'FEB'),
    (2, 200, 'FEB'),
    (2, 90500, 'FEB'),
    (1, 6000, 'MAR'),
    (1, 5000, 'MAR'),
    (2, 2500, 'MAR'),
    (2, 9500, 'MAR');

select * from monthly_sales;

select * from monthly_sales
PIVOT(sum(amount) for month in ('JAN', 'FEB', 'MAR')) as p
order by empid;