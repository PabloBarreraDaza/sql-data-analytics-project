-- ====================================================================
-- Análisis Acumulado (Cumulative Analysis)
-- ====================================================================
 
-- Total de ventas por año con total acumulado y media móvil de precio
SELECT
    order_date,
    total_ventas,
    SUM(total_ventas) OVER (ORDER BY order_date) AS total_ventas_acumulado,
    AVG(precio_medio) OVER (ORDER BY order_date) AS media_movil_precio
FROM (
    SELECT
        DATE_TRUNC('year', order_date) AS order_date,
        SUM(sales_amount)              AS total_ventas,
        AVG(precio)                    AS precio_medio
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_TRUNC('year', order_date)
) t;
 
