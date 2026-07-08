-- ====================================================================
-- Exploración de Métricas Clave
-- ====================================================================

-- Total de ventas
SELECT SUM(sales_amount) AS total_ventas FROM gold.fact_sales;

-- Total de unidades vendidas
SELECT SUM(cantidad) AS total_cantidad FROM gold.fact_sales;

-- Precio medio de venta
SELECT AVG(precio) AS precio_medio FROM gold.fact_sales;

-- Total de pedidos (con y sin duplicados)
SELECT COUNT(order_number)        AS total_pedidos     FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_pedidos_unicos FROM gold.fact_sales;

-- Total de productos
SELECT COUNT(nombre_producto) AS total_productos FROM gold.dim_products;

-- Total de clientes registrados
SELECT COUNT(cliente_key) AS total_clientes FROM gold.dim_customers;

-- Total de clientes que han realizado algún pedido
SELECT COUNT(DISTINCT customer_key) AS clientes_con_pedido FROM gold.fact_sales;

-- Resumen de todas las métricas clave del negocio
SELECT 'Total Ventas'            AS metrica, SUM(sales_amount)::BIGINT          AS valor FROM gold.fact_sales
UNION ALL
SELECT 'Total Cantidad',                      SUM(cantidad)::BIGINT              FROM gold.fact_sales
UNION ALL
SELECT 'Precio Medio',                        AVG(precio)::BIGINT                FROM gold.fact_sales
UNION ALL
SELECT 'Total Pedidos Unicos',                COUNT(DISTINCT order_number)       FROM gold.fact_sales
UNION ALL
SELECT 'Total Productos',                     COUNT(DISTINCT nombre_producto)    FROM gold.dim_products
UNION ALL
SELECT 'Total Clientes',                      COUNT(cliente_key)                 FROM gold.dim_customers;
