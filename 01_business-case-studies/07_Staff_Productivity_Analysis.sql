/*
===============================================================================
PROJECT : SQL Business Case Studies

MODULE  : 07 - Staff Productivity Analysis

DOMAIN  : Logistics & Supply Chain

DESCRIPTION
-----------
This module analyses warehouse staff performance, task allocation and workload
distribution to identify productivity trends and operational efficiency.

DATABASE
--------
PostgreSQL

TABLES USED
-----------
- warehouse_staff
- task_allocation_log
- warehouses

===============================================================================
*/

/*
===============================================================================
Business Case 1

Question:
Display all warehouse staff.

Business Purpose:
View complete employee master data.

===============================================================================
*/

SELECT *
FROM warehouse_staff;

/*
===============================================================================
Business Case 2

Question:
Total staff count.

Business Purpose:
Understand workforce size.

===============================================================================
*/

SELECT COUNT(*) AS total_staff
FROM warehouse_staff;

/*
===============================================================================
Business Case 3

Question:
Number of tasks handled by each staff member.

Business Purpose:
Measure employee workload.

===============================================================================
*/

SELECT
staff_id,
COUNT(task_id) AS total_tasks
FROM task_allocation_log
GROUP BY staff_id
ORDER BY total_tasks DESC;

/*
===============================================================================
Business Case 4

Question:
Show staff names with total assigned tasks.

Business Purpose:
Generate employee workload report.

===============================================================================
*/

SELECT
s.staff_name,
COUNT(t.task_id) AS total_tasks
FROM warehouse_staff s
JOIN task_allocation_log t
ON s.staff_id = t.staff_id
GROUP BY s.staff_name
ORDER BY total_tasks DESC;

/*
===============================================================================
Business Case 5

Question:
Warehouse-wise staff count.

Business Purpose:
Analyse manpower distribution.

===============================================================================
*/

SELECT
warehouse_code,
COUNT(staff_id) AS total_staff
FROM warehouse_staff
GROUP BY warehouse_code
ORDER BY total_staff DESC;

/*
===============================================================================
Business Case 6

Question:
Top 5 busiest staff members.

Business Purpose:
Identify employees handling maximum workload.

===============================================================================
*/

SELECT
staff_id,
COUNT(task_id) AS total_tasks
FROM task_allocation_log
GROUP BY staff_id
ORDER BY total_tasks DESC
LIMIT 5;

/*
===============================================================================
Business Case 7

Question:
Rank employees based on completed tasks.

Business Purpose:
Identify top-performing staff members.

===============================================================================
*/

SELECT
staff_id,
COUNT(task_id) AS total_tasks,
RANK() OVER(
ORDER BY COUNT(task_id) DESC
) AS productivity_rank
FROM task_allocation_log
GROUP BY staff_id;

/*
===============================================================================
Business Case 8

Question:
Dense rank employees by workload.

Business Purpose:
Compare workload fairly when ties exist.

===============================================================================
*/

SELECT
staff_id,
COUNT(task_id) AS total_tasks,
DENSE_RANK() OVER(
ORDER BY COUNT(task_id) DESC
) AS workload_rank
FROM task_allocation_log
GROUP BY staff_id;

/*
===============================================================================
Business Case 9

Question:
Employees performing above average workload.

Business Purpose:
Identify highly productive employees.

===============================================================================
*/

WITH task_summary AS
(
SELECT
staff_id,
COUNT(task_id) AS total_tasks
FROM task_allocation_log
GROUP BY staff_id
)

SELECT *
FROM task_summary
WHERE total_tasks >
(
SELECT AVG(total_tasks)
FROM task_summary
);

/*
===============================================================================
Business Case 10

Question:
Assign row numbers based on productivity.

Business Purpose:
Create employee productivity leaderboard.

===============================================================================
*/

SELECT
staff_id,
COUNT(task_id) AS total_tasks,

ROW_NUMBER() OVER(
ORDER BY COUNT(task_id) DESC
) AS row_num

FROM task_allocation_log

GROUP BY staff_id;