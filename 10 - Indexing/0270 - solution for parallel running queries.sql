/*============================================================================
	File:		0270 - solution for parallel running queries.sql

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
USE demo_db;
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

-- First step is to create a covering index on the dbo.Customers table
CREATE NONCLUSTERED INDEX nix_Customers_Name_Id ON dbo.Customers
(Id, Name)
WITH DROP_EXISTING;
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

-- now we create another covering index for the aggregation of orders
CREATE NONCLUSTERED INDEX nix_CustomerOrders_Customer_Id
ON dbo.CustomerOrders
(
	Customer_Id,
	OrderDate
);
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