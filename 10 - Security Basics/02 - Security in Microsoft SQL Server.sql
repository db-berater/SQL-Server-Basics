/*============================================================================
	File:		02 - Security for Microsoft SQL Server.sql

	Summary:	This script demonstrates the different settings / logins
				for the sql server instance you are connected with.


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

/* what security model is Microsoft SQL Server using? */
BEGIN
	DECLARE @T TABLE
	(
		Value	NVARCHAR(255)	NOT NULL,
		Data	SQL_VARIANT		NOT NULL
	);

	INSERT INTO @T (Value, Data)
	EXEC sys.xp_instance_regread
		N'HKEY_LOCAL_MACHINE',
		N'Software\Microsoft\MSSQLServer\MSSQLServer',
		N'LoginMode';

	SELECT	*,
			CASE WHEN CAST(Data AS INT) = 1
				 THEN 'Windows Authentication'
				 ELSE 'Mixed Authentication'
			END	AS	Authentication_Mode
	FROM @T;
END
GO

/* a sysadmin is the master of the SQL Server */
SELECT	IS_SRVROLEMEMBER(N'sysadmin', SUSER_SNAME());
GO

/* Who is allowed to access my SQL Server */
SELECT	name,
        sid,
        type_desc,
        default_database_name,
        default_language_name
FROM	sys.server_principals
WHERE	type_desc <> N'SERVER_ROLE'
		AND name NOT LIKE N'##%';
GO

/*
	Windows accounts can always be created!
	a windows account is organized by the windows domain controller
*/
BEGIN TRY
BEGIN
	RAISERROR ('Creating login for [NB-LENOVO-I\Donald Duck]...', 0, 1) WITH NOWAIT;
	CREATE LOGIN [NB-LENOVO-I\Donald Duck] FROM WINDOWS
	WITH
		DEFAULT_DATABASE = [master],
		DEFAULT_LANGUAGE = [Deutsch];
END
END TRY
BEGIN CATCH
	RAISERROR ('Login [NB-LENOVO-I\Donald Duck] already exists...', 0, 1) WITH NOWAIT;
END CATCH
GO

/*
	IF no windows account is available we need to create a login FROM
	inside Microsoft SQL Server.
	The Login can only be used inside of the instance of Microsoft SQL Server!
	This technique requires "mixed authentication" for the login to the server!
*/
BEGIN TRY
BEGIN
	RAISERROR ('Creating login for [Daisy Duck]...', 0, 1) WITH NOWAIT;
	CREATE LOGIN [Daisy Duck]
	WITH PASSWORD = N'Pa$$w0rd',
		 CHECK_EXPIRATION = OFF,
		 CHECK_POLICY = OFF,
		 DEFAULT_DATABASE = [master],
		 DEFAULT_LANGUAGE = [Deutsch];
END
END TRY
BEGIN CATCH
	RAISERROR ('Login [Daisy Duck] already exists...', 0, 1) WITH NOWAIT;
END CATCH
GO

SELECT	name,
        sid,
        type_desc,
        default_database_name,
        default_language_name
FROM	sys.server_principals
WHERE	name LIKE N'%Donald%'
		OR name LIKE N'%Daisy%';
GO