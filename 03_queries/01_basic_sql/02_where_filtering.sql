/* ============================================================================
   File: 02_where_filtering.sql
   Author: Youssef Hany
   Description: Foundational SQL SELECT queries covering basic filtering.
   Database: MyDatabase
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: FILTERING DATA (WHERE CLAUSE)
   ============================================================================ */

-- Retrieve customers with a score not equal to 0
SELECT *
FROM dbo.customers
WHERE score != 0;

-- Retrieve customers from Germany
SELECT *
FROM dbo.customers
WHERE country = 'Germany';

-- Retrieve each customer's name and country for customers from Germany
SELECT
    first_name,
    country
FROM dbo.customers
WHERE country = 'Germany';