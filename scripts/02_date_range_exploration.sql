-- ====================================================================
-- Exploración de Rango de Fechas
-- ====================================================================

-- Primera y última fecha de pedido y duración total en meses
SELECT
    MIN(order_date)                                             AS primera_fecha_pedido,
    MAX(order_date)                                             AS ultima_fecha_pedido,
    DATE_PART('year', AGE(MAX(order_date), MIN(order_date))) * 12
    + DATE_PART('month', AGE(MAX(order_date), MIN(order_date))) AS meses_rango_pedidos
FROM gold.fact_sales;

-- Cliente más joven y más mayor según fecha de nacimiento
SELECT
    MIN(fecha_nacimiento)                                       AS fecha_nac_mayor,
    DATE_PART('year', AGE(NOW(), MIN(fecha_nacimiento)))        AS edad_mayor,
    MAX(fecha_nacimiento)                                       AS fecha_nac_menor,
    DATE_PART('year', AGE(NOW(), MAX(fecha_nacimiento)))        AS edad_menor
FROM gold.dim_customers;
