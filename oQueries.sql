/*
The dataset is a little confusing here, each order is assigned a customer_id, which is not equal to the customer_unique_id.
This means the same customer will get different ids in each order.
*/

SELECT
	COUNT(DISTINCT customer_id),
	COUNT(DISTINCT customer_unique_id),
	COUNT(DISTINCT customer_city),
	COUNT(DISTINCT customer_state)
FROM olist_customers_dataset;

/*
Calculating number of orders and customers by state. 
*/
SELECT
	customer_state AS "State",
	COUNT(DISTINCT customer_id) AS "Number of Orders", --Recall each order is assigned a new customer_id, which is not equal to customer_unique_id
	COUNT(DISTINCT customer_unique_id) AS "Number of Customers"
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY 3 DESC;

/*
Calculating number of orders and customers by city
*/
SELECT
	customer_city AS "City",
	COUNT(DISTINCT customer_id) AS "Number of Orders", --Recall each order is assigned a new customer_id, which is not equal to customer_unique_id
	COUNT(DISTINCT customer_unique_id) AS "Number of Customers"
FROM olist_customers_dataset
GROUP BY 1
ORDER BY 3 DESC;

SELECT
	
FROM olist_customers_dataset

/*
Counting the number of top 50 cities by total customers in each state

Avg percentile of cities in each state
*/
Incomplete

/*
Total Sales

******BIG ISSUE. amount paid does not always match with price+delivery!!!
*/

WITH total_price AS (
	SELECT
		SUM(price) AS sum_price
	FROM olist_order_items_dataset
),
total_payments as (
	SELECT
		SUM(payment_value) AS sum_payments
	FROM olist_order_payments_dataset
)
SELECT 
	sum_price AS "Total Revenue not including Delivery", 
	sum_payments AS "Total Revenue including Delivery"
FROM total_price
CROSS JOIN total_payments;


/*
Total Sales by State.
******BIG ISSUE. amount paid does not always match with price+delivery!!!
*/

WITH total_price AS (
	SELECT
		olist_customers_dataset.customer_state AS state,
		SUM(olist_order_items_dataset.price) AS sum_price
	FROM olist_order_items_dataset
	JOIN olist_orders_dataset
		ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
	JOIN olist_customers_dataset
		ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
	GROUP BY 1
),
total_payments AS (
	SELECT
		olist_customers_dataset.customer_state AS state,
		SUM(payment_value) AS sum_payments
	FROM olist_order_payments_dataset
	JOIN olist_orders_dataset
		ON 	olist_order_payments_dataset.order_id = olist_orders_dataset.order_id
	JOIN olist_customers_dataset
		ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
	GROUP BY 1
)
SELECT
	total_price.state AS "State",
	sum_price AS "Revenue Before Shipping",
	sum_payments AS "Revenue After Shipping"
FROM total_price
JOIN total_payments
	ON total_price.state =  total_payments.state;


/*
Total Sales by City
******BIG ISSUE. amount paid does not always match with price+delivery!!!
*/
WITH total_price AS (
	SELECT
		olist_customers_dataset.customer_city AS City,
		SUM(olist_order_items_dataset.price) AS sum_price
	FROM olist_order_items_dataset
	JOIN olist_orders_dataset
		ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
	JOIN olist_customers_dataset
		ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
	GROUP BY 1
),
total_payments AS (
	SELECT
		olist_customers_dataset.customer_city AS City,
		SUM(payment_value) AS sum_payments
	FROM olist_order_payments_dataset
	JOIN olist_orders_dataset
		ON 	olist_order_payments_dataset.order_id = olist_orders_dataset.order_id
	JOIN olist_customers_dataset
		ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
	GROUP BY 1
)
SELECT
	total_price.city AS "City",
	sum_price AS "Revenue Before Shipping",
	sum_payments AS "Revenue After Shipping"
FROM total_price
JOIN total_payments
	ON total_price.city =  total_payments.city
LIMIT 100;


/*
Total Sales By Zip with Geolocation
******BIG ISSUE. amount paid does not always match with price+delivery!!!
*/

WITH total_price AS (
	SELECT
		olist_customers_dataset.customer_zip_code_prefix AS zip,
		SUM(olist_order_items_dataset.price) AS sum_price
	FROM olist_order_items_dataset
	JOIN olist_orders_dataset
		ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
	JOIN olist_customers_dataset
		ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
	GROUP BY 1
),
total_payments AS (
	SELECT
		olist_customers_dataset.customer_zip_code_prefix AS zip,
		SUM(payment_value) AS sum_payments
	FROM olist_order_payments_dataset
	JOIN olist_orders_dataset
		ON 	olist_order_payments_dataset.order_id = olist_orders_dataset.order_id
	JOIN olist_customers_dataset
		ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
	GROUP BY 1
)
SELECT
	total_price.zip AS "Zip",
	sum_price AS "Revenue Before Shipping",
	sum_payments AS "Revenue After Shipping",
	olist_geolocation_dataset.geolocation_lat AS "Zip Code Lat",
	olist_geolocation_dataset.geolocation_lng AS "Zip Code Long"
FROM total_price
JOIN total_payments
	ON total_price.zip =  total_payments.zip
JOIN olist_geolocation_dataset
	ON total_price.zip = olist_geolocation_dataset.geolocation_zip_code_prefix;

/*
Average Order Value, Including Shipping
******BIG ISSUE. amount paid does not always match with price+delivery!!!
*/

SELECT AVG(payment_value) AS "Average Order Value"
FROM olist_order_payments_dataset;


/*
Revenue and Number of Items Sold from each Product Category
*/

SELECT 
	product_category_name_translation.product_category_name_english AS "Category",
	COUNT(*) AS "Number Sold",
	SUM(olist_order_items_dataset.price) AS "Revenue"
FROM olist_order_items_dataset
JOIN olist_products_dataset
	ON olist_order_items_dataset.product_id = olist_products_dataset.product_id
JOIN product_category_name_translation
	ON olist_products_dataset.product_category_name = product_category_name_translation.product_category_name
GROUP BY 1
ORDER BY 3 DESC;


/*
Checking Geolcation Data for duplicate zipcodes
*/

SELECT
	geolocation_zip_code_prefix,
	COUNT(*)
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(*) > 1;




/*
There may be an issue in that, the number of orders in each table differs. Below is the code investigating this.
*/

SELECT
	DISTINCT order_status
FROM olist_orders_dataset;

SELECT
	order_status,
	COUNT(order_status)
FROM olist_orders_dataset
GROUP BY order_status;

SELECT 
	COUNT(DISTINCT order_id)
FROM olist_order_payments_dataset;

SELECT 
	COUNT(DISTINCT order_id)
FROM olist_order_items_dataset;

/*
Finding out the order_status of the orders not included in olist_order_items_dataset
*/

WITH uniq_in_items AS (
SELECT 
	DISTINCT order_id
FROM olist_order_items_dataset
)

SELECT
	olist_orders_dataset.order_id,
	order_status,
	COUNT(order_status)
FROM olist_orders_dataset
LEFT JOIN uniq_in_items
	ON olist_orders_dataset.order_id = uniq_in_items.order_id
WHERE uniq_in_items.order_id IS NULL
GROUP BY order_status;