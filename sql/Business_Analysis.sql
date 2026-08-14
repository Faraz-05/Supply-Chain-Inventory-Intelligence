WITH product_metrics AS (
    SELECT
        sku_id,
        SUM(revenue) AS total_revenue,
        SUM(profit) AS total_profit,
        COUNT(*) AS total_days,

        SUM(
            CASE
                WHEN inventory_level < reorder_point THEN 1
                ELSE 0
            END
        ) AS below_reorder_days

    FROM supply_chain_analysis

    GROUP BY sku_id
),

product_ranking AS (
    SELECT
        *,
        ROUND(
            (
                below_reorder_days::NUMERIC
                / total_days
            ) * 100,
            2
        ) AS below_reorder_percentage,

        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile

    FROM product_metrics
)

SELECT
    sku_id,
    total_revenue,
    total_profit,
    total_days,
    below_reorder_days,
    below_reorder_percentage,

    CASE
        WHEN revenue_quartile = 1
             AND below_reorder_percentage >= 25
            THEN 'High Performing & High Risk'

        WHEN revenue_quartile = 1
             AND below_reorder_percentage < 25
            THEN 'High Performing & Low Risk'

        ELSE 'Other'
    END AS performance_risk_category

FROM product_ranking

ORDER BY
    revenue_quartile,
    below_reorder_percentage DESC;