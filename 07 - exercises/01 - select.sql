-- Alles weitere IN der Zeile ist Kommentar
/*
	Alles dazwischen ist Text!
*/
USE ERP_demo;
GO

/* Unterbindet das Senden einer Message an den Client über die Anzahl der Records */
SET NOCOUNT ON;
GO

DECLARE @v AS INT = 1;
SELECT @v;
GO	/* wie ein neues Abfragefenster */

SELECT	@v;
GO

/*
	NUR IN ENTWICKLUNG!!!!
*/
SET STATISTICS IO, TIME ON;
GO

SELECT * FROM dbo.regions;

/* Alle Kunden mit allen Attributen */
SELECT	* /* zeige ALLE Attribute */
FROM	dbo.customers;

SELECT	[c_custkey], [c_mktsegment], [c_nationkey], [c_name], [c_address], [c_phone], [c_acctbal], [c_comment]
FROM	dbo.customers;
GO

SELECT	c_custkey
FROM	dbo.customers;
GO

/*
	Auflistung aller Attribute einer Relation
*/
SELECT	name
FROM	sys.columns
WHERE	OBJECT_ID = OBJECT_ID(N'dbo.customers');
GO

