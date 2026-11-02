/* ============================================================================
   File: 01_views.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Views.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: VIEWS
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