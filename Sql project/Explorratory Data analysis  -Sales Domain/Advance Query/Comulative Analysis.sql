/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/
SELECT
order_date,
Total_sales,
SUM(Total_sales) OVER (ORDER BY order_date) as running_total
FROM
(SELECT
DATETRUNC(MONTH,order_date) as order_date,
SUM(sales_amount) as Total_sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
) t 

--Running Total by using Partition
SELECT
order_date,
Total_sales,
SUM(Total_sales) OVER (PARTITION BY order_date ORDER BY order_date) as running_total
FROM
(SELECT
DATETRUNC(MONTH,order_date) as order_date,
SUM(sales_amount) as Total_sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
) t 


--Running Total by Year
SELECT
order_date,
Total_sales,
SUM(Total_sales) OVER ( ORDER BY order_date) as running_total
FROM
(SELECT
DATETRUNC(YEAR,order_date) as order_date,
SUM(sales_amount) as Total_sales
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR,order_date)
) t 

-- Moving Avg
SELECT
order_date,
Total_sales,
AVG_price,
SUM(Total_sales) OVER ( ORDER BY order_date) as running_total_sales,
AVG(AVG_price) OVER ( ORDER BY order_date) as MOVING_AVG_price
FROM
(SELECT
DATETRUNC(MONTH,order_date) as order_date,
SUM(sales_amount) as Total_sales,
AVG(price) as AVG_price
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
) t 