/*
==================================================
Project : Farmers Market Analytics

Report  : Vendor Best-Selling Product

Author  : Jieyu Ke

Description

Summarizes product revenue by vendor and identifies
each vendor's best-selling product based on total revenue.

Metrics:

- Vendor ID
- Vendor name
- Product ID
- Product name
- Total revenue
- Revenue rank

Skills Used

- CTE
- JOIN
- GROUP BY
- Aggregate Functions
- Window Function (RANK)

==================================================
*/

WITH vendor_product_summary AS
(
    SELECT
        product_id,
        vendor_id,
        SUM(quantity * cost_to_customer_per_qty) AS total_revenue
    FROM customer_purchases
    GROUP BY vendor_id, product_id
),

ranked_vendor_products AS
(
    SELECT
        PV.product_id,
        P.product_name,
        PV.vendor_id,
        V.vendor_name,
        PV.total_revenue,
        RANK() OVER
        (
            PARTITION BY PV.vendor_id
            ORDER BY PV.total_revenue DESC
        ) AS revenue_rank
    FROM vendor_product_summary AS PV
    JOIN vendor AS V
        ON PV.vendor_id = V.vendor_id
    JOIN product AS P
        ON PV.product_id = P.product_id
)

SELECT
    vendor_id,
    vendor_name,
    product_id,
    product_name,
    total_revenue,
    revenue_rank
FROM ranked_vendor_products
WHERE revenue_rank = 1
ORDER BY vendor_id;