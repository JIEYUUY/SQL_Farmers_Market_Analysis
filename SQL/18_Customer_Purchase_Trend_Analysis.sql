/*
==================================================
Project : Farmers Market Analytics

Report  : Customer Monthly Purchase Trend Analysis

Author  : Jieyu Ke

Description

Analyzes monthly customer purchasing behavior
by measuring order frequency, purchase quantity,
monthly spending, cumulative spending, and
monthly customer revenue ranking.

Metrics

- Customer Name
- Sales Month
- Total Orders
- Total Quantity Purchased
- Monthly Revenue
- Running Revenue
- Monthly Revenue Rank

Skills Used

- Multiple CTE
- INNER JOIN
- DATE_FORMAT
- COUNT DISTINCT
- SUM
- ROUND
- RANK
- Window Function
- PARTITION BY
- ROWS BETWEEN

==================================================
*/

WITH customer_monthly_summary AS
(
    SELECT
        customer_id,
        DATE_FORMAT(market_date, '%Y-%m') AS sales_month,
        COUNT(DISTINCT market_date) AS total_orders,
        SUM(quantity) AS total_quantity_purchased,
        SUM(
            quantity * cost_to_customer_per_qty
        ) AS monthly_revenue
    FROM customer_purchases
    GROUP BY
        customer_id,
        DATE_FORMAT(market_date, '%Y-%m')
),

customer_trend_analysis AS
(
    SELECT
        CMS.customer_id,
        CMS.sales_month,
        CMS.total_orders,
        CMS.total_quantity_purchased,
        CMS.monthly_revenue,

        SUM(CMS.monthly_revenue) OVER
        (
            PARTITION BY CMS.customer_id
            ORDER BY CMS.sales_month
            ROWS BETWEEN UNBOUNDED PRECEDING
                     AND CURRENT ROW
        ) AS running_revenue,

        RANK() OVER
        (
            PARTITION BY CMS.sales_month
            ORDER BY CMS.monthly_revenue DESC
        ) AS monthly_revenue_rank
    FROM customer_monthly_summary AS CMS
)

SELECT
    CONCAT_WS(
        ' ',
        C.customer_first_name,
        C.customer_last_name
    ) AS customer_name,
    CTA.sales_month,
    CTA.total_orders,
    CTA.total_quantity_purchased,
    ROUND(CTA.monthly_revenue, 2) AS monthly_revenue,
    ROUND(CTA.running_revenue, 2) AS running_revenue,
    CTA.monthly_revenue_rank
FROM customer_trend_analysis AS CTA
JOIN customer AS C
    ON CTA.customer_id = C.customer_id
ORDER BY
    CTA.sales_month,
    CTA.monthly_revenue_rank,
    CTA.customer_id;