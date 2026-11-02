/* ============================================================================
   File: 02_numeric_functions.sql
   Author: Youssef Hany
   Description: Comprehensive SQL queries demonstrating Numeric functions.
   ============================================================================ */

/* ============================================================================
   SECTION 1: NUMERIC FUNCTIONS
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