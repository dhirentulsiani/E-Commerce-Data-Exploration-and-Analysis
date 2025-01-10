/*
This final table generated is for use in Power Bi.

It is based off the 'olist_order_items_dataset' table but includes more information like customer location.

This table may be used to calculate Sales in Power Bi, however we discovered in the 'Payment_Investigation.sql' file that the
revenue data collected in this manner will be slightly innaccurate. Namely R$3233 (517USD) will be miscounted, the total revenue is R$15.32 Million.

We are using this table to calculate Sales and not the more accuracte table, as the accurate table needs to be significantly adjusted to do what we need in Power Bi.
I think the difference is negligible and I am short on time so it is worth it to use the innaccurate version.

For now, we will not delete the orders that are causing issues as I want as many orders as possible and the total error is very small relative to total Revenue.

*/

/*
Quick Data Cleaning: Add Product Category Name in English to 'olist_products_dataset'
Creates a new version of the products table containing the product category name in English.
Then used the database browser to the old table with this one, the final name will be the same as before, i.e 'olist_products_dataset'
*/

CREATE TABLE olist_products_dataset_new AS 
	SELECT
		*
	FROM olist_products_dataset
	JOIN product_category_name_translation
		ON olist_products_dataset.product_category_name = product_category_name_translation.product_category_name;


/*
To Add to table:
purchase date (done)
revenue, i.e price+sales (done)
customer location (city, state) (oone)
seller location (city, state) (done)
product category name english (done)
Review Score (done)
*/
SELECT
	olist_order_items_dataset.*,
	olist_order_items_dataset.price + olist_order_items_dataset.freight_value AS "Total Revenue",
	DATE(olist_orders_dataset.order_purchase_timestamp) AS "Purchase Date",
	olist_customers_dataset.customer_city,
	olist_customers_dataset.customer_state,
	olist_sellers_dataset.seller_city,
	olist_sellers_dataset.seller_state,
	olist_products_dataset.product_category_name_english,
	olist_order_reviews_dataset.review_score
	
FROM olist_order_items_dataset
JOIN olist_orders_dataset
	ON olist_order_items_dataset.order_id = olist_orders_dataset.order_id
JOIN olist_customers_dataset
	ON olist_orders_dataset.customer_id = olist_customers_dataset.customer_id
JOIN olist_sellers_dataset
	ON olist_order_items_dataset.seller_id = olist_sellers_dataset.seller_id
JOIN olist_products_dataset
	ON olist_order_items_dataset.product_id = olist_products_dataset.product_id
JOIN olist_order_reviews_dataset
	ON olist_order_items_dataset.order_id = olist_order_reviews_dataset.order_id

/*
There are 1739 rows less than the order_items table.

This is mostly due to join from order_items to products_dataset tables. (108630 rows if you just join those 2, out of 110189 in order_items, 108450 in General Table currently)
Yep, it looks like there are many product_ids in the order_items table that dont exist in the products_dataset table.

IS this to account for orders deleted due to cleaning investigations, but i have code where i deleted those already

*/