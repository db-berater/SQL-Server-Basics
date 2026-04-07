/*============================================================================
	File:		0160 - scenario for wrong collation usage.sql

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
USE master;
GO

-- Create the demo database as a brand new test environment
IF DB_ID(N'demo_db') IS NOT NULL
BEGIN
	ALTER DATABASE demo_db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE demo_db;
END
GO

CREATE DATABASE demo_db COLLATE Latin1_General_BIN;
GO
ALTER DATABASE demo_db SET RECOVERY SIMPLE;
GO

USE demo_db;
GO

-- Let's create the demo table dbo.CustomerOrders
IF OBJECT_ID(N'dbo.CustomerOrders', N'U') IS NOT NULL
	DROP TABLE dbo.CustomerOrders;
	GO

CREATE TABLE dbo.CustomerOrders
(
	Id int IDENTITY(1,1) NOT NULL,
	Customer_Id int NOT NULL,
	OrderNumber char(10) NOT NULL,
	InvoiceNumber char(10) NOT NULL,
	OrderDate date NOT NULL,
	OrderStatus_Id int NOT NULL,
	Employee_Id int NOT NULL,
	InsertUser sysname NOT NULL,
	InsertDate datetime NOT NULL
);
GO

BEGIN TRANSACTION;
GO
	INSERT INTO dbo.CustomerOrders
	(
		Customer_Id, OrderNumber, InvoiceNumber, OrderDate, OrderStatus_Id,
		Employee_Id, InsertUser, InsertDate
	)
	SELECT	Customer_Id, OrderNumber, InvoiceNumber, OrderDate, OrderStatus_Id,
			Employee_Id, InsertUser, InsertDate
	FROM	CustomerOrders.dbo.CustomerOrders;

COMMIT TRANSACTION;
GO

-- Create indexes on the table dbo.CustomerOrders
CREATE UNIQUE CLUSTERED INDEX cuix_CustomerOrders_Id ON dbo.CustomerOrders (Id);
CREATE NONCLUSTERED INDEX nuix_CustomerOrders_OrderNumber
ON dbo.CustomerOrders (OrderNumber);
GO

-- typical workload
CREATE TABLE #OrderNumbers (OrderNumber CHAR(10));
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