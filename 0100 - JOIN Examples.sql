/*============================================================================
	File:		0100 - JOIN Examples.sql

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
USE demo_db;
GO

-- CROSS JOIN
-- Kombination von ALLE E mit ALLE P
-- SELECT 150 * 5
SELECT	E.Personal_Id,
		P.Project_Id
FROM	dbo.Employees AS E,
		dbo.Projects AS P
ORDER BY
		E.Personal_Id,
		P.Project_Id;
GO

-- INNER JOIN
SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName,
		PC.ProjectHours
FROM	dbo.Employees AS E
		INNER JOIN dbo.ProjectConsumption AS PC
		ON (E.Personal_Id = PC.Personal_Id)
GO

/*
	E -> PC -> P
	E -> P -> PC
	P -> PC -> E
	...
*/
SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName,
		P.Project,
		PC.ProjectHours
FROM	dbo.Employees AS E
		INNER JOIN dbo.ProjectConsumption AS PC
		ON (E.Personal_Id = PC.Personal_Id)
		INNER JOIN dbo.Projects AS P
		ON (PC.Project_Id = P.Project_Id)
GO

SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName,
		D.Department,
		P.Project,
		PC.ProjectHours
FROM	dbo.Employees AS E
		INNER JOIN dbo.Departments AS D
		ON (E.Department_Id = D.Department_Id)
		INNER JOIN dbo.ProjectConsumption AS PC
		ON (E.Personal_Id = PC.Personal_Id)
		INNER JOIN dbo.Projects AS P
		ON (PC.Project_Id = P.Project_Id)
GO

/* ANSI 92 Standard!!! */
SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName,
		D.Department,
		P.Project,
		PC.ProjectHours
FROM	dbo.Employees AS E,
		dbo.Departments AS D,
		dbo.ProjectConsumption AS PC,
		dbo.Projects AS P
WHERE	E.Personal_Id = PC.Personal_Id
		AND PC.Project_Id = P.Project_Id
		AND E.Department_Id = D.Department_Id
GO

/* OUTER JOINS - LEFT */
INSERT INTO dbo.Employees
(Personal_Id, FirstName, LastName, Department_Id)
VALUES
(151, 'Uwe', 'Ricken', 4);
GO

-- Alle Mitarbeiter!!! in Verbindung zu Projekterfassung
-- Zeige auch die Mitarbeiter, die keine Stundenerfassung haben!
SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName,
		PC.ProjectHours
FROM	dbo.Employees AS E
		LEFT JOIN dbo.ProjectConsumption AS PC
		ON (E.Personal_Id = PC.Personal_Id);
GO

-- Alle Mitarbeiter, die noch keine Zeiten erfasst haben
-- Schritt 3
SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName,
		PC.ProjectHours
-- Schritt 1
FROM	dbo.Employees AS E
		LEFT JOIN dbo.ProjectConsumption AS PC
		ON (E.Personal_Id = PC.Personal_Id)
-- Schritt 2
WHERE	PC.ProjectHours IS NULL;
GO

-- Schritt 3
SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName
-- Schritt 1!
FROM	dbo.Employees AS E
-- Schritt 2!
WHERE	E.Personal_Id NOT IN
		(SELECT Personal_Id FROM dbo.ProjectConsumption);
GO

SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName,
		PC.ProjectHours
-- Schritt 1
FROM	dbo.Employees AS E
		OUTER APPLY
		(
			SELECT	Personal_Id,
					ProjectHours
			FROM	dbo.ProjectConsumption
			WHERE	Personal_Id = E.Personal_Id
		) AS PC
-- Schritt 2
WHERE	PC.Personal_Id IS NULL
GO

/* ANSI 92 Standard - NICHT IN SQL Server MÖGLICH!!!
	SELECT	E.Personal_Id,
			E.FirstName,
			E.LastName,
			PC.ProjectHours
	FROM	dbo.Employees AS E,
			dbo.ProjectConsumption AS PC
	WHERE	E.Personal_Id *= PC.Personal_Id
GO
*/