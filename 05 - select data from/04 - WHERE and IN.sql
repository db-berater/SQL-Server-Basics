/*
	============================================================================
	File:		04 - WHERE and IN.sql

	Summary:	This script demonstrates the specific problems with IN clause
				in Microsoft SQL Server!

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

/*
	Which customers are in the countries with the n_nationkey 
	44 and 46?
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
WHERE	c.c_nationkey IN (44, 46);
GO

/* Which countries are represented by 44 and 46? */
SELECT	n.n_nationkey,
        n.n_name,
        n.n_regionkey,
        n.n_comment
FROM	dbo.nations AS n
WHERE	n_nationkey IN (44, 46);
GO

/*
	Show customers from Portugal and Slovenia!
*/
BEGIN
	SELECT	n_nationkey
	FROM	dbo.nations
	WHERE	n_name IN ('PORTUGAL', 'SLOVENIA');

	SELECT	c.c_custkey,
            c.c_mktsegment,
            c.c_nationkey,
            c.c_name,
            c.c_address,
            c.c_phone,
            c.c_acctbal,
            c.c_comment
	FROM	dbo.customers AS c
	WHERE	c.c_nationkey IN
			(
				SELECT	n_nationkey
				FROM	dbo.nations
				WHERE	n_name IN ('PORTUGAL', 'SLOVENIA')		
			);
END
GO

/*
	Zeige alle Kunden aus Europa
	Europa = dbo.nations.n_regionkey = 3
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
WHERE	c.c_nationkey IN
		(
			SELECT	n_nationkey
			FROM	dbo.nations
			WHERE	n_regionkey = 3 /* Europa */
		);
GO