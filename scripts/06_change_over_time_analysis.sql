-- =============================================================
-- Análisis Temporal, Acumulado, Rendimiento y Segmentación
-- =============================================================
-- Propósito : Análisis de tendencias, crecimiento, segmentación
--             y contribución al total en la capa Gold.
-- Motor     : PostgreSQL 17
-- =============================================================
 
-- ====================================================================
-- Análisis de Cambio en el Tiempo (Change Over Time)
-- ====================================================================
 
-- Rendimiento de ventas por año y mes
SELECT
    EXTRACT(YEAR  FROM order_date) AS anio_pedido,
    EXTRACT(MONTH FROM order_date) AS mes_pedido,
    SUM(sales_amount)              AS total_ventas,
    COUNT(DISTINCT customer_key)   AS total_clientes,
    SUM(cantidad)                  AS total_cantidad
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY anio_pedido, mes_pedido;
 
-- Usando DATE_TRUNC (equivalente a DATETRUNC de SQL Server)
SELECT
    DATE_TRUNC('month', order_date) AS fecha_pedido,
    SUM(sales_amount)               AS total_ventas,
    COUNT(DISTINCT customer_key)    AS total_clientes,
    SUM(cantidad)                   AS total_cantidad
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY fecha_pedido;
 
-- Usando TO_CHAR para formato legible (equivalente a FORMAT de SQL Server)
SELECT
    TO_CHAR(order_date, 'YYYY-Mon')  AS fecha_pedido,
    SUM(sales_amount)                AS total_ventas,
    COUNT(DISTINCT customer_key)     AS total_clientes,
    SUM(cantidad)                    AS total_cantidad
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'YYYY-Mon')
ORDER BY fecha_pedido;
