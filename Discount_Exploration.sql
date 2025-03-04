SELECT
	olist_order_items_dataset.product_id,
	COUNT(*),
	olist_products_dataset.product_category_name_english
FROM olist_order_items_dataset
JOIN olist_products_dataset
	ON olist_order_items_dataset.product_id = olist_products_dataset.product_id
GROUP BY 1
ORDER BY 2 DESC;