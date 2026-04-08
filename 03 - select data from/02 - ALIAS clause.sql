/*
	============================================================================
	File:		02 - ALIAS (AS) clause.sql

	Summary:	This script demonstrates the work with aliases for better reading
				and understanding of sql queries

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
	Using an alias makes queries easier to read by shortening long table or column
	names, which reduces visual noise and improves clarity.
	It also helps developers avoid ambiguity in joins or subqueries, making complex
	statements more maintainable and less error‑prone.
*/
SELECT	n.n_nationkey,
        n.n_name,
        n.n_regionkey,
        n.n_comment
FROM	dbo.nations AS n;
GO

SELECT	TOP (100)
		c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
GO

/*
	Aliases can although be used for the presentation layer (column names)
*/
SELECT	TOP (100)
		c.c_custkey			AS	customer_number,
        c.c_mktsegment		AS	marketing_segment,
        c.c_nationkey		AS	nation_reference,
        c.c_name			AS	customer_name,
        c.c_address			AS	customer_address,
        c.c_phone			AS	customer_phone,
        c.c_acctbal			AS	actual_balance
FROM	dbo.customers AS c
GO
