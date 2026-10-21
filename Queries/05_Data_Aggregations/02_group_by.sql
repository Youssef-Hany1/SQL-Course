/* ============================================================================
   File: 02_group_by.sql
   Author: Youssef Hany
   Description: Foundational SQL queries covering Aggregation & Grouping.
   Database: MyDatabase
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: AGGREGATION & GROUPING (GROUP BY CLAUSE)
   ============================================================================ */

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