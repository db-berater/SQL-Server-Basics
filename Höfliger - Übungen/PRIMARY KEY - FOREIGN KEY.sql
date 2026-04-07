ALTER TABLE dbo.customers
ADD PRIMARY KEY CLUSTERED (c_custkey);
GO

/*
	1. Versuch, eine Fremdschlüsselbeziehung zwischen
	dbo.customers und dbo.nations herzustellen
*/
ALTER TABLE dbo.customers
ADD FOREIGN KEY (c_nationkey)
REFERENCES dbo.nations (n_nationkey);
GO

/*
	Erstellen von Primary Key (Bedingung)
	auf dbo.nations
*/
ALTER TABLE dbo.nations
ADD PRIMARY KEY (n_nationkey);
GO

/*
	Testen von Fremdschlüsselbeziehung
*/
SELECT * FROM dbo.nations;
SELECT * FROM dbo.customers WHERE c_custkey = 10;

