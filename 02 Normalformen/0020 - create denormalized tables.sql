/*
	============================================================================
	File:		0020 - create denormalized tables.sql

	Summary:	This script creates a relational set with denormalized tables
				for the demonstration of 1st, 2nd. and 3rd normal form! 

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
	============================================================================
*/
-- Command Variable(s)
:SETVAR source_db CustomerOrders
USE demo_db;
GO

IF OBJECT_ID(N'dbo.DenormalizedData', N'U') IS NOT NULL
	DROP TABLE dbo.DenormalizedData;
	GO

;WITH Departments
AS
(
	SELECT	1				AS Department_Id,
			'HR'			AS Department
	UNION ALL
	SELECT	2				AS Department_Id,
			'Sales'			AS Department
	UNION ALL
	SELECT	3				AS Department_Id,
			'Management'	AS Department
	UNION ALL
	SELECT	4				AS Department_Id,
			'IT'			AS Department
	UNION ALL
	SELECT	5				AS Department_Id,
			'Marketing'		AS Department
),
Projects
AS
(
	SELECT	1						AS Project_Id,
			'Sales Promotion'		AS Project
	UNION ALL
	SELECT	2						AS Project_Id,
			'SQL 2019 Update'		AS Project
	UNION ALL
	SELECT	3						AS Project_Id,
			'Marketing Campaign'	AS Project
	UNION ALL
	SELECT	4						AS Project_Id,
			'Customer Survey'		AS Project
	UNION ALL
	SELECT	5						AS Project_Id,
			'Aquisition'			AS Project
)
SELECT	E.Id							AS	Personal_Id,
		E.FirstName + ' ' + E.LastName	AS	EmployeeName,
		MONTH(E.HireDate) % 5 + 1		AS	Department_Id,
		D.Department					AS	Department,
		CO.OrderStatus_Id				AS	Project_Id,
		P.Project,
		COUNT_BIG(*)					AS	ProjectHours
INTO	dbo.DenormalizedData
FROM	[$(source_db)].dbo.Customers AS C
		INNER JOIN [$(source_db)].dbo.CustomerOrders AS CO
		ON (C.Id = CO.Customer_Id)
		INNER JOIN [$(source_db)].dbo.Employees AS E
		ON (CO.Employee_Id = E.Id)
		INNER JOIN Departments AS D
		ON (MONTH(E.HireDate) % 5 + 1 = D.Department_Id)
		INNER JOIN Projects AS P
		ON (CO.OrderStatus_Id = P.Project_Id)
GROUP BY
		E.Id,
		E.FirstName + ' ' + E.LastName,
		MONTH(E.HireDate) % 5 + 1,
		D.Department,
		CO.OrderStatus_Id,
		P.Project_Id,
		P.Project
ORDER BY
		E.Id
OPTION	(MAXDOP 1);
GO

SELECT * FROM dbo.DenormalizedData
ORDER BY
	Personal_Id;
GO