SELECT *
FROM
(
	SELECT * FROM (VALUES (2024), (2025), (2026), (2027)) AS x (Jahr)
) AS j
CROSS JOIN
(
	SELECT * FROM (VALUES (1), (2), (3), (4), (5), (6), (7)) AS x (Monat)
) AS m

/* Anzahl der Rows: j * m */