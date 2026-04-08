/*
	Zeige für jeden Kunden die letzten 3 Bestellungen an!
*/
USE ERP_Demo;
GO

/* Die letzten 3 Bestellungen -> TOP-Operator! */
SELECT	TOP (3) WITH TIES
		o_orderdate,
		o_orderkey
FROM	dbo.orders
WHERE	o_custkey = ??? /* variable! */
ORDER BY
		o_orderdate DESC;
GO

SELECT	c.c_custkey,
		c.c_name
FROM	dbo.customers AS c
		INNER JOIN
		(
			SELECT	TOP (3) WITH TIES
					o_custkey,
					o_orderdate,
					o_orderkey
			FROM	dbo.orders
			WHERE	o_custkey = c.c_custkey
			ORDER BY
					o_orderdate DESC
		) AS t3
		ON c.c_custkey = t3.o_custkey
WHERE	c.c_custkey BETWEEN 1 AND 100;
GO

SELECT	c.c_custkey,
		c.c_name,
		t3.o_orderdate,
		t3.o_orderkey
FROM	dbo.customers AS c
		CROSS APPLY /* INNER JOIN */
		(
			SELECT	TOP (3) WITH TIES
					o_custkey,
					o_orderdate,
					o_orderkey
			FROM	dbo.orders
			WHERE	o_custkey = c.c_custkey
			ORDER BY
					o_orderdate DESC
		) AS t3
WHERE	c.c_custkey BETWEEN 1 AND 5
ORDER BY
		c.c_custkey;
GO

SELECT	c.c_custkey,
		c.c_name,
		t3.o_orderdate,
		t3.o_orderkey
FROM	dbo.customers AS c
		OUTER APPLY /* LEFT JOIN */
		(
			SELECT	TOP (3) WITH TIES
					o_custkey,
					o_orderdate,
					o_orderkey
			FROM	dbo.orders
			WHERE	o_custkey = c.c_custkey
			ORDER BY
					o_orderdate DESC
		) AS t3
WHERE	c.c_custkey BETWEEN 1 AND 5
ORDER BY
		c.c_custkey;
GO