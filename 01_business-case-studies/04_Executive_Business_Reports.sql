/*
===============================================================================
PROJECT : SQL Business Case Studies

MODULE  : 04 - Executive Business Reports

DOMAIN  : Logistics & Supply Chain

DESCRIPTION
-----------
This module contains executive-level SQL reports developed to support
business decision-making across warehouse, inventory and supply chain
operations.

The reports combine multiple tables to generate meaningful business insights
for managers and stakeholders.

DATABASE
--------
PostgreSQL

TABLES USED
-----------
- warehouses
- warehouse_staff
- inventory_item_master
- inventory_movement_log
- inventory_discrepancy_log
- inventory_validation_log
- task_allocation_log
- suppliers
- item_categories

===============================================================================
*/

/*
===============================================================================
Executive Report 1

Business Requirement

Management wants to analyse warehouse performance by comparing movement
transactions across all warehouses.

===============================================================================
*/

SELECT
	w.warehouse_name,
	w.warehouse_code,
	count(m.movement_id) AS total_movements,
	sum(m.quantity) AS total_quantity_moved
FROM warehouses w
LEFT JOIN inventory_movement_log m
	ON m.warehouse_id = w.warehouse_id
GROUP BY 
	w.warehouse_name, 
	w.warehouse_code
ORDER BY total_quantity_moved DESC;

/*
===============================================================================
Executive Report 2

Business Requirement

Identify suppliers contributing the highest number of inventory items.

===============================================================================
*/

SELECT
    s.supplier_name,
    COUNT(i.item_id) AS total_items
FROM suppliers s
LEFT JOIN inventory_item_master i
       ON s.supplier_id = i.supplier_id
GROUP BY s.supplier_name
ORDER BY total_items DESC;

/*
===============================================================================
Executive Report 3

Business Requirement

Generate category-wise inventory summary.

===============================================================================
*/

SELECT
    c.category_name,
    COUNT(i.item_id) AS total_items,
    ROUND(AVG(i.unit_cost),2) AS average_price
FROM item_categories c
LEFT JOIN inventory_item_master i
       ON c.category_id = i.category_id
GROUP BY c.category_name
ORDER BY total_items DESC;

/*
===============================================================================
Executive Report 4

Business Requirement

Identify staff members handling the highest number of warehouse tasks.

===============================================================================
*/

SELECT
    s.staff_name,
    COUNT(t.task_id) AS total_tasks
FROM warehouse_staff s
LEFT JOIN task_allocation_log t
       ON s.staff_id = t.staff_id
GROUP BY s.staff_name
ORDER BY total_tasks DESC;

/*
===============================================================================
Executive Report 5

Business Requirement

Analyse inventory validation status across warehouses.

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
Executive Report 6

Business Requirement

Provide overall business KPIs for management.

===============================================================================
*/

SELECT
(SELECT COUNT(*) FROM warehouses) AS total_warehouses,
(SELECT COUNT(*) FROM warehouse_staff) AS total_staff,
(SELECT COUNT(*) FROM inventory_item_master) AS total_inventory_items,
(SELECT COUNT(*) FROM inventory_movement_log) AS total_inventory_movements,
(SELECT COUNT(*) FROM task_allocation_log) AS total_tasks,
(SELECT COUNT(*) FROM suppliers) AS total_suppliers;