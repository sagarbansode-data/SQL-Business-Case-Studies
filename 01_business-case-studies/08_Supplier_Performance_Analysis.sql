/*
===============================================================================
PROJECT : SQL Business Case Studies

MODULE  : 08 - Supplier Performance Analysis

DOMAIN  : Logistics & Supply Chain

DESCRIPTION
-----------
This module analyses supplier performance using inventory data to evaluate
supplier contribution, product portfolio and pricing insights.

DATABASE
--------
PostgreSQL

TABLES USED
-----------
- suppliers
- inventory_item_master
- item_categories

===============================================================================
*/

/*
===============================================================================
Business Case 1

Question:
Display all supplier records.

Business Purpose:
Review supplier master information.

===============================================================================
*/

SELECT *
FROM suppliers;

/*
===============================================================================
Business Case 2

Question:
How many suppliers are available?

Business Purpose:
Measure supplier base.

===============================================================================
*/

SELECT
COUNT(*) AS total_suppliers
FROM suppliers;

/*
===============================================================================
Business Case 3

Question:
How many inventory items are supplied by each supplier?

Business Purpose:
Identify suppliers with the largest product portfolio.

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
Business Case 4

Question:
Find average unit price of products supplied by each supplier.

Business Purpose:
Compare supplier pricing.

===============================================================================
*/

SELECT
s.supplier_name,
ROUND(AVG(i.unit_price),2) AS average_price
FROM suppliers s
JOIN inventory_item_master i
ON s.supplier_id = i.supplier_id
GROUP BY s.supplier_name
ORDER BY average_price DESC;

/*
===============================================================================
Business Case 5

Question:
Find maximum priced product supplied by each supplier.

Business Purpose:
Identify premium-value products.

===============================================================================
*/

SELECT
s.supplier_name,
MAX(i.unit_price) AS highest_price
FROM suppliers s
JOIN inventory_item_master i
ON s.supplier_id = i.supplier_id
GROUP BY s.supplier_name
ORDER BY highest_price DESC;

/*
===============================================================================
Business Case 6

Question:
Category-wise product count supplied by suppliers.

Business Purpose:
Understand supplier category distribution.

===============================================================================
*/

SELECT
c.category_name,
COUNT(i.item_id) AS total_products
FROM item_categories c
JOIN inventory_item_master i
ON c.category_id = i.category_id
GROUP BY c.category_name
ORDER BY total_products DESC;

/*
===============================================================================
Business Case 7

Question:
Rank suppliers based on number of inventory items.

Business Purpose:
Identify top contributing suppliers.

===============================================================================
*/

SELECT
s.supplier_name,
COUNT(i.item_id) AS total_items,

RANK() OVER(
ORDER BY COUNT(i.item_id) DESC
) AS supplier_rank

FROM suppliers s
LEFT JOIN inventory_item_master i
ON s.supplier_id = i.supplier_id
GROUP BY s.supplier_name;

/*
===============================================================================
Business Case 8

Question:
Suppliers supplying above average number of products.

Business Purpose:
Identify strategic suppliers.

===============================================================================
*/

WITH supplier_summary AS
(
SELECT
s.supplier_name,
COUNT(i.item_id) AS total_items
FROM suppliers s
LEFT JOIN inventory_item_master i
ON s.supplier_id = i.supplier_id
GROUP BY s.supplier_name
)

SELECT *
FROM supplier_summary
WHERE total_items >
(
SELECT AVG(total_items)
FROM supplier_summary
);

/*
===============================================================================
Business Case 9

Question:
Top 5 suppliers by average product price.

Business Purpose:
Identify suppliers providing premium inventory.

===============================================================================
*/

SELECT
s.supplier_name,
ROUND(AVG(i.unit_price),2) AS average_price
FROM suppliers s
JOIN inventory_item_master i
ON s.supplier_id=i.supplier_id
GROUP BY s.supplier_name
ORDER BY average_price DESC
LIMIT 5;

/*
===============================================================================
Business Case 10

Question:
Generate supplier performance summary.

Business Purpose:
Executive supplier report.

===============================================================================
*/

SELECT
    COUNT(DISTINCT supplier_id) AS total_suppliers,
    COUNT(item_id) AS total_inventory_items,
    ROUND(AVG(unit_price),2) AS average_inventory_price,
    MAX(unit_price) AS highest_inventory_price,
    MIN(unit_price) AS lowest_inventory_price
FROM inventory_item_master;

/*
===============================================================================

Module Summary

This module demonstrates supplier performance analysis using PostgreSQL.

Business areas covered:

✔ Supplier Contribution
✔ Product Portfolio
✔ Category Distribution
✔ Pricing Analysis
✔ Ranking
✔ CTE
✔ Executive Reporting

===============================================================================
*/