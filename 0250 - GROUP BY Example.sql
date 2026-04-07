/*
	============================================================================
	File:		0250 - GROUP BY Examples.sql

	Summary:	This script demonstrates the GROUP BY operations

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

SET STATISTICS IO, TIME ON;
GO

-- 5.
SELECT	C.Id,
		C.Name,
		DATEPART(YEAR, CO.OrderDate)	AS	OrderYear,
		COUNT(*)						AS	NumOrders
-- 1.
FROM	dbo.Customers AS C
		INNER JOIN dbo.CustomerOrders AS CO
		ON (C.Id = CO.Customer_Id) /* True / False */
-- 2.
WHERE	C.Id <= 100

-- 3.
GROUP BY
		C.Id,
		C.Name,
		DATEPART(YEAR, CO.OrderDate)
-- 4.
HAVING	COUNT(*) > 10

-- 6.
ORDER BY
		C.Id,
		OrderYear --DATEPART(YEAR, CO.OrderDate) DESC
;
