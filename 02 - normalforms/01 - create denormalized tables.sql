/*
	============================================================================
	File:		01 - create denormalized tables.sql

	Summary:	This script creates a relational set with denormalized tables
				for the demonstration of 1st, 2nd. and 3rd normal form! 

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

/*
    We create a demo schema
    Note: The function is part of the framework of ERP_Demo.    
*/
EXEC dbo.sp_create_demo_schema;
GO

/* We drop the denormalized data if it exists! */
DROP TABLE IF EXISTS demo.denormalized_data;
GO

/* and recreate the table demo.denormalized_data with fresh data */
SELECT	c.c_custkey                     AS  customer_number,
        c.c_mktsegment                  AS  market_segment,
        REPLACE(c.c_name, '#', ' ')     AS  customer_firstname_lastname,
        c.c_phone                       AS  customer_phone,
        n.n_name                        AS  customer_nation,
        o.o_orderkey                    AS  order_number,
        l.l_linenumber                  AS  order_position,
        o.o_orderdate                   AS  order_date,
        o.o_orderpriority               AS  order_priority,
        o.o_orderstatus                 AS  order_status,
        l.l_extendedprice               AS  position_price,
        l.l_quantity                    AS  position_quantity,
        p.p_partkey                     AS  article_number,
        p.p_type                        AS  article_type,
        p.p_size                        AS  article_size,
        REPLACE(p.p_brand, '#', ' ')    AS  article_brand
INTO    demo.denormalized_data
FROM	dbo.orders AS o
		INNER JOIN dbo.lineitems AS l
		ON (o.o_orderkey = l.l_orderkey)
        INNER JOIN dbo.parts AS p
        ON (l.l_partkey = p.p_partkey)
        INNER JOIN dbo.customers AS c
        ON (o.o_custkey = c.c_custkey)
        INNER JOIN dbo.nations AS n
        ON (c.c_nationkey = n.n_nationkey)
WHERE	o.o_orderdate >= '2024-01-01'
		AND o.o_orderdate <= '2024-01-31'
GO

RAISERROR ('The denormalized data are created successfully.', 0, 1) WITH NOWAIT;
GO