-- Text Data Type

SELECT title
FROM film
LIMIT 5;

SELECT description
FROM film
LIMIT 2;
------------------------------------------------------------------
-- Numeric Data Type

SELECT payment_id
FROM payment
LIMIT 5;

SELECT amount
FROM payment
LIMIT 5;
-------------------------------------------------------------------
SELECT
    title,
    description,
    special_features
FROM film
LIMIT 5;
-------------------------------------------------------------------
-- Determining data types from existing tables

SELECT
    column_name,
    data_type
FROM INFORMATION_SCHEMA.COLUMNS
WHERE column_name in ('title','description','special_features')
    AND table_name = 'film';
-------------------------------------------------------------------
-- EXERCISES

-- 1 Getting information about your database
 -- Select all columns from the TABLES system database
 SELECT * 
 FROM INFORMATION_SCHEMA.TABLES
 -- Filter by schema
 WHERE table_schema = 'public';


 -- 2
  -- Select all columns from the COLUMNS system database
 SELECT * 
 FROM INFORMATION_SCHEMA.COLUMNS 
 WHERE table_name = 'actor';


 -- 3 Determining data types
-- Get the column name and data type
SELECT
 	column_name, 
    data_type
-- From the system database information schema
FROM INFORMATION_SCHEMA.COLUMNS 
-- For the customer table
WHERE table_name = 'customer';
----------------------------------------------------------------------------------------------------------------------------
-- TIME and DATE data type


-- TIMESTAMP
SELECT payment_date
FROM payment;
------------------------------------------------------
-- Date & Time 

SELECT create_date
FROM customer;
------------------------------------------------------
-- Interval

SELECT rental_date + INTERVAL '3 days' AS expected_return
FROM rental;


SELECT 
    column_name,
    data_type
FROM INFORMATION_SCHEMA.COLUMNS
WHERE column_name in ('rental_date')
    AND table_name = 'rental';
----------------------------------------------------------------------------------------------------------------------------


-- EXERCISES

-- 1 Interval data types
SELECT
 	-- Select the rental and return dates
	rental_date,
	return_date,
 	-- Calculate the expected_return_date
	rental_date + INTERVAL '3 days' AS expected_return_date
FROM rental;
----------------------------------------------------------------------------------------------------------------------------


-- ARRAYS

-- 1 Accessing data in an ARRAY
-- Select the title and special features column 
SELECT 
  title, 
  special_features 
FROM film
-- Use the array index of the special_features column
WHERE special_features[1] = 'Trailers';



-- 2 Accessing data in an ARRAY
-- Select the title and special features column 
SELECT 
  title, 
  special_features 
FROM film
-- Use the array index of the special_features column
WHERE special_features[2] = 'Deleted Scenes';



-- 3 Searching an ARRAY with ANY
SELECT
  title, 
  special_features 
FROM film 
-- Modify the query to use the ANY function 
WHERE 'Trailers' = ANY (special_features);


-- 4 Searching an ARRAY with @>
SELECT 
  title, 
  special_features 
FROM film 
-- Filter where special_features contains 'Deleted Scenes'
WHERE special_features @> ARRAY['Deleted Scenes'];









----------------------------------------------------------------------------------------------------------------------------