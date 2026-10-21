/* ============================================================================
   File: 01_window_functions_aggregations.sql
   Author: Youssef Hany
   Description: Comprehensive SQL queries demonstrating advanced Window Functions
                (Aggregate).
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: WINDOW FUNCTIONS OVERVIEW (PARTITION BY & ORDER BY)
   ============================================================================ */

-- Find the total sales across all orders
SELECT
    SUM(Sales) TotalSales
FROM Sales.Orders;

-- Find the total sales for each product
SELECT
    ProductID,
    SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID;

/* Find the total sales across all orders, additionally 
   provide details such order id & order date */
SELECT
    OrderID,
    OrderDate,
    SUM(Sales) OVER() TotalSales
FROM Sales.Orders;

/* Find the total sales for each product, additionally 
   provide details such order id & order date */
SELECT
    OrderID,
    OrderDate,
    ProductID,
    SUM(Sales) OVER(PARTITION BY ProductID) SalesByProducts
FROM Sales.Orders;

/* Find the total sales for each combination of product
   and order status */
SELECT
    ProductID,
    OrderStatus,
    SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) SalesByProductsAndStatus
FROM Sales.Orders;

/* Find the total sales across all orders, for each product
   and for each combination of product and order status, 
   additionally provide details such order id & order date */
SELECT
    OrderID,
    OrderDate,
    ProductID,
    OrderStatus,
    Sales,
    SUM(Sales) OVER() TotalSales,
    SUM(Sales) OVER(PARTITION BY ProductID) SalesByProducts,
    SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) SalesByProductsAndStatus
FROM Sales.Orders;

/* Rank each order based on their sales from highest to
   lowest, additionally provide details such order id
   & order date */
SELECT
    OrderID,
    OrderDate,
    Sales,
    RANK() OVER(ORDER BY Sales DESC) RankSales
FROM Sales.Orders;

-- Frame Clause Analysis
SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
    ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales1,
    SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
    ROWS 2 PRECEDING) TotalSales2
FROM Sales.Orders;

/* Find the total sales for each order status,
   only for two products 101 and 102 */
SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    ProductID,
    Sales,
    SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN (101,102);

-- Rank the customers based on their total sales
SELECT
    CustomerID,
    SUM(Sales) TotalSales,
    RANK() OVER (ORDER BY SUM(Sales) DESC) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID;

/* ============================================================================
   SECTION 2: WINDOW AGGREGATE FUNCTIONS (COUNT, SUM, AVG, MIN/MAX)
   ============================================================================ */

-- Find the total number of orders
SELECT
    COUNT(*) TotalNrOfOrders
FROM Sales.Orders;

/* Find the total number of orders,
   additionally provide details such order id & order date */
SELECT
    OrderID,
    OrderDate,
    COUNT(*) OVER() TotalNrOfOrders
FROM Sales.Orders;

/* Find the total number of orders for each cutomer,
   and additionally provide details such order id & order date */
SELECT
    OrderID,
    OrderDate,
    CustomerID,
    COUNT(*) OVER (PARTITION BY CustomerID) OrdersByCustomers
FROM Sales.Orders;

/* Find the total number of cutomers,
   find the total number of scores for the cutomers,
   and additionally provide all customer's details */
SELECT
    CustomerID,
    FirstName,
    LastName,
    Country,
    Score,
    COUNT(*) OVER () TotalNrOfCustomers,
    COUNT(Score) OVER () TotalNrOfScores
FROM Sales.Customers;

-- Check whether the table 'Orders' contains any duplicate row
SELECT
    OrderID,
    COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.Orders;

-- Check whether the table 'OrdersArchive' contains any duplicate row
SELECT *
FROM (
    SELECT
        OrderID,
        COUNT(*) OVER (PARTITION BY OrderID) CheckPK
    FROM Sales.OrdersArchive
) t
WHERE CheckPK > 1;

/* Find the total sales across all orders,
   find the total sales for each product,
   and additionally provide details such order id & order date */
SELECT
    OrderID,
    OrderDate,
    Sales,
    ProductID,
    SUM(Sales) OVER () TotalSales,
    SUM(Sales) OVER (PARTITION BY ProductID) SalesByProducts
FROM Sales.Orders;

/* Find the percentage contribution of each product's
   sales to the total sales */
SELECT
    OrderID,
    Sales,
    ProductID,
    SUM(Sales) OVER () TotalSales,
    SUM(Sales) OVER (PARTITION BY ProductID) SalesByProducts,
    ROUND((CAST(SUM(Sales) OVER (PARTITION BY ProductID) AS FLOAT) / SUM(Sales) OVER ()) * 100,2) PercentageOfTotal
FROM Sales.Orders;

/* Find the average sales across all orders,
   find the average sales for each product,
   and additionally provide details such order id & order date */
SELECT
    OrderID,
    OrderDate,
    Sales,
    ProductID,
    AVG(COALESCE(Sales,0)) OVER () AvgSales,
    AVG(COALESCE(Sales,0)) OVER (PARTITION BY ProductID) AvgSalesByProducts
FROM Sales.Orders;

/* Find the average scores of customers,
   and additionally provide details such customer id & last name */
SELECT
    CustomerID,
    LastName,
    Score,
    COALESCE(Score,0) UpdatedScore,
    AVG(Score) OVER () AvgScore,
    AVG(COALESCE(Score,0)) OVER () AvgScoreWithoutNulls
FROM Sales.Customers;

/* Find all orders where sales are higher than the average 
   sales across all orders */
SELECT *
FROM (
    SELECT
        OrderID,
        ProductID,
        Sales,
        AVG(COALESCE(Sales,0)) OVER () AvgSales
    FROM Sales.Orders
) t
WHERE Sales > AvgSales;

/* Find the highest & lowest sales across all orders,
   find the highest & lowest sales for each product,
   and additionally provide details such order id & order date */
SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MIN(Sales) OVER () LowestSales,
    MAX(Sales) OVER () HighestSales,
    MIN(Sales) OVER (PARTITION BY ProductID) LowestSalesByProducts,
    MAX(Sales) OVER (PARTITION BY ProductID) HighestSalesByProducts
FROM Sales.Orders;

-- Show the employees who have the highest salaries
SELECT *
FROM (
    SELECT
        *,
        MAX(Salary) OVER () HighestSalary
    FROM Sales.Employees
) t 
WHERE Salary = HighestSalary;

/* Find the deviation of each sale from both the minimum
   and maximum sales amount */
SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MIN(Sales) OVER () LowestSales,
    MAX(Sales) OVER () HighestSales,
    Sales - MIN(Sales) OVER () DeviationFromMin,
    MAX(Sales) OVER () - Sales DeviationFromMax
FROM Sales.Orders;

-- Calculate moving average of sales for each product over time
SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProduct,
    AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvgSalesByProduct
FROM Sales.Orders;

/* Calculate moving average of sales for each product
   over time, including only the next order */
SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProduct,
    AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate
    ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) MovingAvgSalesByProduct
FROM Sales.Orders;