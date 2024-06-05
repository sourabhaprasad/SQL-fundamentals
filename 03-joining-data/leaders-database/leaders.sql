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

