USE ERP_Demo;
GO

SET STATISTICS IO, TIME ON;
GO

SELECT	o_orderdate,
		o_custkey,
		o_orderstatus
FROM	dbo.orders
WHERE	o_orderdate = '2020-02-18';
GO

CREATE NONCLUSTERED INDEX nix_orders_o_orderdate
ON dbo.orders (o_orderdate);
GO

SELECT	o_orderdate,
		o_custkey,
		o_orderstatus
FROM	dbo.orders
WHERE	o_orderdate = '2020-02-18';
GO