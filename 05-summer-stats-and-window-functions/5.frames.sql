-- Moving maximum of Scandinavian athletes' medals
WITH Scandinavian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM olympics
  WHERE
    Country IN ('DEN', 'NOR', 'FIN', 'SWE', 'ISL')
    AND Medal = 'Gold'
  GROUP BY Year)

SELECT
  -- Select each year's medals
  Year,
  Medals,
  -- Get the max of the current and next years'  medals
  MAX(Medals) OVER (ORDER BY Year ASC
             ROWS BETWEEN CURRENT ROW
             AND 1 FOLLOWING) AS Max_Medals
FROM Scandinavian_Medals
ORDER BY Year ASC;
-----------------------------------------------------------------------
-- Moving maximum of Chinese athletes' medals

WITH Chinese_Medals AS (
  SELECT
    Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'CHN' AND Medal = 'Gold'
    AND Year >= 2000
  GROUP BY Athlete)

SELECT
  -- Select the athletes and the medals they've earned
  Athlete,
  Medals,
  -- Get the max of the last two and current rows' medals 
  MAX(Medals) OVER (ORDER BY Athlete ASC
            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW) AS Max_Medals
FROM Chinese_Medals
ORDER BY Athlete ASC;
-------------------------------------------------------------------------
WITH US_Medals AS (
    SELECT Year, COUNT(*) AS Medals
    FROM olympics
    WHERE
        country = 'USA'
        AND medal = 'Gold'
        AND year >= 1980
    GROUP BY Year
    ORDER BY Year ASC
)

SELECT 
    Year, Medals,
    AVG(Medals) OVER (
        ORDER BY Year ASC
        ROWS BETWEEN
        2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM US_Medals
ORDER BY Year ASC;

-------------------------
WITH US_Medals AS (
    SELECT Year, COUNT(*) AS Medals
    FROM olympics
    WHERE
        country = 'USA'
        AND medal = 'Gold'
        AND year >= 1980
    GROUP BY Year
    ORDER BY Year ASC
)

SELECT 
    Year, Medals,
    SUM(Medals) OVER (
        ORDER BY Year ASC
        ROWS BETWEEN
        2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM US_Medals
ORDER BY Year ASC;
----------------------------------------------




-- EXERCISES

-- 1 Moving average of Russian medals
WITH Russian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM olympics
  WHERE
    Country = 'RUS'
    AND Medal = 'Gold'
    AND Year >= 1980
  GROUP BY Year)

SELECT
  Year, Medals,
  --- Calculate the 3-year moving average of medals earned
  AVG(Medals) OVER
    (ORDER BY Year ASC
     ROWS BETWEEN
     2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM Russian_Medals
ORDER BY Year ASC;


-- 2 Moving total of countries' medals
WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM olympics
  GROUP BY Year, Country)

SELECT
  Year, Country, Medals,
  -- Calculate each country's 3-game moving total
  SUM(Medals) OVER
    (PARTITION BY Country
     ORDER BY Year ASC
     ROWS BETWEEN
     2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM Country_Medals
ORDER BY Country ASC, Year ASC;