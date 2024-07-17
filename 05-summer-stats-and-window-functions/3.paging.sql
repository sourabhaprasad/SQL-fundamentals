WITH Disciplines AS (
    SELECT 
        DISTINCT Discipline
    FROM olympics
)

SELECT 
    Discipline, NTILE(15) OVER() AS Page
FROM Disciplines
ORDER BY Page ASC;
------------------------------------------------------
-- Thirds or Quartiles
WITH Country_Medals AS (
    SELECT 
        Country, COUNT(*) AS Medals
    FROM olympics
    GROUP BY Country
)

SELECT
    Country, Medals,
    NTILE(3) OVER (ORDER BY Medals DESC) AS Third
FROM Country_Medals;
-- Query results will be split into thirds, with the top 33% of countries by medals awarded in the top third, the middle 33% in the middle third etc
----------------------------------------------------
WITH Country_Medals AS (
    SELECT 
        Country, COUNT(*) AS Medals
    FROM olympics
    GROUP BY Country),

Thirds AS (
    SELECT
    Country, Medals,
    NTILE(3) OVER (ORDER BY Medals DESC) AS Third
FROM Country_Medals)

SELECT Third, ROUND(AVG(Medals), 2) AS Avg_Medals
FROM Thirds
GROUP BY Third
ORDER BY Third ASC;
------------------------------------------------



-- EXERCISES


-- 1 Paging events
WITH Events AS (
  SELECT DISTINCT Event
  FROM olympics)
  
SELECT
  --- Split up the distinct events into 111 unique groups
  Event,
  NTILE(111) OVER (ORDER BY Event ASC) AS Page
FROM Events
ORDER BY Event ASC;


-- 2 Top, middle, and bottom thirds
WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1)
  
SELECT
  Athlete,
  Medals,
  -- Split athletes into thirds by their earned medals
  NTILE(3) OVER (ORDER BY Medals DESC) AS Third
FROM Athlete_Medals
ORDER BY Medals DESC, Athlete ASC;


-- 2
WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1),
  
  Thirds AS (
  SELECT
    Athlete,
    Medals,
    NTILE(3) OVER (ORDER BY Medals DESC) AS Third
  FROM Athlete_Medals)
  
SELECT
  -- Get the average medals earned in each third
  Third,
  AVG(Medals) AS Avg_Medals
FROM Thirds
GROUP BY Third
ORDER BY Third ASC;