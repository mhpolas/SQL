/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS (
---
SELECT 
YEAR(F.order_date) AS Sales_Year,
P.product_name,
SUM(F.sales_amount) AS Total_Sales
FROM 
[gold.fact_sales] AS F
LEFT JOIN [gold.dim_products] AS P
ON P.product_key=F.product_key
where F.order_date IS NOT NULL
GROUP BY YEAR(F.order_date),P.product_name
)

SELECT 
Sales_Year,
product_name,
Total_Sales,
AVG(Total_Sales) OVER (PARTITION BY product_name) AS avg_sales,
Total_Sales - AVG(Total_Sales) OVER (PARTITION BY product_name) as Diff_avg,
CASE WHEN Total_Sales - AVG(Total_Sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
     WHEN Total_Sales - AVG(Total_Sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
     ELSE 'Avg' END avg_change,
-- Year over Year Analysis
LAG(Total_Sales) OVER (PARTITION BY product_name ORDER BY Sales_Year) py_sales,
Total_Sales - LAG(Total_Sales) OVER (PARTITION BY product_name ORDER BY Sales_Year) as Diff_py,
CASE WHEN Total_Sales - LAG(Total_Sales) OVER (PARTITION BY product_name ORDER BY Sales_Year) > 0 THEN 'Increasing'
     WHEN Total_Sales - LAG(Total_Sales) OVER (PARTITION BY product_name ORDER BY Sales_Year) < 0 THEN 'Decreasing'
     ELSE 'No change' END py_change
FROM
yearly_product_sales
ORDER BY product_name;
