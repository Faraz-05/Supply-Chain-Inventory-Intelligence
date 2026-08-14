SELECT
    promotion_flag,
    SUM(units_sold) AS total_units_sold,
    ROUND(AVG(units_sold), 2) AS average_units_sold,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit
FROM supply_chain_analysis
GROUP BY promotion_flag
ORDER BY promotion_flag;



SELECT
    stockout_flag,
    SUM(units_sold) AS total_units_sold,
    ROUND(AVG(units_sold), 2) AS average_units_sold,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(AVG(inventory_level), 2) AS average_inventory_level
FROM supply_chain_analysis
GROUP BY stockout_flag
ORDER BY stockout_flag;



SELECT
    DATE_TRUNC('month', date) AS month,
    SUM(units_sold) AS total_units_sold,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit
FROM supply_chain_analysis
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;






WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', date) AS month,
        SUM(revenue) AS total_revenue
    FROM supply_chain_analysis
    GROUP BY DATE_TRUNC('month', date)
)

SELECT
    month,
    total_revenue,
    LAG(total_revenue) OVER (
        ORDER BY month
    ) AS previous_month_revenue,
    ROUND(
        (
            (total_revenue - LAG(total_revenue) OVER (ORDER BY month))
            / LAG(total_revenue) OVER (ORDER BY month)
        ) * 100,
        2
    ) AS growth_percentage
FROM monthly_sales
ORDER BY month;