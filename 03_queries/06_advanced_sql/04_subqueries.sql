/* ============================================================================
   File: 04_subqueries.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Subqueries (Scalar, Row, Table, 
                Correlated).
   ============================================================================ */

USE SalesDB;

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