/*
	============================================================================
	File:		01 - INNER JOIN.sql

	Summary:	An INNER JOIN returns only the rows where both tables have 
				matching values in the join condition, effectively showing
				the intersection of the two datasets.
				
				It ensures that non‑matching rows from either side are excluded, 
				which keeps the result set focused and precise.


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
	Show the region / continent for each country
*/
SELECT	n.n_nationkey,
		n.n_name		AS	country_name,
		r.r_name		AS	continent_name
FROM	dbo.nations AS n
		INNER JOIN dbo.regions AS r
		ON n.n_regionkey = r.r_regionkey
ORDER BY
		r.r_name,
		n.n_name;
GO

/*
	Show all customers and the orderkey of all orders
	from 2020/02/18
*/
SELECT	c.c_custkey,
		c.c_name,
		o.o_orderkey,
		o.o_orderdate,
		o.o_orderstatus
FROM	dbo.customers AS c
		INNER JOIN dbo.orders AS o
		ON c.c_custkey = o.o_custkey
WHERE	o.o_orderdate = '2020-02-18';
GO

/*
	Show all customers from Portugal
*/
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
		INNER JOIN dbo.nations AS n
		ON (c.c_nationkey = n.n_nationkey)
WHERE	n.n_name = 'PORTUGAL'
ORDER BY
		c.c_custkey;