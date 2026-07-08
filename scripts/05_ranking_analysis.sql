-- ====================================================================
-- Análisis de Ranking
-- ====================================================================

-- Top 5 productos con mayores ingresos (método simple)
SELECT
    p.nombre_producto,
    SUM(f.sales_amount) AS ingresos_totales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
GROUP BY p.nombre_producto
ORDER BY ingresos_totales DESC
LIMIT 5;

-- Top 5 productos con mayores ingresos (con window function, más flexible)
SELECT *
FROM (
    SELECT
        p.nombre_producto,
        SUM(f.sales_amount)                             AS ingresos_totales,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS ranking
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
    GROUP BY p.nombre_producto
) ranked
WHERE ranking <= 5;

-- 5 productos con peores ventas
SELECT
    p.nombre_producto,
    SUM(f.sales_amount) AS ingresos_totales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
GROUP BY p.nombre_producto
ORDER BY ingresos_totales ASC
LIMIT 5;

-- Top 10 clientes con mayores ingresos generados
SELECT
    c.cliente_key,
    c.nombre,
    c.apellido,
    SUM(f.sales_amount) AS ingresos_totales
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.cliente_key = f.customer_key
GROUP BY c.cliente_key, c.nombre, c.apellido
ORDER BY ingresos_totales DESC
LIMIT 10;

-- 3 clientes con menos pedidos realizados
SELECT
    c.cliente_key,
    c.nombre,
    c.apellido,
    COUNT(DISTINCT f.order_number) AS total_pedidos
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.cliente_key = f.customer_key
GROUP BY c.cliente_key, c.nombre, c.apellido
ORDER BY total_pedidos ASC
LIMIT 3;
