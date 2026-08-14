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
    ROUND(
        AVG(monthly_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_average
FROM monthly_sales
ORDER BY month;