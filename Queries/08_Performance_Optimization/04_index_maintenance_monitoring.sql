/* ============================================================================
   File: 04_index_maintenance_monitoring.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Performance Optimization 
                through Index Maintenance and Monitoring.
   ============================================================================ */

/* ============================================================================
   SECTION 1: PERFORMANCE OPTIMIZATION (INDEX MAINTENANCE & MONITORING)
   ============================================================================ */

-- 1. Monitor Index Usage

USE SalesDB;
-- Quick view of indexes on a specific table
sp_helpindex 'Sales.DBCustomers';

-- Detailed index usage statistics (identifying unused indexes)
SELECT
	tbl.name AS TableName,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	idx.is_primary_key AS IsPrimaryKey,
	idx.is_unique AS IsUnique,
	idx.is_disabled AS IsDisabled,
	s.user_seeks AS UserSeeks,
	s.user_scans AS UserScans,
	s.user_lookups AS UserLookups,
	s.user_updates AS UserUpdates,
	COALESCE(s.last_user_seek,s.last_user_scan) AS LastUpdate
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON idx.object_id = s.object_id AND idx.index_id = s.index_id
ORDER BY tbl.name, idx.name;

SELECT * FROM sys.dm_db_index_usage_stats;

SELECT * FROM sys.tables;

-- 2. Monitor Missing Indexes

USE AdventureWorksDW2022;
SELECT
	fs.SalesOrderNumber,
	dp.EnglishProductName,
	dp.Color
FROM FactInternetSales fs
INNER JOIN DimProduct dp
ON fs.ProductKey = dp.ProductKey
WHERE dp.Color = 'Black'
AND fs.OrderDateKey BETWEEN 20101229 AND 20101231;

-- Check database recommendations for missing indexes
SELECT * FROM sys.dm_db_missing_index_details;

-- 3. Monitor Duplicate Indexes

USE SalesDB;
-- Identify columns involved in multiple indexes
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    i.name AS IndexName,
	i.type_desc AS IndexType,
    COUNT(*) OVER (PARTITION BY t.name, c.name) AS DuplicateFlag
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
ORDER BY t.name, c.name;

-- 4. Update Statistics

USE SalesDB;
-- Monitor statistics to see if they are outdated
SELECT
	SCHEMA_NAME(t.schema_id) AS SchemaName,
    t.name AS TableName,
    s.name AS StatisticsName,
    sp.last_updated AS LastUpdated,
	DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdatedDay,
    sp.rows AS TotalRows,
    sp.modification_counter AS ModificationsSinceLastUpdate
FROM sys.stats s
JOIN sys.tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) sp
ORDER BY sp.modification_counter DESC;

-- Update specific statistics for a table
UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000003_14270015;

-- Update all statistics for a specific table
UPDATE STATISTICS Sales.DBCustomers;

-- Update all statistics for the entire database (use with caution on large DBs)
EXEC sp_updatestats;

-- 5. Monitor Fragmentations

-- Check index fragmentation levels
SELECT 
    t.name AS TableName,
    i.name AS IndexName,
    ips.avg_fragmentation_in_percent AS AvgFragmentation,
	ips.page_count AS PageCount
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
INNER JOIN sys.tables t
ON ips.object_id = t.object_id
INNER JOIN sys.indexes i 
ON ips.object_id = i.object_id AND ips.index_id = i.index_id
ORDER BY ips.avg_fragmentation_in_percent DESC;

-- Reorganize Index (Lightweight)
ALTER INDEX idx_Customers_Country ON Sales.Customers REORGANIZE;

-- Rebuild Index (Heavyweight)
ALTER INDEX idx_Products_UN_Product ON Sales.Products REBUILD;