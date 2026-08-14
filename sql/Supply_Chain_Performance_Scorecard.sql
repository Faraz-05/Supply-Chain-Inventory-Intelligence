WITH product_metrics AS (
    SELECT
        sku_id,

        SUM(units_sold) AS total_units_sold,

        SUM(revenue) AS total_revenue,

        SUM(profit) AS total_profit,

        ROUND(
            AVG(inventory_level),
            2
        ) AS avg_inventory,

        SUM(
            CASE
                WHEN stockout_flag = 1 THEN 1
                ELSE 0
            END
        ) AS stockout_days,

        ROUND(
            (
                1 - (
                    ABS(
                        SUM(units_sold)
                        - SUM(demand_forecast)
                    )
                    / NULLIF(SUM(units_sold), 0)
                )
            ) * 100,
            2
        ) AS forecast_accuracy_percentage

    FROM supply_chain_analysis

    GROUP BY sku_id
)

SELECT
    sku_id,
    total_units_sold,
    total_revenue,
    total_profit,
    avg_inventory,
    stockout_days,
    forecast_accuracy_percentage,

    CASE
        WHEN total_profit > 0
             AND stockout_days < 10
             AND forecast_accuracy_percentage >= 80
            THEN 'Strong Performer'

        WHEN total_profit > 0
             AND (
                 stockout_days >= 10
                 OR forecast_accuracy_percentage < 80
             )
            THEN 'Needs Attention'

        ELSE 'Poor Performer'
    END AS business_status

FROM product_metrics

ORDER BY total_profit DESC;