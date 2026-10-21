/* ============================================================================
   File: 05_common_table_expressions_ctes.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Common Table Expressions 
                (Recursive & Non-Recursive).
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: COMMON TABLE EXPRESSIONS (CTE)
   ============================================================================ */

-- 1) Non-Recursive CTE (Standalone CTE)
-- Find the total sales and last order date per customer
-- Step1: Find the total sales per customer
WITH CTE_TotalSales AS 
(
    SELECT CustomerID, SUM(Sales) TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)
-- Step2: Find the last order date for each customer
,CTE_LastOrder AS 
(
    SELECT CustomerID, MAX(OrderDate) LastOrderDate
    FROM Sales.Orders
    GROUP BY CustomerID
)
-- Main Query
SELECT
    c.CustomerID,
    c.FirstName,
    cts.TotalSales,
    clo.LastOrderDate
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cts ON c.CustomerID = cts.CustomerID
LEFT JOIN CTE_LastOrder clo ON c.CustomerID = clo.CustomerID;

-- 2) Non-Recursive CTE (Nested CTE)
-- Step1: Find the total sales per customer (Standalone CTE)
WITH CTE_TotalSales AS 
(
    SELECT CustomerID, SUM(Sales) TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
)
-- Step2: Find the last order date for each customer (Standalone CTE)
,CTE_LastOrder AS 
(
    SELECT CustomerID, MAX(OrderDate) LastOrderDate
    FROM Sales.Orders
    GROUP BY CustomerID
)
-- Step3: Rank customers based on total sales per customer (Nested CTE)
,CTE_CustomerRank AS
(
    SELECT CustomerID, RANK() OVER (ORDER BY TotalSales DESC) CustomerRank
    FROM CTE_TotalSales
)
-- Step4: Segment customers based on thier total sales (Nested CTE)
,CTE_CustomerSegment AS
(
    SELECT
        CustomerID,
        CASE
            WHEN TotalSales > 100 THEN 'High'
            WHEN TotalSales > 60 THEN 'Medium'
            ELSE 'Low'
        END CustomerSegment
    FROM CTE_TotalSales
)
-- Main Query
SELECT
    c.CustomerID,
    c.FirstName,
    cts.TotalSales,
    clo.LastOrderDate,
    ccr.CustomerRank,
    ccs.CustomerSegment
FROM Sales.Customers c
LEFT JOIN CTE_TotalSales cts ON c.CustomerID = cts.CustomerID
LEFT JOIN CTE_LastOrder clo ON c.CustomerID = clo.CustomerID
LEFT JOIN CTE_CustomerRank ccr ON c.CustomerID = ccr.CustomerID
LEFT JOIN CTE_CustomerSegment ccs ON c.CustomerID = ccs.CustomerID;

-- 3) Recursive CTE
-- Generate a sequence of numbers from 1 to 20
WITH CTE_SequenceNumbers AS
(
    -- Anchor Query
    SELECT 1 Number
    UNION ALL
    -- Recursive Query
    SELECT Number + 1
    FROM CTE_SequenceNumbers 
    WHERE Number < 20
)
-- Main Query
SELECT Number
FROM CTE_SequenceNumbers
OPTION (MAXRECURSION 100);

/* Show the employee hierarchy by displaying each employee's
   level within the organization */
WITH CTE_EmployeeHierarchy AS
(
    -- Anchor Query
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 Level
    FROM Sales.Employees
    WHERE ManagerID IS NULL
    UNION ALL
    -- Recursive Query
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        ceh.Level + 1 Level
    FROM Sales.Employees e
    INNER JOIN CTE_EmployeeHierarchy ceh
    ON e.ManagerID = ceh.EmployeeID
)
-- Main Query
SELECT *
FROM CTE_EmployeeHierarchy;