/*
	============================================================================
	File:		01 - complex aggregations.sql

	Summary:	This script demonstrates the usage of aggregations!

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
	What is the avg acctbal for Europe (3)?
*/
SELECT	n.n_name			AS	country_name,
		AVG(c.c_acctbal)	AS	avg_balance
FROM	dbo.customers AS c
		INNER JOIN dbo.nations AS n
		ON c.c_nationkey = n.n_nationkey
WHERE	n.n_regionkey = 3
GROUP BY
		n.n_name
ORDER BY
		AVG(c.c_acctbal) DESC;
GO

SELECT	n.n_name			AS	country_name,
		AVG(c.c_acctbal)	AS	avg_balance
FROM	dbo.customers AS c
		INNER JOIN dbo.nations AS n
		ON c.c_nationkey = n.n_nationkey
WHERE	n.n_regionkey = 3
GROUP BY
		n.n_name
HAVING	AVG(c.c_acctbal) > 4500
ORDER BY
		avg_balance DESC;
GO