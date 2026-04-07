/*============================================================================
	File:		0250 - solution for wrong collation usage.sql

	Summary:	Scenario
				A database application is using TEMPDB heavily. In most cases the
				stored procedures collected data from the database into a temporary table.

				When the data have been collected they will be used with a JOIN operator
				for further queries.

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

-- typical workload
IF OBJECT_ID(N'tempdb..#OrderNumbers', N'U') IS NOT NULL
	DROP TABLE #OrderNumbers;
	GO

CREATE TABLE #OrderNumbers (OrderNumber CHAR(10) PRIMARY KEY CLUSTERED);
GO

-- load 100 random rows into the temporary table
INSERT INTO #OrderNumbers (OrderNumber)
SELECT	TOP (100)
		OrderNumber
FROM	dbo.CustomerOrders
ORDER BY
		NEWID();
GO

-- now we run into a problem because of a collation conflict
SET STATISTICS IO ON;
GO

SELECT	CO.*
FROM	dbo.CustomerOrders AS CO
		INNER JOIN #OrderNumbers AS OrdNo
		ON (CO.OrderNumber = OrdNo.OrderNumber);
GO

SET STATISTICS IO OFF;
GO

-- What collation would you take for solving the collation conflict?
SET STATISTICS IO ON;
GO

SELECT	CO.*
FROM	dbo.CustomerOrders AS CO
		INNER JOIN #OrderNumbers AS OrdNo
		ON (CO.OrderNumber = OrdNo.OrderNumber COLLATE LATIN1_GENERAL_CI_AS);
GO

SET STATISTICS IO OFF;
GO

-- why will this solution not work. Investigate the execution plan to find the solution!
-- What collation would you take for solving the collation conflict?
SET STATISTICS IO ON;
GO

SELECT	CO.*
FROM	dbo.CustomerOrders AS CO
		INNER JOIN #OrderNumbers AS OrdNo
		ON (CO.OrderNumber = OrdNo.OrderNumber COLLATE LATIN1_GENERAL_BIN);
GO

SET STATISTICS IO OFF;
GO

/****** Elegantere Lösung ********/
-- typical workload
IF OBJECT_ID(N'tempdb..#OrderNumbers', N'U') IS NOT NULL
	DROP TABLE #OrderNumbers;
	GO

CREATE TABLE #OrderNumbers (OrderNumber CHAR(10) COLLATE DATABASE_DEFAULT PRIMARY KEY CLUSTERED);
GO

-- load 100 random rows into the temporary table
INSERT INTO #OrderNumbers (OrderNumber)
SELECT	TOP (100)
		OrderNumber
FROM	dbo.CustomerOrders
ORDER BY
		NEWID();
GO

-- now we run into a problem because of a collation conflict
SET STATISTICS IO ON;
GO

SELECT	CO.*
FROM	dbo.CustomerOrders AS CO
		INNER JOIN #OrderNumbers AS OrdNo
		ON (CO.OrderNumber = OrdNo.OrderNumber);
GO

SET STATISTICS IO OFF;
GO

/********************* TABLE VARIABLE *******************/
DECLARE  @OrderNumbers TABLE
(
	OrderNumber CHAR(10)
);

-- load 1000 random rows into the temporary table
INSERT INTO @OrderNumbers (OrderNumber)
SELECT	TOP (100)
		OrderNumber
FROM	dbo.CustomerOrders
ORDER BY
		NEWID();

SET STATISTICS IO ON;

SELECT	CO.Id ,
        CO.Customer_Id ,
        CO.OrderNumber ,
        CO.InvoiceNumber ,
        CO.OrderDate ,
        CO.OrderStatus_Id ,
        CO.Employee_Id ,
        CO.InsertUser ,
        CO.InsertDate
FROM	@OrderNumbers AS O
		INNER JOIN dbo.CustomerOrders AS CO
		ON (O.OrderNumber = CO.OrderNumber)
ORDER BY
		CO.OrderNumber;

SET STATISTICS IO OFF;
GO
