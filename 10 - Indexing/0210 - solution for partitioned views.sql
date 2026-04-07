/*============================================================================
	File:		0210 - solution for partitioned views.sql

	Summary:	A company is separating actual data (2013 – 2014) from historical
				data by using two separate tables:
					[dbo].[ActualOrders]
					[dbo].[HistoryOrders]

				Try to optimize the execution of the partitioned view

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

-- we create a Clustered index on the OrderDate because this attribute is
-- mostly used in this scenario.
DECLARE @stmt NVARCHAR(1024) = N'CREATE CLUSTERED INDEX cix_Orders_%s ON dbo.Orders_%s (OrderDate);'
DECLARE @exec NVARCHAR(1024);
DECLARE @i INT = 2000;
WHILE @i <= 2019
BEGIN
	SET @exec = REPLACE(@stmt, '%s', CAST(@i AS NVARCHAR(4)));
	EXEC sys.sp_executesql @exec;
	SET @i += 1;
END
GO

SET STATISTICS IO, TIME ON;
GO

SELECT	*
FROM	dbo.AllOrders AS A
WHERE	A.OrderDate >= '20140101' AND
		A.OrderDate < '20140201'
ORDER BY
		A.Customer_Id;
GO

-- How can we avoid the access path to not used tables?
-- we use CHECK CONSTRAINTS!!!
DECLARE @exec NVARCHAR(1024);
DECLARE @stmt NVARCHAR(1024) = N'
ALTER TABLE dbo.Orders_%s
ADD CONSTRAINT chk_OrderDate_%s
CHECK (OrderDate >= ''%s-01-01'' AND OrderDate < ''%t-01-01'');'

DECLARE @i INT = 2000;
WHILE @i <= 2019
BEGIN
	SET @exec = REPLACE(@stmt, '%s', CAST(@i AS NVARCHAR(4)));
	SET @exec = REPLACE (@exec, '%t', CAST(@i + 1 AS NVARCHAR(4)));

	PRINT @exec;
	EXEC sys.sp_executesql @exec;
	SET @i += 1;
END
GO

-- Select only one month out of 60 and look at the execution plan
SELECT	*
FROM	dbo.AllOrders AS A
WHERE	A.OrderDate >= '20140101' AND
		A.OrderDate < '20140201'
ORDER BY
		A.Customer_Id;
GO

-- what will happen, if we have to access two tables?
SELECT	*
FROM	dbo.AllOrders AS A
WHERE	A.OrderDate >= '20131201'
		AND A.OrderDate < '20140201'
ORDER BY
		Customer_Id;
GO

DECLARE	@StartDate	DATE	= '2013-12-01';
DECLARE @EndDate	DATE	= '2014-01-01';
SELECT	*
FROM	dbo.AllOrders AS A
WHERE	A.OrderDate >= @StartDate
		AND A.OrderDate < @EndDate
ORDER BY
		Customer_Id
OPTION	(RECOMPILE);
GO
