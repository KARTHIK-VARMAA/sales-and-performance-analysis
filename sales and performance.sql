create database sales_analysis;
use sales_analysis;
CREATE TABLE orders(
  row_id int,
  order_id varchar(50),
  order_date varchar(10),
  ship_date varchar(10),
  ship_mode varchar(20),
  customer_id varchar(20),
  customer_name varchar(50),
  segment varchar(20),
  city varchar(100),
  state varchar(100),
  country varchar(50),
  postal_code varchar(20),
  market varchar(30),
  region varchar(20),
  product_id varchar(30),
  category varchar(30),
  sub_category varchar(50),
  product_name varchar(200),
  sales float,
  quantity int,
  discount float,
  profit float,
  shipping_cost float,
  order_priority varchar(30)
);
TRUNCATE TABLE orders;
select * from orders;
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'C:/Users/Karth/OneDrive/Desktop/sales analysis/Global_Superstore dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
select count(*) from orders;

-- null values
select * from orders
where sales is null;

select * from orders
where customer_name is null;

select * from orders
where postal_code = "unknown";

-- updating unknown values
SET SQL_SAFE_UPDATES = 0;
UPDATE orders
SET postal_code = NULL
WHERE postal_code = 'unknown';

-- finding duplicates
SELECT order_id,
COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- profit less than zero
select * from orders
where profit<0;

-- *** total number of sales***
select count(sales) from orders;

-- profit
select round(sum(profit),2) as profit 
from orders;

-- total orders
select count(distinct(order_id)) as total_orders
from orders;

-- total customers
select count(distinct(customer_name)) as total_customers
from orders;

-- MONTHLY SALES REVENUE TREND
select month(str_to_date(order_date,'%d-%m-%Y')) as `month`,round(sum(sales)) as monthly_sales
from orders
group by `month`
order by `month`;

-- REGIONAL SALES ANALYSIS
select region, round(sum(sales),2) as total_sales
from orders
group by region
order by total_sales desc;

-- TOP 10 PERFORMING PRODUCTS
select product_name,round(sum(sales)) as total_sales
from orders
group by product_name
order by total_sales desc
limit 10;

-- under performing products
select product_name,round(sum(profit),2) as total_profit
from orders
group by product_name
having total_profit <0
order by total_profit asc;

-- CATEGORY PERFORMANCE ANALYSIS
select category,round(sum(sales),2)as sales,round(sum(profit),2) as profits
from orders
group by category
order by sales,profits desc;

-- CUSTOMER ANALYSIS
select distinct(customer_name) as customer,round(sum(sales))as sales
from orders
group by customer
order by sales desc
limit 10;
select * from orders;

