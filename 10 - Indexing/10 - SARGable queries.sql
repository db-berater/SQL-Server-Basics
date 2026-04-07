/*============================================================================
	File:		0120 - scenario for SARGable queries.sql

	Summary:	The customer table can have empty columns.
				How can we improve the performance on these columns
				with indexes and other strategies?

				Implement the correct index and check whether it works
				or not!

				THIS SCRIPT IS PART OF THE TRACK:
				"Database Optimization By Indexes"

	Date:		February 2025

	SQL Server Version: >= 2016
============================================================================*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE ERP_Demo;
GO

EXEC dbo.sp_create_demo_schema;
GO

/*
	We create a demo environment which covers the topic
	- SARGability
	- Functions/Transformations
*/
DROP TABLE IF EXISTS demo.customers;
GO

SELECT	c_custkey,
        c_mktsegment,
        c_nationkey,
        c_name,
        c_address,
		CASE WHEN c_custkey % 10000 = 0
			 THEN NULL
			 ELSE c_phone
		END			AS	c_phone,
        CASE WHEN c_custkey % 1000 = 0
			 THEN NULL
			 ELSE c_acctbal
		END			AS	c_acctbal,
        c_comment
INTO	demo.customers
FROM	dbo.customers;
GO

/*
	Let's create a few indexes for the optimization of the upcoming queries
*/
ALTER TABLE demo.customers
ADD CONSTRAINT pk_demo_customers
PRIMARY KEY CLUSTERED (c_custkey)
WITH
(
	SORT_IN_TEMPDB = ON,
	DATA_COMPRESSION = PAGE
);
GO

CREATE NONCLUSTERED INDEX nix_demo_customers_c_phone
ON demo.customers (c_phone)
WITH
(
	SORT_IN_TEMPDB = ON,
	DATA_COMPRESSION = PAGE
);
GO

CREATE NONCLUSTERED INDEX nix_demo_customers_c_acctbal
ON demo.customers (c_acctbal)
WITH
(
	SORT_IN_TEMPDB = ON,
	DATA_COMPRESSION = PAGE
);
GO

/*
	Now we can check the SARGability of the next queries
*/
SET STATISTICS TIME, IO ON;
GO

SELECT	*
FROM	demo.customers
WHERE	ISNULL(c_phone, 'n.v') = 'n.v';
GO


SELECT	*
FROM	demo.customers
WHERE	ISNULL(c_acctbal, 0) = 0;
GO