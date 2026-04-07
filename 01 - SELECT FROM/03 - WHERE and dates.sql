/*
	Besonderheiten bei der Verwendung von Datumswerten in WHERE Klausel
*/
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

/* Was ist unser Spracheinstellung? */
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