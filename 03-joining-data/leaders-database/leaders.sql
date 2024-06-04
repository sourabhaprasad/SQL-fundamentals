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
FROM public.prime_minister_terms;