/*
	============================================================================
	File:		03 - WHERE and dates.sql

	Summary:	This script demonstrates the specific problems with date formats
				in Microsoft SQL Server!

				THIS SCRIPT IS PART OF THE TRACK: "Workshop - SQL Server Basics"

	Date:		November 2025

	SQL Server Version: >= 2016
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
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE ERP_Demo;
GO

SELECT @@LANGUAGE;
SET LANGUAGE us_english;
GO

/* Deutsches Datum */
SELECT	CAST('29.01.2026' AS DATE);
SELECT	CAST('01.12.2026' AS DATE);

/* schweizer Format? */
SELECT	CAST('29/01/2026' AS DATE);
SELECT	CAST('01/29/2026' AS DATE);
GO

/*
	ISO Format
	YYYY-MM-DDThh:mm:ss.nnn	
*/

/* What is our language setting? */
SELECT @@LANGUAGE;
GO

/* us_english */
SET LANGUAGE us_english;
GO

SELECT	CAST('2026-01-29T11:40:00.000' AS DATE);
SELECT	CAST('2026-01-29T11:40:00.000' AS DATETIME2(3));
GO

/* deutsch */
SET LANGUAGE deutsch;
GO

SELECT	CAST('2026-01-29T11:40:00.000' AS DATE);
SELECT	CAST('2026-01-29T11:40:00.000' AS DATETIME2(3));
GO