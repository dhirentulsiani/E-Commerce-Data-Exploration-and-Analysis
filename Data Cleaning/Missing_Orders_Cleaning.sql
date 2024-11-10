/*
Multiple tables use the column 'order_id', each table ought to have the same number of distinct 'order_id' values. Here are my counts for distinct 'order_id' in the 
relevant tables (please excuse the informal names for the tables):

Orders Dataset: 99441

Customers: 99441

Order_items: 98666

Order_Payments: 99440

Order_reviews: 98673


Orders and customers tables are the same, payments is basically the same, order_items and order_reviews are the main issues

The one order_id value missing from the Order_Payments dataset is investigated in the nulls_and_dupes file

This file focus's on the missing values in the order_items and order_reviews tables.
*/




/*
Here is a query to test whether the both tables have (mostly) the same missing values.

Unfortunately the query revealed that the tables only had 19 missing values in common (database browser automatically counted rows).
*/

WITH uniq_in_items AS (
SELECT 
	DISTINCT order_id
FROM olist_order_items_dataset
),

uniq_in_reviews AS (
SELECT
	DISTINCT order_id
FROM olist_order_reviews_dataset
)

SELECT
	olist_orders_dataset.order_id,
	uniq_in_items.order_id,
	uniq_in_reviews.order_id
FROM olist_orders_dataset
LEFT JOIN uniq_in_items
	ON olist_orders_dataset.order_id = uniq_in_items.order_id
LEFT JOIN uniq_in_reviews
	ON olist_orders_dataset.order_id = uniq_in_reviews.order_id
WHERE uniq_in_items.order_id IS NULL AND uniq_in_reviews.order_id IS NULL;



/*
Finding out the order_status of the orders not included in olist_order_items_dataset

We discuss the results after the query
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

/*
From the query we see that the orders that are missing have status's: canceled, created, invoiced, shipped, unavailable.

Every order that is missing did not end up being delivered to the customer. However, there are 2965 undelivered orders but only 775 missing orders in the 
order_items table.

Similary the query shows there are 164 missing orders in the order_items table with the status 'cancelled', but there are 625 orders in the dataset with the status
'cancelled'. Similar statement same can be made for each of the status's listed in the first line.

Thus we have found a clue as to why the orders may be missing (they were not delivered to the customer) but not the whole story.


Overall the missing orders in the order_items table will affect analysis related to the items purchased, delivery costs (but not time taken to deliver), 
seller purchased from, and possibly price discounts.

Purchase date and customer location are unaffected
*/





/*
PROBABLY DELETE THIS LATER

In the nuls_and_dupes file we found orders with dupilicate review_id entries in the order_review_tables.
Here is a query to test if those orders correspond with missing values in the order_items table.

Unfortunately only 63 match out of a possible 775.
*/

WITH uniq_in_items AS (
SELECT 
	DISTINCT order_id
FROM olist_order_items_dataset
),

missing_order_items AS (
SELECT
	olist_orders_dataset.order_id AS oid,
	uniq_in_items.order_id
FROM olist_orders_dataset
LEFT JOIN uniq_in_items
	ON olist_orders_dataset.order_id = uniq_in_items.order_id
WHERE uniq_in_items.order_id IS NULL
),

duped_reviews AS (
SELECT
	review_id,
	COUNT(*) AS instances
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING instances > 1
),
duped_order_ids AS (
SELECT
	olist_order_reviews_dataset.order_id AS order_id
FROM olist_order_reviews_dataset
JOIN duped_reviews
	ON olist_order_reviews_dataset.review_id = duped_reviews.review_id
)

SELECT
	*
FROM duped_order_ids
JOIN missing_order_items
	ON duped_order_ids.order_id = missing_order_items.oid;


/*
Missing values JOIN template
*/

WITH uniq_in_items AS (
SELECT 
	DISTINCT order_id
FROM olist_order_items_dataset
),

missing_order_items AS (
SELECT
	olist_orders_dataset.order_id AS oid,
	uniq_in_items.order_id
FROM olist_orders_dataset
LEFT JOIN uniq_in_items
	ON olist_orders_dataset.order_id = uniq_in_items.order_id
WHERE uniq_in_items.order_id IS NULL
)

SELECT 
	*
FROM olist_order_reviews_dataset

JOIN missing_order_items
	ON olist_order_reviews_dataset.order_id = missing_order_items.oid;