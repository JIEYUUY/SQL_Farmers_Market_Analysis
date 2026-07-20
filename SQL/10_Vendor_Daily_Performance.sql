/*
==================================================
Project : Farmers Market Analytics

Report  : Vendor Daily Performance

Author  : Jieyu Ke

Description

Summarizes each vendor's daily sales performance,
including orders, quantity sold, revenue,
and daily revenue ranking.

Metrics

- Market Date
- Vendor ID
- Vendor Name
- Total Orders
- Total Quantity Sold
- Total Revenue
- Daily Revenue Rank

Skills Used

- CTE
- JOIN
- GROUP BY
- Aggregate Functions
- COUNT(DISTINCT)
- Window Function (RANK)

==================================================
*/

WITH vendor_daily_summary AS
(
    SELECT
        market_date,
        vendor_id,
        COUNT(DISTINCT CONCAT (market_date,"-",vendor_id,"-",transaction_time)) AS total_orders,
        SUM(quantity) AS total_quantity_sold,
        ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS total_revenue
    FROM customer_purchases
    GROUP BY vendor_id,market_date
)
SELECT
	VDP.market_date,
    VDP.vendor_id,
    V.vendor_name,
    VDP.total_orders,
    VDP.total_quantity_sold,
    VDP.total_revenue,
    RANK() OVER(PARTITION BY market_date
				ORDER BY total_revenue DESC) AS revenue_rank
FROM vendor_daily_summary AS VDP
JOIN vendor AS V ON  VDP.vendor_id = V.vendor_id
ORDER BY revenue_rank, market_date;		
    