/*
==================================================
Project : Farmers Market Analytics

Report  : Vendor Customer Analysis

Author  : Jieyu Ke

Description

Analyzes vendor performance by measuring customer reach,
total revenue, and average spending per customer.

Metrics:

- Vendor ID
- Vendor Name
- Customer Count
- Total Revenue
- Average Spending Per Customer
- Customer Rank

Skills Used

- CTE
- JOIN
- GROUP BY
- Aggregate Functions
- COUNT(DISTINCT)
- Window Function (RANK)

==================================================
*/

WITH vendor_customer_summary AS
(   
   SELECT
		vendor_id,
		ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS total_revenue,
		COUNT(DISTINCT customer_id) AS customer_count   
    FROM customer_purchases
    GROUP BY vendor_id
),
vendor_performance AS
(
	SELECT
		VCS.vendor_id,
        V.vendor_name,
        VCS.total_revenue,
        VCS.customer_count,
		ROUND(total_revenue / customer_count,2) AS average_spending_per_customer
        FROM vendor_customer_summary AS VCS
        JOIN vendor AS V ON VCS.vendor_id = V.vendor_id
)
SELECT
	vendor_id,
    vendor_name,
    customer_count,
    total_revenue,
    average_spending_per_customer,
	RANK() OVER(ORDER BY customer_count DESC) AS customer_rank
FROM vendor_performance
ORDER BY customer_rank, vendor_id;
