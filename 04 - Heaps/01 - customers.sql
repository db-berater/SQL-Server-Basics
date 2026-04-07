USE ERP_demo;
GO

/* Löschen aller Fremdschlüsselbeziehungen */
EXEC dbo.sp_drop_foreign_keys @table_name = 'ALL';
EXEC dbo.sp_drop_indexes @table_name = 'ALL';
GO

/* Statistiken für Ausführung von Abfragen aktivieren */
SET STATISTICS IO, TIME ON;
GO

SELECT * FROM dbo.customers;
GO

SELECT c_custkey FROM dbo.customers;
GO

SELECT	*
FROM	dbo.customers
ORDER BY
		c_custkey;
GO

SELECT	*
FROM	dbo.customers
WHERE	c_custkey = 10
OPTION	(QUERYTRACEON 9130);
GO

