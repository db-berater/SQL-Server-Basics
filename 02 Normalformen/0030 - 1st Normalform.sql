/*============================================================================
	File:		0030 - 1st Normalform.sql

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

SELECT * FROM dbo.DenormalizedData;
GO


IF OBJECT_ID(N'dbo.FirstNormalization', N'U') IS NOT NULL
	DROP TABLE dbo.FirstNormalization;
	GO

SELECT	Personal_Id,
		CAST
		(
			LEFT(EmployeeName, CHARINDEX(' ', EmployeeName) - 1)
			AS VARCHAR(64)
		) AS	FirstName,
		SUBSTRING(EmployeeName, CHARINDEX(' ', EmployeeName) + 1, 255)	AS	LastName,
		Department_Id,
		Department,
		Project_Id,
		Project,
		ProjectHours
INTO	dbo.FirstNormalization
FROM	dbo.DenormalizedData
ORDER BY
		Personal_Id
OPTION	(MAXDOP 1);
GO

SELECT	Personal_Id,
        Project_Id,
        FirstName,
        LastName,
        Department_Id,
        Department,
        Project,
        ProjectHours
FROM	dbo.FirstNormalization;
GO

ALTER TABLE dbo.FirstNormalization
ADD CONSTRAINT pk_FirstNormalization
PRIMARY KEY CLUSTERED
(
	Personal_Id,
	Project_Id
);
GO

ALTER TABLE dbo.FirstNormalization
DROP CONSTRAINT pk_FirstNormalization;
GO

ALTER TABLE dbo.FirstNormalization
ADD CONSTRAINT pk_FirstNormalization
PRIMARY KEY CLUSTERED
(
	Project_Id,
	Personal_Id
);
GO

SELECT	Personal_Id,
        Project_Id,
        FirstName,
        LastName,
        Department_Id,
        Department,
        Project,
        ProjectHours
FROM	dbo.FirstNormalization;
GO