USE ERP_Demo;
GO

EXEC dbo.sp_drop_foreign_keys @table_name = N'ALL';
EXEC dbo.sp_clean_demo_environment;
GO
