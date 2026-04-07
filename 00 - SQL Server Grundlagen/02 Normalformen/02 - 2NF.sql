-- SELECT * FROM demo.first_normalform

SELECT	DISTINCT    /* Jeder ausgegebene Datensatz ist EINDEUTIG! */
        customer_number,
        market_segment,
        first_name,
        last_name,
        customer_phone,
        customer_nation
INTO    demo.customers
FROM	demo.first_normalform
ORDER BY
        customer_number;
GO

ALTER TABLE demo.customers
ADD CONSTRAINT pk_demo_customers
PRIMARY KEY (customer_number)
WITH
(
    DATA_COMPRESSION = PAGE,
    SORT_IN_TEMPDB = ON
);
GO

SELECT  order_number,
        order_position,
        position_price,
        position_quantity,
        article_number,
        article_type,
        article_size,
        article_brand
INTO    demo.order_details
FROM    demo.denormalized_data;
GO

ALTER TABLE demo.order_details
ADD CONSTRAINT pk_demo_details
PRIMARY KEY
(
    order_number,
    order_position
)
WITH
(
    DATA_COMPRESSION = PAGE,
    SORT_IN_TEMPDB = ON
);
GO

SELECT  DISTINCT
        order_number,
        customer_number,
        order_date,
        order_priority_id,
        order_priority,
        order_status
INTO    demo.orders
FROM    demo.first_normalform
GO

ALTER TABLE demo.orders
ADD CONSTRAINT pk_demo_orders
PRIMARY KEY
(
    order_number
)
WITH
(
    DATA_COMPRESSION = PAGE,
    SORT_IN_TEMPDB = ON
);
GO

DROP TABLE IF EXISTS demo.first_normalform;
