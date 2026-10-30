# 🗄️ Database Setup & Initialization Guide

This directory contains all the necessary files to set up the databases used throughout the course. You can initialize the database using the provided SQL scripts (recommended) or by importing the raw CSV datasets manually.

## 📁 Folder Structure
- **`00_sql-server/`, `01_mysql/`, `02_postgres/`**: Contains the SQL initialization scripts tailored for your specific Database Management System (DBMS).
- **`03_csv-files/`**: Raw data files (`Customers.csv`, `Employees.csv`, `Orders.csv`, `OrdersArchive.csv`, `Products.csv`) used for manual import or specific data warehousing ETL tasks.

## 🛠️ Method 1: Execute Initialization Scripts (Recommended)
The easiest way to set up the database with all tables and data is to run the pre-written SQL scripts.
1. Open your preferred DBMS client (e.g., SQL Server Management Studio for SQL Server).
2. Navigate to the folder matching your DBMS (e.g., `00_sql-server/`).
3. Open the initialization script (e.g., `init_database.sql`).
4. **Important:** Check the script for any file path variables that need to be updated to match your local machine's directories.
5. Execute the entire script. 
6. Refresh your database explorer to see the newly created database, schemas, and populated tables.

## 🛠️ Method 2: Manual CSV Import
If you prefer to build the tables yourself or practice data ingestion, you can manually import the provided CSV files from the `03_csv-files` folder.
1. Create a new, blank database in your DBMS (e.g., `DataWarehouseAnalytics`).
2. In SSMS, right-click the new database -> **Tasks** -> **Import Flat File**.
3. Browse and select one of the CSV files in the `03_csv-files` folder (e.g., `Customers.csv`).
4. Follow the import wizard, ensuring you allow NULLs where appropriate based on the data preview.
5. Repeat this process for the remaining files (`Employees.csv`, `Orders.csv`, `OrdersArchive.csv`, and `Products.csv`).

## 🛠️ Method 3: Database Restore (.bak) - *SQL Server Only*
If your `00_sql-server` folder contains a `.bak` backup file, you can restore the entire database directly.
1. Move the `.bak` file to your SQL Server's default backup directory (typically `C:\Program Files\Microsoft SQL Server\...\MSSQL\Backup`).
2. In SSMS, right-click **Databases** -> **Restore Database**.
3. Select **Device**, click the `...` button, and click **Add** to locate your `.bak` file.
4. Click **OK** to restore. 
5. Refresh your Object Explorer to access the database.
