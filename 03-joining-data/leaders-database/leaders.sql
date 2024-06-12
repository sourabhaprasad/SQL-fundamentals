-- presidents
SELECT *
FROM public.presidents;

-- prime ministers
SELECT *
FROM public.prime_ministers;

-- Egypt, Portugal, Pakistan & India have both presidents & prime ministers.
-- INNER JOIN of presidents & prime minister
SELECT pm.country, pm.continent, prime_minister, president
FROM public.prime_ministers AS pm
INNER JOIN public.presidents AS p
ON pm.country = p.country;

-- INNER JOIN of presidents & prime ministers joining on country
SELECT pm.country, pm.continent, prime_minister, president
FROM public.prime_ministers AS pm
INNER JOIN public.presidents AS p
USING(country);


SELECT pm.country, pm.continent, prime_minister, president, pm_start
FROM public.prime_ministers AS pm
INNER JOIN public.presidents AS p
USING(country)
INNER JOIN public.prime_minister_terms AS pmt
ON pm.prime_minister = pmt.name;


SELECT *
FROM prime_ministers;

SELECT *
FROM presidents;

-- OUTER JOIN
-- LEFT JOIN
-- To include all countries with prime ministers, presidents if exists else missing values/ NULL
SELECT country, prime_minister, president
FROM prime_ministers AS pm
LEFT JOIN presidents AS p
USING (country);


SELECT *
FROM prime_ministers;

SELECT *
FROM presidents;

-- RIGHT JOIN : with presidents & prime ministers
SELECT p.country, prime_minister, president
FROM prime_ministers AS pm
RIGHT JOIN presidents as p
USING (country);


-- FULL JOIN
SELECT COALESCE(pm.country, p.country) AS country, prime_minister, president
FROM prime_ministers as pm 
FULL JOIN presidents as p
ON pm.country = p.country;

--
SELECT prime_minister, president
FROM prime_ministers as pm
CROSS JOIN presidents as p
WHERE pm.continent IN ('Asia')
    AND p.continent IN ('South America');



-- SELF JOIN
SELECT 
    pm.country AS country1,
    p.country AS country2,
    pm.continent
FROM prime_ministers as pm
INNER JOIN presidents as p
ON pm.continent = p.continent
LIMIT 10;


SELECT 
    pm.country AS country1,
    p.country AS country2,
    pm.continent
FROM prime_ministers as pm
INNER JOIN presidents as p
ON pm.continent = p.continent
    AND pm.country <> p.country; -- != operator to exclude identical countries




-- SET OPERATIONS
SELECT *
FROM monarchs;


-- UNION
SELECT monarch as leader, country
FROM monarchs
UNION
SELECT prime_minister, country
FROM prime_ministers
ORDER BY country, leader;
-- Oman & Brunei lists only one person, while norway lists two people since monarch and prime ministers as different.


SELECT monarch as leader, country
FROM monarchs
UNION ALL
SELECT prime_minister, country
FROM prime_ministers
ORDER BY country, leader;


-- CROSS JOIN
SELECT prime_minister, president
FROM prime_ministers as pm
CROSS JOIN presidents as p
WHERE pm.continent IN ('Asia')
    AND p.continent IN ('South America');


-- INTERSECT - countries with both prime minister and president
SELECT country as intersect_country
FROM prime_ministers 
INTERSECT
SELECT country
FROM presidents;

SELECT country as intersect_country, prime_minister as leader
FROM prime_ministers 
INTERSECT
SELECT country, president
FROM presidents;
-- INTERSECT requires data from both fields in the left table to match their corresponding fields in the right table.


SELECT country as country, prime_minister as leader
FROM prime_ministers 
INTERSECT
SELECT country, monarch
FROM monarchs;


-- MONARCHS that do not hold the title of prime minister
SELECT monarch , country
FROM monarchs
EXCEPT
SELECT prime_minister, country
FROM prime_ministers;


-- SEMI JOINS
SELECT president, country, continent
FROM presidents
WHERE country IN 
    (
        SELECT country
        FROM states
        WHERE indep_year < 1800
    );


-- ANTI JOINS > chooses records in the first table where col1 does NOT find a match in col2
SELECT president, country
FROM presidents
WHERE continent LIKE '%America'
    AND country NOT IN
    (
        SELECT country
        FROM states
        WHERE indep_year < 1800
    );

SELECT DISTINCT continent
FROM states;


SELECT DISTINCT continent,
    (
        SELECT count(*)
        FROM monarchs
        WHERE states.continent = monarchs.continent
    ) AS monarch_count
FROM states;



SELECT continent, MAX(indep_year) AS most_recent
FROM states
GROUP BY continent


SELECT DISTINCT monarchs.continent, sub.most_recent
FROM monarchs,
    (
        SELECT
            continent,
            MAX(indep_year) AS most_recent
            FROM states
            GROUP BY continent
    ) AS sub
WHERE monarchs.continent = sub.continent
ORDER BY continent;



