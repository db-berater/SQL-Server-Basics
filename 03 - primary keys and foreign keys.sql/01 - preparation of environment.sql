/*
	============================================================================
	File:		01 - preparation of environment

	Summary:	This script prepares the data in the [demo] schema to show
				the usage of
				- PRIMARY KEY constraints
				- FOREIGN KEY constraints

				THIS SCRIPT IS PART OF THE TRACK: "Workshop - SQL Server Basics"

	Date:		November 2025

	SQL Server Version: >= 2016
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
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE ERP_Demo;
GO

DROP TABLE IF EXISTS demo.customers;
DROP TABLE IF EXISTS demo.nations;
DROP TABLE IF EXISTS demo.regions;
GO

/* Let's create a demo schema for the objects */
EXEC dbo.sp_create_demo_schema;
GO

/* We create three objects to demonstrate the key constraints */
RAISERROR ('Creating table demo.regions...', 0, 1) WITH NOWAIT;
SELECT	r_regionkey,
        r_name,
        r_comment
INTO	demo.regions
FROM	dbo.regions;
GO

RAISERROR ('Creating table demo.nations...', 0, 1) WITH NOWAIT;
SELECT	n_nationkey,
        n_name,
        n_regionkey,
        n_comment
INTO	demo.nations
FROM	dbo.nations;
GO

RAISERROR ('Creating table demo.customers...', 0, 1) WITH NOWAIT;
SELECT	c_custkey,
        c_mktsegment,
        c_nationkey,
        c_name,
        c_address,
        c_phone,
        c_acctbal,
        c_comment
INTO	demo.customers
FROM	dbo.customers
GO

ALTER TABLE demo.regions
ALTER COLUMN r_regionkey INT NULL;
GO

INSERT INTO demo.nations
(n_nationkey, n_name, n_regionkey, n_comment)
SELECT	TOP (1)
		n_nationkey,
        n_name,
        n_regionkey,
        n_comment
FROM	dbo.nations
WHERE	n_nationkey = 47;
GO

UPDATE	demo.customers
SET		c_nationkey = 99
WHERE	c_custkey = 10;
GO