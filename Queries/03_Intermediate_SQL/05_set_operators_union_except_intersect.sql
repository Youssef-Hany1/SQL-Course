/* ============================================================================
   File: 05_set_operators_union_except_intersect.sql
   Author: Youssef Hany
   Description: Advanced SQL queries demonstrating SET Operators (UNION, 
                UNION ALL, EXCEPT, INTERSECT).
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 4: SQL SET OPERATORS
   ============================================================================ */

/* Combine the data from employees
   and customers into one table (Removes Duplicates) */
SELECT
    FirstName,
    LastName
FROM Sales.Customers
UNION
SELECT
    FirstName,
    LastName
FROM Sales.Employees;

/* Combine the data from employees and customers
   into one table, including duplicates */
SELECT
    FirstName,
    LastName
FROM Sales.Customers
UNION ALL
SELECT
    FirstName,
    LastName
FROM Sales.Employees;

/* Find employees who are not customers at the same time */
SELECT
    FirstName,
    LastName
FROM Sales.Employees
EXCEPT
SELECT
    FirstName,
    LastName
FROM Sales.Customers;

/* Find employees who are also customers */
SELECT
    FirstName,
    LastName
FROM Sales.Customers
INTERSECT
SELECT
    FirstName,
    LastName
FROM Sales.Employees;

/* Orders are stored in seperate tables (Orders and OrdersArchive)
   Combine all orders into one report without duplicates */
SELECT
    'Orders' AS SourceTable
    ,[OrderID]
    ,[ProductID]
    ,[CustomerID]
    ,[SalesPersonID]
    ,[OrderDate]
    ,[ShipDate]
    ,[OrderStatus]
    ,[ShipAddress]
    ,[BillAddress]
    ,[Quantity]
    ,[Sales]
    ,[CreationTime]
FROM Sales.Orders
UNION
SELECT
    'OrdersArchive' AS SourceTable
    ,[OrderID]
    ,[ProductID]
    ,[CustomerID]
    ,[SalesPersonID]
    ,[OrderDate]
    ,[ShipDate]
    ,[OrderStatus]
    ,[ShipAddress]
    ,[BillAddress]
    ,[Quantity]
    ,[Sales]
    ,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID ASC;