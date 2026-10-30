/* ============================================================================
   File: 05_execution_plans.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Performance Optimization 
                through Execution Plans and SQL Hints.
   ============================================================================ */

/* ============================================================================
   SECTION 1: PERFORMANCE OPTIMIZATION (EXECUTION PLANS & HINTS)
   ============================================================================ */

USE AdventureWorksDW2022;

SELECT *
INTO dbo.FactResellerSales_HP
FROM dbo.FactResellerSales;

-- Table Scan
SELECT *
FROM dbo.FactResellerSales_HP;

-- Index Scan
SELECT *
FROM dbo.FactResellerSales;

-- Heap vs Clustered Index
SELECT *
FROM dbo.FactResellerSales_HP
ORDER BY SalesOrderNumber;

SELECT *
FROM dbo.FactResellerSales
ORDER BY SalesOrderNumber;

-- Heap vs Non-Clustered Index (Index Seek)
SELECT *
FROM dbo.FactResellerSales_HP
WHERE CarrierTrackingNumber = '4911-403C-98';

CREATE NONCLUSTERED INDEX idx_FactResellerSales_CTA
ON dbo.FactResellerSales (CarrierTrackingNumber);

SELECT *
FROM dbo.FactResellerSales
WHERE CarrierTrackingNumber = '4911-403C-98';

-- Rowstore vs Columnstore
SELECT
	p.EnglishProductName AS ProductName,
	SUM(s.SalesAmount) AS TotalSales
FROM dbo.FactResellerSales s
JOIN DimProduct p
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName;

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactResellerSalesHP
ON dbo.FactResellerSales_HP;

SELECT
	p.EnglishProductName AS ProductName,
	SUM(s.SalesAmount) AS TotalSales
FROM dbo.FactResellerSales_HP s
JOIN DimProduct p
ON p.ProductKey = s.ProductKey
GROUP BY p.EnglishProductName;

-- SQL Hints

USE SalesDB;

SELECT
	o.Sales,
	c.Country
FROM Sales.Orders o -- WITH (INDEX([PK_orders]))
LEFT JOIN Sales.Customers c -- WITH (FORCESEEK)
ON o.CustomerID = c.CustomerID
-- OPTION (HASH JOIN)
;