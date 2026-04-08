/*
	============================================================================
	File:		02 - 1NF.sql

	Summary:	Demonstration of normalization of data tables
				http://de.wikipedia.org/wiki/Normalisierung_%28Datenbank%29

				THIS SCRIPT IS PART OF THE TRACK: "Workshop - SQL Server Basics"

	Date:		November 2025

	SQL Server Version: >= 2016
	------------------------------------------------------------------------------
		Written by Uwe Ricken, db Berater GmbH

		This script is intended only as a supplement to demos and lectures
		given by Uwe Ricken.  
  
		THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
		ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
		TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
		PARTICULAR PURPOSE.
	============================================================================
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE ERP_Demo;
GO

DROP TABLE IF EXISTS demo.customers;
DROP TABLE IF EXISTS demo.order_details
DROP TABLE IF EXISTS demo.orders;


/*
    A table is in Second Normal Form (2NF) if:
    - It is already in First Normal Form (1NF), and
    - Every non‑key attribute is fully functionally dependent on the entire primary key, not just part of it.

    The keyword is no partial dependencies.
*/
/* Every customer must be unique with it's customer_number! */
SELECT	DISTINCT
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

/*
	The 3rd rule of relational theory states that every relation must
	have a primary key.

	This requirement is part of the “Guaranteed Access Rule” (Rule 2)
	and is often referred to in the literature as Rule 3 or Key Rule,
	although it formally follows from Rule 2.
*/
ALTER TABLE demo.customers
ADD CONSTRAINT pk_demo_customers
PRIMARY KEY (customer_number)
WITH
(
    DATA_COMPRESSION = PAGE,
    SORT_IN_TEMPDB = ON
);
GO

/* Every order position must be unique with it's order_number and order_position! */
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

/*
	The 3rd rule of relational theory states that every relation must
	have a primary key.

	This requirement is part of the “Guaranteed Access Rule” (Rule 2)
	and is often referred to in the literature as Rule 3 or Key Rule,
	although it formally follows from Rule 2.
*/
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

/* Every order must be unique with it's order_number! */
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

/*
	The 3rd rule of relational theory states that every relation must
	have a primary key.

	This requirement is part of the “Guaranteed Access Rule” (Rule 2)
	and is often referred to in the literature as Rule 3 or Key Rule,
	although it formally follows from Rule 2.
*/
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
