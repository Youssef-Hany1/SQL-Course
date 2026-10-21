/* ============================================================================
   File: 02_in_between_like.sql
   Author: Youssef Hany
   Description: Foundational SQL queries demonstrating data filtering techniques
                using Range, Membership, and Search operators.
   Database: MyDatabase
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: RANGE OPERATOR
   ============================================================================ */

/* Retrieve all customers whose score falls
   in the range between 100 and 500 */
SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500;

-- OR
SELECT *
FROM customers
WHERE score >= 100 AND score <= 500;

/* ============================================================================
   SECTION 2: MEMBERSHIP OPERATOR
   ============================================================================ */

/* Retrieve all customers from
   either Germany or USA */
SELECT *
FROM customers
WHERE country IN ('Germany', 'USA');

/* Retrieve all customers from
   neither Germany nor USA */
SELECT *
FROM customers
WHERE country NOT IN ('Germany', 'USA');

/* ============================================================================
   SECTION 3: SEARCH OPERATOR
   ============================================================================ */

/* Find all customers whose
   first name starts with 'M' */
SELECT *
FROM customers
WHERE first_name LIKE 'M%';

/* Find all customers whose
   first name ends with 'n' */
SELECT *
FROM customers
WHERE first_name LIKE '%n';

/* Find all customers whose
   first name contains 'r' */
SELECT *
FROM customers
WHERE first_name LIKE '%r%';

/* Find all customers whose
   first name has 'r' in the third position */
SELECT *
FROM customers
WHERE first_name LIKE '__r%';