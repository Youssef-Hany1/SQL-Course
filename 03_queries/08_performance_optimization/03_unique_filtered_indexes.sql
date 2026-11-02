/* ============================================================================
   File: 03_unique_filtered_indexes.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Performance Optimization 
                using Unique and Filtered Indexes.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: PERFORMANCE OPTIMIZATION (UNIQUE & FILTERED INDEXES)
   ============================================================================ */

-- Unique Index
SELECT * FROM Sales.Products;

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_UN_Product
ON Sales.Products (Product);

INSERT INTO Sales.Products (ProductID,Product)
VALUES (106, 'Bottle');

-- Filterd Index
SELECT * FROM Sales.Customers WHERE Country = 'USA';

CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA';