/*
==================================================
Project : Farmers Market Analytics

Report  : Top 3 Products by Vendor

Author  : Jieyu Ke

Description

Identifies the top three best-selling products for
each vendor based on total revenue.

Metrics

- Vendor ID
- Vendor Name
- Product ID
- Product Name
- Total Revenue
- Revenue Rank

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
        vendor_id,
		product_id,
        ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS total_revenue
    FROM customer_purchases
    GROUP BY vendor_id,product_id
),
ranked_vendor_products AS
(
SELECT
    VPS.vendor_id,
    V.vendor_name,
    VPS.product_id,
    P.product_name,
    VPS.total_revenue,
    RANK() OVER(PARTITION BY VPS.vendor_id
				ORDER BY VPS.total_revenue DESC) AS revenue_rank
FROM vendor_product_summary AS VPS
JOIN vendor AS V ON VPS.vendor_id = V.vendor_id
JOIN product AS P ON VPS.product_id = P.product_id
)
SELECT
    vendor_id,
    vendor_name,
    product_id,
    product_name,
    total_revenue,
	revenue_rank
FROM ranked_vendor_products
WHERE revenue_rank <= 3
ORDER BY vendor_id,revenue_rank;	
