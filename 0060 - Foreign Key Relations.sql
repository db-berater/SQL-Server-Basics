/*============================================================================
	File:		0060 - Foreign Key Relations.sql

	Summary:	Implementation of foreign keys after 3rd normalization
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

/*
	For the implementation of foreign keys a master table must have
	a Primary Key or UNIQUE Index
*/
SELECT	QUOTENAME(S.name) + N'.' + QUOTENAME(T.name)	AS	table_name,
		QUOTENAME(KC.name)								AS	pk_name,
		KC.type
FROM	sys.tables AS T
		INNER JOIN sys.schemas AS S
		ON (T.schema_id = S.schema_id)
		INNER JOIN sys.key_constraints AS KC
		ON (T.object_id = KC.parent_object_id)
WHERE	T.is_ms_shipped = 0
		AND KC.type = N'PK';

SELECT	QUOTENAME(S.name) + N'.' + QUOTENAME(T.name)	AS	table_name,
		N'<----'										AS	reference_type,
		QUOTENAME(RS.name) + N'.' + QUOTENAME(R.name)	AS	table_name
FROM	sys.tables AS T
		INNER JOIN sys.schemas AS S
		ON (T.schema_id = S.schema_id)
		INNER JOIN sys.foreign_keys AS FK
		ON (T.object_Id = FK.parent_object_id)
		INNER JOIN sys.tables AS R
		ON (FK.referenced_object_id = R.object_id)
		INNER JOIN sys.schemas AS RS
		ON (R.schema_id = RS.schema_id)
GO
