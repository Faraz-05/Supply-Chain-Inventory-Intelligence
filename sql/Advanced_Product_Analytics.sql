WITH product_revenue AS (
    SELECT
        sku_id,
        SUM(revenue) AS total_revenue
    FROM supply_chain_analysis
    GROUP BY sku_id
)

SELECT
    sku_id,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM product_revenue
ORDER BY revenue_rank;













WITH category_sales AS (
    SELECT
        p.product_name,
        p.category,
        SUM(s.revenue) AS total_revenue
    FROM supply_chain_analysis s
    JOIN products p
        ON s.sku_id = p.sku_id
    GROUP BY
        p.product_name,
        p.category
)

SELECT
    product_name,
    category,
    total_revenue,
    RANK() OVER (
        PARTITION BY category
        ORDER BY total_revenue DESC
    ) AS category_revenue_rank
FROM category_sales
ORDER BY
    category,
    category_revenue_rank;