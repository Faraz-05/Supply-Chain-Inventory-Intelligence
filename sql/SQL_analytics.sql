// Creating reusable financial view

CREATE VIEW supply_chain_analysis AS
SELECT
    *,
    units_sold * unit_price AS revenue,
    units_sold * unit_cost AS cost,
    (units_sold * unit_price)
        - (units_sold * unit_cost) AS profit
FROM supply_chain_daily;

SELECT
    SUM(units_sold) AS total_units_sold,
    SUM(revenue) AS total_revenue,
    SUM(cost) AS total_cost,
    SUM(profit) AS total_profit
FROM supply_chain_analysis;

SELECT
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(
        (SUM(profit) / SUM(revenue)) * 100,
        2
    ) AS profit_margin_percentage
FROM supply_chain_analysis;

SELECT
    sku_id,
    SUM(units_sold) AS total_units_sold,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit
FROM supply_chain_analysis
GROUP BY sku_id
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    sku_id,
    SUM(units_sold) AS total_units_sold,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit
FROM supply_chain_analysis
GROUP BY sku_id
ORDER BY total_profit DESC
LIMIT 10;

SELECT
    p.product_name,
    p.category,
    SUM(s.units_sold) AS total_units_sold,
    SUM(s.revenue) AS total_revenue,
    SUM(s.profit) AS total_profit
FROM supply_chain_analysis s
JOIN products p
    ON s.sku_id = p.sku_id
GROUP BY
    p.product_name,
    p.category
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    warehouse_id,
    SUM(units_sold) AS total_units_sold,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit,
    ROUND(AVG(inventory_level), 2) AS average_inventory
FROM supply_chain_analysis
GROUP BY warehouse_id
ORDER BY total_revenue DESC;

SELECT
    supplier_id,
    SUM(units_sold) AS total_units_sold,
    COUNT(*) AS total_orders,
    ROUND(AVG(supplier_lead_time_days), 2) AS avg_lead_time,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit
FROM supply_chain_analysis
GROUP BY supplier_id
ORDER BY total_profit DESC;