/*
The dataset lists the product price and delivery charge in the 'olist_order_items_dataset table' for every item bought, 
It also provides data for the total amount the customer actually paid customer paid.
This query checks how close these two values are for every order  
*/

WITH item_table AS (
	SELECT
	order_id,
	SUM(price) + SUM(freight_value) AS price_plus_delivery
	FROM olist_order_items_dataset
	GROUP BY order_id
),
payment_table AS (
	SELECT
		order_id,
		SUM(payment_value) AS sum_payment_value
	FROM olist_order_payments_dataset
	GROUP BY order_id
)

SELECT
	item_table.order_id,
	item_table.price_plus_delivery,
	payment_table.sum_payment_value,
	item_table.price_plus_delivery - payment_table.sum_payment_value
FROM item_table
JOIN payment_table
	ON item_table.order_id = payment_table.order_id
ORDER BY 4 DESC;

/*
From the query above we find there are 18 orders with a significant difference (>= $1, note. Brazillian Real not USD). With the largest difference being $51.62.

Normally discounts are accounted for in the 'olist_order_items_dataset' table. The amount in the price column (in said table) can be different for the same product, 
and notably the prices often reduce on Black Friday.

However the amount missing often matches percentages divisible by 10 or 5 on the item prices, so it is likely discounts that have not been accounted for properly.
*/
