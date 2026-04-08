/*
	Beispiele und Anwendungsbereiche für "Unterabfragen"
*/
USE ERP_Demo;
GO

/*
	Zeige alle Kunden, die in EINEM Monat mindestens 20 Bestellung
	getätigt haben!
*/
SELECT	o.o_custkey,
		COUNT_BIG(*)
FROM	dbo.orders AS o
WHERE	o.o_orderdate >= '2020-01-01'
		AND o.o_orderdate <= '2020-01-31'
GROUP BY
		o.o_custkey
HAVING	COUNT_BIG(*) >= 20;
GO


SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
		lo.number_of_orders
FROM	dbo.customers AS c
		INNER JOIN
		(
			SELECT	o.o_custkey,
					COUNT_BIG(*)	AS	number_of_orders
			FROM	dbo.orders AS o
			WHERE	o.o_orderdate >= '2020-01-01'
					AND o.o_orderdate <= '2020-01-31'
			GROUP BY
					o.o_custkey
			HAVING	COUNT_BIG(*) >= 20
		) AS lo
		ON c.c_custkey = lo.o_custkey
ORDER BY
		c.c_custkey;
GO
