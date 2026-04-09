/*
	============================================================================
	File:		0060 - demonstration of HEAPS.sql

	Summary:	This script demonstrates the internal structure of a HEAP.

				THIS SCRIPT IS PART OF THE TRACK:
				"Database Optimization By Indexes"

	Date:		Januar 2026

	SQL Server Version: >= 2016
	============================================================================
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE ERP_Demo;
GO

EXEC dbo.sp_drop_foreign_keys @table_name = N'ALL';
EXEC dbo.sp_drop_indexes
    @table_name = N'ALL',
    @check_only = 0;
EXEC dbo.sp_drop_statistics
    @table_name = N'ALL',
    @check_only = 0;
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
FROM	dbo.get_table_pages_info
		(
			N'dbo.customers',
			0
		) AS gtp;
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

/*
	Wether you are looking for all data or only 1 single row
	Microsoft SQL Server has to scan the whole table!
*/
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
WHERE	c.c_custkey = 10
OPTION	(MAXDOP 4);
GO

/*
	Microsoft SQL Server must scan the table because it does not know
	where the record is located!
*/
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
WHERE	c_custkey = 10
OPTION	(
			MAXDOP 4,
			QUERYTRACEON 9130
		);
GO

/*
    There might be a little improvement BUT...
    - it is not because the table is a HEAP
    - it is because of the ROWGOAL!
*/
-- Check the execution plan of the next query and afterwards the IO
SELECT TOP (1)
		c_custkey,
        c_mktsegment,
        c_nationkey,
        c_name,
        c_address,
        c_phone,
        c_acctbal,
        c_comment
FROM	dbo.customers
WHERE	c_custkey = 10
OPTION  (
            MAXDOP 4,
            QUERYTRACEON 9130
        );
GO

-- same with a higher Customer Id
SELECT TOP (1)
		c_custkey,
        c_mktsegment,
        c_nationkey,
        c_name,
        c_address,
        c_phone,
        c_acctbal,
        c_comment
FROM	dbo.customers
WHERE	c_custkey = 100000
OPTION  (
            MAXDOP 1,
            QUERYTRACEON 9130
        );
GO

SET STATISTICS IO, TIME OFF;
GO