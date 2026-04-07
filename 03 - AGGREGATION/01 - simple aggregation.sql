/*
	Beispiele für Syntax bei Aggregationen

	- Aggregationen
	COUNT()
	MIN()
	MAX()
	AVG()
*/
USE ERP_Demo;
GO

/* Wie viele Bestellungen haben wir im System? */
SELECT	COUNT(*)
FROM	dbo.orders;
GO

/* Welcher Kunde hat das niedrigste acctbal? */
SELECT	MIN(c_acctbal)
FROM	dbo.customers;
GO

SELECT	MIN(c_acctbal),
		MAX(c_acctbal)
FROM	dbo.customers;
GO

/*
	Aggregationen über Gruppen!

	Wie ist das durchschnittliche c_acctbal pro Land?
*/
SELECT	n.n_name			AS	Land,
		AVG(c.c_acctbal)	AS	avg_bal
FROM	dbo.customers AS c
		INNER JOIN dbo.nations AS n
		ON c.c_nationkey = n.n_nationkey
GROUP BY
		n.n_name
ORDER BY
		AVG(c.c_acctbal) DESC;