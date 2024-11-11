/*
First lets find the number of orders from each city.

It may look like we are counting the number of customers, but due to the way the dataset is set up, 
this actually counts the number of orders (since customer_id is seperate from customer_unique_id)
*/

SELECT
	customer_city,
	COUNT(*) AS num_customers
FROM olist_customers_dataset
GROUP BY customer_city
ORDER BY 2 DESC

/*
Our Goal is to find big cities with a relatively low number of orders.

To do this lets calculate the ratio of orders to city population.
*/

WITH Orders_by_City AS (
SELECT
	customer_city,
	COUNT(*) AS num_orders
FROM olist_customers_dataset
GROUP BY customer_city
ORDER BY 2 DESC
)
SELECT
	customer_city,
	num_orders,
	Population,
	CAST(num_orders AS REAL) * 10000 / Population AS order_pop_ratio
FROM Orders_by_City
JOIN City_Populations
ON Orders_by_City.customer_city = City_Populations.Cities
ORDER BY 3 DESC
LIMIT 50;

# Some cities with a low orders to population are: fortaleza, manaus (by far the lowest ratio), maceio.

/*
Currently olist does not do any advertising. Their ways of increasing sales are: lowering product price, freight costs, delivery time, and increasing store reputation.

Let us see investigate whether high frieght costs or delivery time is the reason these cities have a low number of orders relative to their population.
(also check how close to estimate).

Check the data cleaning folder to see how we created the delivered_orders table
*/ 


/*
Avg Freight/Delivery Costs by City

We will need to use the olist_order_items table, which we found out has missing orders (data cleaning process).

Luckily the missing orders are all undelivered orders, so every order we are considering is included in the table.
*/

WITH deliv_costs AS (
SELECT
	order_id,
	SUM(freight_value) AS delivery_cost
FROM olist_order_items_dataset
GROUP BY order_id
),
cost_and_city AS (
SELECT
	delivered_orders.order_id,
	deliv_costs.delivery_cost,
	customer_city
FROM delivered_orders
JOIN deliv_costs
	ON delivered_orders.order_id = deliv_costs.order_id
JOIN olist_customers_dataset
	ON delivered_orders.customer_id = olist_customers_dataset.customer_id
)

SELECT
	customer_city,
	AVG(delivery_cost)
FROM cost_and_city
GROUP BY customer_city;



/*
Avg Delivery Length by City
*/

WITH delivery_length_per_order AS (
SELECT
	order_id,
	julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp) AS delivery_length
FROM delivered_orders
),
length_and_city AS (
SELECT
	delivered_orders.order_id,
	delivery_length_per_order.delivery_length,
	customer_city
FROM delivered_orders
JOIN delivery_length_per_order
	ON delivered_orders.order_id = delivery_length_per_order.order_id
JOIN olist_customers_dataset
	ON delivered_orders.customer_id = olist_customers_dataset.customer_id
)

SELECT
	customer_city,
	AVG(delivery_length)
FROM length_and_city
GROUP BY customer_city;


/*
Joining the three queries above into 1 table used for data analysis, and saving it to the database.

 Note we saved each of the queries as a View using out Database Browser.
*/

CREATE TABLE Cities_and_Delivery AS
	SELECT
		*
	FROM Temp_Order_pop_ratio
	JOIN Temp_avg_cost_by_city
		ON Temp_Order_pop_ratio.customer_city = Temp_avg_cost_by_city.customer_city
	JOIN Temp_avg_len_by_city
		ON Temp_Order_pop_ratio.customer_city = Temp_avg_len_by_city.customer_city
	ORDER BY Temp_Order_pop_ratio.Population DESC;


/*
Cleaning:
Delete Duplicate City columns
Rename columns
Added states

*/


/*
New table including customer and seller locations with olist_order_items table.

*/

CREATE TABLE products_and_location AS
SELECT 
	olist_order_items_dataset.order_id,
	olist_orders_dataset.customer_id,
	olist_order_items_dataset.product_id,
	olist_order_items_dataset.seller_id,
	olist_customers_dataset.customer_city,
	olist_customers_dataset.customer_state,
	olist_sellers_dataset.seller_city,
	olist_sellers_dataset.seller_state,
	olist_order_items_dataset.freight_value,
	julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp) AS delivery_length
	
FROM olist_order_items_dataset
JOIN olist_orders_dataset
	ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
JOIN olist_customers_dataset
	ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
JOIN olist_sellers_dataset
	ON olist_order_items_dataset.seller_id = olist_sellers_dataset.seller_id



/*
Data related to where a city buys its products from.
*/

SELECT
	customer_state,
	seller_state,
	COUNT(*),
	AVG(freight_value),
	AVG(delivery_length)
FROM products_and_location
GROUP BY customer_state, seller_state;

/*
IDK BELOW
*/


WITH Prices AS (
SELECT
	order_id,
	SUM(price) + SUM(freight_value) AS total_price
FROM olist_order_items_dataset
GROUP BY 1
ORDER BY 2 DESC;
),
Payments AS (
SELECT


)
