/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?

WITH category_sales as(
Select 
P.category,
SUM(F.sales_amount) as Total_sales
FROM [gold.fact_sales] as F
LEFT JOIN [gold.dim_products] AS P
ON F.product_key=P.product_key
group by P.category)

SELECT
category,
Total_sales,
SUM(Total_sales) over() as Overall_sales,
CONCAT(ROUND((CAST(Total_sales AS FLOAT) / SUM(Total_sales) over()) *100,2),'%') as PERCENTAGE_OF_TOTAL
FROM
category_sales
ORDER BY Total_sales desc