/*============================================================================
	File:		0130 - scenario for data type queries.sql

	Summary:	The customer table has an attribute [state].

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
	WITH C
	AS
	(
		SELECT	DISTINCT
				C.Id,
				C.Name,
				A.CCode,
				A.State,
				A.ZIP,
				A.Street,
				A.City,
				Phone.Property_Value		AS	Phone,
				Fax.Property_Value			AS	Fax,
				EMail.Property_Value		AS	EMail,
				CAST ('Just a filler' AS CHAR(1024))	AS	C1
		FROM	CustomerOrders.dbo.Customers AS C
				INNER JOIN CustomerOrders.dbo.CustomerAddresses AS CA
				ON (C.Id = CA.Customer_Id)
				INNER JOIN CustomerOrders.dbo.Addresses AS A
				ON (CA.Address_Id = A.Id)
				OUTER APPLY
				(
					SELECT	Property_Value
					FROM	CustomerOrders.dbo.CustomerProperties
					WHERE	Customer_Id = C.Id
							AND Property_Id = 1
				)		AS	Phone
				OUTER APPLY
				(
					SELECT	Property_Value
					FROM	CustomerOrders.dbo.CustomerProperties
					WHERE	Customer_Id = C.Id
							AND Property_Id = 2
				)		AS	Fax
				OUTER APPLY
				(
					SELECT	Property_Value
					FROM	CustomerOrders.dbo.CustomerProperties
					WHERE	Customer_Id = C.Id
							AND Property_Id = 3
				)		AS	EMail
		WHERE	CA.IsDefault = 1
	)
	SELECT	TOP (1000) *
	INTO dbo.Customers
	FROM C;
COMMIT TRANSACTION;
GO

SET STATISTICS IO ON;
GO

SELECT * FROM dbo.Customers
WHERE [ZIP] = 11745;
GO

SET STATISTICS IO OFF;
GO
