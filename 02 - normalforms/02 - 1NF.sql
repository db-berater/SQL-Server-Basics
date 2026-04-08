/*
	============================================================================
	File:		02 - 1NF.sql

	Summary:	Demonstration of normalization of data tables
				http://de.wikipedia.org/wiki/Normalisierung_%28Datenbank%29

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
	The denormalized table contains all data in one table!
*/
SELECT	TOP (100)
		customer_number,
        market_segment,
        customer_firstname_lastname,
        customer_phone,
        customer_nation,
        order_number,
        order_position,
        order_date,
        order_priority,
        order_status,
        position_price,
        position_quantity,
        article_number,
        article_type,
        article_size,
        article_brand
FROM	demo.denormalized_data
ORDER BY
		order_number,
		order_position;
GO

/*
	Codd's Rule 1 of normal forms states that a relation is in 1NF if:

	- all attributes are atomic (not decomposable)
	- no repeating groups occur
	- no lists, arrays, or composite values ​​are contained in any attribute
*/
IF OBJECT_ID(N'demo.first_normalform', N'U') IS NOT NULL
	DROP TABLE demo.first_normalform;
	GO

SELECT	customer_number,
        market_segment,
		LEFT(customer_firstname_lastname, CHARINDEX(' ', customer_firstname_lastname) - 1) AS first_name,
		SUBSTRING(customer_firstname_lastname, CHARINDEX(' ', customer_firstname_lastname) + 1, 255) AS last_name,
        customer_phone,
        customer_nation,
        order_number,
        order_position,
        order_date,
		LEFT(order_priority, CHARINDEX('-', order_priority) - 1) AS order_priority_id,
		SUBSTRING(order_priority, CHARINDEX('-', order_priority) + 1, 255) AS order_priority,
        order_status,
        position_price,
        position_quantity,
        article_number,
        article_type,
        article_size,
        article_brand
INTO	demo.first_normalform
FROM	demo.denormalized_data
GO

/*
	The 3rd rule of relational theory states that every relation must
	have a primary key.

	This requirement is part of the “Guaranteed Access Rule” (Rule 2)
	and is often referred to in the literature as Rule 3 or Key Rule,
	although it formally follows from Rule 2.
*/
ALTER TABLE demo.first_normalform
ADD CONSTRAINT pk_first_normalform
PRIMARY KEY CLUSTERED
(
	order_number,
	order_position
)
WITH
(
	DATA_COMPRESSION = PAGE,
	SORT_IN_TEMPDB = ON
);
GO

SELECT	TOP (100)
        customer_number,
        market_segment,
        first_name,
        last_name,
        customer_phone,
        customer_nation,
        order_number,
        order_position,
        order_date,
        order_priority_id,
        order_priority,
        order_status,
        position_price,
        position_quantity,
        article_number,
        article_type,
        article_size,
        article_brand
FROM	demo.first_normalform
ORDER BY
        order_number,
        order_position;
GO