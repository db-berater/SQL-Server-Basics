/*============================================================================
	File:		07 - grant privileges to the family.sql

	Summary:	This script demonstrates the usage of database roles

	Date:		April 2025

	SQL Server Version: >= 2025
------------------------------------------------------------------------------
	Written by Uwe Ricken, db Berater GmbH

	This script is intended only as a supplement to demos and lectures
	given by Uwe Ricken.  
  
	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
============================================================================*/
USE myCastle;
GO

-- Can Daisy use the stove?
EXECUTE AS USER = N'Daisy Duck';
SELECT * FROM [Kitchen].[Oven];
REVERT;
GO

-- Can the kids use the stove?
EXECUTE AS USER = N'Tick';
SELECT * FROM [Kitchen].[Oven];
REVERT;
GO

-- Can they use the fridge?
EXECUTE AS USER = N'Trick';
SELECT * FROM [Kitchen].[Fridge];
REVERT;
GO

-- OK - give ALL kids the permission to use the fridge!
GRANT SELECT ON [Kitchen].[Fridge] TO [Children];
GO

EXECUTE AS USER = N'Tick';
SELECT * FROM [Kitchen].[Fridge];
REVERT;
GO

EXECUTE AS USER = N'Tick';
SELECT * FROM [Kitchen].[Oven];
REVERT;
GO

-- Trick wants to "insert" in the [Toilet] :)
EXECUTE AS USER = N'Trick'
GO
	INSERT INTO [Bath Room].[Toilet]
	(n_nationkey, n_name, n_comment, n_regionkey)
	VALUES (151, 'Villa Kunterbunt', 'Pippi Langstrumpf', 1);
	GO

	SELECT * FROM [Bath Room].[Toilet];
	GO
REVERT;
GO

-- Everybody who has access to the appartment is allowed
-- to use the toilet!
GRANT INSERT, UPDATE, DELETE ON SCHEMA::[Bath Room] TO PUBLIC;
GO

GRANT SELECT, INSERT, UPDATE, DELETE
ON SCHEMA::[Kids Room] TO [Children];
GO

-- Alle ausser Tick dürfen ein UPDATE
/*
	GRANT	= Genehmigen
	REVOKE	= Entziehen
	DENY	= Verboten!!!		TOP 1
*/
DENY UPDATE ON SCHEMA::[Kids Room] TO [Tick];
GO

ALTER AUTHORIZATION ON SCHEMA::[Kids Room] TO [dbo];
GO

EXECUTE AS USER = 'Tick'
GO
	UPDATE	[Kids Room].[toys]
	SET		n_name = 'Nix'
	WHERE	n_nationkey = 10;
	GO
REVERT;
GO
