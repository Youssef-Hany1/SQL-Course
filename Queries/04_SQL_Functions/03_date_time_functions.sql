/* ============================================================================
   File: 03_date_time_functions.sql
   Author: Youssef Hany
   Description: Comprehensive SQL queries demonstrating Date/Time functions.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: DATE & TIME FUNCTIONS
   ============================================================================ */

-- Basic Date Selection
SELECT
    OrderID,
    OrderDate,
    ShipDate,
    CreationTime
FROM Sales.Orders;

-- YEAR, MONTH, DAY Extraction
SELECT
    OrderID,
    CreationTime,
    YEAR(CreationTime) AS creationtime_year,
    MONTH(CreationTime) AS creationtime_month,
    DAY(CreationTime) AS creationtime_day
FROM Sales.Orders;

-- DATEPART Extraction
SELECT
    OrderID,
    CreationTime,
    DATEPART(year, CreationTime) AS Year_dp,
    DATEPART(month, CreationTime) AS Month_dp,
    DATEPART(day, CreationTime) AS Day_dp,
    DATEPART(hour, CreationTime) AS Hour_dp,
    DATEPART(week, CreationTime) AS Week_dp,
    DATEPART(quarter, CreationTime) AS Quarter_dp
FROM Sales.Orders;

-- DATENAME Extraction (Returns string representation)
SELECT
    OrderID,
    CreationTime,
    DATENAME(month, CreationTime) AS Year_dn,
    DATENAME(weekday, CreationTime) AS Day_dn
FROM Sales.Orders;

-- DATETRUNC (Truncating Dates)
SELECT
    OrderID,
    CreationTime,
    DATETRUNC(minute, CreationTime) AS Minute_dt,
    DATETRUNC(hour, CreationTime) AS Hour_dt,
    DATETRUNC(day, CreationTime) AS Day_dt,
    DATETRUNC(month, CreationTime) AS Month_dt,
    DATETRUNC(year, CreationTime) AS Year_dt
FROM Sales.Orders;

SELECT
    DATETRUNC(month,CreationTime) AS Creation,
    COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(month,CreationTime);

-- EOMONTH (End of Month)
SELECT
    OrderID,
    CreationTime,
    EOMONTH(CreationTime) AS EndOfMonth,
    CAST(DATETRUNC(month,CreationTime) AS DATE) AS StartOfMonth
FROM Sales.Orders;

-- EXAMPLES: How many orders were placed each year?
SELECT
    YEAR(OrderDate) AS OrderDate,
    COUNT(*) AS NoOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate);

-- EXAMPLES: How many orders were placed each month?
SELECT
    DATENAME(month,OrderDate) AS OrderDate,
    COUNT(*) AS NoOfOrders
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate);

/* Show all orders that were placed during
   the month of february */
SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2;

-- FORMAT (Custom Date Formatting)
SELECT
    OrderID,
    CreationTime,
    FORMAT(CreationTime, 'MM-dd-yyyy') USA_FORMAT,
    FORMAT(CreationTime, 'dd-MM-yyyy') EURO_FORMAT,
    FORMAT(CreationTime, 'dd') dd,
    FORMAT(CreationTime, 'ddd') ddd,
    FORMAT(CreationTime, 'dddd') dddd,
    FORMAT(CreationTime, 'MM') MM,
    FORMAT(CreationTime, 'MMM') MMM,
    FORMAT(CreationTime, 'MMMM') MMMM
FROM Sales.Orders;

/* Show Creation Time using the following format:
   Day Wed Jan Q1 2025 12:34:56 PM */
SELECT
    OrderID,
    CreationTime,
    'Day ' + FORMAT(CreationTime, 'ddd MMM') +
    ' Q' + DATENAME(quarter,CreationTime) + ' ' +
    FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomeFormat
FROM Sales.Orders;

-- Data Aggregations using FORMAT
SELECT
    FORMAT(OrderDate,'MMM yy') AS OrderDate,
    COUNT(*) AS NrOfOrders
FROM Sales.Orders
GROUP BY FORMAT(OrderDate,'MMM yy');

-- DATEADD (Adding/Subtracting Intervals)
SELECT
    OrderID,
    OrderDate,
    DATEADD(day, -10, OrderDate) AS TenDaysBefore,
    DATEADD(month, 3, OrderDate) AS ThreeMonthsLater,
    DATEADD(year, 2, OrderDate) AS TwoYearsLater
FROM Sales.Orders;

-- DATEDIFF (Difference between dates)
-- Calculate the age of employees
SELECT
    EmployeeID,
    FirstName,
    BirthDate,
    DATEDIFF(year, BirthDate, GETDATE()) AS Age
FROM Sales.Employees;

-- ISDATE (Checking for valid dates)
SELECT 
    ISDATE('123') AS DateCheck1,
    ISDATE('2005-11-06') AS DateCheck2,
    ISDATE('06-11-2005') AS DateCheck3,
    ISDATE('2005') AS DateCheck4,
    ISDATE('11') AS DateCheck5;

SELECT
    OrderDate,
    ISDATE(OrderDate),
    CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
         ELSE '9999-09-09'
    END AS NewOrderDate
FROM
(
    SELECT '2025-09-12' AS OrderDate UNION
    SELECT '2025-09-13' UNION
    SELECT '2025-09-15' UNION
    SELECT '2025-09'
) t;