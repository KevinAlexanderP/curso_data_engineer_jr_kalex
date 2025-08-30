-- =====================================================
-- Script: Limitación de Resultados
-- Módulo 2: Consultas Básicas SELECT
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. LIMIT básico - limitar el número de filas retornadas
-- Sintaxis: SELECT * FROM tabla LIMIT numero_filas;

-- Obtener solo los primeros 5 empleados
SELECT nombre, apellido, salario 
FROM empleados 
LIMIT 5;

-- Obtener solo los primeros 3 empleados ordenados por salario
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY salario DESC 
LIMIT 3;

-- 2. OFFSET - saltar filas antes de aplicar LIMIT
-- Sintaxis: SELECT * FROM tabla LIMIT numero_filas OFFSET numero_filas_a_saltar;

-- Obtener empleados del 6 al 10 (saltar 5, tomar 5)
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre 
LIMIT 5 OFFSET 5;

-- Obtener empleados del 11 al 15 (saltar 10, tomar 5)
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre 
LIMIT 5 OFFSET 10;

-- 3. Sintaxis alternativa: LIMIT offset, count
-- Sintaxis: SELECT * FROM tabla LIMIT offset, count;

-- Obtener empleados del 6 al 10 usando sintaxis alternativa
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre 
LIMIT 5, 5;

-- Obtener empleados del 11 al 15 usando sintaxis alternativa
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre 
LIMIT 10, 5;

-- 4. Paginación básica

-- Primera página (filas 1-5)
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre 
LIMIT 5 OFFSET 0;

-- Segunda página (filas 6-10)
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre 
LIMIT 5 OFFSET 5;

-- Tercera página (filas 11-15)
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre 
LIMIT 5 OFFSET 10;

-- 5. Paginación con variables (ejemplo conceptual)

-- Para implementar paginación dinámica, puedes usar:
-- LIMIT page_size OFFSET (page_number - 1) * page_size
-- Donde:
-- page_size = 5 (filas por página)
-- page_number = 1, 2, 3, etc.

-- Página 1: LIMIT 5 OFFSET 0
-- Página 2: LIMIT 5 OFFSET 5
-- Página 3: LIMIT 5 OFFSET 10

-- 6. Limitación con WHERE y ORDER BY

-- Top 3 empleados con mayor salario del departamento 1
SELECT nombre, apellido, salario, departamento_id 
FROM empleados 
WHERE departamento_id = 1 
ORDER BY salario DESC 
LIMIT 3;

-- Top 5 empleados más jóvenes
SELECT nombre, apellido, fecha_nacimiento 
FROM empleados 
ORDER BY fecha_nacimiento DESC 
LIMIT 5;

-- 7. Limitación con DISTINCT

-- Primeros 3 departamentos únicos
SELECT DISTINCT departamento_id 
FROM empleados 
ORDER BY departamento_id 
LIMIT 3;

-- 8. Limitación con funciones agregadas (preparación para módulo 4)

-- Top 3 departamentos por número de empleados
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados
FROM empleados 
GROUP BY departamento_id 
ORDER BY numero_empleados DESC 
LIMIT 3;

-- 9. Limitación con subconsultas (preparación para módulo 4)

-- Empleados con salario mayor al promedio (limitado a 5)
SELECT nombre, apellido, salario 
FROM empleados 
WHERE salario > (SELECT AVG(salario) FROM empleados)
ORDER BY salario DESC 
LIMIT 5;

-- 10. Limitación con JOINs (preparación para módulo 5)

-- Top 3 empleados con mayor salario incluyendo nombre del departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento
FROM empleados e
JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.salario DESC 
LIMIT 3;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. TOP básico - limitar el número de filas retornadas
-- Sintaxis: SELECT TOP numero_filas * FROM tabla;

-- Obtener solo los primeros 5 empleados
SELECT TOP 5 nombre, apellido, salario 
FROM empleados;

-- Obtener solo los primeros 3 empleados ordenados por salario
SELECT TOP 3 nombre, apellido, salario 
FROM empleados 
ORDER BY salario DESC;

-- 2. TOP con porcentaje
-- Sintaxis: SELECT TOP numero_filas PERCENT * FROM tabla;

-- Obtener el top 20% de empleados por salario
SELECT TOP 20 PERCENT nombre, apellido, salario 
FROM empleados 
ORDER BY salario DESC;

-- 3. Paginación con OFFSET-FETCH (SQL Server 2012+)
-- Sintaxis: SELECT * FROM tabla ORDER BY columna OFFSET numero_filas_a_saltar ROWS FETCH NEXT numero_filas ROWS ONLY;

-- Primera página (filas 1-5)
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre 
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- Segunda página (filas 6-10)
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre 
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;

-- Tercera página (filas 11-15)
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre 
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;

-- 4. Paginación con ROW_NUMBER() (método alternativo)

-- Primera página usando ROW_NUMBER()
SELECT * FROM (
    SELECT 
        nombre, 
        apellido, 
        salario,
        ROW_NUMBER() OVER (ORDER BY nombre) AS row_num
    FROM empleados
) AS numbered_employees
WHERE row_num BETWEEN 1 AND 5;

-- Segunda página usando ROW_NUMBER()
SELECT * FROM (
    SELECT 
        nombre, 
        apellido, 
        salario,
        ROW_NUMBER() OVER (ORDER BY nombre) AS row_num
    FROM empleados
) AS numbered_employees
WHERE row_num BETWEEN 6 AND 10;

-- 5. Limitación con WHERE y ORDER BY

-- Top 3 empleados con mayor salario del departamento 1
SELECT TOP 3 nombre, apellido, salario, departamento_id 
FROM empleados 
WHERE departamento_id = 1 
ORDER BY salario DESC;

-- Top 5 empleados más jóvenes
SELECT TOP 5 nombre, apellido, fecha_nacimiento 
FROM empleados 
ORDER BY fecha_nacimiento DESC;

-- 6. Limitación con DISTINCT

-- Primeros 3 departamentos únicos
SELECT DISTINCT TOP 3 departamento_id 
FROM empleados 
ORDER BY departamento_id;

-- 7. Limitación con funciones agregadas

-- Top 3 departamentos por número de empleados
SELECT TOP 3
    departamento_id,
    COUNT(*) AS numero_empleados
FROM empleados 
GROUP BY departamento_id 
ORDER BY numero_empleados DESC;

-- 8. Limitación con subconsultas

-- Empleados con salario mayor al promedio (limitado a 5)
SELECT TOP 5 nombre, apellido, salario 
FROM empleados 
WHERE salario > (SELECT AVG(salario) FROM empleados)
ORDER BY salario DESC;

-- 9. Limitación con JOINs

-- Top 3 empleados con mayor salario incluyendo nombre del departamento
SELECT TOP 3
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento
FROM empleados e
JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.salario DESC;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Limitación básica:
--    - PostgreSQL: LIMIT
--    - MS SQL Server: TOP
-- 2. Paginación:
--    - PostgreSQL: LIMIT ... OFFSET
--    - MS SQL Server: OFFSET ... FETCH (SQL Server 2012+) o ROW_NUMBER()
-- 3. Porcentaje:
--    - PostgreSQL: No soportado nativamente
--    - MS SQL Server: TOP ... PERCENT
-- 4. Sintaxis de paginación:
--    - PostgreSQL: LIMIT count OFFSET offset
--    - MS SQL Server: OFFSET offset ROWS FETCH NEXT count ROWS ONLY

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Siempre usa ORDER BY con LIMIT/TOP para resultados predecibles
-- 2. Para paginación, usa OFFSET-FETCH en SQL Server moderno
-- 3. Considera el rendimiento: LIMIT/OFFSET puede ser lento en tablas grandes
-- 4. Usa índices en las columnas de ORDER BY para mejor rendimiento
-- 5. Para resultados consistentes, asegúrate de que ORDER BY sea único
-- 6. TOP con PERCENT es útil para análisis exploratorio
-- 7. ROW_NUMBER() es más flexible pero más complejo
-- 8. Siempre especifica el orden de las filas antes de limitar
