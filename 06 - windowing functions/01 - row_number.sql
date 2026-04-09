USE ERP_Demo;
GO

SELECT	ROW_NUMBER() OVER (ORDER BY n.n_name) AS rn,
		n.n_nationkey,
        n.n_name,
        n.n_regionkey,
        n.n_comment
FROM	dbo.nations AS n;
GO

SELECT	ROW_NUMBER () OVER (PARTITION BY n.n_regionkey ORDER BY n.n_name) AS rn,
		n.n_nationkey,
        n.n_name,
        n.n_regionkey,
        n.n_comment
FROM	dbo.nations AS n;