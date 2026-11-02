/* ============================================================================
   File: 01_comparison_logical_operators.sql
   Author: Youssef Hany
   Description: Foundational SQL queries demonstrating data filtering techniques
                using Comparison and Logical operators.
   Database: MyDatabase
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: COMPARISON OPERATORS
   ============================================================================ */

-- Retrieve all customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany';

-- Retrieve all customers who are not from Germany
SELECT *
FROM customers
WHERE country != /* or <> */ 'Germany';

-- Retrieve all customers with a score greater than 500
SELECT *
FROM customers
WHERE score > 500;

-- Retrieve all customers with a score of 500 or more
SELECT *
FROM customers
WHERE score >= 500;

-- Retrieve all customers with a score less than 500
SELECT *
FROM customers
WHERE score < 500;

-- Retrieve all customers with a score of 500 or less
SELECT *
FROM customers
WHERE score <= 500;

/* ============================================================================
   SECTION 2: LOGICAL OPERATORS
   ============================================================================ */

/* Retrieve all customers who are from the USA
   AND have a score greater than 500 */
SELECT *
FROM customers
WHERE country = 'USA' AND score > 500;

/* Retrieve all customers who are either from the USA
   OR have a score greater than 500 */
SELECT *
FROM customers
WHERE country = 'USA' OR score > 500;

-- Retrieve all customers with a score NOT less than 500
SELECT *
FROM customers
WHERE NOT score < 500;