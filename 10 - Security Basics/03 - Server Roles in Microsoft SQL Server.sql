/*============================================================================
	File:		03 - Server Roles in Microsoft SQL Server.sql

	Summary:	This script demonstrates the usage of server roles

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

/* what server roles do we have in Microsoft SQL Server? */
SELECT	name,
        sid,
        type_desc,
        default_database_name,
        default_language_name
FROM	sys.server_principals
WHERE	type = N'R';
GO

/* Let's give Donald Duck the same privileges as the owner of the server */
BEGIN
	SELECT	R.name	AS	server_role,
			U.name	AS	user_name
	FROM	sys.server_principals AS R
			INNER JOIN sys.server_role_members AS RM ON (R.principal_id = RM.role_principal_id)
			INNER JOIN sys.server_principals AS U ON (RM.member_principal_id = U.principal_id)
	WHERE	U.name = N'NB-LENOVO-I\Donald Duck';

	ALTER SERVER ROLE sysadmin
	ADD MEMBER [NB-LENOVO-I\Donald Duck];

	SELECT	R.name	AS	server_role,
			U.name	AS	user_name
	FROM	sys.server_principals AS R
			INNER JOIN sys.server_role_members AS RM ON (R.principal_id = RM.role_principal_id)
			INNER JOIN sys.server_principals AS U ON (RM.member_principal_id = U.principal_id)
	WHERE	U.name = N'NB-LENOVO-I\Donald Duck';
END
GO

/*
	now let's make Daisy a security admin to hand over the keys
	to the server
*/
BEGIN
	SELECT	R.name	AS	server_role,
			U.name	AS	user_name
	FROM	sys.server_principals AS R
			INNER JOIN sys.server_role_members AS RM ON (R.principal_id = RM.role_principal_id)
			INNER JOIN sys.server_principals AS U ON (RM.member_principal_id = U.principal_id)
	WHERE	U.name = N'Daisy Duck';

	ALTER SERVER ROLE securityadmin ADD MEMBER [Daisy Duck];

	SELECT	R.name	AS	server_role,
			U.name	AS	user_name
	FROM	sys.server_principals AS R
			INNER JOIN sys.server_role_members AS RM ON (R.principal_id = RM.role_principal_id)
			INNER JOIN sys.server_principals AS U ON (RM.member_principal_id = U.principal_id)
	WHERE	U.name = N'Daisy Duck';
END
GO

/* Does Daisy now have access to any appartment? */
BEGIN
	EXECUTE AS LOGIN = N'Daisy Duck';
	
	USE MyCastle;

	REVERT;
END
GO

/*
	Let's check the possible privileges of Daisy...
	can she make her own account an owner of the server?
*/
BEGIN
	EXECUTE AS LOGIN = N'Daisy Duck';

	ALTER SERVER ROLE sysadmin ADD MEMBER [Daisy Duck];
	EXEC sys.sp_addsrvrolemember
		@loginame = N'Daisy Duck',
		@rolename = N'sysadmin';

	/* Can Daisy hand over a new key to the server? */
	CREATE LOGIN [Tick Duck]
	WITH
		PASSWORD = 'test',
		CHECK_EXPIRATION = OFF,
		CHECK_POLICY = OFF;

	/* Can Daisy make Tick Duck an owner of the server? */
	ALTER SERVER ROLE processadmin ADD MEMBER [Tick Duck];

	EXEC sys.sp_addsrvrolemember
		@loginame = N'Tick Duck',
		@rolename = N'sysadmin';

	REVERT;
END
GO

ALTER SERVER ROLE sysadmin DROP MEMBER [NB-LENOVO-I\Donald Duck];
ALTER SERVER ROLE securityadmin DROP MEMBER [Daisy Duck];

IF SUSER_ID(N'Tick Duck') IS NOT NULL
	DROP LOGIN [Tick Duck];
GO