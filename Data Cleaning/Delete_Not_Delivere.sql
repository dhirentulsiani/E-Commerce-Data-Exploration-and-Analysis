/*
There is not much additional information about the orders that were not delivered. Many have the order_status 'cancelled', but many also have 
statuses like 'invoiced', 'processing', or "shipped", but the shipping limit date has long since passed and the order has not been delivered!! 
I suspect they were cancelled or lost but the data collectors did not update the dataset.

Most of reviews from the customers who's orders are marked undelivered are low star ratings. The fact that the order never arrived is mentioned 
in many of the review comments, including when the order_status is not 'cancelled'. 

However once in a while customers give a 5 star review and mention that they liked the product. The product is clearly marked undelivered or even has
order_status 'cancelled'. I am assuming that these 5 star reviews are written by review manipulators and/or bots, and that the data collectors
correctly marked the order as undelivered. 

Thus all reviews for undelivered orders will be deleted. 
Similarly I think its fair to assume the payments will be refunded too, so we have to delete undelivered orders from the payments table too

On top of that, for analysing things like Sales,  Number of Orders, Delivery Prices, I think it makes more sense not to include orders that have not been delivered.

Below are the queries we used to delete undelivered orders from the relevant tables.

Note the delivered_orders table was created in the Delivered_Orders_Cleaning file.

The queries are all extremely similar
*/

DELETE FROM olist_orders_dataset
WHERE order_id NOT IN (SELECT
						order_id
					FROM delivered_orders);

DELETE FROM olist_order_payments_dataset
WHERE order_id NOT IN (SELECT
						order_id
					FROM delivered_orders);


DELETE FROM olist_order_reviews_dataset
WHERE order_id NOT IN (SELECT
						order_id
					FROM delivered_orders);

DELETE FROM olist_order_items_dataset
WHERE order_id NOT IN (SELECT
						order_id
					FROM delivered_orders);
