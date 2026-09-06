USE MyDatabase;

-- SQL JOINs

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

/* Get all customers who haven't place any order */

SELECT 
	c.id,
	c.first_name
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL;

/* Get all orders without matching customers */

SELECT 
	o.order_id,
	o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL;

/* Get all orders without matching customers 
   (using LEFT JOIN) */

SELECT 
	o.order_id,
	o.sales
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id
WHERE c.id IS NULL;

/* Find customers without orders
   and orders without customers */

SELECT *
FROM orders AS o
FULL JOIN customers AS c
ON c.id = o.customer_id
WHERE o.customer_id IS NULL OR c.id IS NULL;

/* Get all customers along with their orders,
   but only for customers who have placed an order
   (Without using INNER JOIN) */

SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;

/* Generate all possible combinations of customers and orders */

SELECT *
FROM customers
CROSS JOIN orders;

/* Using SalesDB, Retrieve a list of all orders,
   along with the related customer, product,
   and employee details.
   For each order, display: Order ID, Customer's name,
							Product name, Sales amount,
							Product price, Salesperson's name */

USE SalesDB;

SELECT *
FROM Sales.Orders;

SELECT *
FROM Sales.Customers;

SELECT *
FROM Sales.Products;

SELECT *
FROM Sales.Employees;

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

-- SQL SET Operators

USE SalesDB;

/* Combine the data from employees
   and customers into one table */

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