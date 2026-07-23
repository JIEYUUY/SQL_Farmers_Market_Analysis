/*
==================================================
Project : Farmers Market Analytics

Report  : Vendor Monthly Revenue Growth Analysis

Author  : Jieyu Ke

Description

Analyzes monthly revenue performance for each
vendor and measures revenue changes compared
with the previous month.

Metrics

- Vendor Name
- Sales Month
- Total Quantity Sold
- Monthly Revenue
- Previous Month Revenue
- Revenue Change
- Revenue Growth Rate

Skills Used

- CTE
- INNER JOIN
- DATE_FORMAT
- SUM
- LAG
- PARTITION BY
- ORDER BY
- ROUND
- NULLIF

==================================================
*/

WITH vendor_monthly_revenue AS
(
    SELECT 
        vendor_id,
        DATE_FORMAT(market_date, '%Y-%m') AS sales_month,
        SUM(quantity) AS total_quantity_sold,
        SUM(
            quantity * cost_to_customer_per_qty
        ) AS monthly_revenue
    FROM customer_purchases
    GROUP BY
        vendor_id,
        sales_month
),

vendor_monthly_revenue_summary AS
(
    SELECT
        VMR.vendor_id,
        V.vendor_name,
        VMR.sales_month,
        VMR.total_quantity_sold,
        VMR.monthly_revenue,
        LAG(VMR.monthly_revenue) OVER
        (
            PARTITION BY VMR.vendor_id
            ORDER BY VMR.sales_month
        ) AS previous_month_revenue
    FROM vendor_monthly_revenue AS VMR
    JOIN vendor AS V
        ON VMR.vendor_id = V.vendor_id
)

SELECT
    vendor_name,
    sales_month,
    total_quantity_sold,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        monthly_revenue - previous_month_revenue,
        2
    ) AS revenue_change,
    ROUND(
        (
            monthly_revenue - previous_month_revenue
        ) /
        NULLIF(previous_month_revenue, 0)
        * 100,
        2
    ) AS revenue_growth_rate
FROM vendor_monthly_revenue_summary
ORDER BY
    vendor_name,
    sales_month;