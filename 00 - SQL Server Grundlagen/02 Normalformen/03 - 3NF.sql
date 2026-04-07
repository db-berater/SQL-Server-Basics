USE ERP_Demo;
GO

DROP TABLE IF EXISTS demo.market_segments;
DROP TABLE IF EXISTS demo.nations;
GO

;WITH l
AS
(
	SELECT	DISTINCT
			market_segment
	FROM	demo.customers
)
SELECT	ROW_NUMBER() OVER (ORDER BY market_segment) AS segment_id,
		market_segment
INTO	demo.market_segments
FROM	l;
GO

ALTER TABLE demo.market_segments
ALTER COLUMN segment_id INT NOT NULL;
GO

ALTER TABLE demo.market_segments
ADD CONSTRAINT pk_demo_market_segments
PRIMARY KEY (segment_id);
GO

/* Damit ALLES oder NICHTS durchgeführt wird... */
BEGIN TRANSACTION;
GO
	/* Update in demo.customers (market_segment) */
	UPDATE	c
	SET		c.market_segment = m.segment_id
	FROM	demo.customers AS c
			INNER JOIN demo.market_segments AS m
			ON (c.market_segment = m.market_segment);
	GO

	SELECT * FROM demo.customers;

	ALTER TABLE demo.customers
	ALTER COLUMN market_segment INT NOT NULL;
	GO

COMMIT TRANSACTION;
GO

/* Nations */
;WITH l
AS
(
	SELECT	DISTINCT
			customer_nation
	FROM	demo.customers
)
SELECT	ROW_NUMBER() OVER (ORDER BY customer_nation) AS nation_id,
		customer_nation
INTO	demo.nations
FROM	l;
GO

ALTER TABLE demo.nations
ALTER COLUMN nation_id INT NOT NULL;
GO

ALTER TABLE demo.nations
ADD CONSTRAINT pk_demo_nations
PRIMARY KEY (nation_id);
GO

/* Damit ALLES oder NICHTS durchgeführt wird... */
BEGIN TRANSACTION;
GO
	/* Update in demo.customers (market_segment) */
	UPDATE	c
	SET		c.customer_nation = m.nation_id
	FROM	demo.customers AS c
			INNER JOIN demo.nations AS m
			ON (c.customer_nation = m.customer_nation);
	GO

	SELECT * FROM demo.customers;

	ALTER TABLE demo.customers
	ALTER COLUMN customer_nation INT NOT NULL;
	GO

COMMIT TRANSACTION;
GO

/* Orders */
SELECT	DISTINCT
		order_priority_id,
        order_priority
INTO	demo.order_priorities
FROM	demo.orders;
GO

ALTER TABLE demo.order_priorities
ALTER COLUMN order_priority_id INT NOT NULL;
GO

ALTER TABLE demo.order_priorities
ADD CONSTRAINT pk_demo_order_priorities
PRIMARY KEY (order_priority_id);

ALTER TABLE demo.orders
DROP COLUMN order_priority;
GO

/* Order Details */
SELECT	DISTINCT
		article_number,
        article_type,
        article_size,
        article_brand
INTO	demo.articles
FROM	demo.order_details;
GO

ALTER TABLE demo.articles
ADD CONSTRAINT pk_demo_articles
PRIMARY KEY CLUSTERED (article_number);

ALTER TABLE demo.order_details
DROP COLUMN article_type;
ALTER TABLE demo.order_details
DROP COLUMN article_size;
ALTER TABLE demo.order_details
DROP COLUMN article_brand;
GO

