/*============================================================================
	File:		02 - Clustered Index.sql

	Summary:	This script demonstrates the internal structure of a CI.

				THIS SCRIPT IS PART OF THE TRACK:
				"Database Optimization By Indexes"

	Date:		Januar 2026

	SQL Server Version: >= 2016
------------------------------------------------------------------------------
	Written by Uwe Ricken, db Berater GmbH

	This script is intended only as a supplement to demos and lectures
	given by Uwe Ricken.  
  
	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
============================================================================*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE ERP_Demo;
GO

/*
	Note:	The procedure is part of the framework developed by db Berater GmbH
			for demonstration purposes!
*/
EXEC dbo.sp_drop_indexes @table_name = N'dbo.customers', @check_only = 0;
GO


/*
	Create a non unique clustered index on dbo.customers
*/
CREATE CLUSTERED INDEX pk_customers ON dbo.customers (c_custkey);
GO

/*
	Note:	The procedure is part of the framework developed by db Berater GmbH
			for demonstration purposes!
*/
SELECT	gtp.index_id,
        gtp.partition_number,
        gtp.rows,
        gtp.total_pages,
        gtp.used_pages,
        gtp.data_pages,
        gtp.space_mb,
        gtp.root_page,
        gtp.first_iam_page
FROM	dbo.get_table_pages_info(N'dbo.customers', 1) AS gtp;
GO

/*
	************************* LET THE QUERIES START !!! **************************
	- a good developer checks consumed IO and TIME and the execution plan
	- EVERY TIME!
*/
SET STATISTICS IO, TIME ON;
GO

/*
	Get a list of all customers in the database.
	Note: To get the results faster just drop the result after execution.
*/
SELECT	c.c_custkey,
		c.c_mktsegment,
		c.c_nationkey,
		c.c_name,
		c.c_address,
		c.c_phone,
		c.c_acctbal,
		c.c_comment
FROM	dbo.customers AS c;
GO

-- SELECT with ORDER BY
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.Customers AS c
ORDER BY
		c.c_custkey;
GO

SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.Customers AS c
ORDER BY
		c_name;
GO

/* Check the exection plan of the next query and afterwards the IO */
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.Customers AS c
WHERE	c.c_custkey = 10;
GO

/*
	Note:	The procedure is part of the framework developed by db Berater GmbH
			for demonstration purposes!
*/
SELECT	gtp.root_page,
        gtp.first_iam_page
FROM	dbo.get_table_pages_info(N'dbo.customers', 1) AS gtp;
GO

/*
    Let's do it in slow motion again! We only need the ROOT-Node!
    (1:311378:0)
*/
DBCC TRACEON (3604);
DBCC PAGE (0, 1, 311378, 3);
GO

-- 2nd IO into the B-Tree (Intermediate Level)
DBCC PAGE (0, 1, 10904, 3);
GO

-- 3rd IO into the Leaf Level
DBCC PAGE (0, 1, 8680, 3) WITH TABLERESULTS;
GO

-- same with a higher Customer Id
SELECT * FROM dbo.Customers WHERE c_custkey = 74000;
GO

/* Even an ORDER will now not use a SORT operation anymore */
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.Customers AS c
WHERE	c_custkey = 10
ORDER BY
		c.c_name;
GO

SET STATISTICS IO, TIME ON;
GO

-- now we create the CI as a UNIQUE index
CREATE UNIQUE CLUSTERED INDEX pk_customers ON dbo.customers (c_custkey)
WITH
(
	DROP_EXISTING = ON,
	MAXDOP = 1,
	DATA_COMPRESSION = NONE
);
GO

/*
	Note:	The procedure is part of the framework developed by db Berater GmbH
			for demonstration purposes!
*/
SELECT	gtp.index_id,
        gtp.partition_number,
        gtp.rows,
        gtp.total_pages,
        gtp.used_pages,
        gtp.data_pages,
        gtp.space_mb,
        gtp.root_page,
        gtp.first_iam_page
FROM	dbo.get_table_pages_info(N'dbo.customers', 1) AS gtp;
GO

-- walk through the B-Tree Index
-- (1:457410:0)
DBCC TRACEON (3604);
DBCC PAGE (0, 1, 457410, 3);
GO

-- 2nd IO into the B-Tree (Intermediate Level)
DBCC PAGE (0, 1, 124784, 3);
GO

-- 3rd IO into the Leaf Level
DBCC PAGE (0, 1, 124752, 3) WITH TABLERESULTS;
GO

SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.Customers AS c
WHERE	c.c_custkey = 10
ORDER BY
		c.c_name;
GO