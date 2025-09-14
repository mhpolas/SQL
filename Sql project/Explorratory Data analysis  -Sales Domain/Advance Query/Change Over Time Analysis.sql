/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

--By Year

SELECT 
YEAR(order_date) as Order_Year, 
SUM( sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Customer,
SUM(quantity) as Total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY Order_Year;


--By Month

SELECT 
MONTH(order_date) as Order_MONTH, 
SUM( sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Customer,
SUM(quantity) as Total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);

--By Month & Year

SELECT 
YEAR(order_date) as Order_Year, 
MONTH(order_date) as Order_MONTH, 
SUM( sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Customer,
SUM(quantity) as Total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

--Month & Year by DATETRUNC Function

SELECT 
DATETRUNC(Month,order_date) as order_date, 
SUM( sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Customer,
SUM(quantity) as Total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(Month,order_date)
ORDER BY DATETRUNC(Month,order_date);

--Month & Year by Format Function

SELECT 
FORMAT(order_date,'yyyy-MMM') as order_date, 
SUM( sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Customer,
SUM(quantity) as Total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MMM')
ORDER BY FORMAT(order_date,'yyyy-MMM');