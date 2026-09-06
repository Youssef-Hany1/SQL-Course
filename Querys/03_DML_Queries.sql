-- Insert a new customers
INSERT INTO customers (id, first_name, country, score)
VALUES
	(6, 'Youssef', 'Egypt', 800),
	(7, 'Sam', NULL, 100);

-- Copy data from customers table into persons
INSERT INTO persons (id, person_name, birth_date, phone)
SELECT
	id,
	first_name,
	NULL,
	'Unknown'
FROM customers;

SELECT * FROM persons;

-- Change the score of customer with ID 6 to 0
UPDATE customers
SET score = 0
WHERE id = 6;

SELECT * FROM customers;

/* Change the score of customer 7 to 0
   and update the country to UK */
UPDATE customers
SET score = 0,
    country = 'UK'
WHERE id = 7;

/* Update all customers with a NULL score
   by setting their score to 0 */
UPDATE customers
SET score = 0
WHERE score IS NULL;

-- Delete all cusstomers with an ID greater than 5
DELETE FROM customers
WHERE id > 5;

-- Delete all data from the persons table
DELETE FROM persons
-- OR
TRUNCATE TABLE persons;

SELECT * FROM persons;