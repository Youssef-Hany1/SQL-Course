/* ============================================================================
   File: 03_having_clause.sql
   Author: Youssef Hany
   Description: Foundational SQL queries covering HAVING clauses.
   Database: MyDatabase
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: AGGREGATION & GROUPING (HAVING CLAUSE)
   ============================================================================ */

/* Find the average score for each country considering only customers with
   a score not equal to 0 and return only those countries with an average
   score greater than 430 */
SELECT 
    country,
    AVG(score) AS average_score
FROM dbo.customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;