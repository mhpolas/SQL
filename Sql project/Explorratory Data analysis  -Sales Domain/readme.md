# 📊 SQL Exploratory Data Analysis (EDA) Project – MS SQL Server  

## 🔎 Project Overview
This project demonstrates **Exploratory Data Analysis- Sales Domian** using **Microsoft SQL Server**.  
The goal is to analyze sales, customers, and product data to uncover key insights such as:  
- Business performance metrics  
- Customer demographics  
- Product trends  
- Revenue distribution  
- Top/Bottom performing customers & products  

The SQL queries are structured in different sections (Exploration, Measures, Magnitude, and Ranking) to provide clarity and reusability.  

---

## 📂 Database Schema
The project works on a **star schema** with the following tables:  
- `dim_customers` → `customer_key` (PK), `customer_id`, `customer_number`, `first_name`, `last_name`,
    `country`, `marital_status`, `gender`, `birthdate`, `create_date`  
- `dim_products` → `product_key` (PK), `product_id`, `product_number`, `product_name`,
    `category_id`, `category`, `subcategory`, `maintenance` (bit),
    `cost`, `product_line`, `start_date`  
- `fact_sales` → `order_number`, `product_key` (FK), `customer_key` (FK),
    `order_date`, `shipping_date`, `due_date`,
    `sales_amount`, `quantity`, `price`
S
---

## 🛠️ SQL Techniques Used
- **Exploration Queries** → Database structure, metadata, distinct values  
- **Aggregate Functions** → `SUM()`, `COUNT()`, `AVG()`, `MIN()`, `MAX()`  
- **Date Functions** → `DATEDIFF()`, `GETDATE()`  
- **Ranking Functions** → `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`  
- **Joins** → To link fact and dimension tables  
- **Grouping & Ordering** → For category and customer-level analysis  

---

## 📌 Key Insights
1. **Business Metrics**
   - Total Sales, Orders, Customers, Products, and Average Selling Price.  
2. **Customer Analysis**
   - Age distribution (oldest & youngest), customer count by country & gender.  
3. **Product Analysis**
   - Revenue by product category, top 5 highest revenue products, bottom 5 least sold products.  
4. **Revenue Distribution**
   - Top 10 customers contribute the most revenue.  
   - Few customers place very few orders (potential churn).  
 


