/*
==================================================
Project : Farmers Market Analytics

Report  : Monthly Sales Trend Analysis

Author  : Jieyu Ke

Description

Analyzes monthly sales performance based on
revenue, order volume, customer activity, and
average order value.

Metrics

- Sales Month
- Total Revenue
- Total Orders
- Customer Count
- Average Order Value
- Revenue Rank

Skills Used

- CTE
- DATE_FORMAT
- GROUP BY
- Aggregate Functions
- COUNT DISTINCT
- NULLIF
- Window Function
- RANK

==================================================
*/

WITH monthly_sales_summary AS
(
SELECT 
	DATE_FORMAT(market_date,'%Y-%m') AS sales_month,
	ROUND(
			SUM(quantity * cost_to_customer_per_qty),
            2
        ) AS total_revenue,
	COUNT(DISTINCT CONCAT_WS("-",customer_id,market_date,transaction_time)) AS total_orders,
    COUNT(DISTINCT customer_id) AS customer_count
FROM customer_purchases
GROUP BY DATE_FORMAT(market_date,'%Y-%m')
)
SELECT 
	sales_month,
    total_revenue,
    total_orders,
    customer_count,
    ROUND(total_revenue/NULLIF(total_orders,0),2) AS average_order_value,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM monthly_sales_summary
ORDER BY revenue_rank