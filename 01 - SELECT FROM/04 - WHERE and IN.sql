/*
	IN Operator für Prädikate
*/
USE ERP_Demo;
GO

/*
	Welche Kunden befinden sich in den Ländern mit der n_nationkey
	44 und 46?
*/
SELECT	*
FROM	dbo.customers
WHERE	c_nationkey IN (44, 46);
GO

/* Welche Länder werden durch 44 und 46 repräsentiert? */
SELECT	*
FROM	dbo.nations
WHERE	n_nationkey IN (44, 46);
GO

/*
	Zeige Kunden aus Portugal und Slovenia!
*/
SELECT	n_nationkey
FROM	dbo.nations
WHERE	n_name IN ('PORTUGAL', 'SLOVENIA');
GO

SELECT	*
FROM	dbo.customers
WHERE	c_nationkey IN
		(
			SELECT	n_nationkey
			FROM	dbo.nations
			WHERE	n_name IN ('PORTUGAL', 'SLOVENIA')		
		);
GO

/*
	Zeige alle Kunden aus Europa
	Europa = dbo.nations.n_regionkey = 3
*/
SELECT	*
FROM	dbo.customers
WHERE	c_nationkey IN
		(
			SELECT	n_nationkey
			FROM	dbo.nations
			WHERE	n_regionkey = 3 /* Europa */
		);
GO