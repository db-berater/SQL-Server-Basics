/*
	Aggregationen über Gruppen!

	Wie ist das durchschnittliche c_acctbal pro Land
	in Europa?
*/
USE ERP_Demo;
GO

SELECT	n.n_name			AS	Land,
		AVG(c.c_acctbal)	AS	avg_bal
FROM	dbo.customers AS c
		INNER JOIN dbo.nations AS n
		ON c.c_nationkey = n.n_nationkey
WHERE	n.n_regionkey = 3
GROUP BY
		n.n_name
ORDER BY
		AVG(c.c_acctbal) DESC;
GO

/*
	SELECT		|		FROM	-> JOIN

	FROM		|		WHERE

	WHERE		|		GROUP BY	(Aggregation)

	GROUP BY	|		HAVING		(Filter auf aggregierte Werte)

	HAVING		|		SELECT

	ORDER BY	|		ORDER BY
*/

SELECT	n.n_name			AS	Land,
		AVG(c.c_acctbal)	AS	avg_bal
FROM	dbo.customers AS c
		INNER JOIN dbo.nations AS n
		ON c.c_nationkey = n.n_nationkey
WHERE	n.n_regionkey = 3
GROUP BY
		n.n_name
HAVING	AVG(c.c_acctbal) > 4500
ORDER BY
		avg_bal DESC;
GO