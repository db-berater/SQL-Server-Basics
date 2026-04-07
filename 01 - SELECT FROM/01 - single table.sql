/* Datenbankkontext wechseln */
USE ERP_Demo;
GO

/*
	Ausgabe ALLER Attribute einer Relation mit Platzhalter "*"
*/
SELECT	*
FROM	dbo.customers;
GO

/*
	Bessere Technik ist die Angabe aller Attribute im SELECT!
	Dadurch wird besser erkennbar, welche Attribute in der Tabelle
	vorhanden sind.
*/
SELECT	c_custkey,
        c_mktsegment,
        c_nationkey,
        c_name,
        c_address,
        c_phone,
        c_acctbal,
        c_comment
FROM	dbo.customers;
GO

/*
    Die dedizierte Angabe von Attributen optimiert die Performance,
    da nicht alle Informationen zum Client gesendet werden müssen!
*/
SELECT	c_custkey,
        c_name
FROM	dbo.customers;
GO