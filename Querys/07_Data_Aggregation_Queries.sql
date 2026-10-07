-- Aggregate Functions

USE MyDatabase;

-- Find the total number of orders

SELECT
	COUNT(*) TotalNrOfOrders
FROM dbo.orders;

-- Find the total sales of all orders

SELECT
	SUM(sales) TotalSales
FROM dbo.orders;

-- Find the average sales of all orders

SELECT
	AVG(sales) AvgSales
FROM dbo.orders;

-- Find the highest sales of all orders

SELECT
	MAX(sales) HighestSales
FROM dbo.orders;

-- Find the lowest sales of all orders

SELECT
	MIN(sales) LowestSales
FROM dbo.orders;

-- All

SELECT
	customer_id,
	COUNT(*) TotalNrOfOrders,
	SUM(sales) TotalSales,
	AVG(sales) AvgSales,
	MAX(sales) HighestSales,
	MIN(sales) LowestSales
FROM dbo.orders
GROUP BY customer_id;

-- Analyze the scores in customers table

SELECT
	country,
	COUNT(*) TotalNrOfCustomers,
	SUM(score) TotalScores,
	AVG(score) AvgScores,
	MAX(score) HighestScore,
	MIN(score) LowestScore
FROM dbo.customers
GROUP BY country;

-- Find the total sales across all orders

USE SalesDB;

SELECT
	SUM(Sales) TotalSales
FROM Sales.Orders;

-- Find the total sales for each product

SELECT
	ProductID,
	SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID;

-- Window Functions

-- PARTITION BY

/* Find the total sales across all orders, additionally 
   provide details such order id & order date */

SELECT
	OrderID,
	OrderDate,
	SUM(Sales) OVER() TotalSales
FROM Sales.Orders;

/* Find the total sales for each product, additionally 
   provide details such order id & order date */

SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) SalesByProducts
FROM Sales.Orders;

/* Find the total sales for each combination of product
   and order status */

SELECT
	ProductID,
	OrderStatus,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) SalesByProductsAndStatus
FROM Sales.Orders;

/* Find the total sales across all orders, for each product
   and for each combination of product and order status, 
   additionally provide details such order id & order date */

SELECT
	OrderID,
	OrderDate,
	ProductID,
	OrderStatus,
	Sales,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) SalesByProducts,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) SalesByProductsAndStatus
FROM Sales.Orders;

-- ORDER BY

/* Rank each order based on their sales from highest to
   lowest, additionally provide details such order id
   & order date */

SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) RankSales
FROM Sales.Orders;

-- Frame Clause

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales1,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS 2 PRECEDING) TotalSales2
FROM Sales.Orders;

/* Find the total sales for each order status,
   only for two products 101 and 102 */

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	ProductID,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN (101,102);

-- Rank the customers based on their total sales

SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER (ORDER BY SUM(Sales) DESC) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID;

-- Window Aggregate Functions

-- COUNT

-- Find the total number of orders

SELECT
	COUNT(*) TotalNrOfOrders
FROM Sales.Orders;

/* Find the total number of orders,
   additionally provide details such order id & order date */

SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() TotalNrOfOrders
FROM Sales.Orders;

/* Find the total number of orders for each cutomer,
   and additionally provide details such order id & order date */

SELECT
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER (PARTITION BY CustomerID) OrdersByCustomers
FROM Sales.Orders;

/* Find the total number of cutomers,
   find the total number of scores for the cutomers,
   and additionally provide all customer's details */

SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
	Score,
	COUNT(*) OVER () TotalNrOfCustomers,
	COUNT(Score) OVER () TotalNrOfScores
FROM Sales.Customers;

-- Check whether the table 'Orders' contains any duplicate row

SELECT
	OrderID,
	COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.Orders;

-- Check whether the table 'OrdersArchive' contains any duplicate row

SELECT
	*
FROM (
	SELECT
		OrderID,
		COUNT(*) OVER (PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
)t
WHERE CheckPK > 1;

-- SUM

/* Find the total sales across all orders,
   find the total sales for each product,
   and additionally provide details such order id & order date */

SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	SUM(Sales) OVER () TotalSales,
	SUM(Sales) OVER (PARTITION BY ProductID) SalesByProducts
FROM Sales.Orders;

/* Find the percentage contribution of each product's
   sales to the total sales */

SELECT
	OrderID,
	Sales,
	ProductID,
	SUM(Sales) OVER () TotalSales,
	SUM(Sales) OVER (PARTITION BY ProductID) SalesByProducts,
	ROUND((CAST(SUM(Sales) OVER (PARTITION BY ProductID) AS FLOAT) / SUM(Sales) OVER ()) * 100,2) PercentageOfTotal
FROM Sales.Orders;

-- AVG

/* Find the average sales across all orders,
   find the average sales for each product,
   and additionally provide details such order id & order date */

SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	AVG(COALESCE(Sales,0)) OVER () AvgSales,
	AVG(COALESCE(Sales,0)) OVER (PARTITION BY ProductID) AvgSalesByProducts
FROM Sales.Orders;

/* Find the average scores of customers,
   and additionally provide details such customer id & last name */

SELECT
	CustomerID,
	LastName,
	Score,
	COALESCE(Score,0) UpdatedScore,
	AVG(Score) OVER () AvgScore,
	AVG(COALESCE(Score,0)) OVER () AvgScoreWithoutNulls
FROM Sales.Customers;

/* Find all orders where sales are higher than the average 
   sales across all orders */

SELECT
	*
FROM (
	SELECT
		OrderID,
		ProductID,
		Sales,
		AVG(COALESCE(Sales,0)) OVER () AvgSales
	FROM Sales.Orders
)t
WHERE Sales > AvgSales;

-- MIN / MAX

/* Find the highest & lowest sales across all orders,
   find the highest & lowest sales for each product,
   and additionally provide details such order id & order date */

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MIN(Sales) OVER () LowestSales,
	MAX(Sales) OVER () HighestSales,
	MIN(Sales) OVER (PARTITION BY ProductID) LowestSalesByProducts,
	MAX(Sales) OVER (PARTITION BY ProductID) HighestSalesByProducts
FROM Sales.Orders;

-- Show the employees who have the highest salaries

SELECT
	*
FROM (
	SELECT
		*,
		MAX(Salary) OVER () HighestSalary
	FROM Sales.Employees
)t 
WHERE Salary = HighestSalary;

/* Find the deviation of each sale from both the minimum
   and maximum sales amount */

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MIN(Sales) OVER () LowestSales,
	MAX(Sales) OVER () HighestSales,
	Sales - MIN(Sales) OVER () DeviationFromMin,
	MAX(Sales) OVER () - Sales DeviationFromMax
FROM Sales.Orders;

-- Calculate moving average of sales for each product over time

SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvgSalesByProduct
FROM Sales.Orders;

/* Calculate moving average of sales for each product
   over time, including only the next order */

SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgSalesByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) MovingAvgSalesByProduct
FROM Sales.Orders;

-- Window Ranking Functions

-- ROW_NUMBER

-- Rank the orders based on their sales from highest to lowest by using ROW_NUMBER

SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_RowNumber
FROM Sales.Orders;

-- Rank the orders based on their sales from highest to lowest by using RANK

SELECT
	OrderID,
	ProductID,
	Sales,
	RANK() OVER (ORDER BY Sales DESC) SalesRank_Rank
FROM Sales.Orders;

-- Rank the orders based on their sales from highest to lowest by using DENSE_RANK

SELECT
	OrderID,
	ProductID,
	Sales,
	DENSE_RANK() OVER (ORDER BY Sales DESC) SalesRank_DenseRank
FROM Sales.Orders;

-- ROW_NUMBER vs RANK vs DENSE_RANK

SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_RowNumber,
	RANK()       OVER (ORDER BY Sales DESC) SalesRank_Rank,
	DENSE_RANK() OVER (ORDER BY Sales DESC) SalesRank_DenseRank
FROM Sales.Orders;

-- TOP-N ANALYSIS
-- Find the top highest sales for each product

SELECT
	*
FROM (
	SELECT
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Sales DESC) SalesRank
	FROM Sales.Orders
)t 
WHERE SalesRank = 1;

-- BOTTOM-N ANALYSIS
-- Find the lowest 2 customers based on their total sales

SELECT
	*
FROM (
	SELECT
		CustomerID,
		SUM(Sales) TotalSales,
		ROW_NUMBER() OVER (ORDER BY SUM(Sales)) RankCustomers
	FROM Sales.Orders
	GROUP BY CustomerID
)t 
WHERE RankCustomers <= 2;

-- GENERATE UNIQUE IDS
-- Assign unique IDs to the rows of the 'OrdersArchive' table

SELECT
	ROW_NUMBER() OVER (ORDER BY OrderDate) NewOrderID, 
	*
FROM Sales.OrdersArchive;

-- IDENTIFY DUPLICATES
/* Identify duplicate rows in the table 'OrdersArchive'
   and return a clean result without any duplicates */

SELECT
	*
FROM (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY OrderID
		ORDER BY CreationTime DESC) DuplicateOrder, 
		*
	FROM Sales.OrdersArchive
)t
WHERE DuplicateOrder = 1;

--NTILE

SELECT
	OrderID,
	Sales,
	NTILE(1) OVER (ORDER BY Sales DESC) OneBucket,
	NTILE(2) OVER (ORDER BY Sales DESC) TwoBuckets,
	NTILE(3) OVER (ORDER BY Sales DESC) ThreeBuckets,
	NTILE(4) OVER (ORDER BY Sales DESC) FourBuckets
FROM Sales.Orders;

-- DATA SEGMENTATION
-- Segment all orders into 3 categories: high, medium and low sales

SELECT
	OrderID,
	Sales,
	CASE (NTILE(3) OVER (ORDER BY Sales DESC)) 
		WHEN 1 THEN 'High'
		WHEN 2 THEN 'Medium'
		WHEN 3 THEN 'Low'
	END SalesSegmentation
FROM Sales.Orders;

-- EQUALIZING LOAD
-- In order to export the data, divide the orders into 2 groups

SELECT
	NTILE(2) OVER (ORDER BY OrderID) GroupID,
	*
FROM Sales.Orders;

-- CUME_DIST

-- Find the products that fall within the highest 40% of the prices using CUME_DIST

SELECT
	*,
	CONCAT(DistRank * 100,'%') DistRankPerc
FROM (
	SELECT
		Product,
		Price,
		CUME_DIST() OVER (ORDER BY Price DESC) DistRank
	FROM Sales.Products
)t
WHERE DistRank <= 0.4;

-- PERCENT_RANK

-- Find the products that fall within the highest 40% of the prices using PERCENT_RANK

SELECT
	*,
	CONCAT(PercentRank * 100,'%') PercentRankPerc
FROM (
	SELECT
		Product,
		Price,
		PERCENT_RANK() OVER (ORDER BY Price DESC) PercentRank
	FROM Sales.Products
)t
WHERE PercentRank <= 0.4;

-- Window Value Functions

-- LEAD / LAG

-- Month-Over-Month (MoM) ANALYSIS
/* Analyze the month-over-month (MoM) performance by finding
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
)t;

-- CUSTOMER RETENTION ANALYSIS
/* In order to analyze customer loyalty, rank customers
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
)t
GROUP BY CustomerID;

-- TIME GAP ANALYSIS
-- Find the average shipping duration in days for each month

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

-- FIRST_VALUE / LAST_VALUE

-- Find the lowest and highest sales for each product

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

-- COMPARE TO EXTREMES
-- Find the difference between the highest and lowest sales

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
)t;