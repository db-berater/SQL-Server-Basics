/*
	============================================================================
	File:		06 - TOP Operator.sql

	Summary:	This script demonstrates behavior of the TOP Operator!

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

SELECT	TOP (5)
		o.o_custkey,
		COUNT_BIG(*)	AS	number_of_orders
FROM	dbo.orders AS o
WHERE	o.o_orderdate >= '2022-01-01'
		AND o.o_orderdate <= '2022-06-30'
GROUP BY
		o.o_custkey
ORDER BY
		number_of_orders DESC;
GO

SELECT	TOP (5) WITH TIES
		o.o_custkey,
		COUNT_BIG(*)	AS	number_of_orders
FROM	dbo.orders AS o
WHERE	o.o_orderdate >= '2022-01-01'
		AND o.o_orderdate <= '2022-06-30'
GROUP BY
		o.o_custkey
ORDER BY
		number_of_orders DESC;
GO
