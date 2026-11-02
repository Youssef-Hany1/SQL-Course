/* ============================================================================
   File: 02_window_functions_ranking.sql
   Author: Youssef Hany
   Description: Comprehensive SQL queries demonstrating advanced Window Functions
                (Ranking).
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: WINDOW RANKING FUNCTIONS
   ============================================================================ */

-- Rank the orders based on their sales from highest to lowest by using ROW_NUMBER
SELECT
    OrderID,
    ProductID,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_RowNumber
FROM Sales.Orders;

-- Rank the orders based on their sales from highest to lowest by using RANK
SELECT
    OrderID,
    ProductID,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) SalesRank_Rank
FROM Sales.Orders;

-- Rank the orders based on their sales from highest to lowest by using DENSE_RANK
SELECT
    OrderID,
    ProductID,
    Sales,
    DENSE_RANK() OVER (ORDER BY Sales DESC) SalesRank_DenseRank
FROM Sales.Orders;

-- ROW_NUMBER vs RANK vs DENSE_RANK
SELECT
    OrderID,
    ProductID,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_RowNumber,
    RANK()       OVER (ORDER BY Sales DESC) SalesRank_Rank,
    DENSE_RANK() OVER (ORDER BY Sales DESC) SalesRank_DenseRank
FROM Sales.Orders;

-- TOP-N ANALYSIS: Find the top highest sales for each product
SELECT *
FROM (
    SELECT
        OrderID,
        ProductID,
        Sales,
        ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Sales DESC) SalesRank
    FROM Sales.Orders
) t 
WHERE SalesRank = 1;

-- BOTTOM-N ANALYSIS: Find the lowest 2 customers based on their total sales
SELECT *
FROM (
    SELECT
        CustomerID,
        SUM(Sales) TotalSales,
        ROW_NUMBER() OVER (ORDER BY SUM(Sales)) RankCustomers
    FROM Sales.Orders
    GROUP BY CustomerID
) t 
WHERE RankCustomers <= 2;

-- GENERATE UNIQUE IDS: Assign unique IDs to the rows of the 'OrdersArchive' table
SELECT
    ROW_NUMBER() OVER (ORDER BY OrderDate) NewOrderID, 
    *
FROM Sales.OrdersArchive;

/* IDENTIFY DUPLICATES: Identify duplicate rows in the table 'OrdersArchive'
   and return a clean result without any duplicates */
SELECT *
FROM (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY OrderID
        ORDER BY CreationTime DESC) DuplicateOrder, 
        *
    FROM Sales.OrdersArchive
) t
WHERE DuplicateOrder = 1;

-- NTILE
SELECT
    OrderID,
    Sales,
    NTILE(1) OVER (ORDER BY Sales DESC) OneBucket,
    NTILE(2) OVER (ORDER BY Sales DESC) TwoBuckets,
    NTILE(3) OVER (ORDER BY Sales DESC) ThreeBuckets,
    NTILE(4) OVER (ORDER BY Sales DESC) FourBuckets
FROM Sales.Orders;

-- DATA SEGMENTATION: Segment all orders into 3 cateries: high, medium and low sales
SELECT
    OrderID,
    Sales,
    CASE (NTILE(3) OVER (ORDER BY Sales DESC)) 
        WHEN 1 THEN 'High'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'Low'
    END SalesSegmentation
FROM Sales.Orders;

-- EQUALIZING LOAD: In order to export the data, divide the orders into 2 groups
SELECT
    NTILE(2) OVER (ORDER BY OrderID) GroupID,
    *
FROM Sales.Orders;

-- CUME_DIST: Find the products that fall within the highest 40% of the prices
SELECT
    *,
    CONCAT(DistRank * 100,'%') DistRankPerc
FROM (
    SELECT
        Product,
        Price,
        CUME_DIST() OVER (ORDER BY Price DESC) DistRank
    FROM Sales.Products
) t
WHERE DistRank <= 0.4;

-- PERCENT_RANK: Find the products that fall within the highest 40% of the prices
SELECT
    *,
    CONCAT(PercentRank * 100,'%') PercentRankPerc
FROM (
    SELECT
        Product,
        Price,
        PERCENT_RANK() OVER (ORDER BY Price DESC) PercentRank
    FROM Sales.Products
) t
WHERE PercentRank <= 0.4;