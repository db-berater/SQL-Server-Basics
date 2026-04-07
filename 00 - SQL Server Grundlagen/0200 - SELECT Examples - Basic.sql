/*
	============================================================================
	File:		0200 - SELECT Examples - Basic.sql

	Summary:	This script demonstrates the SELECT operations

				THIS SCRIPT IS PART OF THE TRACK: "SQL Server - Database Basics"

	Date:		April 2022

	SQL Server Version: 2014 / 2017 / 2019
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
USE ERP_Demo;
GO

/*
	1. Query: All attributes from dbo.Customers
*/
SELECT	c_custkey,
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
	1. Query: All attributes by dedicated column name
*/
SELECT	Id,
		[Name],
		InsertUser,
		InsertDate
FROM	dbo.Customers;
GO

/*
	2. Query:	Use aliases in the query to reference objects
*/
SELECT	dbo.Customers.Id,
		dbo.Customers.Name,
		dbo.Customers.InsertUser,
		dbo.Customers.InsertDate
FROM	dbo.Customers
		INNER JOIN dbo.CustomerOrders
		ON (dbo.Customers.Id = dbo.CustomerOrders.Customer_Id)
GO

SELECT	c.Id,
		c.Name,
		c.InsertUser,
		c.InsertDate
FROM	dbo.Customers AS c
		INNER JOIN dbo.CustomerOrders AS co
		ON (c.Id = co.Customer_Id)
ORDER BY
		c.Name ASC;
GO

/*
	2. Query: Output of ordered data
*/
SELECT	c.Id,
        c.Name,
        c.InsertUser,
        c.InsertDate
FROM	dbo.Customers AS c
ORDER BY
		c.Id ASC;
GO

/*
	4. Query: filter data with WHERE statement
*/
SELECT	c.Id,
        c.Name,
        c.InsertUser,
        c.InsertDate
FROM	dbo.Customers AS c
WHERE	c.Id = 10;	/* True / False */
GO

/*
	5. Query: Precedence of logical operators
		- AND before OR!
*/
SELECT	c.*
FROM	dbo.Customers AS c
WHERE	c.Id = 10
		OR InsertDate >= '2003-01-01'
		AND InsertDate < '2004-01-01';
GO

/*
	To break the rule you must use brackets
*/
SELECT	c.Id,
        c.Name,
        c.InsertUser,
        c.InsertDate
FROM	dbo.Customers AS c
WHERE	c.Id = 10
		OR
		(
			c.InsertDate >= '2003-01-01'
			AND c.InsertDate < '2004-01-01'
		);
GO

SELECT	c.Id,
        c.Name,
        c.InsertUser,
        c.InsertDate
FROM	dbo.Customers AS c
WHERE	(
			c.Id = 10
			OR c.InsertDate >= '2003-01-01'
		)
		AND c.InsertDate < '2004-01-01';
GO

/*
	6. Query:	All orders from 2008 with NON SARGable predicate!
	NOTE:		An index cannot be used because of transformation
				of the predicate for all rows in the table!
*/
SELECT	co.Id,
        co.Customer_Id,
        co.OrderNumber,
        co.InvoiceNumber,
        co.OrderDate,
        co.OrderStatus_Id,
        co.Employee_Id,
        co.InsertUser,
        co.InsertDate
FROM	dbo.CustomerOrders AS co
WHERE	YEAR(co.OrderDate) = 2008;
GO

/*
	To use an existing index it is mandatory to NOT transform
	the attribute of the table!
*/
SELECT	co.Id,
        co.Customer_Id,
        co.OrderNumber,
        co.InvoiceNumber,
        co.OrderDate,
        co.OrderStatus_Id,
        co.Employee_Id,
        co.InsertUser,
        co.InsertDate
FROM	dbo.CustomerOrders AS co
WHERE	co.OrderDate >= '2008-01-01'
		AND co.OrderDate < '2009-01-01';
GO

/*
	7. Query:	Aggregations
		COUNT
		SUM
		MIN
		MAX
		AVG

	Example: All customers with more than 55 orders
*/
SELECT	co.Customer_Id,
		COUNT(*)		AS AnzahlBestellungen
FROM	dbo.CustomerOrders AS co
GROUP BY	/* pro */
		co.Customer_Id
HAVING	COUNT(*) > 55
ORDER BY
		AnzahlBestellungen DESC;
GO

/*
	NOTE:	NULL values will not be considered
*/

DROP TABLE IF EXISTS dbo.TestTable;
GO

SELECT	co.Id,
		co.Customer_Id,
		co.OrderDate,
		co.OrderNumber,
		CASE WHEN co.id % 1000 = 0
			 THEN NULL
			 ELSE co.InvoiceNumber
		END	AS	InvoiceNumber
INTO	dbo.TestTable
FROM	dbo.CustomerOrders AS co;
GO

SELECT	tt.Customer_Id,
		COUNT(*) AS	NumOfOrders,
		COUNT(tt.InvoiceNumber) AS NumOfInvoices
FROM	dbo.TestTable AS tt
GROUP BY
		tt.Customer_Id
HAVING	COUNT(*) <> COUNT(tt.InvoiceNumber);
GO
