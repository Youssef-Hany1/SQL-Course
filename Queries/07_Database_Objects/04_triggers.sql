/* ============================================================================
   File: 04_triggers.sql
   Author: Youssef Hany
   Description: Advanced SQL techniques covering Triggers.
   ============================================================================ */

USE SalesDB;

/* ============================================================================
   SECTION 1: TRIGGERS
   ============================================================================ */

-- LOGGING

-- Step1: Create Log Table
CREATE TABLE Sales.EmployeesLogs (
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
);

-- Step2: Create Trigger on Employees Table
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
	INSERT INTO Sales.EmployeesLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee Added = ' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED
END;

-- Step3: Insert New Data into Employees
SELECT * FROM Sales.EmployeesLogs;

INSERT INTO Sales.Employees
VALUES
(6, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3);

SELECT * FROM Sales.Employees;
SELECT * FROM Sales.EmployeesLogs;