/* ============================================================================
   File: 04_handling_nulls_coalesce_isnull.sql
   Author: Youssef Hany
   Description: Comprehensive SQL queries demonstrating Conversion and NULL handling.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: DATA TYPE CONVERSIONS (CAST & CONVERT)
   ============================================================================ */

-- CONVERT
SELECT
    CONVERT(INT, '123') AS [String to Int CONVERT],
    CONVERT(DATE, '2005-11-06') AS [String to Date CONVERT];

SELECT
    CreationTime,
    CONVERT(DATE, CreationTime) AS [Datetime to Date CONVERT],
    CONVERT(VARCHAR, CreationTime, 32) AS [USA Std. Style:32],
    CONVERT(VARCHAR, CreationTime, 34) AS [EURO Std. Style:34]
FROM Sales.Orders;

-- CAST
SELECT
    CAST('123' AS INT) AS [String to Int CAST],
    CAST(123 AS VARCHAR) AS [Int to String CAST],
    CAST('2005-11-06' AS DATE) AS [String to Date CAST],
    CAST('2005-11-06' AS DATETIME2) AS [String to Datetime CAST];

SELECT
    CreationTime,
    CAST(CreationTime AS DATE) AS [Datetime to Date CAST]
FROM Sales.Orders;

/* ============================================================================
   SECTION 2: NULL HANDLING
   ============================================================================ */

-- ISNULL | COALESCE
-- Find the average scores of the customers
SELECT 
    CustomerID,
    Score,
    COALESCE(Score, 0) AS Score2,
    AVG(Score) OVER () AS AvgScores,
    AVG(COALESCE(Score, 0)) OVER () AS CorrectAvgScores
FROM Sales.Customers;

/* Display the full name of customers in a single field
   by merging their first and last names,
   and add 10 bonus points to each customer's score. */
SELECT
    CustomerID,
    FirstName,
    LastName,
    FirstName + ' ' + LastName AS FullName1,
    FirstName + ' ' + COALESCE(LastName, '') AS FullName2,
    Score,
    Score + 10 AS NewScore1,
    COALESCE(Score, 0) + 10 AS NewScore2
FROM Sales.Customers;

/* Sort the customers from the lowest to highest scores,
   with nulls appearing last */
SELECT
    CustomerID,
    Score
FROM Sales.Customers
ORDER BY 
    CASE WHEN Score IS NULL THEN 1 ELSE 0 END ASC,
    Score ASC;

-- NULLIF
/* Find the sale price for each order by dividing
   the sales by the quantity */
SELECT
    OrderID,
    Sales,
    Quantity,
    Sales / NULLIF(Quantity, 0) AS SalePrice
FROM Sales.Orders;

-- IS NULL | IS NOT NULL
-- Identify the customers who have no scores
SELECT
    CustomerID,
    FirstName,
    Score
FROM Sales.Customers
WHERE Score IS NULL;

-- List all customers who have scores
SELECT
    CustomerID,
    FirstName,
    Score
FROM Sales.Customers
WHERE Score IS NOT NULL;

-- List all details for customers who have not placed any orders
SELECT
    c.*,
    o.OrderID
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

-- NULL vs Empty String vs Blank Space
WITH Orders AS (
    SELECT 1 Id, 'A' Catery UNION
    SELECT 2, NULL UNION
    SELECT 3, '' UNION
    SELECT 4, ' '
)
SELECT
    *,
    DATALENGTH(Catery) CateryLen,
    TRIM(Catery) Policy1,
    DATALENGTH(TRIM(Catery)) PolicyLen1,
    NULLIF(TRIM(Catery),'') Policy2,
    COALESCE(NULLIF(TRIM(Catery),''),'unknown') Policy3
FROM Orders;