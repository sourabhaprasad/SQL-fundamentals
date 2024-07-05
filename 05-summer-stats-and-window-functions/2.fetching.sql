With Hosts AS (
    SELECT DISTINCT Year, City
    FROM olympics
)

SELECT
    Year, 
    LAG(City, 1) OVER (ORDER BY Year ASC) AS Previous_City,
    City,
    Lead(City, 1) OVER (ORDER BY Year ASC) AS Next_City,
    LEAD(City, 2) OVER (ORDER BY Year ASC) AS After_Next_City
FROM Hosts
ORDER BY Year ASC;
-------------------------------------------
With Hosts AS (
    SELECT DISTINCT Year, City
    FROM olympics
)

SELECT
    Year, City,
    First_Value(City) OVER (ORDER BY Year ASC) AS First_City,
    Last_Value(City) OVER (
        ORDER BY Year ASC
        RANGE BETWEEN 
        UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_City 
        -- A window function by default starts at the beginning of a table or partition and ends at the current row.
        -- Without the range betweeen clause, Last_Value will get the value of the current row and so Last_City will be the same as the as City.
        -- RANGE BETWEEEN clause extends the window to to the end of the table or partition.
FROM Hosts
ORDER BY Year ASC;
-------------------------------------
-- fetch the current gold medalist and the gold medalist 3 competitions ahead of the current row.
WITH Discus_Medalists AS (
  SELECT DISTINCT
    Year,
    Athlete
  FROM olympics
  WHERE Medal = 'Gold'
    AND Event = 'Discus Throw'
    AND Gender = 'Women'
    AND Year >= 2000)

SELECT
  -- For each year, fetch the current and future medalists
  Year,
  Athlete,
  LEAD(Athlete, 3) OVER (ORDER BY Year ASC) AS Future_Champion
FROM Discus_Medalists
ORDER BY Year ASC;
--------------------------------
WITH All_Male_Medalists AS (
  SELECT DISTINCT
    Athlete
  FROM olympics
  WHERE Medal = 'Gold'
    AND Gender = 'Men')

SELECT
  -- Fetch all athletes and the first athlete alphabetically
  Athlete,
  First_Value(Athlete) OVER (
    ORDER BY Athlete ASC
  ) AS First_Athlete
FROM All_Male_Medalists;
------------------------------------------
WITH Hosts AS (
  SELECT DISTINCT Year, City
    FROM Summer_Medals)

SELECT
  Year,
  City,
  -- Get the last city in which the Olympic games were held
  Last_Value(City) OVER (
   ORDER BY Year ASC
   RANGE BETWEEN
     UNBOUNDED PRECEDING AND
     UNBOUNDED FOLLOWING
  ) AS Last_City
FROM Hosts
ORDER BY Year ASC;
-----------------------------------------------
WITH Country_Games AS(
SELECT  
    Country, COUNT(DISTINCT Year) AS Games
    FROM olympics
    WHERE 
        Country IN ('GBR','DEN','FRA','ITA','AUT','BEL','NOR','POL','ESP')
GROUP BY Country
ORDER BY Games DESC)

SELECT 
    Country, Games,
    ROW_NUMBER()
        OVER (ORDER BY Games DESC) AS Row_N
FROM Country_Games
ORDER BY Games DESC, Country ASC;
