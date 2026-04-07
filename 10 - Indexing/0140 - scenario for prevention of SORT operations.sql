/*============================================================================
	File:		0140 - scenario for foreign key constrainst.sql

	Summary:	Scenario
				There are two tables in the database without any relational dependencies
				Optimize the query to consider the dependencies and usage of best
				index strategy

				Implement the correct index stragegy and check whehter it works
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
USE master;
GO

-- Create the demo database as a brand new test environment
IF DB_ID(N'demo_db') IS NOT NULL
BEGIN
	ALTER DATABASE [demo_db] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [demo_db];
END
GO

CREATE DATABASE [demo_db];
GO
ALTER DATABASE [demo_db] SET RECOVERY SIMPLE;
GO

USE [demo_db];
GO

/************************** create a demo environment from CustomerOrders *********/
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

SELECT	C.Id,
		C.Name,
		CO.OrderNumber,
		CO.OrderDate,
		CO.Employee_Id
FROM	dbo.Customers AS c
		INNER JOIN dbo.CustomerOrders AS co
		ON (C.Id = CO.Customer_Id)
WHERE	C.Id = 10
ORDER BY
		CO.OrderDate;
GO