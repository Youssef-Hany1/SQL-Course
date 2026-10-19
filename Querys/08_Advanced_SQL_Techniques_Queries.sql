/* ============================================================================
   File: 08_Advanced_SQL_Techniques_Queries.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Subqueries (Scalar, Row, Table, 
                Correlated), Common Table Expressions (Recursive & Non-Recursive), 
                Views, CTAS and Temporary Tables.
   ============================================================================ */

/* ============================================================================
   SECTION 1: DATABASE STRUCTURE & SYSTEM CATALOG
   ============================================================================ */

-- USER DATA STORGAE
SELECT *
FROM Sales.Orders;

-- SYSTEM CATALOG
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS;

SELECT DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS;

/* ============================================================================
   SECTION 2: SUBQUERIES (TYPES)
   ============================================================================ */

-- 1) Scalar Subquery
SELECT AVG(Sales) AvgSales
FROM Sales.Orders;

-- 2) Row Subquery
SELECT OrderID
FROM Sales.Orders;

-- 3) Table Subquery
SELECT *
FROM Sales.Orders;

/* ============================================================================
   SECTION 3: SUBQUERIES (LOCATIONS & CLAUSES)
   ============================================================================ */

-- 1) FROM Clause
/* Find the products that have a price higher than
   the average price of all products */
-- Main Query
SELECT *
FROM (
    -- Subquery
    SELECT
        ProductID,
        Price,
        AVG(Price) OVER () AvgPrice
    FROM Sales.Products
) t
WHERE Price > AvgPrice;

-- Rank customers based on their total amount of sales
-- Main Query
SELECT
    RANK() OVER (ORDER BY TotalSales DESC) CustomerRank,
    *
FROM (
    -- Subquery
    SELECT
        CustomerID,
        SUM(Sales) TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) t;

-- 2) SELECT Clause
-- Show the product IDs, names, prices and total number of orders
-- Main Query
SELECT
    ProductID,
    Product,
    Price,
    -- Subquery
    (SELECT COUNT(*) FROM Sales.Orders) TotalOrders
FROM Sales.Products;

-- 3) JOIN Clause
-- Show all customer details and find the total orders for each customer
-- Main Query
SELECT
    c.*,
    o.TotalOrdersByCustomer
FROM Sales.Customers c
LEFT JOIN (
    -- Subquery
    SELECT
        CustomerID,
        COUNT(*) TotalOrdersByCustomer
    FROM Sales.Orders
    GROUP BY CustomerID
) o
ON c.CustomerID = o.CustomerID;

-- 4) WHERE Clause (Comparison Operators)
/* Find the products that have a price higher than
   the average price of all products */
-- Main Query
SELECT
    ProductID,
    Price,
    (SELECT AVG(Price) FROM Sales.Products) AvgPrice
    FROM Sales.Products
-- Subquery
WHERE Price > (SELECT AVG(Price) FROM Sales.Products);

/* ============================================================================
   SECTION 4: SUBQUERIES (LOGICAL OPERATORS)
   ============================================================================ */

-- 1) IN | NOT IN Operator
-- Show the details of orders made by customers in Germany
-- Main Query
SELECT
    OrderID,
    OrderDate,
    CustomerID
FROM Sales.Orders
-- Subquery
WHERE CustomerID IN (SELECT CustomerID
                     FROM Sales.Customers
                     WHERE Country = 'Germany');

-- 2) ANY | ALL Operator
/* Find female employees whose salaries are greater than
   the salaries of any male employees */
-- Main Query
SELECT
    EmployeeID,
    FirstName,
    Gender,
    Salary
FROM Sales.Employees
-- Subquery
WHERE Gender = 'F' AND
Salary > ANY (SELECT Salary
              FROM Sales.Employees
              WHERE Gender = 'M');

/* Find female employees whose salaries are greater than
   the salaries of all male employees */
-- Main Query
SELECT
    EmployeeID,
    FirstName,
    Gender,
    Salary
FROM Sales.Employees
-- Subquery
WHERE Gender = 'F' AND
Salary > ALL (SELECT Salary
              FROM Sales.Employees
              WHERE Gender = 'M');

-- 3) EXISTS | NOT EXISTS Operator
-- Show the details of orders made by customers in Germany
-- Main Query
SELECT
    OrderID,
    OrderDate,
    CustomerID
FROM Sales.Orders o
-- Subquery
WHERE EXISTS (SELECT 1
              FROM Sales.Customers c 
              WHERE c.Country = 'Germany' AND 
              c.CustomerID = o.CustomerID);

/* ============================================================================
   SECTION 5: CORRELATED SUBQUERIES
   ============================================================================ */

-- Show all customer details and find the total orders for each customer
SELECT
    *,
    (SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalOrders
FROM Sales.Customers c;

/* ============================================================================
   SECTION 6: COMMON TABLE EXPRESSIONS (CTE)
   ============================================================================ */

-- 1) Non-Recursive CTE (Standalone CTE)
-- Find the total sales and last order date per customer
-- Step1: Find the total sales per customer
WITH CTE_TotalSales AS 
(
    SELECT CustomerID, SUM(Sales) TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)
-- Step2: Find the last order date for each customer
,CTE_LastOrder AS 
(
    SELECT CustomerID, MAX(OrderDate) LastOrderDate
    FROM Sales.Orders
    GROUP BY CustomerID
)
-- Main Query
SELECT
    c.CustomerID,
    c.FirstName,
    cts.TotalSales,
    clo.LastOrderDate
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cts ON c.CustomerID = cts.CustomerID
LEFT JOIN CTE_LastOrder clo ON c.CustomerID = clo.CustomerID;

-- 2) Non-Recursive CTE (Nested CTE)
-- Step1: Find the total sales per customer (Standalone CTE)
WITH CTE_TotalSales AS 
(
    SELECT CustomerID, SUM(Sales) TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)
-- Step2: Find the last order date for each customer (Standalone CTE)
,CTE_LastOrder AS 
(
    SELECT CustomerID, MAX(OrderDate) LastOrderDate
    FROM Sales.Orders
    GROUP BY CustomerID
)
-- Step3: Rank customers based on total sales per customer (Nested CTE)
,CTE_CustomerRank AS
(
    SELECT CustomerID, RANK() OVER (ORDER BY TotalSales DESC) CustomerRank
    FROM CTE_TotalSales
)
-- Step4: Segment customers based on thier total sales (Nested CTE)
,CTE_CustomerSegment AS
(
    SELECT
        CustomerID,
        CASE
            WHEN TotalSales > 100 THEN 'High'
            WHEN TotalSales > 60 THEN 'Medium'
            ELSE 'Low'
        END CustomerSegment
    FROM CTE_TotalSales
)
-- Main Query
SELECT
    c.CustomerID,
    c.FirstName,
    cts.TotalSales,
    clo.LastOrderDate,
    ccr.CustomerRank,
    ccs.CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cts ON c.CustomerID = cts.CustomerID
LEFT JOIN CTE_LastOrder clo ON c.CustomerID = clo.CustomerID
LEFT JOIN CTE_CustomerRank ccr ON c.CustomerID = ccr.CustomerID
LEFT JOIN CTE_CustomerSegment ccs ON c.CustomerID = ccs.CustomerID;

-- 3) Recursive CTE
-- Generate a sequence of numbers from 1 to 20
WITH CTE_SequenceNumbers AS
(
    -- Anchor Query
    SELECT 1 Number
    UNION ALL
    -- Recursive Query
    SELECT Number + 1
    FROM CTE_SequenceNumbers 
    WHERE Number < 20
)
-- Main Query
SELECT Number
FROM CTE_SequenceNumbers
OPTION (MAXRECURSION 100);

/* Show the employee hierarchy by displaying each employee's
   level within the organization */
WITH CTE_EmployeeHierarchy AS
(
    -- Anchor Query
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL
    UNION ALL
    -- Recursive Query
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        ceh.Level + 1 Level
    FROM Sales.Employees e
    INNER JOIN CTE_EmployeeHierarchy ceh
    ON e.ManagerID = ceh.EmployeeID
)
-- Main Query
SELECT *
FROM CTE_EmployeeHierarchy;

/* ============================================================================
   SECTION 7: VIEWS
   ============================================================================ */

-- CREATE, DROP, ALTER Views
CREATE VIEW Sales.V_Monthly_Summary AS
(
    SELECT
        DATETRUNC(month, OrderDate) OrderMonth,
        SUM(Sales) TotalSales,
        COUNT(OrderID) TotalOrders,
        SUM(Quantity) TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
);

DROP VIEW V_Monthly_Summary;

IF OBJECT_ID('Sales.V_Monthly_Summary', 'V') IS NOT NULL
    DROP VIEW Sales.V_Monthly_Summary;
GO
CREATE VIEW Sales.V_Monthly_Summary AS
(
    SELECT
        DATETRUNC(month, OrderDate) OrderMonth,
        SUM(Sales) TotalSales,
        COUNT(OrderID) TotalOrders
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
);

SELECT *
FROM Sales.V_Monthly_Summary;

-- Finding the running total of sales for each month using CTE
WITH CTE_Monthly_Summary AS
(
    SELECT
        DATETRUNC(month, OrderDate) OrderMonth,
        SUM(Sales) TotalSales,
        COUNT(OrderID) TotalOrders,
        SUM(Quantity) TotalQuantities
    FROM Sales.Orders
    GROUP BY DATETRUNC(month, OrderDate)
)
SELECT
    OrderMonth,
    SUM(TotalSales) OVER (ORDER BY OrderMonth) RunningTotal,
    TotalSales
FROM CTE_Monthly_Summary;

-- OR using View
SELECT
    OrderMonth,
    SUM(TotalSales) OVER (ORDER BY OrderMonth) RunningTotal,
    TotalSales
FROM Sales.V_Monthly_Summary;

/* Hide Complexity: Provide a view that combines details from
   orders, products, consumers, and employees */
CREATE VIEW Sales.V_Order_Details AS
(
    SELECT
        o.OrderID,
        o.OrderDate,
        p.Product,
        p.Catery,
        COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') CustomerName,
        c.Country CustomerCountry,
        COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') EmployeeName,
        e.Department,
        o.Sales,
        o.Quantity
    FROM Sales.Orders o
    LEFT JOIN Sales.Products p ON o.ProductID = p.ProductID
    LEFT JOIN Sales.Customers c ON o.CustomerID = c.CustomerID
    LEFT JOIN Sales.Employees e ON o.SalesPersonID = e.EmployeeID
);

SELECT *
FROM Sales.V_Order_Details;

/* Data Security: Provide a view for the EU Sales Team
   that combines details from all tables and excludes
   data related to the USA */
CREATE VIEW Sales.V_Order_Details_EU AS
(
    SELECT
        o.OrderID,
        o.OrderDate,
        p.Product,
        p.Catery,
        COALESCE(c.FirstName,'') + ' ' + COALESCE(c.LastName,'') CustomerName,
        c.Country CustomerCountry,
        COALESCE(e.FirstName,'') + ' ' + COALESCE(e.LastName,'') EmployeeName,
        e.Department,
        o.Sales,
        o.Quantity
    FROM Sales.Orders o
    LEFT JOIN Sales.Products p ON o.ProductID = p.ProductID
    LEFT JOIN Sales.Customers c ON o.CustomerID = c.CustomerID
    LEFT JOIN Sales.Employees e ON o.SalesPersonID = e.EmployeeID
    WHERE c.Country != 'USA'
);

SELECT *
FROM Sales.V_Order_Details_EU;

/* ============================================================================
   SECTION 8: CTAS (Create Table As Select) & TEMP TABLES
   ============================================================================ */

-- CTAS Implementation
SELECT
    DATENAME(month, OrderDate) OrderMonth,
    COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);

SELECT *
FROM Sales.MonthlyOrders;

DROP TABLE Sales.MonthlyOrders;

-- Refresh CTAS
IF OBJECT_ID('Sales.MonthlyOrders', 'U') IS NOT NULL
    DROP TABLE Sales.MonthlyOrders;
GO
SELECT
    DATENAME(month, OrderDate) OrderMonth,
    COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate);

-- Temporary Tables
SELECT *
INTO #Orders
FROM Sales.Orders;

SELECT * FROM #Orders;

DELETE FROM #Orders
WHERE OrderStatus = 'Delivered';

SELECT * FROM #Orders;

SELECT *
INTO Sales.OrdersTemp
FROM #Orders;

SELECT * FROM Sales.OrdersTemp;