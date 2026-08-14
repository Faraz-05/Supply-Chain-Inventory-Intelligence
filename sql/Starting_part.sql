CREATE TABLE raw_supply_chain (
    date DATE,
    sku_id VARCHAR(20),
    warehouse_id VARCHAR(20),
    supplier_id VARCHAR(20),
    region VARCHAR(50),
    units_sold INT,
    inventory_level INT,
    supplier_lead_time_days INT,
    reorder_point INT,
    order_quantity INT,
    unit_cost NUMERIC(10,2),
    unit_price NUMERIC(10,2),
    promotion_flag INT,
    stockout_flag INT,
    demand_forecast NUMERIC(10,2)
);

DROP TABLE raw_supply_chain;

SELECT COUNT(*)
FROM raw_supply_chain;

SELECT *
FROM raw_supply_chain
LIMIT 5;

SELECT
    MIN(date) AS start_date,
    MAX(date) AS end_date,
    COUNT(DISTINCT date) AS total_days
FROM raw_supply_chain;













SELECT
    sku_id,
    warehouse_id,
    COUNT(DISTINCT reorder_point) AS reorder_point_count
FROM raw_supply_chain
GROUP BY sku_id, warehouse_id
HAVING COUNT(DISTINCT reorder_point) > 1;

SELECT
    sku_id,
    warehouse_id,
    MIN(reorder_point) AS reorder_point
FROM raw_supply_chain
GROUP BY sku_id, warehouse_id
ORDER BY sku_id, warehouse_id
LIMIT 20;












CREATE TABLE products (
    sku_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100),
    brand VARCHAR(100),
    category VARCHAR(100)
);

SELECT COUNT(*) AS total_products
FROM products;

SELECT *
FROM products
ORDER BY sku_id
LIMIT 10;







CREATE TABLE supply_chain_daily (
    record_id BIGSERIAL PRIMARY KEY,
    date DATE,
    sku_id VARCHAR(20),
    warehouse_id VARCHAR(20),
    supplier_id VARCHAR(20),
    region VARCHAR(50),
    units_sold INT,
    inventory_level INT,
    supplier_lead_time_days INT,
    reorder_point INT,
    order_quantity INT,
    unit_cost NUMERIC(10,2),
    unit_price NUMERIC(10,2),
    promotion_flag INT,
    stockout_flag INT,
    demand_forecast NUMERIC(10,2),

    FOREIGN KEY (sku_id)
        REFERENCES products(sku_id)
);

INSERT INTO supply_chain_daily (
    date,
    sku_id,
    warehouse_id,
    supplier_id,
    region,
    units_sold,
    inventory_level,
    supplier_lead_time_days,
    reorder_point,
    order_quantity,
    unit_cost,
    unit_price,
    promotion_flag,
    stockout_flag,
    demand_forecast
)
SELECT
    date,
    sku_id,
    warehouse_id,
    supplier_id,
    region,
    units_sold,
    inventory_level,
    supplier_lead_time_days,
    reorder_point,
    order_quantity,
    unit_cost,
    unit_price,
    promotion_flag,
    stockout_flag,
    demand_forecast
FROM raw_supply_chain;

SELECT COUNT(*) AS total_records
FROM supply_chain_daily;

SELECT *
FROM supply_chain_daily
LIMIT 10;