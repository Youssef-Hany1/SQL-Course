/* ============================================================================
   File: 01_string_functions.sql
   Author: Youssef Hany
   Description: Comprehensive SQL queries demonstrating String functions.
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