-- =============================================================
-- Reports - Gold Layer
-- =============================================================
-- Propósito : Vistas de reporting consolidadas para clientes
--             y productos con KPIs y segmentación.
-- Motor     : PostgreSQL 17
-- =============================================================
 
-- ====================================================================
-- gold.report_customers
-- ====================================================================
 
CREATE OR REPLACE VIEW gold.report_customers AS
 
WITH base_query AS (
-- 1) Query base: columnas principales de fact y dimensión clientes
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.cantidad,
        c.cliente_key,
        c.cliente_numero,
        CONCAT(c.nombre, ' ', c.apellido)                           AS nombre_cliente,
        DATE_PART('year', AGE(NOW(), c.fecha_nacimiento))::INT       AS edad
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON c.cliente_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),
 
agregacion_clientes AS (
-- 2) Agregaciones por cliente
    SELECT
        cliente_key,
        cliente_numero,
        nombre_cliente,
        edad,
        COUNT(DISTINCT order_number)                                 AS total_pedidos,
        SUM(sales_amount)                                            AS total_ventas,
        SUM(cantidad)                                                AS total_cantidad,
        COUNT(DISTINCT product_key)                                  AS total_productos,
        MAX(order_date)                                              AS ultimo_pedido,
        DATE_PART('year',  AGE(MAX(order_date), MIN(order_date))) * 12
        + DATE_PART('month', AGE(MAX(order_date), MIN(order_date))) AS meses_historial
    FROM base_query
    GROUP BY cliente_key, cliente_numero, nombre_cliente, edad
)
 
-- 3) Query final con segmentación y KPIs
SELECT
    cliente_key,
    cliente_numero,
    nombre_cliente,
    edad,
    CASE
        WHEN edad < 20                    THEN 'Menos de 20'
        WHEN edad BETWEEN 20 AND 29       THEN '20-29'
        WHEN edad BETWEEN 30 AND 39       THEN '30-39'
        WHEN edad BETWEEN 40 AND 49       THEN '40-49'
        ELSE '50 y más'
    END                                                              AS grupo_edad,
    CASE
        WHEN meses_historial >= 12 AND total_ventas > 5000  THEN 'VIP'
        WHEN meses_historial >= 12 AND total_ventas <= 5000 THEN 'Regular'
        ELSE 'Nuevo'
    END                                                              AS segmento_cliente,
    ultimo_pedido,
    DATE_PART('year',  AGE(NOW(), ultimo_pedido)) * 12
    + DATE_PART('month', AGE(NOW(), ultimo_pedido))                  AS recencia_meses,
    total_pedidos,
    total_ventas,
    total_cantidad,
    total_productos,
    meses_historial,
    -- Valor medio por pedido
    CASE
        WHEN total_pedidos = 0 THEN 0
        ELSE total_ventas / total_pedidos
    END                                                              AS valor_medio_pedido,
    -- Gasto medio mensual
    CASE
        WHEN meses_historial = 0 THEN total_ventas
        ELSE total_ventas / meses_historial
    END                                                              AS gasto_medio_mensual
FROM agregacion_clientes;
 
-- ====================================================================
-- gold.report_products
-- ====================================================================
 
CREATE OR REPLACE VIEW gold.report_products AS
 
WITH base_query AS (
-- 1) Query base: columnas principales de fact y dimensión productos
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.cantidad,
        p.product_key,
        p.nombre_producto,
        p.nombre_categoria,
        p.nombre_subcategoria,
        p.coste_producto
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),
 
agregacion_productos AS (
-- 2) Agregaciones por producto
    SELECT
        product_key,
        nombre_producto,
        nombre_categoria,
        nombre_subcategoria,
        coste_producto,
        DATE_PART('year',  AGE(MAX(order_date), MIN(order_date))) * 12
        + DATE_PART('month', AGE(MAX(order_date), MIN(order_date))) AS meses_historial,
        MAX(order_date)                                              AS ultima_venta,
        COUNT(DISTINCT order_number)                                 AS total_pedidos,
        COUNT(DISTINCT customer_key)                                 AS total_clientes,
        SUM(sales_amount)                                            AS total_ventas,
        SUM(cantidad)                                                AS total_cantidad,
        ROUND(AVG(sales_amount::FLOAT / NULLIF(cantidad, 0))::NUMERIC, 1) AS precio_medio_venta
    FROM base_query
    GROUP BY product_key, nombre_producto, nombre_categoria, nombre_subcategoria, coste_producto
)
 
-- 3) Query final con segmentación y KPIs
SELECT
    product_key,
    nombre_producto,
    nombre_categoria,
    nombre_subcategoria,
    coste_producto,
    ultima_venta,
    DATE_PART('year',  AGE(NOW(), ultima_venta)) * 12
    + DATE_PART('month', AGE(NOW(), ultima_venta))                   AS recencia_meses,
    CASE
        WHEN total_ventas > 50000  THEN 'Alto Rendimiento'
        WHEN total_ventas >= 10000 THEN 'Rendimiento Medio'
        ELSE 'Bajo Rendimiento'
    END                                                              AS segmento_producto,
    meses_historial,
    total_pedidos,
    total_ventas,
    total_cantidad,
    total_clientes,
    precio_medio_venta,
    -- Ingreso medio por pedido
    CASE
        WHEN total_pedidos = 0 THEN 0
        ELSE total_ventas / total_pedidos
    END                                                              AS ingreso_medio_pedido,
    -- Ingreso medio mensual
    CASE
        WHEN meses_historial = 0 THEN total_ventas
        ELSE total_ventas / meses_historial
    END                                                              AS ingreso_medio_mensual
FROM agregacion_productos;
