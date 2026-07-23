/*
==================================================
Project : Farmers Market Analytics

Report  : Customer Lifetime Value Analysis

Author  : Jieyu Ke

Description

Analyzes customer lifetime value by measuring
purchase frequency, total spending, average
order value, and customer ranking.

Metrics

- Customer Rank
- Customer Name
- First Purchase Date
- Last Purchase Date
- Purchase Days
- Total Orders
- Total Quantity Purchased
- Total Revenue
- Average Order Value
- Customer Lifetime Value

Skills Used

- Multiple CTE
- INNER JOIN
- DATE Functions
- COUNT DISTINCT
- SUM
- MIN
- MAX
- ROUND
- CASE
- DENSE_RANK
- Window Function

==================================================
*/

WITH customer_purchase_analysis AS
(
    SELECT 
        customer_id,
        MIN(market_date) AS first_purchase_date,
        MAX(market_date) AS last_purchase_date,
        DATEDIFF(MAX(market_date),MIN(market_date)) AS purchase_days,
        SUM(quantity) AS total_quantity_purchased,
        SUM(quantity * cost_to_customer_per_qty) AS total_revenue,
        COUNT(DISTINCT market_date) AS total_orders
    FROM customer_purchases
	GROUP BY customer_id
),
customer_spending_analysis AS
(
	SELECT
		CONCAT_WS(" ",C.customer_first_name,C.customer_last_name) AS customer_name,
		CPA.first_purchase_date,
		CPA.last_purchase_date,
		CPA.purchase_days,
		CPA.total_quantity_purchased,
		CPA.total_revenue,
		CPA.total_orders,
		ROUND((CPA.total_revenue / 
		NULLIF(CPA.total_orders,
		0)),
		2) AS average_order_value
	FROM customer_purchase_analysis AS CPA
	JOIN customer AS C
	ON CPA.customer_id = C.customer_id
)
SELECT
	customer_name,
    first_purchase_date,
    last_purchase_date,
    purchase_days,
    total_quantity_purchased,
    total_revenue,
    total_orders,
    average_order_value,
    (average_order_value * total_orders) AS customer_lifetime_value,
    DENSE_RANK() OVER(ORDER BY total_revenue DESC) AS customer_rank,
    CASE
    WHEN total_revenue < 1600 THEN 'Silver'
    WHEN total_revenue BETWEEN 1600 AND 3500 THEN 'Gold'
    ELSE 'VIP'
    END AS customer_type
FROM customer_spending_analysis
ORDER BY customer_rank;