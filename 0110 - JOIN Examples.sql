/*============================================================================
	File:		0110 - JOIN Examples.sql

	Summary:	This script demonstrates the different JOIN operations
				INNER / LEFT / RIGHT / CROSS JOIN

				THIS SCRIPT IS PART OF THE TRACK: "SQL Server - Database Basics"

	Date:		November 2020

	SQL Server Version: 2008 / 2012 / 2014 / 2017 / 2019
------------------------------------------------------------------------------
	Written by Uwe Ricken, db Berater GmbH

	This script is intended only as a supplement to demos and lectures
	given by Uwe Ricken.  
  
	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
============================================================================*/
USE CustomerOrders;
GO

-- 1. Regel: Statistiken über Ausführung aktivieren!!!
SET STATISTICS IO, TIME ON;
GO

-- 2. Regel: Verwende NIE * für Ausgabefelder!!!
-- 3. Regel: Verwende IMMER Schema.Objekt-Syntax
-- 4. Regel: Versuche, Aliase zu verwenden!!!
-- 5. Regel: Aliase vor den Spaltennamen verwenden!
-- 6. Regel: Abfragen IMMER mit Execution Plan ausführen
--			 (GILT NUR IN ENTWICKLUNGSUMGEBUNG!!!)
-- 7. Regel: Ein SCAN-Operator ist TEUER!!!!
SELECT	CP.[Customer_Id],
		C.Name,
		-- CP.[Property_Id],
		P.Property,
		CP.[Property_Value]

FROM	dbo.CustomerProperties AS CP
		INNER JOIN dbo.Properties AS P
		ON CP.Property_Id = P.Id
		INNER JOIN dbo.Customers AS C
		ON (CP.Customer_Id = C.Id)

WHERE	CP.Customer_Id <= 10
		AND P.Id = 1

ORDER BY
		CP.Customer_Id ASC,
		P.Property DESC;
GO

/*
	JOIN: LEFT JOIN
	ALLE Kunden und ihre Telefonnummer.
	Kunden ohne Telefonnummer müssen auch angezeigt werden!!!
*/
SELECT	C.Id,
		C.Name,
		-- CP.[Property_Id],
		P.Property,
		CP.[Property_Value]
-- 1 Schritt:	Cartesian Product!
FROM	dbo.Customers AS C
		LEFT JOIN dbo.CustomerProperties AS CP
		ON
		(
			-- KRITERIUM MUSS IM JOIN-PREDICATE VORHANDEN SEIN!
			C.Id = CP.Customer_Id
			AND CP.Property_Id = 1
		)
		LEFT JOIN dbo.Properties AS P
		ON (CP.Property_Id = P.Id)
-- 2 Schritt:	Ausfiltern!!
WHERE	C.Id <= 10

ORDER BY
		C.Id ASC;
GO