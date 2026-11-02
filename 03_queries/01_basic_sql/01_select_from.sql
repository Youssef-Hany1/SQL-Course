/* ============================================================================
   File: 01_select_from.sql
   Author: Youssef Hany
   Description: Foundational SQL SELECT queries covering basic retrieval.
   Database: MyDatabase
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: BASIC DATA RETRIEVAL
   ============================================================================ */

-- Retrieve All Customer Data
SELECT * 
FROM dbo.customers;

-- Retrieve All Order Data
SELECT *
FROM dbo.orders;

-- Retrieve each customer's name, country, and score
SELECT 
    first_name,
    country,
    score
FROM dbo.customers;