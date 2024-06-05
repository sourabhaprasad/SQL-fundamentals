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
