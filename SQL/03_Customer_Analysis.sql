/*
==================================================
Project : Farmers Market Analytics

Report  : Customer Analysis

Author  : Jieyu Ke

Description

Summarizes customer spending behavior and ranks customers by total spending.

Metrics:

- Customer id
- Transaction count
- Total spending
- Average spending
- Spending rank

Skills Used

- CTE
- GROUP BY
- Aggregate Functions
- Window Function (RANK)

==================================================
*/

WITH customer_summary AS
(
	SELECT
        customer_id,
        COUNT(*) AS transaction_count,
        SUM(quantity * cost_to_customer_per_qty) AS total_spending,
        AVG(quantity * cost_to_customer_per_qty) AS average_spending
    FROM customer_purchases
    GROUP BY customer_id
),
spending_rank AS
(
    SELECT
		customer_summary.*,
        RANK() OVER (
            ORDER BY total_spending DESC
        ) AS total_spending_rank
    FROM customer_summary
)

SELECT
    customer_id,
    transaction_count,
    total_spending,
    average_spending,
    total_spending_rank
FROM spending_rank
ORDER BY total_spending_rank ;
