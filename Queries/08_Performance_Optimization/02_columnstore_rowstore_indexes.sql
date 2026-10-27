/* ============================================================================
   File: 02_columnstore_rowstore_indexes.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Performance Optimization 
                using Columnstore and Rowstore Indexes.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: PERFORMANCE OPTIMIZATION (COLUMNSTORE & ROWSTORE INDEXES)
   ============================================================================ */

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers;

-- Clustered Columnstore Index
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers;

DROP INDEX idx_DBCustomers_CS ON Sales.DBCustomers;

-- Non-Clustered Columnstore Index
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers (FirstName);

-- Comparison
USE AdventureWorksDW2022;

-- HEAP
SELECT *
INTO FactInternetSales_HP
FROM FactInternetSales;

-- ROWSTORE
SELECT *
INTO FactInternetSales_RS
FROM FactInternetSales;

CREATE CLUSTERED INDEX idx_FactInternetSales_RS_PK
ON FactInternetSales_RS (SalesOrderNumber, SalesOrderLineNumber);

-- COLUMNSTORE
SELECT *
INTO FactInternetSales_CS
FROM FactInternetSales;

CREATE CLUSTERED COLUMNSTORE INDEX idx_FactInternetSales_CS
ON FactInternetSales_CS;