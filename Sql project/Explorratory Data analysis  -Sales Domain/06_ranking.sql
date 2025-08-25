
/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/


-- Which 5 products generate the highest Revenue

SELECT TOP 5
P.product_name, SUM(f.sales_amount) AS Total_revenue
FROM [gold.fact_sales] as f
LEFT JOIN [gold.dim_products] AS P
on p.product_key=f.product_key
GROUP BY  P.product_name
ORDER BY Total_revenue desc;

--Using Windows Function
SELECT * 
FROM (
        SELECT 
        P.product_name, SUM(f.sales_amount) AS Total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
        FROM [gold.fact_sales] as f
        LEFT JOIN [gold.dim_products] AS P
        on p.product_key=f.product_key
        GROUP BY  P.product_name ) T
WHERE rank_products <= 5 ;



-- What are the worst performing products in terms of sold item
SELECT TOP 5
P.product_name, SUM(f.quantity) AS Total_sold_item
FROM [gold.fact_sales] as f
LEFT JOIN [gold.dim_products] AS P
on p.product_key=f.product_key
GROUP BY  P.product_name
ORDER BY Total_sold_item asc;

--Using Windows Function
SELECT * FROM(
SELECT 
P.product_name, SUM(f.quantity) AS Total_sold_item,
ROW_NUMBER() OVER (ORDER BY SUM(f.quantity) ASC) AS Ranked_Products
FROM [gold.fact_sales] as f
LEFT JOIN [gold.dim_products] AS P
on p.product_key=f.product_key
GROUP BY  P.product_name) T
WHERE Ranked_Products <=10;

-- Find the top 10 customers who have generated the highest revenue
SELECT * 
FROM (
SELECT c.customer_key,c.first_name , c.last_name ,sum(f.sales_amount) as Total_revenue,
DENSE_RANK() OVER (ORDER BY sum(f.sales_amount) DESC) AS ranked_Customer
FROM [gold.fact_sales] as f
LEFT JOIN [gold.dim_customers] AS c
ON f.customer_key=c.customer_key
GROUP BY c.customer_key,c.first_name, c.last_name) T
WHERE ranked_Customer <=20 ;

--The 3 Customer with the Fewst Orders Place


SELECT TOP 3
c.customer_key,c.first_name , c.last_name ,COUNT(DISTINCT f.order_number) as Total_order,
RANK() OVER (ORDER BY COUNT(DISTINCT f.order_number) ASC) AS ranked_Customer
FROM [gold.fact_sales] as f
LEFT JOIN [gold.dim_customers] AS c
ON f.customer_key=c.customer_key
GROUP BY c.customer_key,c.first_name, c.last_name;