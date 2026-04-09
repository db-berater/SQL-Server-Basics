/*============================================================================
	File:		06 - Play around in our new appartment.sql

	Summary:	This script demonstrates the usage of database roles and privileges

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
USE myCastle;
GO

-- Let's get the furniture in...
IF OBJECT_ID(N'[Bed Room].[Bed]', N'U') IS NULL
	SELECT	*
	INTO	[Bed Room].[Bed]
	FROM	ERP_Demo.dbo.nations;
	GO

IF OBJECT_ID(N'[Kids Room].[Bed]', N'U') IS NULL
	SELECT	*
	INTO	[Kids Room].[Bed]
	FROM	ERP_Demo.dbo.nations;
	GO


IF OBJECT_ID(N'[Kitchen].[Fridge]', N'U') IS NULL
	SELECT	*
	INTO	[Kitchen].[Fridge]
	FROM	ERP_Demo.dbo.nations;
	GO

IF OBJECT_ID(N'[Kitchen].[Oven]', N'U') IS NULL
	SELECT	*
	INTO	[Kitchen].[Oven]
	FROM	ERP_Demo.dbo.nations;
	GO

IF OBJECT_ID(N'[Living Room].[TV]', N'U') IS NULL
	SELECT	*
	INTO	[Living Room].[TV]
	FROM	ERP_Demo.dbo.nations;
	GO

IF OBJECT_ID(N'[Children Room].[toys]', N'U') IS NULL
	SELECT	*
	INTO	[Kids Room].[toys]
	FROM	ERP_Demo.dbo.nations;
	GO

IF OBJECT_ID(N'[Bath Room].[Toilet]', N'U') IS NULL
	SELECT	*
	INTO	[Bath Room].[Toilet]
	FROM	ERP_Demo.dbo.nations;
	GO

IF OBJECT_ID(N'[Living Room].[85 Inch FlatScreen Curved]', N'U') IS NULL
	SELECT	*
	INTO	[Living Room].[85 Inch FlatScreen Curved]
	FROM	ERP_Demo.dbo.nations;
	GO
