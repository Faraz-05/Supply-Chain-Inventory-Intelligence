SELECT
    sku_id,
    warehouse_id,
    ROUND(AVG(inventory_level), 2) AS average_inventory,
    ROUND(AVG(reorder_point), 2) AS average_reorder_point,

    SUM(
        CASE
            WHEN inventory_level < reorder_point THEN 1
            ELSE 0
        END
    ) AS below_reorder_count,

    CASE
        WHEN AVG(inventory_level) < AVG(reorder_point)
            THEN 'High Risk'

        WHEN AVG(inventory_level) < AVG(reorder_point) * 1.5
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS risk_level

FROM supply_chain_analysis

GROUP BY
    sku_id,
    warehouse_id

ORDER BY
    below_reorder_count DESC;









SELECT
    sku_id,
    warehouse_id,
    COUNT(*) AS total_days,

    SUM(
        CASE
            WHEN inventory_level < reorder_point THEN 1
            ELSE 0
        END
    ) AS below_reorder_days,

    ROUND(
        (
            SUM(
                CASE
                    WHEN inventory_level < reorder_point THEN 1
                    ELSE 0
                END
            )::NUMERIC
            / COUNT(*)
        ) * 100,
        2
    ) AS below_reorder_percentage

FROM supply_chain_analysis

GROUP BY
    sku_id,
    warehouse_id

ORDER BY
    below_reorder_percentage DESC

LIMIT 10;