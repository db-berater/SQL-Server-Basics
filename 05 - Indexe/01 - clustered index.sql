USE ERP_Demo;
GO

/* Statistiken aktivieren, um Workloads zu vergleichen */
SET STATISTICS IO, TIME ON;
GO

/* Select in einem HEAP (I/O) */
SELECT * FROM dbo.customers;
GO

/* Erstellen eines Clustered Index - Tabelle SORTIEREN!!! */
CREATE CLUSTERED INDEX cix_customers_c_custkey
ON dbo.customers (c_custkey);
GO

SELECT * FROM dbo.customers;
GO

SELECT * FROM dbo.customers WHERE c_custkey = 10;
GO

SELECT	*
FROM	dbo.customers
WHERE	c_custkey = 10
ORDER BY
		c_name;
GO

CREATE UNIQUE CLUSTERED INDEX cix_customers_c_custkey
ON dbo.customers (c_custkey)
WITH (DROP_EXISTING = ON);
GO

SELECT	*
FROM	dbo.customers
WHERE	c_custkey = 10
ORDER BY
		c_name;
GO