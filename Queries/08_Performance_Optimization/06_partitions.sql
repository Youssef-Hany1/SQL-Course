/* ============================================================================
   File: 06_partitions.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Performance Optimization 
                through Table Partitioning.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: PERFORMANCE OPTIMIZATION (PARTITIONING)
   ============================================================================ */

-- Step1: Create a partition function
CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31','2024-12-31','2025-12-31');

-- REMOVE
DROP PARTITION FUNCTION PartitionByYear;

-- Query lists all existing partition function
SELECT
	name,
	function_id,
	type,
	type_desc,
	boundary_value_on_right
FROM sys.partition_functions;

-- Step2: Create filegroups
ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

-- REMOVE
ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2023;

-- Query lists all existing filegroups
SELECT
	*
FROM sys.filegroups
WHERE type = 'FG';

-- Step3: Add .ndf files to each filegroup
ALTER DATABASE SalesDB ADD FILE
(
	Name = P_2023,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
	Name = P_2024,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
	Name = P_2025,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
	Name = P_2026,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026;

-- REMOVE
ALTER DATABASE SalesDB REMOVE FILE P_2023;

-- Query lists all existing data files
SELECT
	fg.name AS FilegroupName,
	mf.name AS LogicalFileName,
	mf.physical_name AS PhysicalFilePath,
	mf.size / 128 AS SizeInMB
FROM sys.filegroups fg
JOIN sys.master_files mf
ON fg.data_space_id = mf.data_space_id
WHERE mf.database_id = DB_ID('SalesDB');

-- Step4: Create partition scheme
CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026);

-- REMOVE
DROP PARTITION SCHEME SchemePartitionByYear;

-- Query lists all existing partition schemes
SELECT
	ps.name AS PartitionSchemeName,
	pf.name AS PartitionFunctionName,
	ds.destination_id AS PartitionNumber,
	fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf
ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds
ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg
ON ds.data_space_id = fg.data_space_id;

-- Step5: Create the partitioned table
CREATE TABLE Sales.Orders_Partitioned
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear (OrderDate);

-- Step6: Insert data into the partitioned table
INSERT INTO Sales.Orders_Partitioned VALUES (1, '2023-05-15', 100);
INSERT INTO Sales.Orders_Partitioned VALUES (2, '2024-07-20', 50);
INSERT INTO Sales.Orders_Partitioned VALUES (3, '2025-12-31', 20);
INSERT INTO Sales.Orders_Partitioned VALUES (4, '2026-01-01', 100);


SELECT * FROM Sales.Orders_Partitioned;

-- Query Test
SELECT 
    p.partition_number AS PartitionNumber,
    f.name AS PartitionFilegroup,
    p.rows AS NumberOfRows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds 
ON p.partition_number = dds.destination_id
JOIN sys.filegroups f 
ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned';

-- The Performance (Execution Plan)
SELECT *
INTO Sales.Orders_NoPartition
FROM Sales.Orders_Partitioned;

SELECT *
FROM Sales.Orders_NoPartition
WHERE OrderDate = '2026-01-01';

SELECT *
FROM Sales.Orders_Partitioned
WHERE OrderDate = '2026-01-01';