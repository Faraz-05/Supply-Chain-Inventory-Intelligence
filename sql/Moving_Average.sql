WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', date) AS month,
        SUM(revenue) AS monthly_revenue
    FROM supply_chain_analysis
    GROUP BY DATE_TRUNC('month', date)
)

SELECT
    month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY month
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY month;