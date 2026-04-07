/*============================================================================
	File:		0010 - create database and relations.sql

	Summary:	This script creates a demo database which will be used for
				the future demonstration scripts

				THIS SCRIPT IS PART OF THE TRACK: "SQL Server - Database Basics"

	Date:		November 2020

	SQL Server Version: 2008 / 2012 / 2014 / 2017 / 2019
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

-- Restore the CustomerOrders-Database
EXEC dbo.sp_restore_Customers;
GO

-- Restore the ERP_Demo-Database
EXEC dbo.sp_restore_ERP_demo;
GO

-- Create a demo database
EXEC dbo.sp_create_demo_db;
GO
