/*
==================================================
Project : Farmers Market Analytics

Report  : Vendor Customer Analysis

Author  : Jieyu Ke

Description

Analyze how many different customers each vendor has.

Metrics:

- Vendor ID
- Vendor Name
- Customer ID
- Average Spending Per Customer Rank
- Revenue rank

Skills Used

- CTE
- JOIN
- GROUP BY
- Aggregate Functions
- Window Function (RANK)

==================================================
*/

WITH vendor_customer_summary AS
(
    SELECT
        vendor_id,
        customer_id,
        ROUND(AVG(quantity * cost_to_customer_per_qty / ),2) AS average_spending_per_customer
    FROM customer_purchases
    GROUP BY vendor_id, customer_id
),

ranked_vendor_customer AS
(
    SELECT
        VC.vendor_id,
        V.vendor_name,
        VC.customer_id,
        VC.average_spending_per_customer,
        RANK() OVER
        (
            PARTITION BY VC.vendor_id
            ORDER BY VC.average_spending_per_customer DESC
        ) AS verage_spending_per_customer_rank
    FROM vendor_customer_summary AS VC
    JOIN vendor AS V
        ON VC.vendor_id = V.vendor_id
)

SELECT
	vendor_id,
	vendor_name,
	customer_id,
	verage_spending_per_customer_rank

FROM ranked_vendor_customer
WHERE verage_spending_per_customer_rank = 1
ORDER BY vendor_id;
