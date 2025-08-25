/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Retrieve a list of all tables in the database

SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- Retrieve all columns for a specific table (dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Explore All Countries 
SELECT DISTINCT country from [gold.dim_customers];

--Explore all product category 

SELECT DISTINCT category , subcategory , product_name from  [gold.dim_products]
ORDER BY 1,2,3;


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


/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM [gold.fact_sales];

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM [gold.fact_sales];

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM [gold.fact_sales];

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM [gold.fact_sales];
SELECT COUNT(DISTINCT order_number) AS total_orders FROM [gold.fact_sales];

-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM [gold.dim_products];

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM [gold.dim_customers];

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM [gold.fact_sales];

-- Generate a Report that shows all key metrics of the business

SELECT 'Total Sales' AS MeasureName , SUM(sales_amount) AS MeasureValues FROM [gold.fact_sales]
UNION ALL
SELECT 'Total quantity' , SUM(quantity) FROM [gold.fact_sales]
UNION ALL
SELECT 'Average Price', AVG(price) FROM [gold.fact_sales]
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM [gold.fact_sales]
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM [gold.dim_products]
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM [gold.dim_customers];

 
/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/


-- Find the total number of custormer  by countries
SELECT  country , COUNT(customer_id) AS Total_Customer 
FROM [gold.dim_customers]
GROUP BY country
ORDER BY Total_Customer DESC;

-- Find the total number of custormer  by Gender
SELECT  gender , COUNT(customer_id) AS Total_Customer 
FROM [gold.dim_customers]
GROUP BY gender
ORDER BY Total_Customer DESC;

-- Find the total productnumber by category

SELECT category , COUNT(product_id) AS Total_product
FROM [gold.dim_products]
GROUP BY category
ORDER BY Total_product DESC;

-- AVG costs in each Category

SELECT  category, AVG(cost) as avg_cost
FROM [gold.dim_products] 
GROUP BY category
ORDER BY avg_cost DESC

-- Total revenue generated for each category
SELECT  P.category, SUM(f.sales_amount) AS Total_revenue
FROM [gold.fact_sales] as f
LEFT JOIN [gold.dim_products] AS P
on p.product_key=f.product_key
GROUP BY p.category
ORDER BY Total_revenue desc;


-- Total revenue generated by each customer
SELECT c.customer_key,c.first_name , c.last_name ,sum(f.sales_amount) as Total_revenue
FROM [gold.fact_sales] as f
LEFT JOIN [gold.dim_customers] AS c
ON f.customer_key=c.customer_key
GROUP BY c.customer_key,c.first_name, c.last_name
ORDER BY Total_revenue DESC

-- What is the distribution of sold item across countries

SELECT c.country ,sum(f.quantity ) as Total_sold_item
FROM [gold.fact_sales] as f
LEFT JOIN [gold.dim_customers] AS c
ON f.customer_key=c.customer_key
GROUP BY c.country
ORDER BY Total_sold_item DESC


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