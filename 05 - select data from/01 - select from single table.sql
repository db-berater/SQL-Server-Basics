/*
	============================================================================
	File:		01 - select from single table.sql

	Summary:	This script demonstrates the primitive way to select data
				from a single table.

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
	output of all existing columns of a table with "*" as placeholder
*/
SET STATISTICS IO, TIME ON;
GO

SELECT	TOP (100)
		*
FROM	dbo.customers;
GO

/*
	A better technique is to specify all attributes in the SELECT! 
	This makes it easier to see which attributes are in the table 
	are present.
*/
SELECT	TOP (100)
		c_custkey,
        c_mktsegment,
        c_nationkey,
        c_name,
        c_address,
        c_phone,
        c_acctbal,
        c_comment
FROM	dbo.customers;
GO

/*
	The dedicated specification of attributes optimizes performance, 
	because not all information has to be sent to the client!
*/
SELECT	TOP (100)
		c_custkey,
        c_name
FROM	dbo.customers;
GO

/*
	Calculation / Manipulation of output of columns
*/
SELECT	TOP (100)
		c_custkey,
		LEFT(c_mktsegment, 1)	AS	c_mkt_character
FROM	dbo.customers ;
GO

SELECT	TOP (10000)
		o_orderdate,
		---CHOOSE(DATEPART(WEEKDAY, o_orderdate), 'So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa')	AS	weekday,
		dbo.get_weekday(o_orderdate) AS week_day,
        o_orderkey,
        o_custkey,
        o_orderpriority,
        o_shippriority,
        o_clerk,
        o_orderstatus,
        o_totalprice,
        o_comment,
        o_storekey
FROM	dbo.orders 
WHERE	o_orderdate = '2020-01-01'
GO


/*
	CASE Construction
*/
SELECT	TOP (100)
		c_custkey,
		CASE
			WHEN c_mktsegment = 'AUTOMOBILE' THEN 1
			WHEN c_mktsegment = 'BUILDING' THEN 2
			WHEN c_mktsegment = 'FURNITURE' THEN 3
			WHEN c_mktsegment = 'HOUSEHOLD' THEN 4
			WHEN c_mktsegment = 'MACHINERY' THEN 5
			ELSE 6
		END				AS	category,
		c_mktsegment
FROM	dbo.customers
GO