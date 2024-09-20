/*
Setting Primary Keys:
olist_customers_dataset: customer_id
olist_order_items_dataset: order_id, order_item_id
olist_order_payments_dataset: order_id, payment_sequential
olist_orders_dataset: order_id
olist_products_dataset: product_id
olist_sellers_dataset: seller_id
product_category_name_translation: product_category_name

olist_order_reviews_dataset: Primary Key should be review_id but unable. Errors from data entry. Investigated below
olist_geolocation_dataset: Unable to set a primary key. Possibly because of decimal points of long and lat, 
						   it is not of consequence for this analysis

*/





/*
Finding review_id duplcates
*/

SELECT
	review_id,
	COUNT(*) AS instances
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING instances > 1;


/*
After investigating through my database viewer, I found that when the review_id is repeated the order_id is always different, yet every other 
column (data about the actual review, i.e score, comments) remains the same. This means that creator of the dataset made a mistake inputting these rows. 
It is impossible or difficult to find which order_id the review actually corresponds too 

I am not deleting duplicate instances yet as they may still come in handy.
*/

/*
My database viewer allows me to easily identify columns that contain a NULL value. Later I may create a stored procedure 

 Below are the tables and columns containing nulls:

Table : column1, column2, ...

olist_order_reviews_dataset : review_comment_title, review_comment_message
orders: order_approved_at, order_delivered_carrier_date, order_delivered_customer_date,
olist_products_dataset: product_category_name, product_name_length, product_description_length, product_photos_qty, 2 products do not have dimensions.

*/


/*
Some orders do not have a timestamp for when they were approved, but have been delivered. 
So do not use approved_at timestamp for measuring delivery time, use purchase timestamp


Some orders were never delivered (to carrier or customer), but were approved and have a purchase timestamp, and an entry in order_payments.
Some orders have been delivered to carrier but not to customer, it does not seem to be a matter of the dataset being gathered too early, 
though there may be fringe instances of this.

8 entries where order_status is delivered, but no delivery timestamp. They do appear in order_items atleast sometimes.
*/


/*
There is one order with a purchase timestamp that might not be in the order_payments table

Here is the Query I used to find it
*/

WITH distinct_payments AS (
	SELECT 
		DISTINCT order_id AS ord_id
	FROM olist_order_payments_dataset
)

SELECT
	olist_orders_dataset.order_id,
	distinct_payments.ord_id
FROM olist_orders_dataset
LEFT JOIN distinct_payments
	ON olist_orders_dataset.order_id = distinct_payments.ord_id
WHERE distinct_payments.ord_id IS NULL

--bfbd0f9bdef84302105ad712db648a6c
--Note that this order has been fully delivered as well, but still doesn't show up in the olist_order_payments_dataset

/*
In the olist_products_dataset, product_category_name, product_description_length, product_name_length, and product_photos_qty all have matching nulls.
I used my database viewing program to figure this out

*/



