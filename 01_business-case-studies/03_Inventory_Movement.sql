/*
===============================================================================
PROJECT : SQL Business Case Studies

MODULE  : 03 - Inventory Movement Analytics

DOMAIN  : Logistics & Supply Chain

DESCRIPTION
-----------
This module analyses inventory movement transactions to understand
warehouse activity, item movement patterns and operational workload.

DATABASE
--------
PostgreSQL

TABLES USED
-----------
- inventory_movement_log
- inventory_item_master
- warehouses

===============================================================================
*/

/*
===============================================================================
Business Case 1

Question:
Display complete inventory movement records.

Business Purpose:
Understand inventory transaction history.

===============================================================================
*/

SELECT *
FROM inventory_movement_log;

/*
===============================================================================
Business Case 2

Question:
Find total inventory movements.

Business Purpose:
Measure overall warehouse activity.

===============================================================================
*/

SELECT
COUNT(*) AS total_movements
FROM inventory_movement_log;

/*
===============================================================================
Business Case 3

Question:
Which warehouses handle the highest number of movements?

Business Purpose:
Identify high activity warehouses.

===============================================================================
*/

SELECT
warehouse_id,
COUNT(*) AS total_movements
FROM inventory_movement_log
GROUP BY warehouse_id
ORDER BY total_movements DESC;

/*
===============================================================================
Business Case 4

Question:
Which items are moved most frequently?

Business Purpose:
Identify fast-moving inventory items.

===============================================================================
*/

SELECT
item_id,
COUNT(*) AS movement_frequency
FROM inventory_movement_log
GROUP BY item_id
ORDER BY movement_frequency DESC;

/*
===============================================================================
Business Case 5

Question:
Find total quantity moved by warehouse.

Business Purpose:
Understand warehouse workload.

===============================================================================
*/

SELECT
warehouse_id,
SUM(quantity) AS total_quantity_moved
FROM inventory_movement_log
GROUP BY warehouse_id
ORDER BY total_quantity_moved DESC ;

/*
===============================================================================
Business Case 6

Question:
Find items with highest movement quantity.

Business Purpose:
Identify high-demand inventory.

===============================================================================
*/

SELECT
item_id,
SUM(quantity) AS total_quantity_moved
FROM inventory_movement_log
GROUP BY item_id
ORDER BY total_quantity_moved DESC;

/*
===============================================================================
Business Case 7

Question:
Display item names with movement quantity.

Business Purpose:
Connect transaction data with business information.

===============================================================================
*/

SELECT
i.item_name,
SUM(m.quantity) AS total_quantity_moved
FROM inventory_movement_log m
JOIN inventory_item_master i
ON m.item_id = i.item_id
GROUP BY i.item_name
ORDER BY total_quantity_moved DESC;

/*
===============================================================================
Business Case 8

Question:
Show warehouse name and total movement quantity.

Business Purpose:
Create warehouse performance report.

===============================================================================
*/

SELECT
w.warehouse_name,
SUM(m.quantity) AS total_quantity_moved
FROM inventory_movement_log m
JOIN warehouses w
ON m.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_name
ORDER BY total_quantity_moved DESC;

/*
===============================================================================
Business Case 9

Question:
Find average quantity per movement transaction.

Business Purpose:
Understand average transaction size.

===============================================================================
*/

SELECT
AVG(quantity) AS average_movement_quantity
FROM inventory_movement_log;

/*
===============================================================================
Business Case 10

Question:
Find top 10 items based on movement quantity.

Business Purpose:
Identify critical fast-moving inventory.

===============================================================================
*/

SELECT
item_id,
SUM(quantity) AS total_quantity_moved
FROM inventory_movement_log
GROUP BY item_id
ORDER BY total_quantity_moved DESC
LIMIT 10;