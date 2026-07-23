/*
==================================================
Project : Farmers Market Analytics

Report  : Vendor Performance Analysis

Author  : Jieyu Ke

Description

Analyzes vendor sales performance by
summarizing product diversity, sales volume,
revenue, and average selling price.

Metrics

- Revenue Rank
- Vendor Name
- Number of Products Sold
- Total Quantity Sold
- Total Revenue
- Average Selling Price

Skills Used

- CTE
- COUNT DISTINCT
- SUM
- ROUND
- NULLIF
- RANK
- WINDOW FUNCTION
- INNER JOIN

==================================================
*/

WITH product_summary AS
(
SELECT 
	vendor_id,
	COUNT(DISTINCT product_id) AS number_of_products_sold,
    SUM(quantity) AS total_quantity_sold,
    SUM(quantity * cost_to_customer_per_qty) AS mid_total_revenue
FROM customer_purchases
GROUP BY vendor_id
)
SELECT 
	RANK() OVER(ORDER BY PS.mid_total_revenue DESC) AS revenue_rank,
    PS.number_of_products_sold,
    V.vendor_name,
    PS.total_quantity_sold,
    ROUND(PS.mid_total_revenue,2) AS total_revenue, 
	ROUND(
		PS.mid_total_revenue/
        NULLIF(PS.total_quantity_sold,0),
        2) AS average_selling_price
    
FROM product_summary AS PS
JOIN vendor AS V
ON PS.vendor_id = V.vendor_id
ORDER BY revenue_rank


