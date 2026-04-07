/*============================================================================
	File:		0220 - solution for SARGable queries.sql

	Summary:	The customer table can have empty columns.
				How can we improve the performance on these columns
				with indexes and other strategies?

				Implement the correct index and check whether it works
				or not!

				THIS SCRIPT IS PART OF THE TRACK:
				"Database Optimization By Indexes"

	Date:		February 2018

	SQL Server Version: 2012 / 2014 / 2016 / 2017
------------------------------------------------------------------------------
	Written by Uwe Ricken, db Berater GmbH

	This script is intended only as a supplement to demos and lectures
	given by Uwe Ricken.  
  
	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
============================================================================*/
USE [demo_db];
GO

-- Optimize the following query by using indexes and - maybe - rewriting
-- the query.

SET STATISTICS IO ON;
GO

SELECT	Name ,
		CCode ,
		State ,
		ZIP ,
		Street ,
		City
FROM	dbo.Customers
WHERE	ISNULL(Phone, '0') = '0'
ORDER BY
		Name;
GO

-- Create an index on Phone to improve the performance
CREATE NONCLUSTERED INDEX nix_Customers_Phone
ON dbo.Customers (Phone);
GO

SELECT	Name ,
		CCode ,
		State ,
		ZIP ,
		Street ,
		City
FROM	dbo.Customers
WHERE	ISNULL(Phone, '0') = '0';
GO

-- The query is not SARGable because of wthe usage of ISNULL to tranform empty Phone-Entries to '0'!
SELECT	Name ,
		CCode ,
		State ,
		ZIP ,
		Street ,
		City
FROM	dbo.Customers
WHERE	Phone IS NULL
		OR Phone = '0'
ORDER BY
		Name;
GO

/***** UNION ALL = OR */
SELECT	Name ,
		CCode ,
		State ,
		ZIP ,
		Street ,
		City,
		Phone
FROM	dbo.Customers
WHERE	Phone IS NULL

UNION ALL

SELECT	Name ,
		CCode ,
		State ,
		ZIP ,
		Street ,
		City,
		Phone
FROM	dbo.Customers
WHERE	Phone = '0'

ORDER BY
		Name;
GO

CREATE NONCLUSTERED INDEX nix_Customers_Phone
ON	dbo.Customers (Phone)
INCLUDE
(
	Name ,
	CCode ,
	State ,
	ZIP ,
	Street ,
	City
)
--WHERE	Phone IS NULL
WITH DROP_EXISTING;
GO

-- The query is not SARGable because of wthe usage of ISNULL to tranform empty Phone-Entries to '0'!
SELECT	Name ,
		CCode ,
		State ,
		ZIP ,
		Street ,
		City
FROM	dbo.Customers
WHERE	Phone IS NULL
		OR Phone = '0'
ORDER BY
		Name;
GO

-- UNION
-- The query is not SARGable because of wthe usage of ISNULL to tranform empty Phone-Entries to '0'!
SELECT	Name ,
		CCode ,
		State ,
		ZIP ,
		Street ,
		City
FROM	dbo.Customers
WHERE	Phone IS NULL

UNION ALL

SELECT	Name ,
		CCode ,
		State ,
		ZIP ,
		Street ,
		City
FROM	dbo.Customers
WHERE	Phone = '0';
GO
