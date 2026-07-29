/*
===============================================================================
PROJECT : SQL Business Case Studies

MODULE  : 06 - Inventory Validation Analysis

DOMAIN  : Logistics & Supply Chain

DESCRIPTION
-----------
This module analyses inventory validation records to identify validation
failures, warehouse-wise validation trends and operational risks.

DATABASE
--------
PostgreSQL

TABLES USED
-----------
- inventory_validation_log
- inventory_item_master
- warehouses

===============================================================================
*/

/*
===============================================================================
Business Case 1

Question:
Display all validation records.

Business Purpose:
Provides a complete overview of inventory validation activities.

===============================================================================
*/

SELECT *
FROM inventory_validation_log;

/*
===============================================================================
Business Case 2

Question:
Count total validation records.

Business Purpose:
Measure validation workload.

===============================================================================
*/

SELECT
COUNT(*) AS total_validation_records
FROM inventory_validation_log;

/*
===============================================================================
Business Case 3

Question:
Count validations by status.

Business Purpose:
Understand validation success and failure distribution.

===============================================================================
*/

SELECT
validation_status,
COUNT(*) AS total_records
FROM inventory_validation_log
GROUP BY validation_status
ORDER BY total_records DESC;

/*
===============================================================================
Business Case 4

Question:
Warehouse-wise validation records.

Business Purpose:
Identify warehouses performing maximum validations.

===============================================================================
*/

SELECT
warehouse_code,
COUNT(*) AS total_validations
FROM inventory_validation_log
GROUP BY warehouse_code
ORDER BY total_validations DESC;

/*
===============================================================================
Business Case 5

Question:
Validation status by warehouse.

Business Purpose:
Evaluate warehouse-wise validation quality.

===============================================================================
*/

SELECT
warehouse_code,
validation_status,
COUNT(*) AS total_records
FROM inventory_validation_log
GROUP BY
warehouse_code,
validation_status
ORDER BY warehouse_code;

/*
===============================================================================
Business Case 6

Question:
Items involved in validation activities.

Business Purpose:
Identify frequently validated inventory items.

===============================================================================
*/

SELECT
i.item_name,
COUNT(v.validation_id) AS validation_count
FROM inventory_validation_log v
JOIN inventory_item_master i
ON v.item_id = i.item_id
GROUP BY i.item_name
ORDER BY validation_count DESC;

/*
===============================================================================
Business Case 7

Question:
Warehouse names with validation count.

Business Purpose:
Business-friendly warehouse validation report.

===============================================================================
*/

SELECT
w.warehouse_name,
COUNT(v.validation_id) AS total_validations
FROM inventory_validation_log v
JOIN warehouses w
ON v.warehouse_code = w.warehouse_code
GROUP BY w.warehouse_name
ORDER BY total_validations DESC;

/*
===============================================================================
Business Case 8

Question:
Validation failures only.

Business Purpose:
Identify Closed validation records.

===============================================================================
*/

SELECT *
FROM inventory_validation_log
WHERE validation_status='Closed';

/*
===============================================================================
Business Case 9

Question:
Top warehouses with Closed validations.

Business Purpose:
Identify operational risk locations.

===============================================================================
*/

SELECT
warehouse_code,
COUNT(*) AS failed_validations
FROM inventory_validation_log
WHERE validation_status='Closed'
GROUP BY warehouse_code
ORDER BY failed_validations DESC;

/*
===============================================================================
Business Case 10

Question:
Validation CLOSED percentage.

Business Purpose:
Measure inventory validation effectiveness.

===============================================================================
*/

SELECT
    (SUM(CASE
            WHEN validation_status = 'Closed' THEN 1
            ELSE 0
         END) * 100.0 / COUNT(validation_status)) AS Validation_percentage
FROM inventory_validation_log;


/* Another One Method (Postgresql)  */

SELECT
    COUNT(*) FILTER (WHERE validation_status = 'Closed') * 100.0
    / COUNT(*) AS Validation_percentage
FROM inventory_validation_log;

/* for Round UP the output  */

SELECT
    ROUND(
        (SUM(CASE
            WHEN validation_status = 'Closed' THEN 1 ELSE 0
            END) * 100.0 / COUNT(validation_status))
        ,2) AS Validation_percentage
FROM inventory_validation_log;