 
-- ====================================================================
-- Análisis de Segmentación (Data Segmentation)
-- ====================================================================
 
-- Segmentación de productos por rango de coste
WITH segmentos_producto AS (
    SELECT
        product_key,
        nombre_producto,
        coste_producto,
        CASE
            WHEN coste_producto < 100                     THEN 'Menos de 100'
            WHEN coste_producto BETWEEN 100 AND 500       THEN '100-500'
            WHEN coste_producto BETWEEN 500 AND 1000      THEN '500-1000'
            ELSE 'Más de 1000'
        END AS rango_coste
    FROM gold.dim_products
)
SELECT
    rango_coste,
    COUNT(product_key) AS total_productos
FROM segmentos_producto
GROUP BY rango_coste
ORDER BY total_productos DESC;
 
-- Segmentación de clientes por comportamiento de gasto
-- VIP     : >= 12 meses de historial y gasto > 5000
-- Regular : >= 12 meses de historial y gasto <= 5000
-- Nuevo   : < 12 meses de historial
WITH gasto_clientes AS (
    SELECT
        c.cliente_key,
        SUM(f.sales_amount)                                             AS gasto_total,
        MIN(f.order_date)                                               AS primer_pedido,
        MAX(f.order_date)                                               AS ultimo_pedido,
        DATE_PART('year',  AGE(MAX(f.order_date), MIN(f.order_date))) * 12
        + DATE_PART('month', AGE(MAX(f.order_date), MIN(f.order_date))) AS meses_historial
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON f.customer_key = c.cliente_key
    GROUP BY c.cliente_key
)
SELECT
    segmento_cliente,
    COUNT(cliente_key) AS total_clientes
FROM (
    SELECT
        cliente_key,
        CASE
            WHEN meses_historial >= 12 AND gasto_total > 5000  THEN 'VIP'
            WHEN meses_historial >= 12 AND gasto_total <= 5000 THEN 'Regular'
            ELSE 'Nuevo'
        END AS segmento_cliente
    FROM gasto_clientes
) segmentados
GROUP BY segmento_cliente
ORDER BY total_clientes DESC;
