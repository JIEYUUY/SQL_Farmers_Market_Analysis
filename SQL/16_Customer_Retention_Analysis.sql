/*
==================================================
Project : Farmers Market Analytics

Report  : Customer Retention Analysis

Author  : Jieyu Ke

Description

Analyzes customer retention behavior by
identifying first purchase, last purchase,
purchase frequency, customer type, and average
days between purchases.

Metrics

- Customer ID
- Customer Name
- First Purchase Date
- Last Purchase Date
- Purchase Count
- Customer Type
- Average Days Between Purchases

Skills Used

- CTE
- MIN
- MAX
- COUNT DISTINCT
- CASE
- DATEDIFF
- NULLIF
- ROUND

==================================================
*/

WITH customer_purchase_analysis AS
(
    SELECT 
        customer_id,
        MIN(market_date) AS first_purchase_date,
        MAX(market_date) AS last_purchase_date,
        COUNT(DISTINCT market_date) AS purchase_count
    FROM customer_purchases
    GROUP BY customer_id
)

SELECT 
    CPA.customer_id,
    CONCAT(
        C.customer_first_name,
        ' ',
        C.customer_last_name
    ) AS customer_name,
    CPA.first_purchase_date,
    CPA.last_purchase_date,
    CPA.purchase_count,
    CASE
        WHEN CPA.purchase_count = 1 THEN 'New'
        ELSE 'Returning'
    END AS customer_type,
    ROUND(
        DATEDIFF(
            CPA.last_purchase_date,
            CPA.first_purchase_date
        ) /
        NULLIF(CPA.purchase_count - 1, 0),
        2
    ) AS average_days_between_purchases
FROM customer_purchase_analysis AS CPA
JOIN customer AS C
    ON CPA.customer_id = C.customer_id
ORDER BY CPA.customer_id;