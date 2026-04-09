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
	Show all customers with NO orders
*/
SELECT	c.c_custkey,
        c.c_name,
		o.o_orderkey
FROM	dbo.customers AS c
		LEFT JOIN dbo.orders AS o
		ON (c.c_custkey = o.o_custkey)
WHERE	o.o_orderkey IS NULL;
GO

/*
	Which products have never been ordered before?
*/
SELECT	p.*
FROM	dbo.parts AS p
		LEFT JOIN dbo.lineitems AS l
		ON (p.p_partkey = l.l_partkey)
WHERE	l.l_orderkey IS NULL;
GO

/*
	What country does not have customers?
*/
SELECT	n.*
FROM	dbo.nations AS n
		LEFT JOIN dbo.customers AS c
		ON (n.n_nationkey = c.c_nationkey)
WHERE	c.c_custkey IS NULL;
GO
