/*============================================================================
	File:		0050 - 3nd Normalform.sql

	Summary:	Demonstration of normalization of data tables
				http://de.wikipedia.org/wiki/Normalisierung_%28Datenbank%29

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

SELECT	Personal_Id,
        FirstName,
        LastName,
        Department_Id,
        Department
FROM	dbo.Employees;
GO

-- Elimination of redundant attribute [Department]
SELECT	Department_Id,
		Department
FROM	dbo.Employees
ORDER BY
		Department_Id;
GO

SELECT	Department_Id,
		Department,
		COUNT(*) AS Anzahl
FROM	dbo.Employees
GROUP BY -- PRO !!!!
		Department_Id,
		Department
ORDER BY
		Department_Id;

SELECT	Department_Id,
		Department
FROM	dbo.Employees
GROUP BY
		Department_Id,
		Department
ORDER BY
		Department_Id;

SELECT	DISTINCT
		Department_Id,
		Department
INTO	dbo.Departments
FROM	dbo.Employees
ORDER BY
		Department_Id;

SELECT * FROM dbo.Departments;

ALTER TABLE dbo.Departments
ADD CONSTRAINT pk_Departments_Department_Id
PRIMARY KEY CLUSTERED (Department_Id);
GO

-- It does not work because the attribute [Department_Id] is NULLable
ALTER TABLE dbo.Departments
ALTER COLUMN [Department_Id] INT NOT NULL;
GO

ALTER TABLE dbo.Departments
ADD CONSTRAINT pk_Departments_Department_Id
PRIMARY KEY CLUSTERED (Department_Id);
GO

ALTER TABLE dbo.Employees
DROP COLUMN [Department];
GO

ALTER TABLE dbo.Employees
ADD CONSTRAINT fk_Departments_Department_Id
FOREIGN KEY (Department_Id)
REFERENCES dbo.Departments (Department_Id);
GO

ALTER TABLE dbo.Employees WITH CHECK CHECK CONSTRAINT fk_Departments_Department_Id;
GO

SELECT * FROM dbo.Employees;
SELECT * FROM dbo.Departments;
GO

/* ANSI 87 Standard!!! */
SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName,
		D.Department_Id,
		D.Department
FROM	dbo.Employees AS E,
		dbo.Departments AS D
WHERE	E.Department_Id = D.Department_Id
		AND E.Personal_Id = 1

/* ANSI 92 Standard!!! */
SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName,
		D.Department_Id,
		D.Department
FROM	dbo.Employees AS E
		INNER JOIN dbo.Departments AS D
		ON (E.Department_Id = D.Department_Id)
WHERE	E.Personal_Id = 1;
GO

SELECT	E.Personal_Id,
		E.FirstName,
		E.LastName,
		D.Department_Id,
		D.Department,
		PC.ProjectHours
FROM	(
			dbo.Employees AS E
			LEFT JOIN dbo.Departments AS D
			ON (E.Department_Id = D.Department_Id)
		)
		INNER JOIN dbo.ProjectConsumption AS PC
		ON (E.Personal_Id = PC.Personal_Id)
WHERE	E.Personal_Id = 1;
GO

;WITH AllEmployees
AS
(
	SELECT	e.Personal_Id,
			e.FirstName,
			e.LastName,
			d.Department_Id,
			d.Department
	FROM	dbo.Employees AS e
			LEFT JOIN dbo.Departments AS d
			ON (e.Department_Id = d.Department_Id)
)
SELECT	*
FROM	AllEmployees AS AE
		INNER JOIN dbo.ProjectConsumption AS pc
		ON (AE.Personal_id = pc.Personal_Id)
WHERE	AE.Personal_Id = 1;