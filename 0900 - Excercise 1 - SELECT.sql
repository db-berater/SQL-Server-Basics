/*
	Aufgabe:	Alle Bestellungen anzeigen, deren Bestellwert
				über dem Durchschnitt liegen (Für das Jahr 2019)

	Fragen:
		Was ist die Durchschnittssumme der Bestellungen für 2019?
		AVG()
		Was ist die Summe der Bestellungen für 2019 / Bestellung?
		SUM()
*/

USE CustomerOrders;
GO

/*
	1. Ergebnis:
		Order_Id | OrderDate | SummeBestellung
*/
SELECT	cod.Order_Id,
		co.OrderDate,
		SUM(cod.Quantity * cod.Price) AS OrderSumme
FROM	dbo.CustomerOrders AS co
		INNER JOIN dbo.CustomerOrderDetails AS cod
		ON (co.Id = cod.Order_Id)
		,
		(
			SELECT	AVG(cod.Quantity * cod.Price)	AS AvgSumme
			FROM	dbo.CustomerOrders AS co
					INNER JOIN dbo.CustomerOrderDetails AS cod
					ON (co.Id = cod.Order_Id)
			WHERE	co.OrderDate >= '2019-01-01'
					AND co.OrderDate < '2020-01-01'
		) AS AvgSumme
WHERE	co.OrderDate >= '2019-01-01'
		AND co.OrderDate < '2020-01-01'
GROUP BY
		cod.Order_Id,
		co.OrderDate,
		AvgSumme.AvgSumme
HAVING	SUM(cod.Quantity * cod.Price) <= AvgSumme.AvgSumme
ORDER BY
		co.OrderDate DESC;
GO

WITH ao
AS
(
	/* Bilde die Durschnittssumme für alle Bestellungen in 2019 */
	SELECT	AVG(cod.Quantity * cod.Price)	AS AvgSumme
	FROM	dbo.CustomerOrders AS co
			INNER JOIN dbo.CustomerOrderDetails AS cod
			ON (co.Id = cod.Order_Id)
	WHERE	co.OrderDate >= '2019-01-01'
			AND co.OrderDate < '2020-01-01'
)
SELECT	cod.Order_Id,
		co.OrderDate,
		SUM(cod.Quantity * cod.Price) AS OrderSumme
FROM	dbo.CustomerOrders AS co
		INNER JOIN dbo.CustomerOrderDetails AS cod
		ON (co.Id = cod.Order_Id),
		ao
WHERE	co.OrderDate >= '2019-01-01'
		AND co.OrderDate < '2020-01-01'
GROUP BY
		cod.Order_Id,
		co.OrderDate,
		ao.AvgSumme
HAVING	SUM(cod.Quantity * cod.Price) <= ao.AvgSumme
ORDER BY
		co.OrderDate DESC;

/*
	Verweis auf CTE in CTE!!!
*/
;WITH TotalOrder
AS
(
	SELECT	cod.Order_Id,
			SUM(cod.Quantity * cod.Price) AS Total
	FROM	dbo.CustomerOrders AS co
			INNER JOIN dbo.CustomerOrderDetails AS cod
			ON (co.Id = cod.Order_Id)
	WHERE	co.OrderDate >= '2019-01-01'
			AND co.OrderDate < '2020-01-01'
	GROUP BY
			cod.Order_Id
),
MaxOrder
AS
(
	SELECT	MAX(Total)	AS	MaxOrder
	FROM	TotalOrder
)
SELECT	tod.Order_Id,
		tod.Total,
		mod.MaxOrder,
		tod.Total - mod.MaxOrder
FROM	TotalOrder AS tod, MaxOrder AS mod;
GO

/*
	Aufgabe:	Das Management gibt über eine Oberfläche
				ein Start - und ein Enddatum an.

				Das Ergebnis soll die Umsätze / Tag anzeigen
*/
DROP TABLE IF EXISTS #Dates;
GO

CREATE TABLE #Dates (OrderDate DATE NOT NULL PRIMARY KEY CLUSTERED);

DECLARE @start_date DATE = '2019-01-01';
DECLARE	@end_date DATE = '2019-01-07';

WHILE @start_date <= @end_date
BEGIN
	INSERT INTO #Dates (OrderDate)
	VALUES (@start_date);

	SET	@start_date = DATEADD(DAY, 1, @start_date)
END

SELECT * FROM #Dates;
GO

SELECT	*
FROM	dbo.CustomerOrders AS co
		INNER JOIN #Dates AS d
		ON (co.OrderDate = d.OrderDate);
GO

/* Bessere Lösung ist eine rekursive CTE */
DECLARE @start_date DATE = '2018-01-01';
DECLARE	@end_date DATE = '2019-06-30';

WITH OrderDates
AS
(
	SELECT	@start_date AS OrderDate,
			YEAR(@start_date) AS Jahr,
			DATEPART(WEEK, @start_date) AS KW

	UNION ALL

	SELECT	DATEADD(DAY, 1, OrderDate),
			YEAR(DATEADD(DAY, 1, OrderDate)) AS Jahr,
			DATEPART(WEEK, DATEADD(DAY, 1, OrderDate)) AS KW
	FROM	OrderDates
	WHERE	OrderDate < @end_date
)
SELECT	od.Jahr,
		od.KW,
		SUM(cod.Quantity * cod.Price) AS Umsatz
FROM	dbo.CustomerOrders AS co
		INNER JOIN OrderDates AS od
		ON (co.OrderDate = od.OrderDate)
		INNER JOIN dbo.CustomerOrderDetails AS cod
		ON (co.Id = cod.Order_Id)
GROUP BY
		od.Jahr,
		od.KW
ORDER BY
		od.Jahr,
		od.KW
OPTION (MAXRECURSION 0)
GO

/* Erstellen einer rekursiven Funktion! */
CREATE OR ALTER FUNCTION dbo.DatumListe
(
	@start_date DATE,
	@end_date DATE
)
RETURNS TABLE
AS
RETURN
(
	WITH OrderDates
	AS
	(
		SELECT	@start_date AS OrderDate,
				YEAR(@start_date) AS Jahr,
				DATEPART(WEEK, @start_date) AS KW

		UNION ALL

		SELECT	DATEADD(DAY, 1, OrderDate),
				YEAR(DATEADD(DAY, 1, OrderDate)) AS Jahr,
				DATEPART(WEEK, DATEADD(DAY, 1, OrderDate)) AS KW
		FROM	OrderDates
		WHERE	OrderDate < @end_date
	)
	SELECT * FROM OrderDates
)
GO

DROP FUNCTION dbo.DatumListe;
GO

SELECT	od.Jahr,
		od.KW,
		SUM(cod.Quantity * cod.Price) AS Umsatz
FROM	dbo.CustomerOrders AS co
		INNER JOIN 
		(
			SELECT OrderDate,
                   Jahr,
                   KW
			FROM dbo.DatumListe('2019-01-01', '2019-01-07')
		)AS od
		ON (co.OrderDate = od.OrderDate)
		INNER JOIN dbo.CustomerOrderDetails AS cod
		ON (co.Id = cod.Order_Id)
GROUP BY
		od.Jahr,
		od.KW
ORDER BY
		od.Jahr,
		od.KW
OPTION (MAXRECURSION 0)
GO

SELECT * FROM dbo.DatumListe ('2019-01-01', '2019-01-07')

OPTION (MAXRECURSION 0);
GO
