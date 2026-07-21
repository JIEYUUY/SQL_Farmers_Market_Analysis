/*
==================================================
Project : Farmers Market Analytics

Report  : Customer RFM Summary

Author  : Jieyu Ke

Description

Summarizes customer purchasing behavior using
basic RFM metrics.

Metrics

- Customer ID
- Customer Name
- Total Orders
- Total Spending
- Last Purchase Date

Skills Used

- CTE
- JOIN
- GROUP BY
- Aggregate Functions
- MAX
- COUNT
- SUM

==================================================
*/


WITH customer_purchase_summary AS
(
    SELECT
        customer_id,
        COUNT(DISTINCT CONCAT(customer_id,"-",market_date,"-",transaction_time)) AS total_orders,
		ROUND(
            SUM(quantity * cost_to_customer_per_qty),
            2
        ) AS total_spending,
        MAX(market_date) AS last_purchase_date
    FROM customer_purchases
    GROUP BY customer_id
 )
 SELECT
	CPS.customer_id,
    CONCAT(C.customer_first_name," ",C.customer_last_name) AS customer_name,
    CPS.total_orders,
    CPS.total_spending,
	CPS.last_purchase_date
FROM customer_purchase_summary AS CPS
JOIN customer AS C
ON CPS.customer_id = C.customer_id
 ORDER BY total_spending DESC, customer_id
