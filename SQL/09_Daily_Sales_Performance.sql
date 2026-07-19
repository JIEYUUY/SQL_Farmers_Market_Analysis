/*
==================================================
Project : Farmers Market Analytics

Report  : Daily Sales Performance

Author  : Jieyu Ke

Description

Summarizes daily market performance by measuring
orders, quantity sold, revenue, and customer activity.

Metrics

- Market Date
- Total Orders
- Total Quantity Sold
- Total Revenue
- Customer Count
- Revenue Rank

Skills Used

- CTE
- GROUP BY
- Aggregate Functions
- COUNT(DISTINCT)
- Window Function (RANK)

==================================================
*/

WITH daily_performance AS
(
    SELECT
        market_date,
        COUNT(*) AS total_orders,
        SUM(quantity) AS total_quantity_sold,
        ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS total_revenue,
        COUNT(DISTINCT customer_id) AS customer_count
    FROM customer_purchases
    GROUP BY market_date
)
SELECT
	market_date,
    total_orders,
    total_quantity_sold,
    total_revenue,
    customer_count,
    RANK() OVER(ORDER BY total_revenue DESC) AS revenue_rank
FROM daily_performance
ORDER BY revenue_rank, market_date;				 
    