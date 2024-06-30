SELECT *
FROM olympics;

SELECT year, event, country
FROM olympics
WHERE medal = 'Gold';

SELECT 
    year, event, country,
    ROW_NUMBER() OVER() AS Row_N
FROM olympics
WHERE medal = 'Gold';


SELECT
  *,
  -- Assign numbers to each row
  ROW_NUMBER() OVER() AS Row_N
FROM olympics
ORDER BY Row_N ASC;


SELECT
  Year,
  -- Assign numbers to each year
  ROW_NUMBER() OVER() AS Row_N
FROM (
  SELECT DISTINCT year
  FROM olympics
  ORDER BY Year ASC
) AS Years
ORDER BY Year ASC;
