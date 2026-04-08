/*
	============================================================================
	File:		03 - WHERE clause.sql

	Summary:	The WHERE clause filters rows before they enter the result set,
				allowing developers to return only the data that matches specific
				conditions.
				
				It also improves performance by reducing the amount of data
				SQL Server must process in later query stages like grouping
				or sorting.

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

/* customer with c_custkey = 1000 */
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
WHERE	c.c_custkey = 1000;
GO

/*
	Operatoren:
	=			equal
	< / >		smaller / greater
	<= / >=		smaller-equal / greater-equal
	<>			unequal
	IN			(all values, which are "IN" a list)
	IS NULL		Attrribut hat keinen Wert (NULL = UNKNOWN)
	BETWEEN		>= AND <=
	LIKE		Wildcard-Search: % = placeholder!
*/

/* Alle Kunden mit einer c_custkey, die kleiner/gleich 10 ist! */
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
WHERE	c.c_custkey <= 10;
GO

SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
WHERE	c_custkey < 11;
GO

SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
WHERE	c_custkey BETWEEN 1 AND 10;
GO

/* Identisch mit BETWEEN */
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
WHERE	c_custkey >= 1
		AND c_custkey <= 10;
GO

/*
	concatenante conditions..

	AND
	OR
*/

/*
	Show all customers from AUTOMOBILE in country 6
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
WHERE	c.c_mktsegment = 'AUTOMOBILE'
		AND c.c_nationkey = 6;
GO

/*
	Contradictions: all customers from AUTOMOBILE and BUILDING
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
/* !Contradiction! */
WHERE	c.c_mktsegment = 'AUTOMOBILE'
		AND c.c_mktsegment = 'BUILDING';
GO

SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
WHERE	c.c_mktsegment = 'AUTOMOBILE'
		OR c.c_mktsegment = 'BUILDING';
GO

SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
WHERE	c.c_mktsegment IN ('AUTOMOBILE', 'BUILDING');
GO

/*
    All customers from
    AUTOMOBILE
    AND nationkey = 6
    OR acctbal < 0
*/
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_acctbal
FROM	dbo.customers AS c
WHERE	c.c_mktsegment = 'AUTOMOBILE'
		AND c.c_nationkey = 6
		OR c.c_acctbal < 0;
GO

SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_acctbal
FROM	dbo.customers AS c
WHERE	c_mktsegment = 'AUTOMOBILE'
		OR c_acctbal < 0
		AND c_nationkey = 6;
GO

/*
    All customers from
    AUTOMOBILE
    AND nationkey = 6
    OR acctbal < 0
*/
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_acctbal
FROM	dbo.customers AS c
WHERE	(
			c_mktsegment = 'AUTOMOBILE'
            AND c_nationkey = 6
		)
        OR c_acctbal < 0
GO