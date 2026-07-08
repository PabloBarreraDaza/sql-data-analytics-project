 
-- ====================================================================
-- Análisis de Rendimiento (Year-over-Year)
-- ====================================================================
 
-- Rendimiento anual de productos comparado con media histórica y año anterior
WITH ventas_anuales_producto AS (
    SELECT
        EXTRACT(YEAR FROM f.order_date) AS anio_pedido,
        p.nombre_producto,
        SUM(f.sales_amount)             AS ventas_actuales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM f.order_date), p.nombre_producto
)
SELECT
    anio_pedido,
    nombre_producto,
    ventas_actuales,
    AVG(ventas_actuales) OVER (PARTITION BY nombre_producto)            AS media_ventas,
    ventas_actuales - AVG(ventas_actuales) OVER (
        PARTITION BY nombre_producto)                                   AS diff_media,
    CASE
        WHEN ventas_actuales - AVG(ventas_actuales) OVER (
            PARTITION BY nombre_producto) > 0 THEN 'Por encima de media'
        WHEN ventas_actuales - AVG(ventas_actuales) OVER (
            PARTITION BY nombre_producto) < 0 THEN 'Por debajo de media'
        ELSE 'En la media'
    END AS vs_media,
    -- Year-over-Year
    LAG(ventas_actuales) OVER (
        PARTITION BY nombre_producto ORDER BY anio_pedido)              AS ventas_anio_anterior,
    ventas_actuales - LAG(ventas_actuales) OVER (
        PARTITION BY nombre_producto ORDER BY anio_pedido)              AS diff_anio_anterior,
    CASE
        WHEN ventas_actuales - LAG(ventas_actuales) OVER (
            PARTITION BY nombre_producto ORDER BY anio_pedido) > 0 THEN 'Aumento'
        WHEN ventas_actuales - LAG(ventas_actuales) OVER (
            PARTITION BY nombre_producto ORDER BY anio_pedido) < 0 THEN 'Descenso'
        ELSE 'Sin cambio'
    END AS cambio_anual
FROM ventas_anuales_producto
ORDER BY nombre_producto, anio_pedido;
