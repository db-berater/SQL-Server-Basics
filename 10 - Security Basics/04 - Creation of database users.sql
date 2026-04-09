/*============================================================================
	File:		04 - Creation of database users.sql

	Summary:	This script demonstrates the database access 

	Date:		April 2025

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

-- Who is the ower of the database MyCastle?
SELECT	database_id,
		name,
		owner_sid,
		SUSER_SNAME(owner_sid)	AS	owner
FROM	sys.databases
WHERE	database_id = DB_ID(N'MyCastle');
GO

-- Let's transfer the ownership to Donald Duck
ALTER AUTHORIZATION ON DATABASE::MyCastle
TO [NB-LENOVO-I\Donald Duck];
GO

-- Who is the ower of the database MyCastle?
SELECT	database_id,
		name,
		owner_sid,
		SUSER_SNAME(owner_sid)	AS	owner
FROM	sys.databases
WHERE	database_id = DB_ID(N'MyCastle');
GO

-- Let's make Donald a tentant of the database
USE myCastle;
GO

CREATE USER [NB-LENOVO-I\Donald Duck]
FROM LOGIN [NB-LENOVO-I\Donald Duck];
GO

-- Let's make Daisy Duck the main tenant of the database
USE MyCastle;
GO

IF USER_ID(N'Daisy Duck') IS NULL
	CREATE USER [Daisy Duck] FROM LOGIN [Daisy Duck];
	GO

ALTER ROLE [db_owner] ADD MEMBER [Daisy Duck];
GO

-- Login von Daisy Duck
SELECT 'Haus' AS Object, sid, name FROM sys.server_principals
WHERE	name = N'Daisy Duck'

UNION ALL

SELECT 'Wohnung' AS Object, sid, name FROM sys.database_principals
WHERE	name = N'Daisy Duck';
GO

EXECUTE AS USER = N'Daisy Duck';
GO

SELECT USER_NAME();
GO

ALTER AUTHORIZATION ON DATABASE::myCastle TO [Daisy Duck];
GO

ALTER AUTHORIZATION ON DATABASE::myCastle TO [sa];
GO

REVERT;
GO

-- Kann der sa/sysadmin den Eigentümer ändern?
ALTER AUTHORIZATION ON DATABASE::myCastle TO [Daisy Duck];
GO

DROP USER [Daisy Duck];
GO

ALTER AUTHORIZATION ON DATABASE::myCastle TO [Daisy Duck];
GO

ALTER AUTHORIZATION ON DATABASE::myCastle TO [NB-LENOVO-I\Donald Duck];
GO

-- Donald verkauft die Wohnung wieder an den Eigentümer des Hauses
ALTER AUTHORIZATION ON DATABASE::myCastle TO sa;
GO

-- Donald wird wieder "normaler" User
ALTER SERVER ROLE [sysadmin] DROP MEMBER [NB-LENOVO-I\Donald Duck];
GO

CREATE USER [NB-LENOVO-I\Donald Duck]
FOR LOGIN [NB-LENOVO-I\Donald Duck];
GO

ALTER ROLE [db_owner]
ADD MEMBER [NB-LENOVO-I\Donald Duck];
GO

-- Kann Donald Daisy in die Wohnung lassen?
EXECUTE AS USER = N'NB-LENOVO-I\Donald Duck';
GO

CREATE USER [Daisy Duck] FOR LOGIN [Daisy Duck];
GO

ALTER ROLE [db_owner] ADD MEMBER [Daisy Duck];
GO

REVERT;
GO

-- Kann Daisy Donald aus der Wohnung schmeissen?
EXECUTE AS USER = N'Daisy Duck';
GO

DROP USER [NB-LENOVO-I\Donald Duck];
GO

REVERT;
GO

-- Danger of TRUSTWORTHY-Settings!!!!!!!!
EXECUTE AS LOGIN = N'Daisy Duck';
GO

-- what privileges does Donald have now?
SELECT	R.name	AS	server_role,
		U.name	AS	user_name
FROM	sys.server_principals AS R
		INNER JOIN sys.server_role_members AS RM ON (R.principal_id = RM.role_principal_id)
		INNER JOIN sys.server_principals AS U ON (RM.member_principal_id = U.principal_id)
WHERE	U.name = N'Daisy Duck';
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [NB-LENOVO-I\Donald Duck];
GO

REVERT;
GO

SELECT	name, is_trustworthy_on
FROM	sys.databases
ORDER BY
		name;
GO

ALTER DATABASE myCastle SET TRUSTWORTHY ON;
GO

SELECT	name, is_trustworthy_on
FROM	sys.databases
ORDER BY
		name;
GO

-- Danger of TRUSTWORTHY-Settings!!!!!!!!
EXECUTE AS USER = N'Daisy Duck';
GO

SELECT	IS_SRVROLEMEMBER(N'sysadmin', N'Daisy Duck');
SELECT USER_NAME(), SUSER_NAME();
GO


-- what privileges does Donald have now?
SELECT	R.name	AS	server_role,
		U.name	AS	user_name
FROM	sys.server_principals AS R
		INNER JOIN sys.server_role_members AS RM ON (R.principal_id = RM.role_principal_id)
		INNER JOIN sys.server_principals AS U ON (RM.member_principal_id = U.principal_id)
WHERE	U.name = N'Daisy Duck';
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [NB-LENOVO-I\Donald Duck];
GO

REVERT;
GO

CREATE USER [NB-LENOVO-I\Donald Duck] FOR LOGIN [NB-LENOVO-I\Donald Duck];
GO

ALTER ROLE [db_owner] ADD MEMBER [NB-LENOVO-I\Donald Duck];
GO

ALTER DATABASE myCastle SET TRUSTWORTHY OFF;
GO
