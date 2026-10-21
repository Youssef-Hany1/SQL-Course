/* ============================================================================
   File: 04_top_distinct.sql
   Author: Youssef Hany
   Description: Foundational SQL SELECT queries covering distinct values and limiting result sets.
   Database: MyDatabase
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: DISTINCT VALUES
   ============================================================================ */

-- Return unique list of all countries
SELECT DISTINCT country
FROM dbo.customers;

/* ============================================================================
   SECTION 2: LIMITING RESULTS (TOP CLAUSE)
   ============================================================================ */

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