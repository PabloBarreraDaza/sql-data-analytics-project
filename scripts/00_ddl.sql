-- =============================================================
-- Crear Base de Datos y Esquemas - Proyecto Analytics
-- =============================================================
-- Propósito:
--     Este script crea las tablas del esquema gold y carga los
--     datos desde archivos CSV exportados de la capa Gold del DWH.
-- ADVERTENCIA:
--     Ejecutar este script eliminará y recreará las tablas gold.
--     Todos los datos existentes se perderán. Asegúrate de tener
--     un backup antes de continuar.
-- Nota PostgreSQL:
--     PostgreSQL no permite eliminar la base de datos activa.
--     Para recrearla conéctate a 'postgres' y ejecuta:
--       DROP DATABASE IF EXISTS "DataAnalytics";
--       CREATE DATABASE "DataAnalytics";
--     Luego conéctate a la nueva base de datos y ejecuta este script.
-- =============================================================

-- Crear esquema gold si no existe
CREATE SCHEMA IF NOT EXISTS gold;

-- ====================================================================
-- Tablas
-- ====================================================================

DROP TABLE IF EXISTS gold.dim_customers;
CREATE TABLE gold.dim_customers (
    cliente_key      INT,
    cliente_id       INT,
    cliente_numero   VARCHAR(50),
    nombre           VARCHAR(50),
    apellido         VARCHAR(50),
    pais             VARCHAR(50),
    estado_civil     VARCHAR(50),
    genero           VARCHAR(50),
    fecha_nacimiento DATE,
    fecha_creacion   DATE
);

DROP TABLE IF EXISTS gold.dim_products;
CREATE TABLE gold.dim_products (
    product_key          INT,
    product_id           INT,
    product_number       VARCHAR(50),
    nombre_producto      VARCHAR(50),
    categoria_id         VARCHAR(50),
    nombre_categoria     VARCHAR(50),
    nombre_subcategoria  VARCHAR(50),
    maintenance          VARCHAR(50),
    coste_producto       INT,
    linea_producto       VARCHAR(50),
    fecha_inicio         DATE
);

DROP TABLE IF EXISTS gold.fact_sales;
CREATE TABLE gold.fact_sales (
    order_number   VARCHAR(50),
    product_key    INT,
    customer_key   INT,
    order_date     DATE,
    shipping_date  DATE,
    due_date       DATE,
    sales_amount   INT,
    cantidad       INT,
    precio         INT
);

-- ====================================================================
-- Carga de datos desde CSV
-- ====================================================================
-- Ejecutar desde psql con \copy (no requiere permisos de superusuario):
--
-- \copy gold.dim_customers   FROM 'ruta/gold.dim_customers.csv'  DELIMITER ',' CSV HEADER;
-- \copy gold.dim_products    FROM 'ruta/gold.dim_products.csv'   DELIMITER ',' CSV HEADER;
-- \copy gold.fact_sales      FROM 'ruta/gold.fact_sales.csv'     DELIMITER ',' CSV HEADER;
--
-- O si tienes permisos de superusuario, desde pgAdmin con COPY:

TRUNCATE TABLE gold.dim_customers;
COPY gold.dim_customers
FROM 'C:/ruta/a/datasets/csv-files/gold.dim_customers.csv'
DELIMITER ',' CSV HEADER;

TRUNCATE TABLE gold.dim_products;
COPY gold.dim_products
FROM 'C:/ruta/a/datasets/csv-files/gold.dim_products.csv'
DELIMITER ',' CSV HEADER;

TRUNCATE TABLE gold.fact_sales;
COPY gold.fact_sales
FROM 'C:/ruta/a/datasets/csv-files/gold.fact_sales.csv'
DELIMITER ',' CSV HEADER;
