SELECT title
FROM film
WHERE title LIKE 'ELF%';

SELECT title
FROM film
WHERE title LIKE '%ELF';

-- FULL TEXT SEARCH
SELECT title, description
FROM film
WHERE to_tsvector(title) @@ to_tsquery('elf');

-- Select all columns
SELECT *
FROM film
-- Select only records that begin with the word 'GOLD'
WHERE title LIKE 'GOLD%';

-- Select the film description as a tsvector
SELECT to_tsvector(description)
FROM film;
------------------------------------------------------------------------------------------------------
-- Create an enumerated data type, compass_position
CREATE TYPE compass_position AS ENUM (
  	-- Use the four cardinal directions
  	'North', 
  	'South',
  	'East', 
  	'West'
);
-- Confirm the new data type is in the pg_type system table
SELECT typname, typcategory
FROM pg_type
WHERE typname='compass_position';
-------------------------------------------------------------------------------------------------------------------
-- Select the column name, data type and udt name columns
SELECT column_name, data_type, udt_name
FROM INFORMATION_SCHEMA.COLUMNS 
-- Filter by the rating column in the film table
WHERE table_name ='film' AND column_name='rating';


-------------------------------------------------------------------------------------------------------------------
SELECT *
FROM pg_type 
WHERE typname='mpaa_rating'
-------------------------------------------------------------------------------------------------------------------
-- Select the film title and inventory ids
SELECT 
	f.title, 
    i.inventory_id,
    -- Determine whether the inventory is held by a customer
    inventory_held_by_customer(i.inventory_id) as held_by_cust
FROM film as f 
	INNER JOIN inventory AS i ON f.film_id=i.film_id 
WHERE
	-- Only include results where the held_by_cust is not null
    inventory_held_by_customer(i.inventory_id) IS NOT NULL
-------------------------------------------------------------------------------------------------------------------
SELECT name
FROM pg_available_extensions;


SELECT extname
FROM pg_extension;


--Enable the fuzzystrmatch extension CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
--Confirm that fuzzstrmatch has been enabled SELECT extname FROM pg_extension;
SELECT extname FROM pg_extension;
------------------------------------------------------------------------------------------------
SELECT levenshtein('Gumbo','Gambol');

-- Enable the pg_trgm extension
CREATE EXTENSION IF NOT EXISTS pg_trgm;

SELECT similarity('Gumbo','Gambol');
---------------------------------------------------------------------------------------
-- Select all rows extensions
SELECT *
FROM pg_extension;
------------------------------------------
-- Select the title and description columns
SELECT 
  title, 
  description, 
  -- Calculate the similarity
  similarity(title, description)
FROM 
  film;
----------------------------------------------
-- Select the title and description columns
SELECT  
  title, 
  description, 
  -- Calculate the levenshtein distance
  levenshtein(title, 'JET NEIGHBOR') AS distance
FROM 
  film
ORDER BY 3;
---------------------------------------------------
SELECT 
  title, 
  description, 
  -- Calculate the similarity
  similarity(description, 'Astounding Drama')
FROM 
  film 
WHERE 
  to_tsvector(description) @@ 
  to_tsquery('Astounding & Drama') 
ORDER BY 
	similarity(description, 'Astounding Drama') DESC;
---------------------------------------------------------------------------------