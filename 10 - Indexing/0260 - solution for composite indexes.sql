/*============================================================================
	File:		0260 - solution for composite indexes.sql

	Summary:	Scenario
				The developer got the order to improve the performance of a query
				which was using a predicate of at least two attributes in the table.
				Therefore the developer created a new index based on these two heavily
				used attributes by the order of their cardinality.

				Although the index was used the performance was really bad!

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

SET STATISTICS IO ON;
GO

SELECT	*
FROM	dbo.CustomerOrders
WHERE	OrderDate >= '20080101'
		AND OrderDate < '20100101'
		AND Customer_Id = 36528
ORDER BY
		OrderDate DESC;
GO

SET STATISTICS IO OFF;
GO

-- Let's have a look into the index to understand the behavior
-- check the allocation units and it's dependend IAM pages
SELECT	P.index_id,
		SIAU.total_pages,
		SIAU.used_pages,
		SIAU.data_pages,
		SIAU.root_page,
		sys.fn_PhysLocFormatter(SIAU.root_page)			AS root_page,
		SIAU.first_iam_page,
		sys.fn_PhysLocFormatter(SIAU.first_iam_page)	AS first_iam_page
FROM	sys.system_internals_allocation_units AS SIAU
		INNER JOIN sys.partitions AS P ON (SIAU.container_id = P.partition_id)
WHERE	P.object_id = OBJECT_ID(N'dbo.CustomerOrders', N'U');
GO

DBCC TRACEON (3604);
DBCC PAGE (0, 1, 70922, 3);
GO

DBCC PAGE (0, 1, 70925, 3);
GO

DBCC PAGE (0, 1, 79572, 3);
GO

-- switch the order of the index to cover equal predicates first!
CREATE NONCLUSTERED INDEX nix_CustomerOrders_OrderDate_Customer_Id
ON dbo.CustomerOrders
(
	Customer_Id,
	OrderDate
)
WITH DROP_EXISTING;
GO

SELECT	P.index_id,
		SIAU.total_pages,
		SIAU.used_pages,
		SIAU.data_pages,
		SIAU.root_page,
		sys.fn_PhysLocFormatter(SIAU.root_page)			AS root_page,
		SIAU.first_iam_page,
		sys.fn_PhysLocFormatter(SIAU.first_iam_page)	AS first_iam_page
FROM	sys.system_internals_allocation_units AS SIAU
		INNER JOIN sys.partitions AS P ON (SIAU.container_id = P.partition_id)
WHERE	P.object_id = OBJECT_ID(N'dbo.CustomerOrders', N'U');
GO

DBCC TRACEON (3604);
DBCC PAGE (0, 1, 79626, 3);
GO

DBCC PAGE (0, 1, 79755, 3);
GO

DBCC PAGE (0, 1, 86648, 3);
GO

SET STATISTICS IO ON;
GO

SELECT	*
FROM	dbo.CustomerOrders
WHERE	Customer_Id = 36528
		AND OrderDate >= '20080101'
		AND OrderDate < '20100101'
ORDER BY
		OrderDate DESC;
GO

SET STATISTICS IO OFF;
GO