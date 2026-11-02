/* ============================================================================
   File: 01_aggregate_functions.sql
   Author: Youssef Hany
   Description: Comprehensive SQL queries demonstrating standard aggregations.
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: BASIC AGGREGATE FUNCTIONS
   ============================================================================ */

-- Find the total number of orders
SELECT
    COUNT(*) TotalNrOfOrders
FROM dbo.orders;

-- Find the total sales of all orders
SELECT
    SUM(sales) TotalSales
FROM dbo.orders;

-- Find the average sales of all orders
SELECT
    AVG(sales) AvgSales
FROM dbo.orders;

-- Find the highest sales of all orders
SELECT
    MAX(sales) HighestSales
FROM dbo.orders;

-- Find the lowest sales of all orders
SELECT
    MIN(sales) LowestSales
FROM dbo.orders;

-- Group all aggregate functions by customer
SELECT
    customer_id,
    COUNT(*) TotalNrOfOrders,
    SUM(sales) TotalSales,
    AVG(sales) AvgSales,
    MAX(sales) HighestSales,
    MIN(sales) LowestSales
FROM dbo.orders
GROUP BY customer_id;

-- Analyze the scores in customers table
SELECT
    country,
    COUNT(*) TotalNrOfCustomers,
    SUM(score) TotalScores,
    AVG(score) AvgScores,
    MAX(score) HighestScore,
    MIN(score) LowestScore
FROM dbo.customers
GROUP BY country;