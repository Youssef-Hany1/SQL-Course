/* ============================================================================
   File: 01_clustered_nonclustered_indexes.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Performance Optimization 
                using Clustered, Non-Clustered, and Composite Indexes.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: PERFORMANCE OPTIMIZATION (INDEXES)
   ============================================================================ */

-- Setup Test Table
SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers;

-- Clustered Index
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID);

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers;

-- Non-Clustered Index
SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown';

CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName);

CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName);

-- Composite Index
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500;

CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score);

-- Leftmost Prefix Rule
-- Will Use Index
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA';

-- Won't Use Index
SELECT *
FROM Sales.DBCustomers
WHERE Score > 500;