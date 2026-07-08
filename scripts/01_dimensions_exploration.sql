-- =============================================================
-- Exploración y Análisis - Gold Layer
-- =============================================================
-- Propósito : Exploración de dimensiones, rangos de fechas,
--             métricas clave, análisis de magnitud y ranking.
-- Motor     : PostgreSQL 17
-- =============================================================

-- ====================================================================
-- Exploración de Dimensiones
-- ====================================================================

-- Países únicos de los que provienen los clientes
SELECT DISTINCT pais
FROM gold.dim_customers
ORDER BY pais;

-- Categorías, subcategorías y productos únicos
SELECT DISTINCT
    nombre_categoria,
    nombre_subcategoria,
    nombre_producto
FROM gold.dim_products
ORDER BY nombre_categoria, nombre_subcategoria, nombre_producto;
