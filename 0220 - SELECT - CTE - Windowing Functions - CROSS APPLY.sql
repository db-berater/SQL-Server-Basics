/*
	============================================================================
	File:		0220 - SELECT - CTE - Windowing Functions - CROSS APPLY.sql

	Summary:	This script demonstrates the functional use of windowing functions

				THIS SCRIPT IS PART OF THE TRACK: "SQL Server - Database Basics"

	Date:		April 2022

	SQL Server Version: 2014 / 2017 / 2019
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

USE CustomerOrders;
GO

/*
	Lesson:	die letzten 3 Bestellungen für jeden Kunden
*/

SELECT * FROM dbo.CustomerOrders
ORDER BY
	Customer_Id ASC,
	OrderDate DESC;
GO

SELECT	TOP (3) * FROM dbo.CustomerOrders
WHERE	Customer_Id = 11
ORDER BY
	OrderDate DESC;
GO

/*
	Windowing Function(s)

	 Group	 Partitionsschlüssel!
	|----  | -------------- |
	|    1 |  11
	|    2 |  11
	...
	|    1 |  12
	|    2 |  12

	ROW_NUMBER() OVER (PARTITION BY Customer_Id ORDER BY OrderDate DESC)
*/
SELECT	ROW_NUMBER() OVER (PARTITION BY Customer_Id ORDER BY OrderDate DESC) AS rn,
		*
FROM	dbo.CustomerOrders
GO

SELECT	ROW_NUMBER() OVER (ORDER BY OrderDate) AS rn,
		Customer_Id,
		OrderDate
FROM	dbo.CustomerOrders
OPTION	(MAXDOP 1)

/*
	Lösung: Verwendung von Subquery für die Erstellung einer derived table
*/
SELECT *
FROM
(
	SELECT	ROW_NUMBER() OVER (PARTITION BY Customer_Id ORDER BY OrderDate DESC) AS rn,
			*
	FROM	dbo.CustomerOrders
) AS co
WHERE	co.rn <= 3;
GO

/*
	Alternative: CTE = Common Table Expression (>= SQL 2005)

	WITH co
	AS
	(
		SELECT-Statement
	)
	SELECT ......
	FROM co;
*/
WITH co
AS
(
	SELECT	ROW_NUMBER() OVER (PARTITION BY Customer_Id ORDER BY OrderDate DESC) AS rn,
			*
	FROM	dbo.CustomerOrders
)
SELECT * FROM co
WHERE	rn <= 3;
GO

/*
	Anzeige des Kunden und das Bestelldatum der letzten 3 Bestellungen
*/

SELECT	c.name,
		co.OrderDate
FROM	dbo.Customers AS c
		INNER JOIN
		(
			SELECT	TOP (3)
					Customer_Id,
					OrderDate
			FROM	dbo.CustomerOrders
			WHERE	Customer_Id = c.Id
			ORDER BY
					OrderDate DESC
		) AS co
		ON (c.Id = co.Customer_Id)
GO

SELECT	c.name,
		co.OrderDate
FROM	dbo.Customers AS c
		CROSS APPLY /* INNER JOIN */
		/* OUTER APPLY -- LEFT JOIN */
		(
			SELECT	TOP (3)
					Customer_Id,
					OrderDate
			FROM	dbo.CustomerOrders
			WHERE	Customer_Id = c.Id
			ORDER BY
					OrderDate DESC
		) AS co
ORDER BY
		c.Id;