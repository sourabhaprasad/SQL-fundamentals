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