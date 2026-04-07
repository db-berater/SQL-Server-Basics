/*
	Vorbereitung für LEFT/RIGHT JOIN Beispiel!
*/
USE ERP_Demo;
GO

DROP TABLE IF EXISTS dbo.new_orders;
GO

/* Befüllen der neuen Tabelle dbo.new_orders mit Daten */
SELECT	*
INTO	dbo.new_orders
FROM	dbo.orders
WHERE	o_orderdate >= '2020-01-01'
		AND o_orderdate <= '2020-01-31';
GO

/*
	Zeige alle Kunden, die noch keine Bestellung in der Tabelle
	dbo.new_orders haben!
*/
SELECT	c.c_custkey,
		c.c_name,
		o.o_orderkey
FROM	dbo.customers AS c
		LEFT JOIN dbo.new_orders AS o
		ON (c.c_custkey = o.o_custkey)
WHERE	o.o_orderkey IS NULL;
GO

/*
	Zeige alle Kunden aus Europa, die noch keine Bestellung in der Tabelle
	dbo.new_orders haben!
*/
SELECT	c.c_custkey,
		c.c_name,
		c.c_nationkey,
		n.n_name,
		n.n_regionkey,
		o.o_orderkey
FROM	dbo.customers AS c
		INNER JOIN dbo.nations AS n
		ON c.c_nationkey = n.n_nationkey
		LEFT JOIN dbo.new_orders AS o
		ON c.c_custkey = o.o_custkey
WHERE	n.n_regionkey = 3
		AND o.o_orderkey IS NULL;
GO