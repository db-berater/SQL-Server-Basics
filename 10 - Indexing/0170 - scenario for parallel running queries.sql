/*============================================================================
	File:		0170 - scenario for parallel running queries.sql

	Summary:	Scenario
				A database developer has created a query for a management report.
				You check the query and find it heavily running in parallel
				although only a few rows will be selected for the report!

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
	INTO	dbo.Customers
	FROM	CustomerOrders.dbo.Customers;
	GO

	SELECT	*
	INTO	dbo.CustomerOrders
	FROM	CustomerOrders.dbo.CustomerOrders;
	GO
COMMIT TRANSACTION;
GO

SET STATISTICS IO ON;
GO

SELECT	C.Name,
		YEAR(CO.OrderDate)	AS	YearOfOrder,
		COUNT_BIG(*)		AS	NumOfOrders
FROM	dbo.Customers AS C INNER JOIN dbo.CustomerOrders AS CO
		ON (C.Id = CO.Customer_Id)
WHERE	C.Id <= 10
GROUP BY
		C.Name,
		YEAR(OrderDate)
ORDER BY
		C.Name;

SET STATISTICS IO OFF;
GO

CREATE UNIQUE CLUSTERED INDEX cuix_Customers_Id
ON dbo.Customers
(
	Id
)
WITH DROP_EXISTING;
GO

CREATE NONCLUSTERED INDEX nix_CustomerOrders_Customer_Id
ON dbo.CustomerOrders
(Customer_Id)
INCLUDE
(OrderDate);
GO

