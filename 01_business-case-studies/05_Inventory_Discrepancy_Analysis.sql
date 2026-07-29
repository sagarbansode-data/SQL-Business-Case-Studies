/*
===============================================================================
PROJECT : SQL Business Case Studies

MODULE  : 05 - Inventory Discrepancy Analysis

DOMAIN  : Logistics & Supply Chain

DESCRIPTION
-----------
This module analyses inventory discrepancies across warehouses, items and
discrepancy types to identify operational risks and inventory accuracy issues.

DATABASE
--------
PostgreSQL

TABLES USED
-----------
- inventory_discrepancy_log
- inventory_item_master
- warehouses

===============================================================================
*/

/*
===============================================================================
Business Case 1

Question:
Display all inventory discrepancy records.

Business Purpose:
Provides a complete overview of discrepancy transactions.

===============================================================================
*/

SELECT *
FROM inventory_discrepancy_log;

/*
===============================================================================
Business Case 2

Question:
How many discrepancy records exist?

Business Purpose:
Measure the total number of inventory discrepancy cases.

===============================================================================
*/

SELECT COUNT(*) AS total_discrepancies
FROM inventory_discrepancy_log;

/*
===============================================================================
Business Case 3

Question:
Which warehouses have the highest number of discrepancies?

Business Purpose:
Identify high-risk warehouse locations.

===============================================================================
*/

SELECT
w.warehouse_name,
COUNT(*) AS total_discrepancies
FROM warehouses w
LEFT JOIN inventory_discrepancy_log d
	ON w.warehouse_id = d.warehouse_id
GROUP BY w.warehouse_name
ORDER BY total_discrepancies DESC;

/*
===============================================================================
Business Case 4

Question:
Which discrepancy types occur most frequently?

Business Purpose:
Understand the major reasons for inventory mismatches.

===============================================================================
*/

SELECT
discrepancy_type,
COUNT(*) AS total_cases
FROM inventory_discrepancy_log
GROUP BY discrepancy_type
ORDER BY total_cases DESC;

/*
===============================================================================
Business Case 5

Question:
Calculate total variance quantity by warehouse.

Business Purpose:
Measure inventory variance across warehouse operations.

===============================================================================
*/

SELECT
warehouse_code,
SUM(variance_quantity) AS total_variance
FROM inventory_discrepancy_log
GROUP BY warehouse_code
ORDER BY total_variance DESC;

/*
===============================================================================
Business Case 6

Question:
Display item names with discrepancy counts.

Business Purpose:
Identify inventory items frequently involved in discrepancies.

===============================================================================
*/

SELECT
i.item_name,
COUNT(d.discrepancy_id) AS total_discrepancies
FROM inventory_discrepancy_log d
JOIN inventory_item_master i
ON d.item_id = i.item_id
GROUP BY i.item_name
ORDER BY total_discrepancies DESC;

/*
===============================================================================
Business Case 7

Question:
Display warehouse names with discrepancy counts.

Business Purpose:
Create warehouse-level discrepancy performance report.

===============================================================================
*/

SELECT
w.warehouse_name,
COUNT(d.discrepancy_id) AS total_discrepancies
FROM inventory_discrepancy_log d
JOIN warehouses w
ON d.warehouse_code = w.warehouse_code
GROUP BY w.warehouse_name
ORDER BY total_discrepancies DESC;

/*
===============================================================================
Business Case 8

Question:
Find items having variance greater than the average variance.

Business Purpose:
Identify high-risk inventory items.

===============================================================================
*/

SELECT
item_id,
variance_quantity
FROM inventory_discrepancy_log
WHERE variance_quantity >
(
SELECT AVG(variance_quantity)
FROM inventory_discrepancy_log
);

/*
===============================================================================
Business Case 9

Question:
Top 10 discrepancy records based on variance quantity.

Business Purpose:
Prioritise critical inventory discrepancies.

===============================================================================
*/

SELECT
discrepancy_id,
warehouse_code,
item_id,
variance_quantity
FROM inventory_discrepancy_log
ORDER BY variance_quantity DESC
LIMIT 10;

/*
===============================================================================
Business Case 10

Question:
Average variance quantity by discrepancy type.

Business Purpose:
Understand the impact of each discrepancy category.

===============================================================================
*/

SELECT
discrepancy_type,
ROUND(AVG(variance_quantity),2) AS average_variance
FROM inventory_discrepancy_log
GROUP BY discrepancy_type
ORDER BY average_variance DESC;