/* ============================================================================
   File: 04_anti_joins_cross_joins.sql
   Author: Youssef Hany
   Description: Advanced SQL queries demonstrating Anti-Joins and Cross Joins.
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: ANTI-JOINS & CROSS JOINS
   ============================================================================ */

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