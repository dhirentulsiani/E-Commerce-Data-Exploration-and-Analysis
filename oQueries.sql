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
Calculating number of orders and customers by state
*/
SELECT
	customer_state AS "State",
	COUNT(DISTINCT customer_id) AS "Number of Orders",
	COUNT(DISTINCT customer_unique_id) AS "Number of Customers"
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY 3 DESC;

/*
Calculating number of orders and customers by state
*/
SELECT
	customer_city AS "City",
	COUNT(DISTINCT customer_id) AS "Number of Orders",
	COUNT(DISTINCT customer_unique_id) AS "Number of Customers"
FROM olist_customers_dataset
GROUP BY 1
ORDER BY 3 DESC;

/*
Counting the number of top 50 cities by total customers in each state

Avg percentile of cities in each state
*/
Incomplete

/*
Total Sales
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
Total Sales By Zip
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
	sum_payments AS "Revenue After Shipping"
FROM total_price
JOIN total_payments
	ON total_price.zip =  total_payments.zip;

