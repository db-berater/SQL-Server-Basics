/*
	============================================================================
	File:		03 - foreign key constraints.sql

	Summary:	This script prepares demonstrates the implementation of
				FOREIGN KEY constraints

				THIS SCRIPT IS PART OF THE TRACK: "Workshop - SQL Server Basics"

	Date:		November 2025

	SQL Server Version: >= 2016
------------------------------------------------------------------------------
	Written by Uwe Ricken, db Berater GmbH

	This script is intended only as a supplement to demos and lectures
	given by Uwe Ricken.
  
	THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
	TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.
	============================================================================
*/
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

USE ERP_Demo;
GO

/*
	Let's create a foreign key constraint between demo.regions and demo.nations
*/
ALTER TABLE demo.nations
ADD CONSTRAINT fk_demo_regions_r_regionkey
FOREIGN KEY (n_regionkey)
REFERENCES demo.regions (r_regionkey);
GO

/*
	If a foreign key detects anomalies it will not be implemented by default!
*/
ALTER TABLE demo.customers
ADD CONSTRAINT fk_demo_nations_n_nationkey
FOREIGN KEY (c_nationkey)
REFERENCES demo.nations (n_nationkey);
GO

/*
	To find the anomalies we must search in demo.customers for c_nationkey values
	which do not exist in demo.nations
*/
SELECT	c.c_custkey,
        c.c_mktsegment,
        c.c_nationkey,
        c.c_name,
        c.c_address,
        c.c_phone,
        c.c_acctbal,
        c.c_comment
FROM	demo.customers AS c
WHERE	NOT EXISTS
		(
			SELECT	*
			FROM	demo.nations AS n
			WHERE	n.n_nationkey = c.c_nationkey
		);
GO

/*
	We update the affected records by changing the c_nationkey to a valid
	entry which exists in demo.nations!
*/
UPDATE	demo.customers
SET		c_nationkey = 6
WHERE	c_custkey = 10;
GO

/*
	... and implement the foreigin key constraint
*/
ALTER TABLE demo.customers
ADD CONSTRAINT fk_demo_nations_n_nationkey
FOREIGN KEY (c_nationkey)
REFERENCES demo.nations (n_nationkey);
GO

SELECT	name,
        type,
        type_desc,
        create_date,
		OBJECT_NAME(parent_object_id)		AS	child_object_name,
		OBJECT_NAME(referenced_object_id)	AS	parent_object_name
FROM	sys.foreign_keys
WHERE	parent_object_id IN
		(
			OBJECT_ID(N'demo.regions', N'U'),
			OBJECT_ID(N'demo.nations', N'U'),
			OBJECT_ID(N'demo.customers', N'U')
		);
GO