/*
==================================================
Project : Farmers Market Analytics

Report  : Daily Market Summary

Author  : Jieyu Ke

Description

This report summarizes daily market performance.

Metrics

- Total Revenue
- Total Quantity
- Transaction Count
- Customer Count
- Revenue Rank

Skills Used

- CTE
- GROUP BY
- Aggregate Functions
- Window Function (RANK)

==================================================
*/

WITH revenue_data AS
(
SELECT 
	market_date,
	COUNT(DISTINCT customer_id) AS total_num_of_customers,
	SUM(quantity * cost_to_customer_per_qty) AS total_revenue,
    SUM(quantity) AS total_qty,
    COUNT(*) AS number_of_transactions
FROM customer_purchases
GROUP BY market_date
),
ranked_revenue AS
(
SELECT
	revenue_data.*,
	RANK() OVER(ORDER BY total_revenue DESC) AS total_revenue_rank
	FROM revenue_data
)
SELECT
	ranked_revenue.*
FROM ranked_revenue
