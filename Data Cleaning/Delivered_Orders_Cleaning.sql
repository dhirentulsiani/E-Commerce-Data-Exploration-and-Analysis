/*
Delivery Related Dataset Issues, Table: olist_orders_dataset

Some orders were never delivered (to carrier or customer), but were approved and have a purchase timestamp, and an entry in order_payments.

Some orders have been delivered to carrier but not to customer, it does not seem to be a matter of the dataset being gathered too early, though there may be fringe instances of this.

8 entries where order_status is delivered, but no timestamp for delivery to the customer

2965 orders total seem not to have been delivered to customer. The lack of a delivery timestamp is not a result of 
the dataset being collected before they had a chance to deliver the orders. Most of these orders were purchased and expected to be delivered long before the latest orders of the
dataset

All but 6 of the 2963 with orders_status != "delivered" genuinely have not been delivered to the customer. All 6 of these exceptions have the order_status: "cancelled"

Some orders do not have a timestamp for when they were approved, but have been delivered. They do have a timestamp for when they were purchased 
*/

/*
Cleaning decisions:

Our goal is to get a table of the orders we can use to measure delivery time

Actions: 

Delete entries where order_status is not delivered. Note, I am deciding not to keep the 6 orders with cancelled status that have actually been delivered in-case there is a 
deeper data-collection issue. Though the 6 orders may potentially be valid for analysis, there are only 6 of them, so I believe they are not worth the risk.

Delete entries where order_status is delivered, but no timestamp for delivery to the customer. (The lack of a delivery timestamp is not a result of 
the dataset being collected before they had a chance to deliver the orders. As they were all purchased and expected to be delivered long before the latest orders of the
dataset)

*/

CREATE TABLE delivered_orders AS 
	SELECT *
	FROM olist_orders_dataset
	WHERE order_status = "delivered" AND order_delivered_customer_date IS NOT NULL;
