USE ERP_Demo;
GO

SELECT	o_orderkey,
		o_orderdate,
		o_totalprice
FROM	dbo.orders
WHERE	o_custkey = 10
ORDER BY
		o_orderdate;
GO

SELECT	o_orderkey,
		o_orderdate,
		o_totalprice,
		SUM(o_totalprice) OVER (PARTITION BY o_custkey ORDER BY o_orderdate) AS running_sum
FROM	dbo.orders
WHERE	o_custkey = 10
ORDER BY
		o_orderdate;
GO

SELECT	o_orderkey,
		o_orderdate,
		o_totalprice,
		SUM(o_totalprice) OVER (PARTITION BY o_custkey ORDER BY o_orderkey) AS running_sum
FROM	dbo.orders
WHERE	o_custkey = 10
ORDER BY
		o_orderkey;
GO
