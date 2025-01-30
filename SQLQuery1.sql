--top five products with the highest profit margin\

with ranked_products as
(select product_name, profit_margin, dense_rank() over(order by profit_margin desc) as rank
from dbo.df_ecommerce)

select product_name, profit_margin, rank from ranked_products 
where rank <= 5


--find top 5 most expensive products in each region

with most_expensive as 
(select product_name, customer_location, final_price, dense_rank() over(order by final_price desc) as rank
from dbo.df_ecommerce)

select product_name, customer_location, final_price, rank
from most_expensive
where rank <= 5


--product that had the highest return rate

select top 1 product_name, return_rate
from dbo.df_ecommerce
order by return_rate desc


--which products do men/women prefer the most

select customer_gender, category, count(*) as purchase_count
from dbo.ecommerce
group by customer_gender, category
order by customer_gender, purchase_count desc



--which age group buys which category and product

select customer_age_group, count(*) as purchase_count
from dbo.ecommerce
group by customer_age_group
order by purchase_count desc


--top three products per location


--average return rate based on each category

select category, avg(return_rate) as avg_return_rate
from dbo.df_ecommerce
group by category
order by avg_return_rate desc

--products that have high stock level but low popularity

select product_name, stock_level, popularity_index
from dbo.df_ecommerce
where stock_level > 50 and popularity_index < 30
order by stock_level desc

--suppliers that have the highest return rate for their products

select supplier_id, avg(return_rate) as avg_return_rate_suppliers
from dbo.df_ecommerce
group by supplier_id
order by avg_return_rate_suppliers desc
