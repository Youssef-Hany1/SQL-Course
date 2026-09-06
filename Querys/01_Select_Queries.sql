USE MyDatabase

-- Retrieve All Customer Data
SELECT * 
FROM dbo.customers;

-- Retrieve All Order Data
SELECT *
FROM dbo.orders;

-- Retrieve each customer's name, country, and score
SELECT 
	first_name,
	country,
	score
FROM dbo.customers;

-- Retrieve customers with a score not equal to 0
SELECT *
FROM dbo.customers
WHERE score != 0;

-- Retrieve customers from Germany
SELECT *
FROM dbo.customers
WHERE country = 'Germany';

/* Retrieve each customer's name, and country
   and customers from Germany */
SELECT
	first_name,
	country
FROM dbo.customers
WHERE country = 'Germany';

/* Retrieve all customers and 
   sort the results by the highest score first */
SELECT *
FROM dbo.customers
ORDER BY score DESC;

/* Retrieve all customers and 
   sort the results by the lowest score first */
SELECT *
FROM dbo.customers
ORDER BY score ASC;

/* Retrieve all customers and
   sort the results by the country
   and then by the highest score */
SELECT *
FROM dbo.customers
ORDER BY 
	country ASC,
	score DESC;

-- Find the total score for each country
SELECT 
	country,
	SUM(score) AS total_score
FROM dbo.customers
GROUP BY country;

-- Find the total score and total number of customers for each country
SELECT 
	country,
	SUM(score) AS total_score,
	COUNT(id) AS total_customers
FROM dbo.customers
GROUP BY country;

/* Find the average score for each country
   considering only customers with a score not equal to 0
   and return only those countries with
   an average score greater than 430 */
SELECT 
	country,
	AVG(score) AS average_score
FROM dbo.customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;

-- Return unique list of all countries
SELECT DISTINCT country
FROM dbo.customers;

-- Retrieve only 3 customers
SELECT TOP 3 *
FROM dbo.customers;

-- Retrieve the top 3 customers with the highest scores
SELECT TOP 3 *
FROM dbo.customers
ORDER BY score DESC;

-- Retrieve the lowest 2 customers based on the score
SELECT TOP 2 *
FROM dbo.customers
ORDER BY score ASC;

-- Get the two most recent orders
SELECT TOP 2 *
FROM dbo.orders
ORDER BY order_date DESC;