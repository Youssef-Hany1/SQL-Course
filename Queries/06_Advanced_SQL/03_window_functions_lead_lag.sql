/* ============================================================================
   File: 03_window_functions_lead_lag.sql
   Author: Youssef Hany
   Description: Comprehensive SQL queries demonstrating advanced Window Functions
                (Value functions).
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: WINDOW VALUE FUNCTIONS (LEAD, LAG, FIRST_VALUE, LAST_VALUE)
   ============================================================================ */

/* Month-Over-Month (MoM) ANALYSIS
   Analyze the month-over-month (MoM) performance by finding
   the percentage change in sales between the current
   and previous month */
SELECT
    *,
    CurrentMonthSales - PreviousMonthSales MoM_Change,
    ROUND(((CAST(CurrentMonthSales AS FLOAT) - PreviousMonthSales) / PreviousMonthSales * 100),1) MoM_Percentage
FROM (
    SELECT
        MONTH(OrderDate) OrderMonth,
        SUM(Sales) CurrentMonthSales,
        LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) PreviousMonthSales
    FROM Sales.Orders
    GROUP BY MONTH(OrderDate)  
) t;

/* CUSTOMER RETENTION ANALYSIS
   In order to analyze customer loyalty, rank customers
   based on the average days between their orders */
SELECT
    CustomerID,
    AVG(DaysUntilNextOrder) AvgDays,
    RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder),9999999)) CustomerRank
FROM (
    SELECT
        OrderID,
        CustomerID,
        OrderDate CurrentOrder,
        LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
        DATEDIFF(day,OrderDate,LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
    FROM Sales.Orders
) t
GROUP BY CustomerID;

-- TIME GAP ANALYSIS: Find the average shipping duration in days for each month
SELECT
    MONTH(OrderDate) OrderMonth,
    AVG(DATEDIFF(day,OrderDate,ShipDate)) AvgShippingDuration
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

-- Find the number of days between each order and previous order
SELECT
    OrderID,
    OrderDate CurrentOrderDate,
    LAG(OrderDate) OVER (ORDER BY OrderDate) PerviousOrderDate,
    DATEDIFF(day,LAG(OrderDate) OVER (ORDER BY OrderDate),OrderDate) DaysDiff
FROM Sales.Orders;

-- FIRST_VALUE / LAST_VALUE: Find the lowest and highest sales for each product
SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID
    ORDER BY Sales) LowestSales,
    MIN(Sales) OVER (PARTITION BY ProductID) LowestSales2,
    LAST_VALUE(Sales) OVER (PARTITION BY ProductID
    ORDER BY Sales 
    ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID
    ORDER BY Sales DESC) HighestSales2,
    MAX(Sales) OVER (PARTITION BY ProductID) HighestSales3
FROM Sales.Orders;

-- COMPARE TO EXTREMES: Find the difference between the highest and lowest sales
SELECT
    *,
    Sales - LowestSales SalesDifference1,
    HighestSales - Sales SalesDifference2
FROM (
    SELECT
        OrderID,
        ProductID,
        Sales,
        FIRST_VALUE(Sales) OVER (PARTITION BY ProductID
        ORDER BY Sales) LowestSales,
        FIRST_VALUE(Sales) OVER (PARTITION BY ProductID
        ORDER BY Sales DESC) HighestSales
    FROM Sales.Orders
) t;