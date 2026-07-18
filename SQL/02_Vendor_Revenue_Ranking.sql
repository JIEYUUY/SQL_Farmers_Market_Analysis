/*
==================================================
Project : Farmers Market Analytics

Report  : Vendor Revenue Ranking

Author  : Jieyu Ke

Description

Ranks vendors by total revenue and summarizes their sales performance.

Metrics:

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

WITH vendor_summary AS
(
	SELECT
        vendor_id,
        COUNT(DISTINCT customer_id) AS customer_count,
        SUM(quantity * cost_to_customer_per_qty) AS total_revenue,
        SUM(quantity) AS total_quantity,
        COUNT(*) AS transaction_count
    FROM customer_purchases
    GROUP BY vendor_id
),
revenue_rank AS
(
    SELECT
		vendor_summary.*,
        RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS ranked_vendors
    FROM vendor_summary
)

SELECT
    vendor_id,
    customer_count,
    total_revenue,
    total_quantity,
    transaction_count,
    ranked_vendors
FROM revenue_rank
ORDER BY ranked_vendors;
