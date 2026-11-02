/* ============================================================================
   File: 05_case_when_statements.sql
   Author: Youssef Hany
   Description: Comprehensive SQL queries demonstrating Conditional Logic functions.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: CONDITIONAL LOGIC (CASE WHEN)
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