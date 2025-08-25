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
