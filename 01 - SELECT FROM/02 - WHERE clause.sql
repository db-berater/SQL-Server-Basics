/*
	einfache und komplexe Filter auf Tabellen
*/
USE ERP_Demo;
GO

/* Kunde mit c_custkey = 1000 */
SELECT	*
FROM	dbo.customers
WHERE	c_custkey = 1000;
GO

/*
	Operatoren:
	=			identisch
	< / >		kleiner/größer
	<= / >=		kleiner+gleich / größer+gleich
	<>			ungleich
	IN			(Alle Werte, die in Liste "IN" vorhanden sind)
	IS NULL		Attrribut hat keinen Wert (NULL = Leer)
	BETWEEN		>= AND <=
	LIKE		Wildcard-Search: % = Platzhalten
*/

/* Alle Kunden mit einer c_custkey, die kleiner/gleich 10 ist! */
SELECT	*
FROM	dbo.customers
WHERE	c_custkey <= 10;
GO

SELECT	*
FROM	dbo.customers
WHERE	c_custkey < 11;
GO

SELECT	*
FROM	dbo.customers
WHERE	c_custkey BETWEEN 1 AND 10;
GO

/* Identisch mit BETWEEN */
SELECT	*
FROM	dbo.customers
WHERE	c_custkey >= 1
		AND c_custkey <= 10;
GO

/*
	Bedingung verknüpfen...

	AND
	OR
*/

/*
	Zeige alle Kunden aus AUTOMOBILE und der Nation 6
*/
SELECT	*
FROM	dbo.customers
WHERE	c_mktsegment = 'AUTOMOBILE'
		AND c_nationkey = 6;
GO

/*
	Zeige alle Kunden aus AUTOMOBILE und BUILDING

	- aus AUTOMOBILE - ODER - BUILDING
	- aus dem Bereich AUTOMOBILE, BUILDING
*/
SELECT	*
FROM	dbo.customers
/* !Contradiction! */
WHERE	c_mktsegment = 'AUTOMOBILE'
		AND c_mktsegment = 'BUILDING';
GO

SELECT	*
FROM	dbo.customers
WHERE	c_mktsegment = 'AUTOMOBILE'
		OR c_mktsegment = 'BUILDING';
GO

SELECT	*
FROM	dbo.customers
WHERE	c_mktsegment IN ('AUTOMOBILE', 'BUILDING');
GO

/*
	Alle Kunden aus dem Segment AUTOMOBILE aus dem Ländercode 6
	oder Kunden mit einen AccountBalance < 0
*/
SELECT	*
FROM	dbo.customers
WHERE	c_mktsegment = 'AUTOMOBILE'
		AND c_nationkey = 6
		OR c_acctbal < 0;
GO

SELECT	*
FROM	dbo.customers
WHERE	c_mktsegment = 'AUTOMOBILE'
		OR c_acctbal < 0
		AND c_nationkey = 6;
GO

/*
	Alle Kunden aus dem Segment AUTOMOBILE oder einem Accountbalance <0,
	die aus dem Land 6 kommen!
*/
SELECT	*
FROM	dbo.customers
WHERE	(
			c_mktsegment = 'AUTOMOBILE'
			OR c_acctbal < 0
		)
		AND c_nationkey = 6;
GO