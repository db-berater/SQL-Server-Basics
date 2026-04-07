/*
	Beispiele und Anwendungsbereiche für "Unterabfragen"
*/
USE ERP_Demo;
GO

/*
	Zeige alle Kunden, die in EINEM Monat mehr als 1 Bestellung
	getätigt haben!
*/

SELECT * FROM dbo.customers WHERE c_custkey <= 10

/* Wie erhalte ich für jeden Kunden das Datum der letzen Bestellung? */
SELECT *
FROM
(
	SELECT	o_custkey,
			MAX(o_orderdate)	AS	last_order
	FROM	dbo.orders
	GROUP BY
			o_custkey
) AS lo;
GO

SELECT	*
FROM	dbo.customers AS c
		INNER JOIN
		(
			SELECT	o_custkey,
					MAX(o_orderdate)	AS	last_order
			FROM	dbo.orders
			GROUP BY
					o_custkey
		) AS lo
		ON c.c_custkey = lo.o_custkey
WHERE	c.c_custkey <= 10
ORDER BY
		c.c_custkey;