/* ============================================================================
   File: 06_Data_Transformation_Queries.sql
   Author: Youssef Hany
   Description: Comprehensive SQL queries demonstrating data transformation 
                techniques, including String, Numeric, Date/Time, Conversion, 
                NULL handling, and Conditional Logic functions.
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: STRING FUNCTIONS
   ============================================================================ */

-- Concatenate first name and country into one column
SELECT CONCAT(first_name, '-', country) AS name_country
FROM customers;

-- Convert the first name to uppercase
SELECT UPPER(first_name) AS up_name
FROM customers;

-- Convert the first name to lowercase
SELECT LOWER(first_name) AS low_name
FROM customers;

/* Find customers whose first name contains
   leading or trailing spaces */
SELECT 
    first_name,
    LEN(first_name) AS len_name,
    LEN(TRIM(first_name)) AS len_trim_name,
    LEN(first_name) - LEN(TRIM(first_name)) AS flag
FROM customers;
-- WHERE LEN(first_name) != LEN(TRIM(first_name))
-- WHERE first_name != TRIM(first_name)

-- Remove dashes (-) from a phone number
SELECT 
    '123-456-7890' AS phone,
    REPLACE('123-456-7890', '-', '') AS clean_phone;

-- Replace File Extension from txt to csv
SELECT 
    'report.txt' AS old_filename,
    REPLACE('report.txt', '.txt', '.csv') AS new_filename;

-- Calculate the length of each customer's first name
SELECT 
    first_name,
    LEN(first_name) AS len_name
FROM customers;

-- Retrieve the first two characters of each first name
SELECT 
    first_name,
    LEFT(first_name, 2) AS first_2_char
FROM customers;

-- Retrieve the last two characters of each first name
SELECT 
    first_name,
    RIGHT(first_name, 2) AS last_2_char
FROM customers;

/* Retrieve a list of customer's first names
   after removing the first character */
SELECT 
    first_name,
    SUBSTRING(first_name, 2, LEN(first_name)) AS sub_char
FROM customers;

/* ============================================================================
   SECTION 2: NUMERIC FUNCTIONS
   ============================================================================ */

-- Rounding Numbers
SELECT
    3.516 AS number,
    ROUND(3.516, 2) AS round_2,
    ROUND(3.516, 1) AS round_1,
    ROUND(3.516, 0) AS round_0;

-- Absolute Values
SELECT
    -10 AS number,
    ABS(-10) AS absolute_1,
    ABS(10) AS absolute_2;

/* ============================================================================
   SECTION 3: DATE & TIME FUNCTIONS
   ============================================================================ */

USE SalesDB;

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

/* ============================================================================
   SECTION 4: DATA TYPE CONVERSIONS (CAST & CONVERT)
   ============================================================================ */

-- CONVERT
SELECT
    CONVERT(INT, '123') AS [String to Int CONVERT],
    CONVERT(DATE, '2005-11-06') AS [String to Date CONVERT];

SELECT
    CreationTime,
    CONVERT(DATE, CreationTime) AS [Datetime to Date CONVERT],
    CONVERT(VARCHAR, CreationTime, 32) AS [USA Std. Style:32],
    CONVERT(VARCHAR, CreationTime, 34) AS [EURO Std. Style:34]
FROM Sales.Orders;

-- CAST
SELECT
    CAST('123' AS INT) AS [String to Int CAST],
    CAST(123 AS VARCHAR) AS [Int to String CAST],
    CAST('2005-11-06' AS DATE) AS [String to Date CAST],
    CAST('2005-11-06' AS DATETIME2) AS [String to Datetime CAST];

SELECT
    CreationTime,
    CAST(CreationTime AS DATE) AS [Datetime to Date CAST]
FROM Sales.Orders;

/* ============================================================================
   SECTION 5: NULL HANDLING
   ============================================================================ */

-- ISNULL | COALESCE
-- Find the average scores of the customers
SELECT 
    CustomerID,
    Score,
    COALESCE(Score, 0) AS Score2,
    AVG(Score) OVER () AS AvgScores,
    AVG(COALESCE(Score, 0)) OVER () AS CorrectAvgScores
FROM Sales.Customers;

/* Display the full name of customers in a single field
   by merging their first and last names,
   and add 10 bonus points to each customer's score. */
SELECT
    CustomerID,
    FirstName,
    LastName,
    FirstName + ' ' + LastName AS FullName1,
    FirstName + ' ' + COALESCE(LastName, '') AS FullName2,
    Score,
    Score + 10 AS NewScore1,
    COALESCE(Score, 0) + 10 AS NewScore2
FROM Sales.Customers;

/* Sort the customers from the lowest to highest scores,
   with nulls appearing last */
SELECT
    CustomerID,
    Score
FROM Sales.Customers
ORDER BY 
    CASE WHEN Score IS NULL THEN 1 ELSE 0 END ASC,
    Score ASC;

-- NULLIF
/* Find the sale price for each order by dividing
   the sales by the quantity */
SELECT
    OrderID,
    Sales,
    Quantity,
    Sales / NULLIF(Quantity, 0) AS SalePrice
FROM Sales.Orders;

-- IS NULL | IS NOT NULL
-- Identify the customers who have no scores
SELECT
    CustomerID,
    FirstName,
    Score
FROM Sales.Customers
WHERE Score IS NULL;

-- List all customers who have scores
SELECT
    CustomerID,
    FirstName,
    Score
FROM Sales.Customers
WHERE Score IS NOT NULL;

-- List all details for customers who have not placed any orders
SELECT
    c.*,
    o.OrderID
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

-- NULL vs Empty String vs Blank Space
WITH Orders AS (
    SELECT 1 Id, 'A' Catery UNION
    SELECT 2, NULL UNION
    SELECT 3, '' UNION
    SELECT 4, ' '
)
SELECT
    *,
    DATALENGTH(Catery) CateryLen,
    TRIM(Catery) Policy1,
    DATALENGTH(TRIM(Catery)) PolicyLen1,
    NULLIF(TRIM(Catery),'') Policy2,
    COALESCE(NULLIF(TRIM(Catery),''),'unknown') Policy3
FROM Orders;

/* ============================================================================
   SECTION 6: CONDITIONAL LOGIC (CASE WHEN)
   ============================================================================ */

/* Generate a report showing the total sales for each catery:
   -High: If the sales higher than 50
   -Medium: If the sales between 200 and 50
   -Low: If the sales equal or lower than 20
   Sort the cateries from highest sales to lowest */
SELECT
    Catery,
    SUM(Sales) Total_Sales
FROM(
    SELECT
        OrderID,
        Sales,
        CASE
            WHEN Sales > 50 THEN 'High'
            WHEN Sales > 20 THEN 'Medium'
            ELSE 'Low'
        END Catery
    FROM Sales.Orders
) t
GROUP BY Catery
ORDER BY Total_Sales DESC;

-- Retrieve employee details with gender displayed as full text
SELECT
    [EmployeeID],
    [FirstName],
    [LastName],
    [Department],
    [BirthDate],
    CASE Gender
        WHEN 'M' THEN 'Male'
        WHEN 'F' THEN 'Female'
        ELSE 'Not Available'
    END Gender,
    [Salary],
    [ManagerID]
FROM Sales.Employees;

-- Retrieve customer details with abbreviated country code
SELECT
    CustomerID,
    FirstName,
    LastName,
    CASE Country
        WHEN 'Germany' THEN 'DE'
        WHEN 'USA' THEN 'US'
        ELSE 'n/a'
    END Country
FROM Sales.Customers;

-- Find the average scores of customers and treats NULLs as 0
SELECT
    CustomerID,
    FirstName,
    LastName,
    Score,
    CASE 
        WHEN Score IS NULL THEN 0
        ELSE Score
    END ScoreClean,
    AVG(Score) OVER () AvgScore,
    AVG(
        CASE 
            WHEN Score IS NULL THEN 0
            ELSE Score
        END
    ) OVER () AvgScoreClean
FROM Sales.Customers;

/* Count how many times each customer has made an order
   with sales greater than 30 */
SELECT
    CustomerId,
    SUM(Flag) TotalOrdersHigherThan30,
    COUNT(*) TotalOrders
FROM(
    SELECT
        CustomerID,
        CASE 
            WHEN Sales > 30 THEN 1
            ELSE 0
        END Flag
    FROM Sales.Orders
) t
GROUP BY CustomerID;