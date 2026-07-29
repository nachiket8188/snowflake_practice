CREATE DATABASE IF NOT EXISTS RETAIL;

USE DATABASE RETAIL;

CREATE SCHEMA IF NOT EXISTS RAW;

USE SCHEMA RAW;

CREATE TABLE
    own_website (
        order_id varchar(100),
        customer_id NUMBER (16, 0),
        product_sku varchar(1000),
        quantity number,
        unit_price_inr number,
        order_timestamp varchar,
        payment_method varchar,
        delivery_pincode varchar,
        order_status varchar
    );


SELECT 
    TO_CHAR(DATEADD(second, UNIFORM(1, 86400, RANDOM()), CURRENT_DATE()), 'DD-MM-YYYY HH24:MI:SS') AS order_timestamp,
    TO_CHAR(TO_TIMESTAMP(order_timestamp, 'DD-MM-YYYY HH24:MI:SS'), 'YYYYMMDD') AS order_date_key,
    CONCAT('WEB-', order_date_key, '-', LPAD(SEQ4() + 1, 6, '0')) AS order_id,
    UNIFORM(ROUND(LPAD(1, 5, '0'), 0), ROUND(LPAD(300, 5, '0'), 0), RANDOM()) AS customer_id
FROM TABLE(GENERATOR(ROWCOUNT => 1000));

with base_cte as(
    select 
        SEQ4() + 1 as rn,
        UNIFORM(1, 86400, RANDOM()) as seconds_offset,
        UNIFORM(1, 4, RANDOM()) as rnd_pmt_method
    from
        TABLE(GENERATOR(ROWCOUNT => 100))
),
second_cte as (
select
    rn,
    CASE WHEN rnd_pmt_method = 1 THEN 'UPI'
    WHEN rnd_pmt_method = 2 THEN 'COD'
    WHEN rnd_pmt_method = 3 THEN 'CARD'
    ELSE 'WALLET' END rnd_pmt_method_desc,
    UNIFORM(1, 3, RANDOM()) as rnd_scrambler,
    TO_CHAR(DATEADD(second, seconds_offset, current_date()), 'DD-MM-YYYY HH24:MI:SS') AS order_timestamp
from base_cte
)
select
    order_timestamp,
    CONCAT('WEB-', TO_CHAR(TO_TIMESTAMP(order_timestamp, 'DD-MM-YYYY HH24:MI:SS'), 'YYYYMMDD'), '-', LPAD(rn, 6, '0')) AS order_id,
    LPAD(ROUND(UNIFORM(1, 300, RANDOM()), 0), 5, '0') AS customer_id,
    CASE WHEN rnd_scrambler = 1 THEN INITCAP(rnd_pmt_method_desc)
    WHEN rnd_scrambler = 2 THEN UPPER(rnd_pmt_method_desc)
    ELSE LOWER(rnd_pmt_method_desc) END payment_method
from second_cte;