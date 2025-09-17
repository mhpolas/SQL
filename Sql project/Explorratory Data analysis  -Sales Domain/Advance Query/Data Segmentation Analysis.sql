/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/
WITH cost_cat AS(
SELECT
product_key,
product_name,
cost,
CASE WHEN cost<100 THEN 'Below 100'
     WHEN cost BETWEEN 100 AND 500 THEN '100-500'
     WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
     ELSE 'Above 1000'
     END cost_range
FROM [gold.dim_products])

Select 
cost_range,
COUNT( product_key) AS TOTAL_PRODUCTS
from cost_cat
GROUP BY cost_range
ORDER BY TOTAL_PRODUCTS;


/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH sales_lifespam AS(
SELECT
C.customer_key,
SUM(F.sales_amount) AS total_spending,
MIN(F.order_date) AS first_order,
MAX(F.order_date) AS last_order,
DATEDIFF(MONTH,MIN(F.order_date),MAX(F.order_date)) AS lifespan
FROM [gold.fact_sales] as F
LEFT JOIN [gold.dim_customers] AS C
ON C.customer_key=F.customer_key
GROUP BY C.customer_key)

SELECT
COUNT(customer_key) AS customer_key,
customer_group
FROM (
SELECT 
customer_key,
CASE WHEN lifespan >=12 AND total_spending >5000 THEN 'VIP'
     WHEN lifespan >=12 AND total_spending <=5000 THEN 'Regular'
     ELSE 'NEW'
END AS customer_group
FROM sales_lifespam) AS t
GROUP BY customer_group


