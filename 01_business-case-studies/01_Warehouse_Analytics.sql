/*
===============================================================================
PROJECT : SQL Business Case Studies
DOMAIN  : Logistics & Supply Chain

DESCRIPTION
-----------
This module contains SQL queries used to analyse warehouse operations,
capacity, workload and inventory performance.

DATABASE
--------
PostgreSQL

TABLES USED
-----------
- warehouses
- inventory_movement_log
- inventory_discrepancy_log
- task_allocation_log
- inventory_validation_log

===============================================================================
*/

/*
===============================================================================
Business Case 1

Question:
Display complete warehouse information.

Business Purpose:
Provides a complete overview of all warehouses.

===============================================================================
*/

SELECT *
FROM warehouses;

/*
===============================================================================
Business Case 2

Question:
Display warehouse names alphabetically.

Business Purpose:
Helps users quickly identify warehouse locations.

===============================================================================
*/

SELECT
warehouse_code,
warehouse_name
FROM warehouses
ORDER BY warehouse_name;

/*
===============================================================================
Business Case 3

Question:
Count total warehouses.

Business Purpose:
Shows total operational warehouses.

===============================================================================
*/

SELECT COUNT(*) AS total_warehouses
FROM warehouses;

/*
===============================================================================
Business Case 4

Question:
Show warehouses by state.

Business Purpose:
Understand warehouse distribution.

===============================================================================
*/

SELECT
state,
COUNT(*) AS total_warehouses
FROM warehouses
GROUP BY state
ORDER BY total_warehouses DESC;

/*
===============================================================================
Business Case 5

Question:
Display warehouse capacity.

Business Purpose:
Helps identify large warehouses.

===============================================================================
*/

SELECT
warehouse_name,
storage_capacity
FROM warehouses
ORDER BY storage_capacity DESC;


