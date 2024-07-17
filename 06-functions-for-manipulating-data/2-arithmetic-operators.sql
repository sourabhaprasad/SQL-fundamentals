SELECT 
    AGE(rental_date)
FROM rental;

-------------------------------------------------
SELECT f.title, f.rental_duration,
    -- Calculate the number of days rented
    r.return_date - r.rental_date AS days_rented
FROM film AS f
     INNER JOIN inventory AS i ON f.film_id = i.film_id
     INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;


SELECT f.title, f.rental_duration,
    -- Calculate the number of days rented
	AGE(r.return_date, r.rental_date) AS days_rented
FROM film AS f
	INNER JOIN inventory AS i ON f.film_id = i.film_id
	INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;



SELECT
	f.title,
 	-- Convert the rental_duration to an interval
    INTERVAL '1' day * f.rental_duration,
 	-- Calculate the days rented as we did previously
    r.return_date - r.rental_date AS days_rented
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
-- Filter the query to exclude outstanding rentals
WHERE r.return_date IS NOT Null
ORDER BY f.title;



SELECT
    f.title,
	r.rental_date,
    f.rental_duration,
    -- Add the rental duration to the rental date
    INTERVAL '1' day * f.rental_duration + r.rental_date AS expected_return_date,
    r.return_date
FROM film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY f.title;
--  compare the expected_return_date to the actual return_date to determine if a rental was returned late
--------------------------------------------------------------------------
SELECT NOW();

SELECT NOW()::TIMESTAMP;

SELECT CAST(NOW() as TIMESTAMP);

SELECT CURRENT_TIMESTAMP;

SELECT CURRENT_TIMESTAMP(2);

SELECT CURRENT_DATE;

SELECT CURRENT_TIME;
---------------------------------
SELECT 
	-- Select the current date
	CURRENT_DATE,
    -- CAST the result of the NOW() function to a date
    CAST( NOW() AS date )




SELECT
	CURRENT_TIMESTAMP(0)::timestamp AS right_now,
    interval '5 days' + CURRENT_TIMESTAMP(0) AS five_days_from_now;
----------------------------------------------------------------------------------------------
SELECT * FROM payment;

SELECT
    EXTRACT(quarter FROM payment_date) AS quarter,
    EXTRACT(year from payment_date) AS year,
    SUM(amount) AS total_payments
FROM    
    payment
GROUP BY 1,2;
--------------------------------------------------------------------------------------
SELECT 
  -- Extract day of week from rental_date
  EXTRACT(dow FROM rental_date) AS dayofweek 
FROM rental 
LIMIT 100;


-- Extract day of week from rental_date
SELECT 
  EXTRACT(dow FROM rental_date) AS dayofweek, 
  -- Count the number of rentals
  COUNT(rental) as rentals 
FROM rental 
GROUP BY 1;


-- Truncate rental_date by year
SELECT DATE_TRUNC('year', rental_date) AS rental_year
FROM rental;


SELECT 
  DATE_TRUNC('day', rental_date) AS rental_day,
  -- Count total number of rentals 
  COUNT(rental) AS rentals 
FROM rental
GROUP BY 1;


SELECT 
  -- Extract the day of week date part from the rental_date
  EXTRACT(dow FROM rental_date) AS dayofweek,
  AGE(return_date, rental_date) AS rental_days
FROM rental AS r 
WHERE 
  -- Use an INTERVAL for the upper bound of the rental_date 
  rental_date BETWEEN CAST('2005-05-01' AS DATE)
   AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';
-----------------------------------------------------------
SELECT 
  c.first_name || ' ' || c.last_name AS customer_name,
  f.title,
  r.rental_date,
  -- Extract the day of week date part from the rental_date
  EXTRACT(dow FROM r.rental_date) AS dayofweek,
  AGE(r.return_date, r.rental_date) AS rental_days,
  -- Use DATE_TRUNC to get days from the AGE function
  CASE WHEN DATE_TRUNC('day', AGE(r.return_date, r.rental_date)) > 
    f.rental_duration * INTERVAL '1' day 
  THEN TRUE 
  ELSE FALSE END AS past_due 
FROM 
  film AS f 
  INNER JOIN inventory AS i 
  	ON f.film_id = i.film_id 
  INNER JOIN rental AS r 
  	ON i.inventory_id = r.inventory_id 
  INNER JOIN customer AS c 
  	ON c.customer_id = r.customer_id 
WHERE 
  -- Use an INTERVAL for the upper bound of the rental_date 
  r.rental_date BETWEEN CAST('2005-05-01' AS DATE) 
  AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';
--------------------------------------------------------------------------------
SELECT
    REPLACE(description, 'A Astounding', 'An Astounding') AS description
FROM film;

--------------------------------------------------------------------------------
SELECT
    title,
    REVERSE(title) as reversed_title
FROM film;

-- Concatenate the first_name and last_name and email 
SELECT first_name || ' ' || last_name  || ' <' || email || '>' AS full_email 
FROM customer

-- Concatenate the first_name and last_name and email
SELECT CONCAT(first_name,' ',last_name, ' <',  email, '>') AS full_email 
FROM customer


--------------------------------------------------------------------------------
SELECT 
  -- Concatenate the category name to coverted to uppercase
  -- to the film title converted to title case
  UPPER(c.name)  || ': ' || INITCAP(title) AS film_category, 
  -- Convert the description column to lowercase
  LOWER(description) AS description
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;
--------------------------------------------------------------------------------
SELECT 
  -- Replace whitespace in the film title with an underscore
  REPLACE(title, ' ', '_') AS title
FROM film; 
--------------------------------------------------------------------------------
SELECT title, CHAR_LENGTH(title)
FROM film
limit 5;

SELECT title, LENGTH(title)
FROM film
limit 5;
--------------------------------------------------------------------------------
SELECT email, POSITION('@' IN email)
FROM customer;
--------------------------------------------------------------------------------
SELECT email, STRPOS(email,'@')
FROM customer;
--------------------------------------------------------------------------------
SELECT 
  -- Select the title and description columns
  title,
  description,
  -- Determine the length of the description column
  length(description) AS desc_len
FROM film;
--------------------------------------------------------------------------------
SELECT 
  -- Select the first 50 characters of description
  LEFT(description, 50) AS short_desc
FROM 
  film AS f; 
--------------------------------------------------------------------------------
SELECT 
  -- Select only the street name from the address table
  SUBSTRING(address FROM POSITION(' ' in address)+1 FOR LENGTH(address))
FROM 
  address;
--------------------------------------------------------------------------------
SELECT
  -- Extract the characters to the left of the '@'
  SUBSTRING(email FROM 0 FOR POSITION('@' IN email)) AS username,
  -- Extract the characters to the right of the '@'
  SUBSTRING(email FROM POSITION('@' IN email)+1 FOR LENGTH(email)) AS domain
FROM customer;
--------------------------------------------------------------------------------
-- Concatenate the padded first_name and last_name 
SELECT 
	RPAD(first_name, LENGTH(first_name)+1) || last_name AS full_name
FROM customer;


-- Concatenate the first_name and last_name 
SELECT 
	first_name || LPAD(last_name, LENGTH(last_name)+1) AS full_name
FROM customer; 


-- Concatenate the first_name and last_name 
SELECT 
	RPAD(first_name, LENGTH(first_name)+1) 
    || RPAD(last_name, LENGTH(last_name)+2, ' <') 
    || RPAD(email, LENGTH(email)+1, '>') AS full_email
FROM customer; 
--------------------------------------------------------------------------------
-- Concatenate the uppercase category name and film title
SELECT 
  CONCAT(UPPER(name), ': ', f.title) AS film_category, 
  -- Truncate the description remove trailing whitespace
  TRIM(LEFT(description, 50)) AS film_desc
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;
--------------------------------------------------------------------------------
SELECT 
  UPPER(c.name) || ': ' || f.title AS film_category, 
  -- Truncate the description without cutting off a word
  LEFT(description, 50 - 
    -- Subtract the position of the first whitespace character
    POSITION(
      ' ' IN REVERSE(LEFT(description, 50))
    )
  ) 
FROM 
  film AS f 
  INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
  INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;
--------------------------------------------------------------------------------