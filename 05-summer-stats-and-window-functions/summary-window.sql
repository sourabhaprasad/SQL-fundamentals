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


SELECT 
  year, event, country,
  ROW_NUMBER() OVER (ORDER BY Year DESC) AS Row_N
FROM olympics 
WHERE 
  Medal = 'Gold';


SELECT 
  year, event, country,
  ROW_NUMBER() OVER 
    (ORDER BY year DESC, event ASC) AS Row_N
FROM olympics
WHERE 
  medal = 'Gold';



-- ORDERING BOTH INSIDE AND OUTSIDE AT THE SAME TIME
SELECT 
  year, event, country,
  ROW_NUMBER() OVER 
    (ORDER BY year DESC, event ASC) AS Row_N
FROM olympics
WHERE 
  medal = 'Gold'
ORDER BY country asc, Row_N asc;


SELECT *
FROM olympics;
-------------------------------------
-- LAG Window Function
SELECT
  year, country as champion
FROM olympics
WHERE 
  gender = 'Men' AND medal = 'Gold'
  AND event = 'Discus Throw';


-- COMMON TABLE EXPRESSIONS
WITH Discus_Gold AS (
  SELECT
    year, country as champion
  FROM olympics
  WHERE
    year IN (1996,2000,2004,2008,2012)
    AND gender = 'Men' AND medal = 'Gold' AND event = 'Discus Throw')


SELECT 
  year, champion,
  LAG(Champion, 1) OVER
  (ORDER BY Year ASC) AS Last_Champion
FROM Discus_Gold
ORDER BY year asc;
----------------------------------------------
WITH Athlete_Medals AS (
  SELECT
    -- Count the number of medals each athlete has earned
    Athlete,
    COUNT(*) AS Medals
  FROM olympics
  GROUP BY Athlete)

SELECT
  -- Number each athlete by how many medals they've earned
  athlete,
  ROW_NUMBER() OVER (ORDER BY medals DESC) AS Row_N
FROM Athlete_Medals
ORDER BY Medals DESC;
---------------------------------------------
WITH Weightlifting_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Country AS champion
  FROM olympics
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')

SELECT
  Year, Champion,
  -- Fetch the previous year's champion
  LAG(Champion) OVER
    (ORDER BY Year ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;
----------------------------------------------------
-- PARTITION BY

WITH Discus_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Event,
    Country AS champion
  FROM olympics
  WHERE
    Year in (2004, 2008, 2012)
    AND Gender = 'Men' AND Medal = 'Gold'
    AND Event in ('Discus Throw','Triple Jump'))

SELECT
  Year,Event, Champion,
  -- Fetch the previous year's champion
  LAG(Champion) OVER
    (ORDER BY Event ASC, Year ASC) AS Last_Champion
FROM Discus_Gold
ORDER BY Event ASC, Year ASC;
-- When event changes from Discus to Triple Jump, LAG fetched Discus Throw's last champion as opposed to null.
----------------------------------

WITH Discus_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Event,
    Country AS champion
  FROM olympics
  WHERE
    Year in (2004, 2008, 2012)
    AND Gender = 'Men' AND Medal = 'Gold'
    AND Event in ('Discus Throw','Triple Jump'))

SELECT
  Year,Event, Champion,
  -- Fetch the previous year's champion
  LAG(Champion) OVER
    (PARTITION BY Event
      ORDER BY Event ASC, Year ASC) AS Last_Champion
FROM Discus_Gold
ORDER BY Event ASC, Year ASC;
----------------------------------
WITH Country_Gold AS (
  SELECT
    DISTINCT Year, Country, Event
  From olympics
  WHERE 
    YEAR IN (2008,2012)
    AND Country IN ('CHN','JPN')
    AND Gender = 'Women' AND Medal = 'Gold'
)

SELECT
  Year, Country, event,
   ROW_NUMBER() OVER (PARTITION BY Year, Country)
  FROM Country_Gold;