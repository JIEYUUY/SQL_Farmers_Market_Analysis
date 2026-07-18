/*
==================================================
Project : Farmers Market Analytics

Report  : Customer Favorite Vendor

Author  : Jieyu Ke

Description

Summarizes customer spending by vendor and identifies each customer's favorite vendor.

Metrics:

- Customer id
- Vendor id
- Total spending
- Total spending rank

Skills Used

- CTE
- GROUP BY
- Aggregate Functions
- Window Function (RANK)

==================================================
*/

WITH customer_vendor_summary AS
(
	SELECT
        customer_id,
        vendor_id,
        SUM(quantity * cost_to_customer_per_qty) AS total_spending
    FROM customer_purchases
    GROUP BY customer_id,vendor_id
),
ranked_customer_vendors AS
(
    SELECT
		customer_vendor_summary.*,
        RANK() OVER (PARTITION BY customer_id
					 ORDER BY total_spending DESC
        ) AS total_spending_rank
    FROM customer_vendor_summary
)

SELECT
    customer_id,
    vendor_id,
    total_spending
FROM ranked_customer_vendors
WHERE total_spending_rank = 1 ;
