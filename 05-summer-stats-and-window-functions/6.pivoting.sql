CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM CROSSTAB($$
    SELECT  
        Country, Year, COUNT(*) :: INTEGER AS Awards 
        FROM olympics
WHERE
    Country IN ('CHN', 'RUS', 'USA')
    AND Year IN (2008, 2012)
    AND Medal = 'Gold'
GROUP BY Country, Year
ORDER BY Country ASC, Year ASC;
$$) AS ct (Country VARCHAR, "2008" INTEGER, "2012" INTEGER)
ORDER BY Country ASC;
-------------------------------------------------------------------------------------------

-- WITHOUT PIVOTING
WITH Country_Awards AS(
    SELECT  
        Country, Year, COUNT(*) AS Awards 
        FROM olympics
WHERE
    Country IN ('CHN', 'RUS', 'USA')
    AND Year IN (2004, 2008, 2012)
    AND Medal = 'Gold' AND Sport = 'Gymnastics'
GROUP BY Country, Year
ORDER BY Country ASC, Year ASC) 

SELECT 
    Country, Year,
    RANK() OVER (
        PARTITION BY Year
        ORDER BY Awards DESC) :: INTEGER
    AS RANK
FROM Country_Awards
ORDER BY Country ASC, Year ASC;


-- WITH PIVOTING
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM CROSSTAB ($$
    WITH Country_Awards AS(
    SELECT  
        Country, Year, COUNT(*) AS Awards 
        FROM olympics
WHERE
    Country IN ('CHN', 'RUS', 'USA')
    AND Year IN (2004, 2008, 2012)
    AND Medal = 'Gold' AND Sport = 'Gymnastics'
GROUP BY Country, Year
ORDER BY Country ASC, Year ASC) 

SELECT 
    Country, Year,
    RANK() OVER (
        PARTITION BY Year
        ORDER BY Awards DESC) :: INTEGER
    AS RANK
FROM Country_Awards
ORDER BY Country ASC, Year ASC;
$$) AS ct (
    Country VARCHAR,
    "2004" INTEGER,
    "2008" INTEGER,
    "2012" INTEGER
)

ORDER BY Country ASC;
-----------------------------------------------------------------------------------
-- EXERCISES



-- 1 A basic pivot
-- Create the correct extension to enable CROSSTAB
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  SELECT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year IN (2008, 2012)
    AND Medal = 'Gold'
    AND Event = 'Pole Vault'
  ORDER By Gender ASC, Year ASC;
-- Fill in the correct column names for the pivoted table
$$) AS ct (Gender VARCHAR,
           "2008" VARCHAR,
           "2012" VARCHAR)

ORDER BY Gender ASC;



-- 2.1 Pivoting with ranking
-- Count the gold medals per country and year
SELECT
  Country,
  Year,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Country IN ('FRA', 'GBR', 'GER')
  AND Year IN (2004, 2008, 2012)
  AND Medal = 'Gold'
GROUP BY Country, year
ORDER BY Country ASC, Year ASC



-- 2.3 
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  WITH Country_Awards AS (
    SELECT
      Country,
      Year,
      COUNT(*) AS Awards
    FROM Summer_Medals
    WHERE
      Country IN ('FRA', 'GBR', 'GER')
      AND Year IN (2004, 2008, 2012)
      AND Medal = 'Gold'
    GROUP BY Country, Year)

  SELECT
    Country,
    Year,
    RANK() OVER
      (PARTITION BY Year
       ORDER BY Awards DESC) :: INTEGER AS rank
  FROM Country_Awards
  ORDER BY Country ASC, Year ASC;
-- Fill in the correct column names for the pivoted table
$$) AS ct (Country VARCHAR,
           "2004" INTEGER,
           "2008" INTEGER,
           "2012" INTEGER)

Order by Country ASC;
-------------------------------------------------------------------------------------
-- ROLLUP()

-- Count the gold medals per country and gender
SELECT
  Country,
  Gender,
  COUNT(*) AS Gold_Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
-- Generate Country-level subtotals
GROUP BY Country, ROLLUP(Gender)
ORDER BY Country ASC, Gender ASC;
----------------------------------------------------------------------------------------------
-- CUBE()

-- Count the medals per gender and medal type
SELECT
  Gender,
  Medal,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2012
  AND Country = 'RUS'
-- Get all possible group-level subtotals
GROUP BY CUBE(Gender, Medal)
ORDER BY Gender ASC, Medal ASC;
--------------------------------------------------------------------------------------------------------------
-- Rollup() & Cube()

--------------------------------------------------------------------------------------------------------------
-- Coalesce()


SELECT
  COALESCE(Country, 'Both countries') AS Country, 
  COALESCE (Medal, 'All medals') AS Medal, 
  COUNT(*) AS Awards
FROM olympics
WHERE
  Year = 2008 
  AND Country IN ('CHN', 'RUS') 
GROUP BY ROLLUP (Country, Medal) 
ORDER BY Country ASC, Medal ASC;



------------------------------------------------------------------------------------------------------------
-- String_Agg()

WITH Country_Medals AS (
SELECT  
  Country, 
  COUNT(*) AS Medals 
FROM olympics
WHERE Year = 2012
  AND Country IN ('CHN', 'RUS', 'USA')
  AND Medal = 'Gold'
  AND Sport = 'Gymnastics'
GROUP BY Country),

  Country_Ranks AS (
  SELECT
    Country, 
    RANK() OVER (ORDER BY Medals DESC) AS Rank 
  FROM Country_Medals 
  ORDER BY Rank ASC
)

SELECT String_Agg(Country, ',')
FROM Country_Medals;
------------------------------------------------------------------------------------------------------------



-- EXERCISE


-- 1 Cleaning up results
SELECT
  -- Replace the nulls in the columns with meaningful text
  COALESCE(Country, 'All countries') AS Country,
  COALESCE(Gender, 'All genders') AS Gender,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
GROUP BY ROLLUP(Country, Gender)
ORDER BY Country ASC, Gender ASC;


-- 2 Summarizing results
WITH Country_Medals AS (
  SELECT
    Country,
    COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE Year = 2000
    AND Medal = 'Gold'
  GROUP BY Country),

  Country_Ranks AS (
  SELECT
    Country,
    RANK() OVER (ORDER BY Medals DESC) AS Rank
  FROM Country_Medals
  ORDER BY Rank ASC)

-- Compress the countries column
SELECT String_Agg(Country, ', ')
FROM Country_Ranks
-- Select only the top three ranks
WHERE Rank <= 3;