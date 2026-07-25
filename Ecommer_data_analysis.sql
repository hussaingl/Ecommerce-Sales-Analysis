use ecommerce_sales_analysis;
-- View all records
SELECT * FROM ecommerce_data;
-- Find date range
SELECT
MIN(order_date) AS Start_Date,
MAX(order_date) AS End_Date
FROM ecommerce_data;
-- Check NULL values
SELECT *
FROM ecommerce_data
WHERE customer_id IS NULL;

-- Check duplicate Order IDs
SELECT order_id,
COUNT(*)
FROM ecommerce_data
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Missing Sales
SELECT *
FROM ecommerce_data
WHERE revenue IS NULL;


-- Sales by Region
SELECT
region,
SUM(revenue) AS Sales
FROM ecommerce_data
GROUP BY region
ORDER BY Sales DESC;

-- Sales by Category
SELECT
product_category,
SUM(revenue) AS Sales
FROM ecommerce_data
GROUP BY product_category
ORDER BY Sales DESC;

-- Top 10 Customers
SELECT
customer_id,
SUM(revenue) AS Sales
FROM ecommerce_data
GROUP BY customer_id
ORDER BY Sales DESC
LIMIT 10;
-- Rank customers by sales
SELECT
customer_id,
SUM(revenue) AS Sales,
RANK() OVER(ORDER BY SUM(revenue) DESC) AS Customer_Rank
FROM ecommerce_data
GROUP BY customer_id;
-- Dense Rank Products
SELECT
product_category,
SUM(revenue) AS Sales,
DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) AS Product_Rank
FROM ecommerce_data
GROUP BY product_category;
-- Monthly Sales
SELECT
MONTHNAME(order_date) AS Month,
SUM(revenue) AS Sales
FROM ecommerce_data
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);
-- CTE Example
WITH RegionSales AS
(
SELECT
region,
SUM(revenue) AS Sales
FROM ecommerce_data
GROUP BY region
)
SELECT *
FROM RegionSales
ORDER BY Sales DESC;

-- Top 3 Product_Category
SELECT *
FROM
(
SELECT
product_category,
SUM(revenue) AS Sales,
ROW_NUMBER() OVER
(PARTITION BY product_category ORDER BY SUM(revenue) DESC) AS rn
FROM ecommerce_data
GROUP BY product_category
) t
WHERE rn <= 3;
-- Customers spending above average
SELECT
customer_id,
SUM(revenue) AS Sales
FROM ecommerce_data
GROUP BY customer_id
HAVING SUM(revenue) >
(
SELECT AVG(revenue)
FROM ecommerce_data
);
