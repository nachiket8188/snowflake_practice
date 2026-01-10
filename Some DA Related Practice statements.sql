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

