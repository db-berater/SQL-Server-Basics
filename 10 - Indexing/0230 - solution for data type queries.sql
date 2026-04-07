/*============================================================================
	File:		0230 - solution for data type queries.sql

	Summary:	The customer table has an attribute [state] which need to
				be queried quite often. Implementn the correct index and
				check whether it is working properly!

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

SELECT * FROM dbo.Customers
WHERE [ZIP] = 11745      
GO

SET STATISTICS IO OFF;
GO

-- to optimize the query we need an index on [state]
CREATE NONCLUSTERED INDEX nix_Customers_ZIP
ON dbo.Customers ([ZIP]);
GO

SET STATISTICS IO ON;
GO

SELECT * FROM dbo.Customers
WHERE [ZIP] = 11745;
GO

-- Ist das gleiche wie:....
SELECT * FROM dbo.Customers
WHERE CAST([ZIP] AS INT) = 11745;
GO

SET STATISTICS IO OFF;
GO

SELECT * FROM dbo.Customers
WHERE [ZIP] = '11745';
GO

DECLARE @ZIP CHAR(10) = 11745;
SELECT * FROM dbo.Customers
WHERE [ZIP] = @ZIP;
GO

SELECT * FROM dbo.Customers
WHERE [ZIP] = N'11745';
GO
