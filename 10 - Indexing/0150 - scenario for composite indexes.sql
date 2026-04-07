/*============================================================================
	File:		0150 - scenario for composite indexes.sql

	Summary:	Scenario
				The developer got the order to improve the performance of a query
				which was using a predicate of at least two attributes in the table.
				Therefore the developer created a new index based on these two heavily
				used attributes by the order of their cardinality.

				Although the index was used the performance was really bad!

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
USE master;
GO

-- Create the demo database as a brand new test environment
IF DB_ID(N'demo_db') IS NOT NULL
BEGIN
	ALTER DATABASE demo_db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE demo_db;
END
GO

CREATE DATABASE demo_db;
GO
ALTER DATABASE demo_db SET RECOVERY SIMPLE;
GO

USE demo_db;
GO

BEGIN TRANSACTION;
GO
	SELECT	*
	INTO	dbo.CustomerOrders
	FROM	CustomerOrders.dbo.CustomerOrders;
	GO
COMMIT TRANSACTION;
GO

CREATE NONCLUSTERED INDEX nix_CustomerOrders_OrderDate_Customer_Id
ON dbo.CustomerOrders
(
	OrderDate,
	Customer_Id
);
GO

SET STATISTICS IO ON;
GO

SELECT	*
FROM	dbo.CustomerOrders
WHERE	OrderDate >= '20080101'
		AND OrderDate < '20100101'
		AND Customer_Id = 36528
ORDER BY
		OrderDate DESC
OPTION (QUERYTRACEON 9130);

SET STATISTICS IO OFF;
GO

-- 1. Index Id herausfinden
SELECT * FROM sys.indexes
WHERE	OBJECT_ID = OBJECT_ID(N'dbo.CustomerOrders');
GO

-- 2. Belegte Datenseiten
SELECT allocated_page_page_id
FROM sys.dm_db_database_page_allocations
(
	DB_ID(),
	OBJECT_ID(N'dbo.CustomerOrders'),
	2,
	NULL,
	N'DETAILED'
)
WHERE	page_level = 2
ORDER BY
	page_level DESC;