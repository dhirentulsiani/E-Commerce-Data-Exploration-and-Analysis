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
	CAST(num_orders AS REAL) * 10000 / Population
FROM Orders_by_City
JOIN City_Populations
ON Orders_by_City.customer_city = City_Populations.Cities
ORDER BY 3 DESC
LIMIT 50;

# Some cities with a low orders to population are: fortaleza, manaus (by far the lowest ratio), maceio.

/*
Currently olist does not do any advertising. Their ways of increasing sales are: lowering product price, freight costs, delivery time, and increasing store reputation.

Let us see investigate whether high frieght costs or delivery time is the reason these cities have a low number of orders relative to their population.
(also check how close to estimate)
*/ 



