/*============================================================================
	File:		0040 - 2nd Normalform.sql

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

SELECT * FROM dbo.FirstNormalization;
GO

DROP TABLE IF EXISTS dbo.ProjectConsumption;
DROP TABLE IF EXISTS dbo.Projects;
DROP TABLE IF EXISTS dbo.Employees;
GO


-- Extraction of employee data
SELECT	DISTINCT
		Personal_Id,
		FirstName,
		LastName,
		Department_Id,
		Department
INTO	dbo.Employees
FROM	dbo.FirstNormalization
ORDER BY
		Personal_Id;
GO

-- Primärschlüssel...
ALTER TABLE dbo.Employees
ADD CONSTRAINT pk_Employees_Personal_Id
PRIMARY KEY CLUSTERED (Personal_Id);
GO

SELECT	Personal_Id,
		FirstName,
		LastName,
		Department_Id,
		Department
FROM	dbo.Employees;
GO

-- Extraction of project data
SELECT	DISTINCT
		Project_Id,
		Project
INTO	dbo.Projects
FROM	dbo.FirstNormalization
ORDER BY
		Project_Id
OPTION	(MAXDOP 1);
GO

ALTER TABLE dbo.Projects
ADD CONSTRAINT pk_Projects_Project_Id
PRIMARY KEY CLUSTERED (Project_Id);
GO

SELECT	Project_Id,
		Project
FROM	dbo.Projects;
GO

-- Extraction of project hours
SELECT	Personal_Id,
		Project_Id,
		ProjectHours
INTO	dbo.ProjectConsumption
FROM	dbo.FirstNormalization;
GO

/* Referential Integrity */
SELECT	Personal_Id,
        Project_Id,
        ProjectHours
FROM	dbo.ProjectConsumption;
GO

INSERT INTO dbo.ProjectConsumption
    (
        Personal_Id,
        Project_Id,
        ProjectHours
    )
VALUES
    (
        1, -- Personal_Id - int
        6, -- Project_Id - int
        10  -- ProjectHours - bigint
    );
GO

ALTER TABLE dbo.ProjectConsumption
ADD CONSTRAINT pk_ProjectConsumption_Personal_Id_Project_Id
PRIMARY KEY CLUSTERED
(
	Personal_Id,
	Project_Id
);
GO

SELECT	Personal_Id,
        Project_Id,
        ProjectHours
FROM	dbo.ProjectConsumption;
GO

-- Implementation of Foreign key relation
ALTER TABLE dbo.ProjectConsumption
ADD CONSTRAINT fk_Employees_Personal_Id
FOREIGN KEY (Personal_Id)
REFERENCES dbo.Employees (Personal_Id);
GO

ALTER TABLE dbo.ProjectConsumption
ADD CONSTRAINT fk_Project_Project_Id
FOREIGN KEY (Project_Id)
REFERENCES dbo.Projects (Project_Id);
GO

/*
	Ein RIGHT JOIN findet alle Projekteinträge,
	zu denen es keine Projekt_id gibt!
*/
SELECT	pc.Personal_Id,
        pc.Project_Id,
        pc.ProjectHours
FROM	dbo.Projects AS p
		RIGHT JOIN dbo.ProjectConsumption AS pc
		ON (pc.Project_Id = p.Project_Id)
WHERE	p.Project_Id IS NULL;
GO

SELECT	pc.Personal_Id,
        pc.Project_Id,
        pc.ProjectHours
FROM	dbo.ProjectConsumption AS pc
WHERE	pc.Project_Id NOT IN (SELECT p.Project_Id FROM dbo.Projects AS p);
GO

DELETE	dbo.ProjectConsumption
WHERE	Personal_Id = 1
		AND Project_Id = 6;
GO

ALTER TABLE dbo.ProjectConsumption
ADD CONSTRAINT fk_Project_Project_Id
FOREIGN KEY (Project_Id)
REFERENCES dbo.Projects (Project_Id);
GO

ALTER TABLE dbo.ProjectConsumption WITH CHECK CHECK CONSTRAINT fk_Employees_Personal_Id;
ALTER TABLE dbo.ProjectConsumption WITH CHECK CHECK CONSTRAINT fk_Project_Project_Id;
GO