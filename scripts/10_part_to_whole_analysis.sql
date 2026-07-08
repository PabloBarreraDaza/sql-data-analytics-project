
-- ====================================================================
-- Análisis de Contribución al Total (Part-to-Whole)
-- ====================================================================
 
-- ¿Qué categorías contribuyen más a las ventas totales?
WITH ventas_categoria AS (
    SELECT
        p.nombre_categoria,
        SUM(f.sales_amount) AS total_ventas
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
    GROUP BY p.nombre_categoria
)
SELECT
    nombre_categoria,
    total_ventas,
    SUM(total_ventas) OVER ()                                          AS ventas_totales,
    ROUND(
        (total_ventas::FLOAT / SUM(total_ventas) OVER ()) * 100, 2
    )                                                                  AS porcentaje_total
FROM ventas_categoria
ORDER BY total_ventas DESC;
 
