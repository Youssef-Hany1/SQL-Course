/* ============================================================================
   File: 03_stored_procedures.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Stored Procedures, Parameters,
                Variables, Control Flow (IF ELSE), and Error Handling.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: STORED PROCEDURES
   ============================================================================ */

-- Step1: Write a Query
-- For US Customers, find the total number of customers and the average score
SELECT
	COUNT(CustomerID) TotalCustomers,
	AVG(COALESCE(Score,0)) AvgScore
FROM Sales.Customers
WHERE Country = 'USA';

-- Step2: Turning the query int a stored procedure
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
	SELECT
		COUNT(CustomerID) TotalCustomers,
		AVG(COALESCE(Score,0)) AvgScore
	FROM Sales.Customers
	WHERE Country = 'USA'
END;

-- Step3: Execute the stored procedure
EXEC GetCustomerSummary;

-- For German Customers, find the total number of customers and the average score
CREATE PROCEDURE GetCustomerSummaryGermany AS
BEGIN
	SELECT
		COUNT(CustomerID) TotalCustomers,
		AVG(COALESCE(Score,0)) AvgScore
	FROM Sales.Customers
	WHERE Country = 'Germany'
END;

EXEC GetCustomerSummaryGermany;

DROP PROCEDURE GetCustomerSummaryGermany;

-- Parameter

-- Step1: Define the parameter (Name, Datatype, Default Value)
-- Step2: Use the parameter
-- Step3: Pass the parameter's value at execution
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	SELECT
		COUNT(CustomerID) TotalCustomers,
		AVG(COALESCE(Score,0)) AvgScore,
		@Country Country
	FROM Sales.Customers
	WHERE Country = @Country
END;

EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary @Country = 'USA';
EXEC GetCustomerSummary;

-- Multi-Queries

-- Find the total number of orders and total sales
CREATE PROCEDURE GetCustomerOrdersSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	SELECT
		COUNT(CustomerID) TotalCustomers,
		AVG(COALESCE(Score,0)) AvgScore,
		@Country Country
	FROM Sales.Customers
	WHERE Country = @Country;

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales
	FROM Sales.Orders o
	JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID
	WHERE c.Country = @Country;
END;

EXEC GetCustomerOrdersSummary @Country = 'Germany';
EXEC GetCustomerOrdersSummary @Country = 'USA';
EXEC GetCustomerOrdersSummary;

-- Stored Procedure Variables

-- Total Customers from Germany: 2
-- Average Score from Germany: 425

-- Step1: Declare variables
-- Step2: Assign values to variables
ALTER PROCEDURE GetCustomerOrdersSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	DECLARE @TotalCustomers INT, @AvgScore FLOAT;

	SELECT
		@TotalCustomers = COUNT(CustomerID),
		@AvgScore = AVG(COALESCE(Score,0))
	FROM Sales.Customers
	WHERE Country = @Country;
	
	PRINT 'Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR);
	PRINT 'Average Score from ' + @Country + ': ' + CAST(@AvgScore AS NVARCHAR);

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales
	FROM Sales.Orders o
	JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID
	WHERE c.Country = @Country;
END;

EXEC GetCustomerOrdersSummary;
EXEC GetCustomerOrdersSummary @Country = 'Germany';

-- Stored Procedure Control Flow (IF ELSE)

ALTER PROCEDURE GetCustomerOrdersSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	DECLARE @TotalCustomers INT, @AvgScore FLOAT;

	-- Prepare & Cleanup Data
	IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
	BEGIN
		PRINT 'Updating NULL Scores to 0';
		UPDATE Sales.Customers
		SET Score = 0
		WHERE Score IS NULL AND Country = @Country;
	END

	ELSE
	BEGIN
		PRINT 'No NULL Scores found';
	END;

	-- Generating Reports
	SELECT
		@TotalCustomers = COUNT(CustomerID),
		@AvgScore = AVG(Score)
	FROM Sales.Customers
	WHERE Country = @Country;
	
	PRINT 'Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR);
	PRINT 'Average Score from ' + @Country + ': ' + CAST(@AvgScore AS NVARCHAR);

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales
	FROM Sales.Orders o
	JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID
	WHERE c.Country = @Country;
END;

EXEC GetCustomerOrdersSummary;
EXEC GetCustomerOrdersSummary @Country = 'Germany';

-- Stored Procedure Error Handling (TRY & CATCH)

ALTER PROCEDURE GetCustomerOrdersSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	BEGIN TRY
		DECLARE @TotalCustomers INT, @AvgScore FLOAT;

		-- Prepare & Cleanup Data
		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
		BEGIN
			PRINT 'Updating NULL Scores to 0';
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country;
		END

		ELSE
		BEGIN
			PRINT 'No NULL Scores found';
		END;

		-- Generating Reports
		SELECT
			@TotalCustomers = COUNT(CustomerID),
			@AvgScore = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country;
	
		PRINT 'Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR);
		PRINT 'Average Score from ' + @Country + ': ' + CAST(@AvgScore AS NVARCHAR);

		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales,
			1/0
		FROM Sales.Orders o
		JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
		WHERE c.Country = @Country;
	END TRY
	BEGIN CATCH
		PRINT 'An error occured.';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
		PRINT 'Error Procedure: ' + ERROR_PROCEDURE();
	END CATCH;
END;

EXEC GetCustomerOrdersSummary;

-- Styling Stored Procedure

ALTER PROCEDURE GetCustomerOrdersSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	BEGIN TRY
		DECLARE @TotalCustomers INT, @AvgScore FLOAT;

		-- =============================
		-- Step1: Prepare & Cleanup Data
		-- =============================
		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
		BEGIN
			PRINT 'Updating NULL Scores to 0';
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country;
		END

		ELSE
		BEGIN
			PRINT 'No NULL Scores found';
		END;

		-- =================================
		-- Step2: Generating Summary Reports
		-- =================================
		-- Calculate total customers and average score for specific country
		SELECT
			@TotalCustomers = COUNT(CustomerID),
			@AvgScore = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country;

		PRINT 'Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR);
		PRINT 'Average Score from ' + @Country + ': ' + CAST(@AvgScore AS NVARCHAR);

		-- Calculate total orders and total sales for specific country
		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales
		FROM Sales.Orders o
		JOIN Sales.Customers c
		ON c.CustomerID = o.CustomerID
		WHERE c.Country = @Country;
	END TRY
	BEGIN CATCH
		-- ==============
		-- Error Handling
		-- ==============
		PRINT 'An error occured.';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
		PRINT 'Error Procedure: ' + ERROR_PROCEDURE();
	END CATCH;
END;