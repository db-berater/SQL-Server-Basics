/*
	============================================================================
	File:		05 - WHERE and EXISTS.sql

	Summary:	This script demonstrates the benefits of EXISTS vs IN!

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
	Let's find all nations where we don't have any customers...
*/
SELECT	n.n_nationkey,
        n.n_name,
        n.n_regionkey,
        n.n_comment
FROM	dbo.nations AS n
WHERE	NOT EXISTS
		(
			SELECT * FROM dbo.customers AS c
			WHERE	c.c_nationkey = n.n_nationkey
		);
GO

/*
	Show all customers which had no orders
*/
SELECT	*
FROM	dbo.customers AS c
WHERE	NOT EXISTS
		(
			SELECT	*
			FROM	dbo.orders AS o
			WHERE	o.o_custkey = c.c_custkey
		);
GO

/*
	Show all customers which had orders in 2024
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
WHERE	EXISTS
		(
			SELECT	*
			FROM	dbo.orders AS o
			WHERE	o.o_orderdate >= '2024-01-01'
					AND o.o_orderdate <= '2024-12-31'
					AND o.o_custkey = c.c_custkey
		);
GO