/*============================================================================
	File:		0080 - demonstration of NONCLUSTERED INDEX.sql

	Summary:	This script demonstrates the internal structure of a
				NONCLUSTERED INDEX.

				THIS SCRIPT IS PART OF THE TRACK:
				"Database Optimization By Indexes"

	Date:		January 2018

	SQL Server Version: 2012 / 2014 / 2016 / 2017 / 2019
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
EXEC dbo.sp_drop_indexes
	@table_name = N'ALL',
	@check_only = 0;
GO


/************************** LET THE QUERIES START !!! ***************************/
-- a good developer checks consumed IO and TIME and the execution plan EVERY TIME!
SET STATISTICS IO, TIME ON;
GO

-- SELECT all data from dbo.orders from 2018-12-20
-- the query operation will be a TABLE SCAN!
SELECT	o_custkey,
		o_orderkey,
		o_orderpriority,
		o_orderdate
FROM	dbo.orders
WHERE	o_orderdate = '2018-12-20'
GO

/*
	Note:	The procedure is part of the framework developed by db Berater GmbH
			for demonstration purposes!
*/
EXEC sp_create_indexes_orders
	@column_list = N'o_orderdate';
GO

-- rerun the above query for improvement checks
SELECT	o_custkey,
		o_orderkey,
		o_orderpriority,
		o_orderdate
FROM	dbo.orders
WHERE	o_orderdate = '2018-12-20'
GO

SELECT	MIN(o_orderdate)	AS	min_o_orderdate
FROM	dbo.orders;
GO

SELECT TOP(1)
		o_orderdate
FROM	dbo.orders
ORDER BY
		o_orderdate ASC;

/*
	Check the allocated data pages!

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
FROM	dbo.get_table_pages_info(N'dbo.orders', NULL) AS gtp;
GO

--MOVE down to the leaf level of the nonclustered index
DBCC TRACEON (3604);
DBCC PAGE (0, 1, 158146, 3);
GO

-- Intermediate Level
DBCC PAGE (0, 1, 87760, 3);
GO

-- Leaf Level
DBCC PAGE (0, 1, 88144, 3);
GO

DBCC PAGE (0, 1, 513, 3) WITH TABLERESULTS;


/*
0x0104010001001200
	The RID is a HEX-Value which points directly to the record!
	0x02 17 00 00	=	Page	=	5890
	0x01 00			=	File	=	1
	0x04 00			=	Slot	=	4
*/

SELECT	sys.fn_PhysLocFormatter(0x0134000001001D00)
GO
DBCC PAGE (0, 1, 13313, 3) WITH TABLERESULTS;
GO

/**************************** NOW a with Clustered Index ****************************/
/*
	Note:	The procedure is part of the framework developed by db Berater GmbH
			for demonstration purposes!
*/
EXEC dbo. sp_create_indexes_orders
	@column_list = N'o_orderkey, o_orderdate';
GO

SELECT	gtp.index_id,
        gtp.partition_number,
        gtp.rows,
        gtp.total_pages,
        gtp.used_pages,
        gtp.data_pages,
        gtp.space_mb,
        gtp.root_page,
        gtp.first_iam_page
FROM	dbo.get_table_pages_info(N'dbo.orders', NULL) AS gtp;
GO

-- rerun the above query for improvement checks
SELECT	o_custkey,
		o_orderkey,
		o_orderpriority,
		o_orderdate
FROM	dbo.orders
WHERE	o_orderdate = '2018-12-20'
GO


-- Create an index on the OrderDate column
CREATE NONCLUSTERED INDEX nix_orders_o_orderdate
ON dbo.orders
(
	o_orderdate
)
INCLUDE
(
	o_custkey,
	o_orderpriority
)
WITH
(
	SORT_IN_TEMPDB = ON,
	DATA_COMPRESSION = PAGE,
	DROP_EXISTING = ON
);
GO

-- rerun the above query for improvement checks
SELECT	o_custkey,
		o_orderkey,
		o_orderpriority,
		o_orderdate
FROM	dbo.orders
WHERE	o_orderdate = '2018-12-20'
GO

-- rerun the above query for improvement checks
SELECT	o_custkey,
		o_orderkey,
		o_orderpriority,
		o_orderdate
FROM	dbo.orders
WHERE	o_orderdate = '2018-12-20'
ORDER BY
		o_custkey
GO

-- Create an index on the OrderDate column
CREATE NONCLUSTERED INDEX nix_orders_o_orderdate_o_custkey
ON dbo.orders
(
	o_orderdate,
	o_custkey
)
INCLUDE
(
	o_orderpriority
)
WITH
(
	SORT_IN_TEMPDB = ON,
	DATA_COMPRESSION = PAGE
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
FROM	dbo.get_table_pages_info(N'dbo.orders', NULL) AS gtp;
GO

-- rerun the above query for improvement checks
SELECT	o_custkey,
		o_orderkey,
		o_orderpriority,
		o_orderdate
FROM	dbo.orders
WHERE	o_orderdate = '2018-12-20'
ORDER BY
		o_custkey
GO

SELECT	o_custkey,
		o_orderkey,
		o_orderpriority,
		o_orderdate
FROM	dbo.orders
WHERE	o_orderDate = '2018-12-20'
		AND o_orderstatus = 'O'
ORDER BY
		o_custkey
OPTION	(QUERYTRACEON 9130);
GO