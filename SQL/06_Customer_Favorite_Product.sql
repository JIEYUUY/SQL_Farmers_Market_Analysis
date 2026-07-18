/*
==================================================
Project : Farmers Market Analytics

Report  : Customer Favorite Product

Author  : Jieyu Ke

Description

Summarizes customer spending by product and identifies
each customer's favorite product based on total spending.

Metrics:

- Customer Id
- Product ID
- Product name
- Total Spending
- Revenue rank

Skills Used

- CTE
- JOIN
- GROUP BY
- Aggregate Functions
- Window Function (RANK)

==================================================
*/

WITH customer_product_summary AS
(
    SELECT
        customer_id,
        product_id,
        SUM(quantity * cost_to_customer_per_qty) AS total_spending
    FROM customer_purchases
    GROUP BY customer_id, product_id
),

ranked_customer_products AS
(
    SELECT
		CP.customer_id,
        P.product_id,
        P.product_name,
        CP.total_spending,
        RANK() OVER
        (
            PARTITION BY CP.customer_id
            ORDER BY CP.total_spending DESC
        ) AS revenue_rank
    FROM customer_product_summary AS CP
    JOIN product AS P
        ON CP.product_id = P.product_id
)

SELECT
	customer_id,
	product_id,
	product_name,
	total_spending,
    revenue_rank
FROM ranked_customer_products
WHERE revenue_rank = 1
ORDER BY customer_id;