/*
	============================================================================
	File:		0230 - SELECT Examples - JOINS.sql

	Summary:	This script demonstrates the JOIN operators

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

SELECT	c.Name,
		co.*
FROM	dbo.Customers AS c
		INNER JOIN dbo.CustomerOrders AS co
		ON (c.Id = co.Customer_Id /* true */)
WHERE	c.Id = 10;
GO

SELECT	c.Id		AS	KundenId,
		c.Name,
		co.*
FROM	dbo.Customers AS c
		INNER JOIN dbo.CustomerOrders AS co
		ON (c.Id = co.Customer_Id /* true */)
WHERE	c.Id = 10
ORDER BY
		OrderDate DESC;
GO

SELECT	c.Id		AS	KundenId,
		c.Name,
		COUNT(*)	AS	AnzahlBestellungen
FROM	dbo.Customers AS c
		INNER JOIN dbo.CustomerOrders AS co
		ON (c.Id = co.Customer_Id /* true */)
GROUP BY
		c.Id,
		c.Name;
GO

/*
	Abfrage 2:	Plausibilitätsprüfungen mit OUTER JOINS

	Id | Status | Anzahl
*/
SELECT	CASE WHEN os.Id IS NULL
			 THEN 0
			 ELSE os.Id
		END			AS	Id,
		--IF os.Status IS NULL
		--	THEN 'not valid'
		--	ELSE os.STATUS
  --      END
		CASE WHEN os.Status IS NULL
			 THEN 'not valid'
			 ELSE os.Status
		END			AS	[Status],
		COUNT(*)	AS	Anzahl
FROM	dbo.OrderStatus AS os
		RIGHT JOIN dbo.CustomerOrders AS co
		ON (os.Id = co.OrderStatus_Id)
GROUP BY
		os.Id,
		os.[Status]
ORDER BY
		Id;
GO


