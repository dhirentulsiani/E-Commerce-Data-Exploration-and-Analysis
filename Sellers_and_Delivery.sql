/*
To-Do List

num sellers by city
Num orders, Delivery cost by seller location and customer location.
Customer location by seller location

Nearly all items 70ish% of items sold are in SP.
Look at belo horizonte, high number of sellers in city and state, it has great order to pop ratio, vs forteleza, very low number of sellers and items sold in city and state
and it has very low order to pop ratio. Note belo hor. has signifincantly greater GDP per capita than fort. But fort has higher than SP and RJ (state)

Increasing number of sellers near big cities with low order to pop ratios should increase sales:
Is this really feasible? Are there structural or inherent reasons why low number of sellers, Which categories in these states should we focus on? Look at what customers like 
And also what is possible to produce in the state.

Product category by seller(?)

*/



/*
Number of Sellers by City and the number of sellers in that state
*/

WITH temp_city AS (
SELECT
	seller_city,
	seller_state,
	COUNT(*) AS num_sellers
FROM olist_sellers_dataset
GROUP BY seller_city
ORDER BY num_sellers DESC
),
temp_state AS (
	SELECT
		seller_state,
		COUNT(*) AS num_sellers_state
	FROM olist_sellers_dataset
	GROUP BY seller_state
	ORDER BY num_sellers_state DESC
)
SELECT
	*
FROM temp_city
JOIN temp_state
	ON temp_city.seller_state = temp_state.seller_state;

/*
Num Items Sold by each Seller
*/
SELECT
	seller_id,
	COUNT(*) AS num_items_sold
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY 2 DESC;

/*
Total Items Sold by Sellers in Each City, an almost identical query can be used to find the information by State intstead.
*/

WITH temp_sellers AS (
SELECT
	seller_id,
	COUNT(*) AS num_items_sold
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY 2 DESC
),
temp_table AS (
SELECT
	*
FROM temp_sellers
JOIN olist_sellers_dataset
	ON temp_sellers.seller_id = olist_sellers_dataset.seller_id
)
SELECT
	seller_city,
	seller_state,
	SUM(num_items_sold) as total_items_sold
FROM temp_table
GROUP BY seller_city
ORDER BY 3 DESC;


/*
Getting 
*/

