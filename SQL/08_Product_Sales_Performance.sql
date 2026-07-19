/*
==================================================
Project : Farmers Market Analytics

Report  : Product Sales Performance

Author  : Jieyu Ke

Description

Analyzes product sales performance by measuring total
quantity sold, total revenue, and unique customer reach.

Metrics:

- Product ID
- Product Name
- Total Quantity Sold
- Total Revenue
- Customer Count
- Revenue Rank

Skills Used

- CTE
- JOIN
- GROUP BY
- Aggregate Functions
- COUNT(DISTINCT)
- Window Function (RANK)

==================================================
*/

WITH product_sales_summary AS
(
    SELECT
        product_id,
        SUM(quantity) AS total_quantity_sold,
        ROUND(
            SUM(quantity * cost_to_customer_per_qty),
            2
        ) AS total_revenue,
        COUNT(DISTINCT customer_id) AS customer_count
    FROM customer_purchases
    GROUP BY product_id
),

product_performance AS
(
    SELECT
        PSS.product_id,
        P.product_name,
        PSS.total_quantity_sold,
        PSS.total_revenue,
        PSS.customer_count
    FROM product_sales_summary AS PSS
    JOIN product AS P
        ON PSS.product_id = P.product_id
)

SELECT
    product_id,
    product_name,
    total_quantity_sold,
    total_revenue,
    customer_count,
    RANK() OVER
    (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM product_performance
ORDER BY revenue_rank, product_id;