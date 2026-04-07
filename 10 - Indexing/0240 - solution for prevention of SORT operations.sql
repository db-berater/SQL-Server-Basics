/*============================================================================
	File:		0240 - solution for prevention of SORT operations.sql

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
USE [demo_db];
GO

-- Optimize the following query by using indexes and - maybe - rewriting
-- the query.


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

SET STATISTICS IO OFF;
GO

-- first we create an index on the customers to seek the customer = 10!
CREATE UNIQUE CLUSTERED INDEX cuix_Customers_Id
ON dbo.Customers
(Id);
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

-- next index is on the dbo.CustomerOrders to avoid the table scan
CREATE NONCLUSTERED INDEX cuix_CustomerOrders_Customer_Id
ON dbo.CustomerOrders
(Customer_Id, OrderDate)
INCLUDE
(
	OrderNumber,
	Employee_Id
)
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