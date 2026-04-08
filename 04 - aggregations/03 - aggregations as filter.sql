SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE ERP_Demo;
GO

/*
	Show all customers whose balance is higher than the average balance
*/
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	dbo.customers AS c
WHERE   c.c_acctbal >=
        (
            SELECT  AVG(i_c.c_acctbal)
            FROM    dbo.customers AS i_c
        );
GO

/*
    How many customers are rated over the average account balance
    and how many customers are rated under the average account balance?
*/
