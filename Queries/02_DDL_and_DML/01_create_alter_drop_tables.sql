/* ============================================================================
   File: 01_create_alter_drop_tables.sql
   Author: Youssef Hany
   Description: Foundational SQL DDL (Data Definition Language) queries covering 
                the creation, alteration, and deletion of database tables.
   Database: MyDatabase
   ============================================================================ */

USE MyDatabase;

/* ============================================================================
   SECTION 1: CREATING TABLES (CREATE)
   ============================================================================ */

/* Create a new table called persons
   with columns: id, person_name, birth_date, and phone */
CREATE TABLE persons (
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY (id)
);

/* ============================================================================
   SECTION 2: MODIFYING TABLES (ALTER)
   ============================================================================ */

-- Add a new column called email to the persons table
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;

-- Remove the column phone from the persons table
ALTER TABLE persons
DROP COLUMN phone;

/* ============================================================================
   SECTION 3: DELETING TABLES (DROP)
   ============================================================================ */

-- Delete the table persons from the database
DROP TABLE persons;