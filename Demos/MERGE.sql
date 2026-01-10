CREATE OR REPLACE TEMPORARY TABLE orders_curated (
    order_id INT,
    customer_id INT,
    amount NUMBER,
    updated_at TIMESTAMP
);

INSERT INTO orders_curated VALUES
(1, 101, 500, '2024-01-01'),
(2, 102, 300, '2024-01-01');

select * from orders_curated;

CREATE OR REPLACE TEMPORARY TABLE orders_source (
    order_id INT,
    customer_id INT,
    amount NUMBER,
    updated_at TIMESTAMP
);

INSERT INTO orders_source VALUES
(2, 102, 350, '2024-01-02'), -- UPDATED order
(3, 103, 700, '2024-01-02');

select * from orders_source;

select * from orders_curated
UNION
select * from orders_source
ORDER BY order_id, updated_at;

MERGE INTO orders_curated tgt
USING orders_source src
ON tgt.order_id = src.order_id

WHEN MATCHED AND tgt.updated_at < src.updated_at THEN
    UPDATE SET
        customer_id = src.customer_id,
        amount = src.amount,
        updated_at = src.updated_at

WHEN NOT MATCHED THEN
    INSERT (order_id, customer_id, amount, updated_at)
    VALUES (src.order_id, src.customer_id, src.amount, src.updated_at);

select * from orders_curated;    