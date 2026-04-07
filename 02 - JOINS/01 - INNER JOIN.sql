/*
	Beispiele für INNER JOIN
*/
USE ERP_Demo;
GO

/*
	Zeige für jedes Land die Region, in der das Land ist!
*/
SELECT	n.n_nationkey,
		n.n_name		AS	Land,
		r.r_name		AS	Kontinent
FROM	dbo.nations AS n
		INNER JOIN dbo.regions AS r
		ON n.n_regionkey = r.r_regionkey;
GO

/*
	Zeige alle Kunden, die am 18.02.2020 bestellt haben!
*/
SELECT	c.c_custkey,
		c.c_name,
		o.o_orderkey,
		o.o_orderstatus
FROM	dbo.customers AS c
		INNER JOIN dbo.orders AS o
		ON c.c_custkey = o.o_custkey
WHERE	o.o_orderdate = '2020-02-18';
GO

