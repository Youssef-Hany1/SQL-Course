/* ============================================================================
   File: 03_sql_joins_inner_left_right_full.sql
   Author: Youssef Hany
   Description: Advanced SQL queries demonstrating data combining techniques 
                including JOINs (INNER, LEFT, RIGHT, FULL) and Multi-Table.
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: SQL JOINS
   ============================================================================ */

/* Retrieve all data from customers
   and orders as seperate results */
SELECT * 
FROM customers;

SELECT * 
FROM orders;

/* Get all customers along with their orders,
   but only for customers who have placed an order */
SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id;

/* Get all customers along with their orders,
   including those without orders */
SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id;

/* Get all customers along with their orders,
   including orders without matching customers */
SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id;

/* Get all customers along with their orders,
   including orders without matching customers 
   (using LEFT JOIN) */
SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id;

/* Get all customers and all orders,
   even if there's no match */
SELECT 
    c.id,
    c.first_name,
    o.order_id,
    o.sales
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id;

/* ============================================================================
   SECTION 2: MULTI-TABLE JOINS (SalesDB)
   ============================================================================ */

USE SalesDB;

-- Retrieve raw data from individual tables
SELECT * FROM Sales.Orders;
SELECT * FROM Sales.Customers;
SELECT * FROM Sales.Products;
SELECT * FROM Sales.Employees;

/* Using SalesDB, Retrieve a list of all orders,
   along with the related customer, product,
   and employee details.
   For each order, display: Order ID, Customer's name,
                            Product name, Sales amount,
                            Product price, Salesperson's name */

USE SalesDB;

SELECT 
    o.OrderID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    p.Product AS ProductName,
    o.Sales,
    p.Price,
    CONCAT(e.FirstName, ' ', e.LastName) AS SalesPersonName
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID;