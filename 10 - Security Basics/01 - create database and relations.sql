/*============================================================================
	File:		01 - create database and relations.sql

	Summary:	This script creates a demo database which will be used for
				the future demonstration scripts

	Date:		Mai 2025

	SQL Server Version: >= 2016
------------------------------------------------------------------------------
	Written by Uwe Ricken, db Berater GmbH

	This script is intended only as a supplement to demos and lectures
	given by Uwe Ricken.  
  
	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
============================================================================*/
USE master;
GO

IF DB_ID(N'MyCastle') IS NOT NULL
BEGIN
	RAISERROR ('Creating demo database [MyCastle]...', 0, 1) WITH NOWAIT;
	ALTER DATABASE [MyCastle] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [MyCastle];
END
GO

CREATE DATABASE myCastle;
ALTER DATABASE MyCastle SET RECOVERY SIMPLE;
ALTER AUTHORIZATION ON DATABASE::MyCastle TO sa;
GO

IF SUSER_ID(N'NB-LENOVO-I\Donald Duck') IS NOT NULL
BEGIN
	RAISERROR ('Deleting login [NB-LENOVO-I\Donald Duck', 0, 1) WITH NOWAIT;
	DROP LOGIN [NB-LENOVO-I\Donald Duck];
END
GO

IF SUSER_ID(N'Daisy Duck') IS NOT NULL
BEGIN
	RAISERROR ('Deleting login [Daisy Duck', 0, 1) WITH NOWAIT;
	DROP LOGIN [Daisy Duck];
END
GO
