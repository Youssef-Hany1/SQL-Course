/* ============================================================================
   File: 03_order_by_sorting.sql
   Author: Youssef Hany
   Description: Foundational SQL SELECT queries covering basic sorting.
   Database: MyDatabase
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: SORTING DATA (ORDER BY CLAUSE)
   ============================================================================ */

-- Retrieve all customers and sort the results by the highest score first
SELECT *
FROM dbo.customers
ORDER BY score DESC;

-- Retrieve all customers and sort the results by the lowest score first
SELECT *
FROM dbo.customers
ORDER BY score ASC;

-- Retrieve all customers and sort the results by the country and then by the highest score
SELECT *
FROM dbo.customers
ORDER BY 
    country ASC,
    score DESC;