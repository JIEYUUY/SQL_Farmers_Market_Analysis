/*
==================================================
Project : Farmers Market Analytics

Report  : Daily Revenue Growth Analysis

Author  : Jieyu Ke

Description

Analyzes daily revenue performance and compares each
market day's revenue with the previous market day.

Metrics

- Market Date
- Total Revenue
- Previous Revenue
- Revenue Change
- Revenue Growth Rate

Skills Used

- CTE
- GROUP BY
- Aggregate Functions
- Window Function (LAG)
- Arithmetic Calculations
- NULLIF

==================================================
*/
WITH daily_total_revenue AS
(
SELECT
	market_date,
	ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS total_revenue
FROM customer_purchases
GROUP BY market_date
),
daily_revenue_comparison AS
(
SELECT
	market_date,
    total_revenue,
    LAG(total_revenue) OVER(ORDER BY market_date) AS previous_revenue
FROM daily_total_revenue
)
SELECT
	market_date,
    total_revenue,
    previous_revenue,
    total_revenue - previous_revenue AS revenue_change,
    CONCAT(
		ROUND(
			(
			(total_revenue - NULLIF(previous_revenue,0))
            / previous_revenue
			) * 100
		,2)
    ,"%") AS revenue_growth_rate
FROM daily_revenue_comparison