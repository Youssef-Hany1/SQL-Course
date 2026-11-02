/* ============================================================================
   File: 02_temporary_tables.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering CTAS and Temporary Tables.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: CTAS (Create Table As Select) & TEMP TABLES
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