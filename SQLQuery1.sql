Top 5 products in each category with the highest profit margin

WITH ranked_products AS (
SELECT category,product_name,profit_margin, RANK() OVER(PARTITION BY category ORDER BY profit_margin DESC) AS rnk
FROM dbo.df_ecommerce
)
SELECT category, product_name, profit_margin
FROM ranked_products
WHERE rnk <= 5
ORDER BY category, profit_margin DESC;


Find the highest-priced product per customer location
  
WITH high_priced AS (
SELECT customer_location, product_name, final_price, RANK() OVER(PARTITION BY customer_location ORDER BY final_price DESC) AS rnk
FROM dbo.df_ecommerce
)
SELECT customer_location, product_name, final_price
FROM high_priced
WHERE rnk = 1
ORDER BY final_price DESC;


Products with high return rates and low profit margins

SELECT product_name, category, profit_margin, return_rate 
FROM dbo.df_ecommerce
WHERE return_rate > (SELECT AVG(return_rate) FROM dbo.df_ecommerce) 
AND profit_margin < (SELECT AVG(profit_margin) FROM dbo.df_ecommerce)
ORDER BY return_rate DESC;


Most commonly purchased product per customer age group

WITH ranked_purchases AS (
SELECT customer, category, product_name, COUNT(*) AS purchase_count, RANK() OVER(PARTITION BY customer ORDER BY COUNT(*) DESC) AS rank
FROM dbo.df_ecommerce
GROUP BY customer, category, product_name
)
SELECT customer AS customer_age_group, category, product_name, purchase_count
FROM ranked_purchases
WHERE rank = 1
ORDER BY purchase_count DESC;
  

Top 3 best-selling products per shipping method

WITH top_sellers AS (
SELECT shipping_method, product_name, COUNT(*) AS total_sales, 
RANK() OVER(PARTITION BY shipping_method ORDER BY COUNT(*) DESC) AS rank
FROM dbo.df_ecommerce
GROUP BY shipping_method, product_name
)
SELECT shipping_method, product_name, total_sales
FROM top_sellers
WHERE rank <= 3
ORDER BY shipping_method, total_sales DESC;



Supplier performance analysis (highest return rate per supplier)

WITH supplier_returns AS (
SELECT supplier_id, AVG(return_rate) AS avg_return_rate, RANK() OVER(ORDER BY AVG(return_rate) DESC) AS rank
FROM dbo.df_ecommerce
GROUP BY supplier_id
)
SELECT supplier_id, avg_return_rate
FROM supplier_returns
WHERE rank <= 5
ORDER BY avg_return_rate DESC;



Identify potential deadstock (high stock level, low demand)

SELECT product_name, stock_level, popularity_index 
FROM dbo.df_ecommerce
WHERE stock_level > (SELECT AVG(stock_level) FROM dbo.df_ecommerce) 
AND popularity_index < (SELECT AVG(popularity_index) FROM dbo.df_ecommerce)
ORDER BY stock_level DESC;  



Top-spending customers and their total purchase value

SELECT customer, customer_location, SUM(final_price) AS total_spent 
FROM dbo.df_ecommerce
GROUP BY customer, customer_location
ORDER BY total_spent DESC
LIMIT 10;

