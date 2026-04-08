SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE ERP_Demo;
GO

SELECT	o.o_orderdate,
        o.o_orderkey,
        LAG(o_orderdate, 1, NULL) OVER (PARTITION BY o_custkey ORDER BY o_orderdate ASC) AS previous_order_date
FROM	dbo.orders AS o
WHERE	o.o_custkey = 10
ORDER BY
        o.o_orderdate;
GO

SELECT	o.o_orderdate,
        o.o_orderkey,
        LAG(o_orderdate, 1, '1900-01-01') OVER (PARTITION BY o_custkey ORDER BY o_orderdate ASC) AS previous_order_date
FROM	dbo.orders AS o
WHERE	o.o_custkey = 10
ORDER BY
        o.o_orderdate;
GO

/* LEAD - next value */
SELECT	o.o_orderdate,
        o.o_orderkey,
        LEAD(o_orderdate, 1, NULL) OVER (PARTITION BY o_custkey ORDER BY o_orderdate ASC) AS previous_order_date
FROM	dbo.orders AS o
WHERE	o.o_custkey = 10
ORDER BY
        o.o_orderdate;
GO

SELECT	o.o_orderdate,
        o.o_orderkey,
        LEAD(o_orderdate, 1, '1900-01-01') OVER (PARTITION BY o_custkey ORDER BY o_orderdate ASC) AS previous_order_date
FROM	dbo.orders AS o
WHERE	o.o_custkey = 10
ORDER BY
        o.o_orderdate;
GO
