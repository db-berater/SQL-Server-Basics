/*
	============================================================================
	File:		01 - simple aggregations.sql

	Summary:	This script demonstrates the usage of aggregations!

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
	COUNT() / COUNT_BIG()
	How many orders do we have in the system
*/
SELECT	COUNT(*)	AS	number_of_orders
FROM	dbo.orders;
GO

/*
	MIN() / MAX()
	What customer has the smalles acctbal?
*/
SELECT	MIN(c_acctbal)	AS	smallest_balance
FROM	dbo.customers;
GO

/*
	smallest and biggest account balance
*/
SELECT	MIN(c_acctbal)	AS	smallest_balance,
		MAX(c_acctbal)	AS	biggest_balance
FROM	dbo.customers;
GO