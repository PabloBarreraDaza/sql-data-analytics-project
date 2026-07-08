-- ====================================================================
-- Análisis de Magnitud
-- ====================================================================

-- Total de clientes por país
SELECT
    pais,
    COUNT(cliente_key) AS total_clientes
FROM gold.dim_customers
GROUP BY pais
ORDER BY total_clientes DESC;

-- Total de clientes por género
SELECT
    genero,
    COUNT(cliente_key) AS total_clientes
FROM gold.dim_customers
GROUP BY genero
ORDER BY total_clientes DESC;

-- Total de productos por categoría
SELECT
    nombre_categoria,
    COUNT(product_key) AS total_productos
FROM gold.dim_products
GROUP BY nombre_categoria
ORDER BY total_productos DESC;

-- Coste medio por categoría
SELECT
    nombre_categoria,
    AVG(coste_producto) AS coste_medio
FROM gold.dim_products
GROUP BY nombre_categoria
ORDER BY coste_medio DESC;

-- Ingresos totales por categoría
SELECT
    p.nombre_categoria,
    SUM(f.sales_amount) AS ingresos_totales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
GROUP BY p.nombre_categoria
ORDER BY ingresos_totales DESC;

-- Ingresos totales por cliente
SELECT
    c.cliente_key,
    c.nombre,
    c.apellido,
    SUM(f.sales_amount) AS ingresos_totales
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.cliente_key = f.customer_key
GROUP BY c.cliente_key, c.nombre, c.apellido
ORDER BY ingresos_totales DESC;

-- Distribución de unidades vendidas por país
SELECT
    c.pais,
    SUM(f.cantidad) AS total_unidades_vendidas
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.cliente_key = f.customer_key
GROUP BY c.pais
ORDER BY total_unidades_vendidas DESC;
