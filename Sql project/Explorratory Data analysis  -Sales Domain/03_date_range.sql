/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- How many years of sales data available
SELECT MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(YEAR, MIN(order_date),MAX(order_date)) as order_range_year
FROM [gold.fact_sales];

-- Find the youngest and the oldest customer
SELECT 
MIN(birthdate) AS oldest_birthdate,
DATEDIFF(YEAR,MIN(birthdate),GETDATE() ) AS oldest_age,
Max(birthdate) as youngest_birthdate,
DATEDIFF(YEAR,MAX(birthdate),GETDATE()) AS youngest_age
FROM [gold.dim_customers];

