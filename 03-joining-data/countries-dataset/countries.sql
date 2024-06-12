-- Select all columns from cities
SELECT *
FROM public.cities;


SELECT * 
FROM public.cities AS cities
INNER JOIN public.countries AS countries
-- Matching on country codes
ON cities.country_code = countries.code;


-- Select name fields (with alias) and region 
SELECT cities.name as city, countries.name AS country, countries.region
FROM public.cities 
INNER JOIN public.countries
ON cities.country_code = countries.code;


SELECT c.code AS country_code, name, year, inflation_rate
FROM public.countries AS c
INNER JOIN public.economies AS e
ON c.code = e.code;


SELECT c.name AS country, l.name AS language, official
FROM public.countries AS c
INNER JOIN public.languages AS l
USING (code);


-- Select country and language names, aliased
SELECT c.name as country, l.name as language
FROM public.countries AS c
INNER JOIN public.languages as l
USING (code);


-- Rearrange SELECT statement, keeping aliases
SELECT l.name AS language, c.name AS country
FROM public.countries AS c
INNER JOIN public.languages AS l
USING(code)
-- Order the results by language
ORDER BY language;



-- MULTIPLE JOINS


-- Select relevant fields
SELECT name, year, fertility_rate
FROM public.countries AS c
-- Inner join countries and populations, aliased, on code
INNER JOIN public.populations AS p
ON c.code = p.country_code;


-- CHAINING another INNER JOIN
SELECT name AS country, e.year, fertility_rate, e.unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies as e
-- Match on country code
USING (code);
-- [Albania: The 2010 value for fertility_rate is also paired with the 2015 value for unemployment_rate, whereas we only want data from one year per record.]


-- Correct Query to ensure no repeatitions
SELECT name, e.year, fertility_rate, unemployment_rate
FROM countries AS c
INNER JOIN populations AS p
ON c.code = p.country_code
INNER JOIN economies AS e
ON c.code = e.code
	AND p.year = e.year;


-- LEFT JOIN
SELECT c.name as country, local_name, l.name as language, percent
FROM countries AS c
LEFT JOIN languages AS l
USING (code)
ORDER BY country DESC;


SELECT 
    c1.name AS city,
    code,
    c2.name AS country,
    region,
    city_proper_pop
FROM cities AS c1
INNER JOIN countries AS c2
ON c1.country_code = c2.code
ORDER BY code DESC;
-- Result of 230 rows using INNER JOIN


SELECT 
	c1.name AS city, 
    code, 
    c2.name AS country,
    region, 
    city_proper_pop
FROM cities AS c1
LEFT JOIN countries as c2
ON c1.country_code = c2.code
ORDER BY code DESC;
-- Result of 236 rows using LEFT JOIN
-- Remember that the LEFT JOIN is a type of outer join: its result is not limited to only those records that have matches for both tables on the joining field.

SELECT name, region, gdp_percapita
FROM countries AS c
LEFT JOIN economies AS e
USING (code)
WHERE year = 2010;


SELECT region, AVG(gdp_percapita) AS avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
USING(code)
WHERE year = 2010
GROUP BY region
ORDER BY avg_gdp DESC
LIMIT 10;


--
-- Modify this query to use RIGHT JOIN instead of LEFT JOIN
SELECT countries.name AS country, languages.name AS language, percent
FROM languages
RIGHT JOIN countries
USING(code)
ORDER BY language;

-- Modify this query to use RIGHT JOIN instead of LEFT JOIN
SELECT countries.name AS country, languages.name AS language, percent
FROM languages
RIGHT JOIN countries
USING(code)
ORDER BY language;
-- when converting a LEFT JOIN to a RIGHT JOIN, change both the type of join and the order of the tables to get equivalent results. You would get different results if you only changed the table order. The order of fields you are joining ON still does not matter.

-- FULL JOIN
SELECT name AS country, code, region, basic_unit
FROM countries
FULL JOIN currencies
USING (code)
WHERE region = 'North America'
    OR name IS NULL
ORDER BY region;


-- LEFT JOIN
SELECT name AS country, code, region, basic_unit
FROM countries
LEFT JOIN currencies
USING (code)
WHERE region = 'North America' 
	OR name IS NULL
ORDER BY region;


-- INNER JOIN
SELECT name AS country, code, region, basic_unit
FROM countries
INNER JOIN currencies 
USING (code)
WHERE region = 'North America' 
	OR name IS NULL
ORDER BY region;

-- NOTE:  The FULL JOIN query returned 18 records, the LEFT JOIN returned four records, and the INNER JOIN only returned three records


SELECT 
	c1.name AS country, 
    region, 
    l.name AS language,
	basic_unit, 
    frac_unit
FROM countries AS c1 
FULL JOIN languages AS l
USING(code)
FULL JOIN currencies AS c2
USING(code)
WHERE region LIKE 'M%esia';
-- The first FULL JOIN in the query pulled countries and languages, and the second FULL JOIN added in currency data for each record in the result of the first FULL JOIN


-- INNER JOIN
SELECT c.name AS country, l.name AS language
-- Inner join countries as c with languages as l on code
FROM countries AS c
INNER JOIN languages AS l
USING(code)
WHERE c.code IN ('PAK','IND')
	AND l.code in ('PAK','IND');

-- Cross Join
SELECT c.name AS country, l.name AS language
FROM countries AS c        
CROSS JOIN languages as l
WHERE c.code in ('PAK','IND')
	AND l.code in ('PAK','IND');


SELECT 
	c.name AS country,
    region,
    life_expectancy AS life_exp
FROM countries AS c
INNER JOIN populations as p 
ON c.code = p.country_code
WHERE year = 2010
ORDER BY life_exp 
LIMIT 5;


SELECT 
    p1.country_code,
    p1.size AS size2010,
    p2.size AS size2015
FROM populations as p1
INNER JOIN populations as p2
USING (country_code);


SELECT 
	p1.country_code, 
    p1.size AS size2010, 
    p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code
WHERE p1.year = 2010
    AND p1.year = p2.year - 5;


SELECT *
FROM economies2015
UNION
SELECT *
FROM economies2019
ORDER BY code, year;


SELECT code, year
FROM economies
UNION
SELECT country_code, year
FROM populations
ORDER BY code, year;


SELECT code, year
FROM economies
UNION ALL
SELECT country_code, year
FROM populations
ORDER BY code, year;


-- Return all cities with the same name as a country
SELECT name
FROM cities
INTERSECT
SELECT name 
FROM countries;


-- Return all cities that do not have the same name as a country
SELECT name
FROM cities
EXCEPT
SELECT name
FROM countries
ORDER BY name;
--  Note that if countries had been on the left and cities on the right, you would have returned the opposite: all countries that do not have the same name as a city.


-- Select country code for countries in the Middle East
SELECT code 
FROM countries
WHERE name IN 
    (
        SELECT name
        FROM countries
        WHERE region LIKE '%Middle East'
    )


SELECT DISTINCT name
FROM languages
WHERE code IN
    (SELECT code
    FROM countries
    WHERE region = 'Middle East')
ORDER BY name;


-- Select code and name of countries from Oceania
SELECT code, name
FROM countries
WHERE continent = 'Oceania';

-- ANIT JOIN
SELECT code, name
FROM countries
WHERE continent = 'Oceania'
-- Filter for countries not included in the bracketed subquery
  AND code NOT IN 
    (SELECT code
    FROM currencies);
--  The anti join determined which five out of 19 countries that were not included in the INNER JOIN provided. Did you notice that Tuvalu has two currencies, and therefore shows up twice in the INNER JOIN? This is why the INNER JOIN returned 15 rather than 14 results.


SELECT *
FROM populations
-- Filter for only those populations where life expectancy is 1.15 times higher than average
WHERE life_expectancy > 1.15 *
  (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015) 
    AND year = 2015;



SELECT name, country_code, urbanarea_pop
FROM cities
-- Filter using a subquery on the countries table
WHERE name IN
  (SELECT capital
   FROM countries)
ORDER BY urbanarea_pop DESC;




SELECT countries.name AS country,
    COUNT(cities.country_code) AS cities_num
FROM countries
LEFT JOIN cities 
ON countries.code = cities.country_code
GROUP BY countries.name
ORDER BY cities_num DESC, 
    country ASC
LIMIT 9;



SELECT countries.name AS country,
-- Subquery that provides the count of cities   
  (SELECT COUNT(cities.country_code)
   FROM cities
   WHERE cities.country_code = countries.code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;



-- Select local_name and lang_num from appropriate tables
SELECT local_name, sub.lang_num
FROM countries,
    (SELECT code, COUNT(*) AS lang_num
     FROM languages
     GROUP BY code) AS sub
-- Where codes match    
WHERE countries.code = sub.code
ORDER BY lang_num DESC;


SELECT code, inflation_rate, unemployment_rate
FROM economies
WHERE year = 2015 
  AND code NOT IN
-- Subquery returning country codes filtered on gov_form
	(SELECT code
   FROM countries
    WHERE (gov_form LIKE '%Monarchy%' OR gov_form LIKE '%Republic%')
  )
ORDER BY inflation_rate;




--------------------------------------------------------------

-- Select fields from cities
SELECT 
	name, 
    country_code, 
    city_proper_pop, 
    metroarea_pop,
    city_proper_pop / metroarea_pop * 100 AS city_perc
FROM cities
-- Use subquery to filter city name
WHERE name IN
  (SELECT capital
   FROM countries
   WHERE (continent = 'Europe'
   OR continent LIKE '%America'))
-- Add filter condition such that metroarea_pop does not have null values
	  AND metroarea_pop IS NOT NULL
-- Sort and limit the result
ORDER BY city_perc DESC
LIMIT 10;