/*
==================================================
Project : Farmers Market Analytics

Report  : ABC Product Analysis

Author  : Jieyu Ke

Description

Categorizes products into A, B, and C groups
based on cumulative revenue contribution.

Metrics

- Product ID
- Product Name
- Total Revenue
- Revenue Percentage
- Cumulative Revenue Percentage
- ABC Category

Skills Used

- CTE
- JOIN
- GROUP BY
- Aggregate Functions
- Window Aggregate
- CASE
- Running Total
- NULLIF

==================================================
*/

WITH product_revenue_summary AS
(
    SELECT
        product_id,
        ROUND(
            SUM(quantity * cost_to_customer_per_qty),
            2
        ) AS product_total_revenue
    FROM customer_purchases
    GROUP BY product_id
),

product_revenue_analysis AS
(
    SELECT
        PRS.product_id,
        P.product_name,
        PRS.product_total_revenue,

        SUM(PRS.product_total_revenue) OVER () AS total_revenue,

        SUM(PRS.product_total_revenue) OVER
        (
            ORDER BY
                PRS.product_total_revenue DESC,
                PRS.product_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue

    FROM product_revenue_summary AS PRS
    JOIN product AS P
        ON PRS.product_id = P.product_id
),

product_percentage_analysis AS
(
    SELECT
        product_id,
        product_name,
        product_total_revenue,

        ROUND(
            product_total_revenue
            / NULLIF(total_revenue, 0)
            * 100,
            2
        ) AS revenue_percentage,

        ROUND(
            cumulative_revenue
            / NULLIF(total_revenue, 0)
            * 100,
            2
        ) AS cumulative_revenue_percentage

    FROM product_revenue_analysis
)

SELECT
    product_id,
    product_name,
    product_total_revenue,
    revenue_percentage,
    cumulative_revenue_percentage,

    CASE
        WHEN cumulative_revenue_percentage <= 80 THEN 'A'
        WHEN cumulative_revenue_percentage <= 95 THEN 'B'
        ELSE 'C'
    END AS abc_category

FROM product_percentage_analysis
ORDER BY
    product_total_revenue DESC,
    product_id;