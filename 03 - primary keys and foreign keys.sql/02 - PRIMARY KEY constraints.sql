/*
	============================================================================
	File:		02 - primary key constraints.sql

	Summary:	This script prepares demonstrates the restrictions for
				PRIMARY KEY constraints

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

/*
	A PRIMARY KEY guarantees the uniqueness of a tuple in a relation.
	In Microsoft SQL Server a PRIMARY KEY is not allowed to be NULLable!
*/
ALTER TABLE demo.regions
ADD CONSTRAINT pk_demo_regions
PRIMARY KEY (r_regionkey);
GO

/*
	If a candidate for a PRIMARY KEY allows NULLable columns it cannot
	be used!
*/
BEGIN
	ALTER TABLE demo.regions
	ALTER COLUMN r_regionkey INT NOT NULL;

	ALTER TABLE demo.regions
	ADD CONSTRAINT pk_demo_regions
	PRIMARY KEY (r_regionkey);
END
GO

/*
	A PRIMARY KEY requires unique values. If a candidate key has 
	duplicate entries the creation will fail!
*/
ALTER TABLE demo.nations
ADD CONSTRAINT pk_demo_nations
PRIMARY KEY (n_nationkey);
GO

/* Search double entries... */
SELECT	n.n_nationkey,
        n.n_name,
        n.n_regionkey,
        n.n_comment
FROM	demo.nations AS n
WHERE	n.n_nationkey IN
		(
			SELECT	n_nationkey
			FROM	demo.nations
			GROUP BY
					n_nationkey
			HAVING	COUNT_BIG(*) > 1
		);
GO

/* We can delete any of the double row by using ROW_NUMBER() */
;WITH l
AS
(
	SELECT	ROW_NUMBER() OVER (PARTITION BY n_nationkey ORDER BY n_name) AS rn,
			*
	FROM	demo.nations
)
DELETE	l
WHERE	rn > 1;
GO

ALTER TABLE demo.nations
ADD CONSTRAINT pk_demo_nations
PRIMARY KEY (n_nationkey);
GO

/* Finally the biggest table demo.customers */
ALTER TABLE demo.customers
ADD CONSTRAINT pk_demo_customers
PRIMARY KEY (c_custkey);
GO

SELECT	name,
        type,
        type_desc,
        create_date,
        unique_index_id
FROM	sys.key_constraints
WHERE	parent_object_id IN
		(
			OBJECT_ID(N'demo.regions', N'U'),
			OBJECT_ID(N'demo.nations', N'U'),
			OBJECT_ID(N'demo.customers', N'U')
		);
GO