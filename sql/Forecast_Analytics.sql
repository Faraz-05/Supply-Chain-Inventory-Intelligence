SELECT
    sku_id,
    SUM(units_sold) AS total_actual_demand,
    SUM(demand_forecast) AS total_forecast,

    ROUND(
        ABS(SUM(units_sold) - SUM(demand_forecast)),
        2
    ) AS forecast_error,

    ROUND(
        (
            1 - (
                ABS(SUM(units_sold) - SUM(demand_forecast))
                / NULLIF(SUM(units_sold), 0)
            )
        ) * 100,
        2
    ) AS forecast_accuracy_percentage

FROM supply_chain_analysis

GROUP BY sku_id

ORDER BY forecast_accuracy_percentage DESC;














SELECT
    sku_id,
    SUM(units_sold) AS total_actual_demand,
    SUM(demand_forecast) AS total_forecast,

    ROUND(
        SUM(demand_forecast) - SUM(units_sold),
        2
    ) AS forecast_bias

FROM supply_chain_analysis

GROUP BY sku_id

ORDER BY forecast_bias DESC;