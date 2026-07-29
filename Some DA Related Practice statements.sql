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

-- Create the PURCHASES table
CREATE OR REPLACE TABLE PURCHASES (
    customer_id INT,
    product_id VARCHAR(10),
    purchase_date DATE
);

-- Insert the data rows as shown in the image
INSERT INTO PURCHASES (customer_id, product_id, purchase_date) VALUES
(1, 'B', '2024-01-03'),
(1, 'A', '2024-01-01'),
(1, 'A', '2024-01-05'),
(1, 'C', '2024-01-06'),
(2, 'B', '2024-01-02'),
(2, 'B', '2024-01-04');

-- Optional: Verify the inserted data
SELECT * FROM PURCHASES ORDER BY customer_id, purchase_date;

/* ◆ 8. Calculate cumulative distinct product purchases per customer
Objective:
For each customer and each purchase date, calculate the cumulative count of distinct products purchased so far. */
-- answer

with cte_1 as 
(
    select p.*, COUNT(product_id) OVER(PARTITION BY customer_id, purchase_date ORDER BY purchase_date) 
    as distinct_count
    from PURCHASES p
)
select * from cte_1;

-- ========================================================================================================================

/* Questions asked during EY Technical Round 1 Interview */

/* Question 1 : Given data like below, for each product in each quarter, find total sales amount. Instead of showing the Quarter names, use quarter end dates derived from report_date field. */

CREATE TABLE interview_prep.data_analysis.product_sales (report_date varchar(12), product_id int, value double);

INSERT INTO product_sales (report_date, product_id, value)
VALUES
('30-06-2025', 1, 100),
('01-04-2025', 2, 10000),
('02-03-2025', 4, 10000),
('03-09-2025', 3, 500),
('04-10-2025', 5, 600),
('05/06/2025', 3, 700),
('06/06/2025', 2, 800),
('07/05/2025', 3, 500),
('08-02-2025', 2, 350),
('09-12-2025', 1, 450);

select * from interview_prep.data_analysis.product_sales;

/* My Answer */

with base_cte as
(
select 
    REPORT_DATE, 
    TO_DATE(TO_VARCHAR(TO_DATE(REPLACE(REPORT_DATE, '/', '-'), 'DD-MM-YYYY')), 'YYYY-MM-DD') FORMATTED_DATE, 
    QUARTER(FORMATTED_DATE) REPORT_QTR, LAST_DAY(FORMATTED_DATE, 'QUARTER') QTR_END_DATE,
    PRODUCT_ID, 
    VALUE 
from INTERVIEW_PREP.DATA_ANALYSIS.PRODUCT_SALES
order by FORMATTED_DATE
)
select QTR_END_DATE, PRODUCT_ID, SUM(VALUE) total_sales
from base_cte
group by QTR_END_DATE, PRODUCT_ID
ORDER BY 1, 2;

/* Answer suggested by CGPT */

with base_cte as
(
select REPORT_DATE,
-- SUBSTR(REPORT_DATE, 4, 2) REPORT_MONTH_1,
TO_NUMBER(SUBSTR(REPORT_DATE, 4, 2)) REPORT_MONTH_1,
TO_NUMBER(SUBSTR(REPORT_DATE, 7, 4)) REPORT_YEAR,
CASE WHEN REPORT_MONTH_1 between 1 and 3 THEN 1
WHEN REPORT_MONTH_1 between 4 and 6 THEN 2
WHEN REPORT_MONTH_1 between 7 and 9 THEN 3
ELSE 4 END as REPORT_QTR, /* Extracted quarter here */
CASE WHEN REPORT_QTR = 1 THEN TO_DATE('31-03-' || REPORT_YEAR, 'DD-MM-YYYY')
WHEN REPORT_QTR = 2 THEN TO_DATE('30-06-' || REPORT_YEAR, 'DD-MM-YYYY')
WHEN REPORT_QTR = 3 THEN TO_DATE('30-09-' || REPORT_YEAR, 'DD-MM-YYYY')
WHEN REPORT_QTR = 4 THEN TO_DATE('31-12-' || REPORT_YEAR, 'DD-MM-YYYY') END AS QTR_END_DATE,
PRODUCT_ID, VALUE from INTERVIEW_PREP.DATA_ANALYSIS.PRODUCT_SALES
ORDER BY REPORT_QTR
)
select QTR_END_DATE, PRODUCT_ID, SUM(VALUE) total_sales
from base_cte
group by QTR_END_DATE, PRODUCT_ID
ORDER BY 1, 2;
;

/* ------------------------------------------------------------------------ */

/* Question 2 : Given a table orders(order_id, customer_id, order_date, amount), write SQL to return the amount difference between the 4th and 5th largest orders by amount for each customer (or globally if customer not provided). */

CREATE OR REPLACE TEMPORARY TABLE interview_prep.data_analysis.orders (
    order_id     INTEGER,
    customer_id  INTEGER,
    order_date   DATE,
    amount       NUMBER(10, 2)
);
INSERT INTO interview_prep.data_analysis.orders (order_id, customer_id, order_date, amount) VALUES
-- Customer 101
(1, 101, '2024-01-01', 1200),
(2, 101, '2024-01-05', 900),
(3, 101, '2024-01-10', 1500),
(4, 101, '2024-01-15', 700),
(5, 101, '2024-01-20', 1100),
(6, 101, '2024-01-25', 1300),

-- Customer 102
(7, 102, '2024-02-01', 2000),
(8, 102, '2024-02-05', 1800),
(9, 102, '2024-02-10', 1600),
(10,102, '2024-02-15', 1400),
(11,102, '2024-02-20', 1200),
(12,102, '2024-02-25', 1000);

/* My Answer */
with cte_1 as
(
    select order_id,
    customer_id,
    order_date,
    amount,
    RANK() OVER(PARTITION BY customer_id order by amount desc) as rank_of_order
    from orders
)
select distinct customer_id,
(select MIN(amount) from cte_1 a1 where a1.customer_id = m1.customer_id and rank_of_order = 4) as fourth_amt,
(select MIN(amount) from cte_1 a2 where a2.customer_id = m1.customer_id and rank_of_order = 5) as fifth_amt,
(fourth_amt - fifth_amt) diff_amt
from cte_1 m1;

WITH ranked_orders AS (
    SELECT
        amount,
        ROW_NUMBER() OVER (ORDER BY amount DESC) AS rn
    FROM orders
    QUALIFY rn IN (4, 5)
)

SELECT
    MAX(CASE WHEN rn = 4 THEN amount END) AS fourth_amount,
    MAX(CASE WHEN rn = 5 THEN amount END) AS fifth_amount,
    MAX(CASE WHEN rn = 4 THEN amount END)
      - MAX(CASE WHEN rn = 5 THEN amount END) AS amount_difference
FROM ranked_orders;

/* Answer by CGPT */
WITH ranked_orders AS (
    SELECT
        customer_id,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY amount DESC
        ) AS rn
    FROM orders
)

SELECT
    customer_id,
    MAX(CASE WHEN rn = 4 THEN amount END) AS fourth_amount,
    MAX(CASE WHEN rn = 5 THEN amount END) AS fifth_amount,
    MAX(CASE WHEN rn = 4 THEN amount END)
      - MAX(CASE WHEN rn = 5 THEN amount END) AS amount_difference
FROM ranked_orders
GROUP BY customer_id;

/* ------------------------------------------------------------------------ */

/* Question 3: Find the 3rd highest salary per department. */
CREATE OR REPLACE TABLE interview_prep.data_analysis.employees (
    emp_id     INT,
    emp_name   STRING,
    dept       STRING,
    salary     INT
);
INSERT INTO employees VALUES
(1, 'A', 'HR', 9000),
(2, 'B', 'HR', 8000),
(3, 'C', 'HR', 7000),
(4, 'D', 'HR', 6000),
(5, 'E', 'IT', 12000),
(6, 'F', 'IT', 11000),
(7, 'G', 'IT', 10000),
(8, 'H', 'IT', 9000);
select dept, emp_name, salary, RANK() OVER(PARTITION BY dept order by salary desc) as ranked_salary from employees;

/* My Answer */
select distinct dept, emp_name, salary, RANK() OVER(PARTITION BY dept order by salary desc) as ranked_salary from employees
QUALIFY ranked_salary IN (3);
select distinct dept, salary from employees
QUALIFY RANK() OVER(PARTITION BY dept order by salary desc) IN (3);

/* Answer by CGPT */
with ranked_cte as
(
    select 
        dept,
        salary,
        ROW_NUMBER() OVER(PARTITION BY dept ORDER BY salary DESC) as ranked_sal
    from employees
)
select
    dept,
    MAX(CASE WHEN ranked_sal = 3 THEN salary END) as third_highest_salary
from ranked_cte
GROUP BY dept;
with ranked_cte as
(
    select 
        dept,
        salary,
        ROW_NUMBER() OVER(PARTITION BY dept ORDER BY salary DESC) as ranked_sal
    from employees
)
select
    dept,
    MAX(CASE WHEN ranked_sal = 1 THEN salary END) as highest_salary,
    MAX(CASE WHEN ranked_sal = 2 THEN salary END) as second_highest_salary,
    MAX(CASE WHEN ranked_sal = 3 THEN salary END) as third_highest_salary,
from ranked_cte
GROUP BY dept;

/* ------------------------------------------------------------------------ */

/* Question 4 : For each order, calculate the difference from previous order amount per customer. */

CREATE OR REPLACE TEMPORARY TABLE orders_diff (
    order_id    INT,
    customer_id INT,
    order_date  DATE,
    amount      INT
);

INSERT INTO orders_diff VALUES
(1, 101, '2024-01-01', 100),
(2, 101, '2024-01-05', 150),
(3, 101, '2024-01-10', 130),
(4, 102, '2024-01-01', 200),
(5, 102, '2024-01-03', 180);

/* My Answer(s) */

select 
    customer_id, order_date, amount, (amount - LAG(amount) OVER(PARTITION BY customer_id ORDER BY order_date asc)) as diff_amt
from orders_diff;

select 
    customer_id, order_date, amount, (amount - LAG(amount) OVER(PARTITION BY customer_id ORDER BY order_date asc)) as diff_amt
from orders_diff
ORDER BY customer_id, order_date;

select 
    customer_id, order_date, amount, (amount - LAG(amount) OVER(PARTITION BY customer_id ORDER BY order_date asc)) as diff_amt
from orders_diff
ORDER BY order_date;

/* Answer by CGPT */
SELECT
    customer_id,
    order_date,
    amount,
    amount - LAG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS diff_from_prev
FROM orders_diff;

/* ------------------------------------------------------------------------ */

/* Question 5 : Find continuous date ranges per customer. */

CREATE OR REPLACE TABLE interview_prep.data_analysis.login_dates (
    customer_id INT,
    login_date  DATE
);

INSERT INTO login_dates VALUES
(101, '2024-01-01'),
(101, '2024-01-02'),
(101, '2024-01-03'),
(101, '2024-01-06'),
(101, '2024-01-07'),
(102, '2024-02-01'),
(102, '2024-02-02');

select
customer_id,
login_date,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY login_date) as day_number,
DATEDIFF(DAY, LAG(login_date) OVER(PARTITION BY customer_id ORDER BY login_date), login_date) as days_diff
from login_dates
order by customer_id, login_date
;

/* Answer by CGPT */
WITH base AS (
    SELECT
        customer_id,
        login_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY login_date
        ) AS rn
    FROM login_dates
)
SELECT
    customer_id,
    MIN(login_date) AS start_date,
    MAX(login_date) AS end_date
FROM base
GROUP BY
    customer_id,
    login_date - rn;

/* ------------------------------------------------------------------------ */

/* Question 6 : Show cumulative sales per customer by date. */

CREATE OR REPLACE TEMPORARY TABLE interview_prep.data_analysis.sales(
    customer_id INT,
    sale_date   DATE,
    amount      INT
);

INSERT INTO sales VALUES
(101, '2024-01-01', 100),
(101, '2024-01-05', 200),
(101, '2024-01-10', 150),
(102, '2024-01-01', 300),
(102, '2024-01-02', 100);

/* My Answer */

select
    customer_id,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY sale_date ASC) as running_total
from sales;

select
    customer_id,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY sale_date ASC
     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as running_total
from sales;

/* Answer by CGPT */

select
    customer_id,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY sale_date ASC
     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as running_total
from sales;

/* ------------------------------------------------------------------------ */

/* Question 7: Find top 2 selling products per category, including ties. */

CREATE OR REPLACE TEMPORARY TABLE interview_prep.data_analysis.products (
    category STRING,
    product  STRING,
    sales    INT
);

INSERT INTO products VALUES
('Electronics', 'TV', 500),
('Electronics', 'Laptop', 600),
('Electronics', 'Tablet', 600),
('Clothing', 'Shirt', 300),
('Clothing', 'Jeans', 400),
('Clothing', 'Jacket', 400);

/* My Answer */

with base as
(select
    category,
    product,
    sales,
    RANK() OVER (PARTITION BY category ORDER BY sales DESC) prod_rank_within_cat
from products)
select category,
       product,
       sales
from base
where prod_rank_within_cat <= 2;

/* Answer by CGPT */
SELECT
    category,
    product,
    sales
FROM (
    SELECT
        category,
        product,
        sales,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY sales DESC
        ) AS dr
    FROM products
)
WHERE dr <= 2;

/* ------------------------------------------------------------------------ */

/* Question 8: "Gaps and Islands" problem. Identify and group consecutive order dates for each customer into distinct "islands" (continuous activity streaks). */

CREATE OR REPLACE TEMPORARY TABLE customer_orders (
    customer_id INT,
    order_date  DATE
);

INSERT INTO customer_orders VALUES
(1, '2024-01-01'),
(1, '2024-01-02'),
(1, '2024-01-03'),
(1, '2024-01-06'),
(1, '2024-01-07'),
(2, '2024-02-01'),
(2, '2024-02-02');

/* My Answer */

with base as
(
    select
        customer_id, order_date, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date ASC) as order_rank
    from customer_orders
)
select
    customer_id, MIN(order_date) start_date, MAX(order_date) end_date
from base
    group by customer_id,
    (order_date - order_rank);

/* ------------------------------------------------------------------------ */

/* Question 9: "Gaps and Islands" problem, specifically applied to employee attendance tracking. */

CREATE OR REPLACE TEMPORARY TABLE attendance (
    emp_id INT,
    attend_date DATE
);
    
INSERT INTO attendance VALUES
(10, '2024-03-01'),
(10, '2024-03-02'),
(10, '2024-03-03'),
(10, '2024-03-05'),
(10, '2024-03-06');

/* My Answer */
with cte_1 as
(
    select
        emp_id,
        attend_date,
        ROW_NUMBER() OVER(PARTITION BY emp_id ORDER BY attend_date ASC) as date_rank
    from attendance
)
select
    emp_id,
    MIN(attend_date) start_date,
    MAX(attend_date) end_date
from cte_1
group by emp_id, (attend_date - date_rank)
;

/* ------------------------------------------------------------------------ */

/* Question 10: "Gaps and Islands" problem, designed to find and group sequences of consecutive integers within a dataset. */

CREATE OR REPLACE TEMPORARY TABLE numbers (
    value INT
);

INSERT INTO numbers VALUES
(10),
(11),
(12),
(20),
(21),
(22),
(30);

/* My Answer */

WITH base AS (
    SELECT
        value,
        ROW_NUMBER() OVER (ORDER BY value) AS rn
    FROM numbers
)
SELECT
    MIN(value) AS start_value,
    MAX(value) AS end_value
FROM base
GROUP BY
    value - rn;

/* ------------------------------------------------------------------------ */

/* Question: Top-N ranking and handling ties within categories (stores or customers). Identifying TOP 3 sales. */

CREATE OR REPLACE TEMPORARY TABLE store_sales (
    store_id   STRING,
    sale_id    INT,
    revenue    INT
);

INSERT INTO store_sales (store_id, sale_id, revenue) VALUES
-- Store A
('A', 1, 1000),
('A', 2, 1000),
('A', 3, 900),
('A', 4, 900),
('A', 5, 800),
('A', 6, 700),

-- Store B
('B', 1, 2000),
('B', 2, 1800),
('B', 3, 1800),
('B', 4, 1600),
('B', 5, 1500);

SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY store_id
               ORDER BY revenue DESC
           ) AS rn
    FROM store_sales
SELECT
    store_id,
    sale_id,
    revenue
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY store_id
               ORDER BY revenue DESC
           ) AS rn
    FROM store_sales
)
WHERE rn <= 3;
SELECT
    store_id,
    sale_id,
    revenue
FROM (
    SELECT *,
           DENSE_RANK() OVER (
               PARTITION BY store_id
               ORDER BY revenue DESC
           ) AS dr
    FROM store_sales
)
WHERE dr <= 3
ORDER BY store_id, revenue DESC;
SELECT
    store_id,
    sale_id,
    revenue
FROM store_sales
QUALIFY
    DENSE_RANK() OVER (
        PARTITION BY store_id
        ORDER BY revenue DESC
    ) <= 3;
SELECT
    store_id,
    sale_id,
    revenue
FROM store_sales
QUALIFY
    DENSE_RANK() OVER (
        PARTITION BY store_id
        ORDER BY revenue DESC
    ) <= 3;

/* ------------------------------------------------------------------------ */

/* Assume a table structure like below - 

"Team
----
India
Pakistan
Srilanka
Australia

Write SQL to generate output like below - 

Output :
----
India VS Pakistan
India VS Srilanka
India VS Australia
Pakistan VS Srilanka
Pakistan VS Australia
Srilanka VS Australia"

*/

CREATE TABLE TEAMS (Team VARCHAR);

INSERT INTO TEAMS VALUES('India'), ('Pakistan'), ('Srilanka'), ('Australia');

select * from TEAMS;

select t1.team || ' VS ' || t2.team
from TEAMS t1, TEAMS t2
where t1.team <> t2.team
and t1.team < t2.team
order by 1;

/* ------------------------------------------------------------------------ */
/* Question (Hexaware Interview): For each customer, identify their two most recent credit transactions and compute the difference between the latest and the previous credit amount, returning one row per customer. */

CREATE OR REPLACE TEMPORARY TABLE transactions (
    cust_id      INT,
    credit_amt   NUMBER(10, 2),
    txn_date     DATE
);

INSERT INTO transactions (cust_id, credit_amt, txn_date) VALUES
    -- Customer 101: 3 records — oldest should be ignored
    (101, 4200.00, '2026-01-15'),
    (101, 5800.00, '2026-02-20'),
    (101, 7100.00, '2026-03-30'),

    -- Customer 102: 2 records
    (102, 1500.00, '2026-02-01'),
    (102, 3200.00, '2026-03-18'),

    -- Customer 103: 3 records — oldest should be ignored
    (103, 9500.00, '2026-01-10'),
    (103, 8800.00, '2026-02-25'),
    (103, 11000.00, '2026-04-05'),

    -- Customer 104: 2 records — diff is negative (credit dropped)
    (104, 6700.00, '2026-03-01'),
    (104, 4900.00, '2026-04-12'),

    -- Customer 105: 3 records — oldest should be ignored
    (105, 2100.00, '2026-01-22'),
    (105, 3400.00, '2026-03-08'),
    (105, 5600.00, '2026-04-19'),

    -- Customer 106: 2 records
    (106, 800.00,  '2026-02-14'),
    (106, 1250.00, '2026-04-01'),

    -- Customer 107: 2 records — diff is negative (credit dropped)
    (107, 15000.00, '2026-03-05'),
    (107, 12300.00, '2026-04-28');

select
    *
from transactions;

with base_cte as (
    select
        t1.cust_id, t1.credit_amt, t1.txn_date,
        ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY txn_date desc) as txn_rank
    from transactions t1
    QUALIFY txn_rank <= 2
)
select 
    cust_id,
    MAX(CASE WHEN txn_rank = 1 THEN credit_amt END) curr_amt,
    MAX(CASE WHEN txn_rank = 2 THEN credit_amt END) prev_amt,
    (curr_amt - prev_amt) as diff
from base_cte
group by cust_id;

/* ------------------------------------------------------------------------ */
/* Question : You have a table called page_views with columns user_id, page_name, and view_time (timestamp).
Write a query that returns, for each user, their first page visited and their last page visited — one row per user. */

CREATE OR REPLACE TEMPORARY TABLE page_views (
    user_id    INTEGER,
    page_name  VARCHAR(50),
    view_time  TIMESTAMP
);

INSERT INTO page_views (user_id, page_name, view_time) VALUES
    (1, 'home',     '2023-07-01 09:00:00'),
    (1, 'products', '2023-07-01 09:05:00'),
    (1, 'checkout', '2023-07-01 09:12:00'),
    (2, 'home',     '2023-07-01 10:00:00'),
    (2, 'about',    '2023-07-01 10:02:00'),
    (3, 'home',     '2023-07-01 11:00:00');

select * from page_views;

select distinct
    user_id,
    FIRST_VALUE(page_name) OVER(PARTITION BY USER_ID ORDER BY view_time ASC) as first_page,
    LAST_VALUE(page_name) OVER(PARTITION BY USER_ID ORDER BY view_time ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as last_page
from page_views;

/* ------------------------------------------------------------------------ */

/* Question : (Seat Availability Problem from StrataScratch (https://platform.stratascratch.com/coding/2088-seat-availability)). */

/* Output only distinct pairs of seats in two columns such that the seat with the lower number is always in the first column and the one with the higher number is in the second column. */

-- ==========================================
-- TABLE 1: Physical Theater Architecture Mapping
-- ==========================================
CREATE OR REPLACE TEMPORARY TABLE THEATER_SEATMAP (
    SEAT_NUMBER INT,
    SEAT_LEFT INT,
    SEAT_RIGHT INT
);

-- ==========================================
-- TABLE 2: Real-time Live Seat Booking Availability
-- ==========================================
CREATE OR REPLACE TEMPORARY TABLE THEATER_AVAILABILITY (
    SEAT_NUMBER INT,
    IS_AVAILABLE INT
);

-- ==========================================
-- POPULATING 25-ROW DATASET
-- Simulates physical rows with broken IDs & realistic bookings
-- ==========================================
INSERT INTO THEATER_SEATMAP (SEAT_NUMBER, SEAT_LEFT, SEAT_RIGHT) VALUES
(1,  NULL, 2),    -- Row A Start
(2,  1,    3),
(3,  2,    4),
(4,  3,    NULL), -- Row A End (Aisle Break)
(11, NULL, 12),   -- Row B Start (Notice the ID jump!)
(12, 11,   13),
(13, 12,   14),
(14, 13,   15),
(15, 14,   NULL), -- Row B End
(21, NULL, 22),   -- Row C Start
(22, 21,   23),
(23, 22,   24),
(24, 23,   25),
(25, 24,   NULL), -- Row C End
(31, NULL, 32),   -- Row D Start
(32, 31,   33),
(33, 32,   34),
(34, 33,   35),
(35, 34,   NULL), -- Row D End
(41, NULL, 42),   -- Row E Start
(42, 41,   43),
(43, 42,   44),
(44, 43,   45),
(45, 44,   NULL); -- Row E End

INSERT INTO THEATER_AVAILABILITY (SEAT_NUMBER, IS_AVAILABLE) VALUES
(1,  1), (2,  0), (3,  1), (4,  1),  -- Row A Mix
(11, 1), (12, 1), (13, 1), (14, 0), (15, 1), -- Row B (11,12,13 free!)
(21, 0), (22, 0), (23, 1), (24, 1), (25, 1), -- Row C (23,24,25 free!)
(31, 1), (32, 0), (33, 1), (34, 0), (35, 1), -- Row D (Isolated seats)
(41, 1), (42, 1), (43, 1), (44, 1), (45, 0); -- Row E (41,42,43,44 free!);

select * from theater_availability;

select * from theater_seatmap;

select distinct
    a.seat_number,
    s.seat_number
from
    theater_availability a,
    theater_seatmap s
where
    a.is_available = 1
    AND (
        1 = (
            select
                MIN(t.is_available)
            from
                theater_availability t
            where
                t.seat_number = s.seat_number
        )
    )
    and a.seat_number = s.seat_left
order by
    1;

/* Question : NiCE Inteerview question (tricky one; but good to learn the fundamentals correctly.) */
/* What would be the row count in the result set if I were to perform an inner join, a left join, a right join, and a full outer join?  */

CREATE OR REPLACE TEMPORARY TABLE table_a (id INTEGER);
CREATE OR REPLACE TEMPORARY TABLE table_b (id INTEGER);

INSERT INTO table_a (id) VALUES (1), (0), (1), (1), (NULL);
INSERT INTO table_b (id) VALUES (1), (1), (1), (NULL), (NULL), (0);

select * from table_a
inner join table_b on table_a.ID = table_b.ID;

select * from table_a
LEFT join table_b on table_a.ID = table_b.ID;

select * from table_a
RIGHT join table_b on table_a.ID = table_b.ID;

select * from table_a
full outer join table_b on table_a.ID = table_b.ID;

/* ------------------------------------------------------------------------ */

/* Question : Given three tables (Products, Stocks, Returns), write a query that shows:
   (a) Product ID
   (b) Product Name
   (c) Total stock for that product
   (d) Total number of times the product was returned
   Data covers May, June, and July 2023, but output should only contain data for July 2023. */

CREATE OR REPLACE TEMPORARY TABLE products (
    id INTEGER,
    title VARCHAR(100)
);

CREATE OR REPLACE TEMPORARY TABLE stocks (
    product_id INTEGER,
    units INTEGER
);

CREATE OR REPLACE TEMPORARY TABLE returns (
    product_id INTEGER,
    returned_at TIMESTAMP
);

/* Sample dataset 1. Works with query v1 below but isn't 100% accurate. */

INSERT INTO products (id, title) VALUES
(1, 'Wireless Mouse'),
(2, 'Mechanical Keyboard'),
(3, 'USB-C Hub'),
(4, 'Monitor Stand'),
(5, 'Webcam HD');

INSERT INTO stocks (product_id, units) VALUES
(1, 150),
(2, 80),
(3, 200),
(4, 60),
(5, 120);

INSERT INTO returns (product_id, returned_at) VALUES
-- May 2023
(1, '2023-05-03 10:15:00'),
(2, '2023-05-10 14:30:00'),
(3, '2023-05-18 09:00:00'),
(1, '2023-05-22 16:45:00'),
-- June 2023
(2, '2023-06-01 11:20:00'),
(4, '2023-06-12 08:50:00'),
(1, '2023-06-19 13:10:00'),
(3, '2023-06-25 17:30:00'),
(5, '2023-06-28 10:00:00'),
-- July 2023
(1, '2023-07-02 09:30:00'),
(1, '2023-07-15 14:00:00'),
(2, '2023-07-05 11:45:00'),
(3, '2023-07-10 16:20:00'),
(3, '2023-07-22 08:15:00'),
(3, '2023-07-29 12:00:00'),
(5, '2023-07-18 10:30:00');

/* Sample dataset 2. Works with query both query versions below. */

-- Products
INSERT INTO products (id, title) VALUES
(1, 'Laptop'),
(2, 'Mouse'),
(3, 'Keyboard');

-- Stocks
INSERT INTO stocks (product_id, units) VALUES
(1, 100),
(2, 50),
(3, 75);

-- Returns: Laptop returned in July, Mouse returned in June only,
-- Keyboard never returned
INSERT INTO returns (product_id, returned_at) VALUES
(1, '2023-07-05 10:00:00'),
(1, '2023-07-18 14:30:00'),
(2, '2023-06-12 09:00:00'),   -- June only, NOT July
(2, '2023-06-28 11:00:00');   -- June only, NOT July
-- Keyboard has no returns at all

select * from products;

select * from stocks;

select * from returns;

/* Query v1 */

select 
    p.id, 
    p.title,
    sum(s.units) total_stock,
    COUNT(r.product_id) times_returned
from products p
inner join stocks s on p.id = s.product_id
inner join returns r on p.id = r.product_id
where TO_CHAR(r.returned_at, 'YYYY-MM') = '2023-07'
group by p.id, p.title
order by 1;

/* Query v2 */

SELECT
    p.id                        AS product_id,
    p.title                     AS product_name,
    COALESCE(SUM(s.units), 0)   AS total_stock,
    COUNT(r.product_id)         AS total_returns
FROM products p
LEFT JOIN stocks s
    ON p.id = s.product_id
LEFT JOIN returns r
    ON p.id = r.product_id
    AND DATE_TRUNC('month', r.returned_at) = '2023-07-01'
GROUP BY
    p.id,
    p.title;