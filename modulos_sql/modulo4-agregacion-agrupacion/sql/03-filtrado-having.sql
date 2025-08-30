-- =====================================================
-- Script: Filtrado de Grupos con HAVING
-- Módulo 4: Agregación y Agrupación
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. DIFERENCIAS ENTRE WHERE Y HAVING
-- WHERE: Filtra filas individuales ANTES de la agrupación
-- HAVING: Filtra grupos DESPUÉS de la agrupación

-- Ejemplo: Empleados activos por departamento, solo departamentos con más de 2 empleados
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
WHERE activo = TRUE                    -- WHERE: Filtra empleados activos
GROUP BY departamento_id
HAVING COUNT(*) > 2                    -- HAVING: Filtra departamentos con > 2 empleados
ORDER BY departamento_id;

-- 2. HAVING CON FUNCIONES AGREGADAS BÁSICAS

-- Departamentos con salario promedio mayor a 65,000
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY departamento_id
HAVING AVG(salario) > 65000
ORDER BY salario_promedio DESC;

-- Departamentos con menos de 3 empleados
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados
FROM empleados 
GROUP BY departamento_id
HAVING COUNT(*) < 3
ORDER BY numero_empleados;

-- 3. HAVING CON MÚLTIPLES CONDICIONES

-- Departamentos que cumplan múltiples condiciones
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    SUM(salario) AS total_salarios
FROM empleados 
GROUP BY departamento_id
HAVING 
    COUNT(*) >= 2 AND                    -- Al menos 2 empleados
    AVG(salario) > 60000 AND             -- Salario promedio > 60k
    SUM(salario) < 500000                -- Total salarios < 500k
ORDER BY departamento_id;

-- 4. HAVING CON FUNCIONES AGREGADAS COMPLEJAS

-- Departamentos con alta variabilidad de salarios (desviación estándar > 10,000)
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    ROUND(STDDEV(salario), 2) AS desviacion_estandar
FROM empleados 
GROUP BY departamento_id
HAVING STDDEV(salario) > 10000
ORDER BY desviacion_estandar DESC;

-- 5. HAVING CON EXPRESIONES CONDICIONALES

-- Departamentos con mayoría de empleados en cierto rango de salario
SELECT 
    departamento_id,
    COUNT(*) AS total_empleados,
    COUNT(CASE WHEN salario > 70000 THEN 1 END) AS empleados_alto_salario,
    ROUND((COUNT(CASE WHEN salario > 70000 THEN 1 END) * 100.0 / COUNT(*)), 2) AS porcentaje_alto_salario
FROM empleados 
GROUP BY departamento_id
HAVING (COUNT(CASE WHEN salario > 70000 THEN 1 END) * 100.0 / COUNT(*)) > 50
ORDER BY porcentaje_alto_salario DESC;

-- 6. HAVING CON SUBCONSULTAS

-- Departamentos con salario promedio mayor al promedio general de la empresa
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_departamento,
    (SELECT ROUND(AVG(salario), 2) FROM empleados) AS salario_promedio_empresa
FROM empleados 
GROUP BY departamento_id
HAVING AVG(salario) > (SELECT AVG(salario) FROM empleados)
ORDER BY salario_promedio_departamento DESC;

-- 7. HAVING CON FECHAS

-- Departamentos con empleados contratados en años específicos
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    COUNT(CASE WHEN EXTRACT(YEAR FROM fecha_contratacion) = 2024 THEN 1 END) AS contratados_2024
FROM empleados 
GROUP BY departamento_id
HAVING COUNT(CASE WHEN EXTRACT(YEAR FROM fecha_contratacion) = 2024 THEN 1 END) > 0
ORDER BY departamento_id;

-- 8. HAVING CON OPERADORES DE COMPARACIÓN COMPLEJOS

-- Departamentos con salarios en rangos específicos
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    MAX(salario) - MIN(salario) AS rango_salarios
FROM empleados 
GROUP BY departamento_id
HAVING 
    MAX(salario) - MIN(salario) > 20000 AND    -- Rango de salarios > 20k
    MAX(salario) < 100000                       -- Salario máximo < 100k
ORDER BY rango_salarios DESC;

-- 9. HAVING CON MÚLTIPLES GRUPOS

-- Análisis por departamento y año de contratación
SELECT 
    departamento_id,
    EXTRACT(YEAR FROM fecha_contratacion) AS año_contratacion,
    COUNT(*) AS empleados_contratados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY departamento_id, EXTRACT(YEAR FROM fecha_contratacion)
HAVING COUNT(*) >= 1 AND AVG(salario) > 55000
ORDER BY departamento_id, año_contratacion;

-- 10. HAVING CON FUNCIONES DE STRING

-- Departamentos con nombres de empleados de cierta longitud
SELECT 
    departamento_id,
    LENGTH(nombre) AS longitud_nombre,
    COUNT(*) AS empleados_misma_longitud,
    STRING_AGG(nombre, ', ') AS nombres_ejemplo
FROM empleados 
GROUP BY departamento_id, LENGTH(nombre)
HAVING COUNT(*) >= 2 AND LENGTH(nombre) > 4
ORDER BY departamento_id, longitud_nombre;

-- 11. COMBINACIÓN COMPLEJA DE WHERE Y HAVING

-- Análisis completo: empleados activos por departamento con filtros complejos
SELECT 
    departamento_id,
    COUNT(*) AS total_empleados,
    COUNT(CASE WHEN telefono IS NOT NULL THEN 1 END) AS con_telefono,
    ROUND(AVG(salario), 2) AS salario_promedio,
    ROUND(STDDEV(salario), 2) AS desviacion_estandar
FROM empleados 
WHERE 
    activo = TRUE AND                           -- Solo empleados activos
    fecha_contratacion >= '2020-01-01'         -- Contratados desde 2020
GROUP BY departamento_id
HAVING 
    COUNT(*) >= 2 AND                           -- Al menos 2 empleados
    AVG(salario) > 60000 AND                    -- Salario promedio > 60k
    COUNT(CASE WHEN telefono IS NOT NULL THEN 1 END) > 0  -- Al menos 1 con teléfono
ORDER BY salario_promedio DESC;

-- 12. HAVING CON FUNCIONES AGREGADAS ANIDADAS

-- Departamentos con empleados que tienen salarios por encima del percentil 75
SELECT 
    departamento_id,
    COUNT(*) AS total_empleados,
    COUNT(CASE WHEN salario > (
        SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) 
        FROM empleados
    ) THEN 1 END) AS empleados_alto_percentil
FROM empleados 
GROUP BY departamento_id
HAVING COUNT(CASE WHEN salario > (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) 
    FROM empleados
) THEN 1 END) > 0
ORDER BY empleados_alto_percentil DESC;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. DIFERENCIAS ENTRE WHERE Y HAVING
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
WHERE activo = 1                              -- WHERE: Filtra empleados activos
GROUP BY departamento_id
HAVING COUNT(*) > 2                            -- HAVING: Filtra departamentos con > 2 empleados
ORDER BY departamento_id;

-- 2. HAVING CON FUNCIONES AGREGADAS BÁSICAS
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY departamento_id
HAVING AVG(salario) > 65000
ORDER BY salario_promedio DESC;

-- 3. HAVING CON MÚLTIPLES CONDICIONES
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    SUM(salario) AS total_salarios
FROM empleados 
GROUP BY departamento_id
HAVING 
    COUNT(*) >= 2 AND
    AVG(salario) > 60000 AND
    SUM(salario) < 500000
ORDER BY departamento_id;

-- 4. HAVING CON FUNCIONES AGREGADAS COMPLEJAS
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    ROUND(STDEV(salario), 2) AS desviacion_estandar
FROM empleados 
GROUP BY departamento_id
HAVING STDEV(salario) > 10000
ORDER BY desviacion_estandar DESC;

-- 5. HAVING CON EXPRESIONES CONDICIONALES
SELECT 
    departamento_id,
    COUNT(*) AS total_empleados,
    COUNT(CASE WHEN salario > 70000 THEN 1 END) AS empleados_alto_salario,
    ROUND((COUNT(CASE WHEN salario > 70000 THEN 1 END) * 100.0 / COUNT(*)), 2) AS porcentaje_alto_salario
FROM empleados 
GROUP BY departamento_id
HAVING (COUNT(CASE WHEN salario > 70000 THEN 1 END) * 100.0 / COUNT(*)) > 50
ORDER BY porcentaje_alto_salario DESC;

-- 6. HAVING CON SUBCONSULTAS
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_departamento,
    (SELECT ROUND(AVG(salario), 2) FROM empleados) AS salario_promedio_empresa
FROM empleados 
GROUP BY departamento_id
HAVING AVG(salario) > (SELECT AVG(salario) FROM empleados)
ORDER BY salario_promedio_departamento DESC;

-- 7. HAVING CON FECHAS
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    COUNT(CASE WHEN YEAR(fecha_contratacion) = 2024 THEN 1 END) AS contratados_2024
FROM empleados 
GROUP BY departamento_id
HAVING COUNT(CASE WHEN YEAR(fecha_contratacion) = 2024 THEN 1 END) > 0
ORDER BY departamento_id;

-- 8. HAVING CON OPERADORES DE COMPARACIÓN COMPLEJOS
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    MAX(salario) - MIN(salario) AS rango_salarios
FROM empleados 
GROUP BY departamento_id
HAVING 
    MAX(salario) - MIN(salario) > 20000 AND
    MAX(salario) < 100000
ORDER BY rango_salarios DESC;

-- 9. HAVING CON MÚLTIPLES GRUPOS
SELECT 
    departamento_id,
    YEAR(fecha_contratacion) AS año_contratacion,
    COUNT(*) AS empleados_contratados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY departamento_id, YEAR(fecha_contratacion)
HAVING COUNT(*) >= 1 AND AVG(salario) > 55000
ORDER BY departamento_id, año_contratacion;

-- 10. HAVING CON FUNCIONES DE STRING
SELECT 
    departamento_id,
    LEN(nombre) AS longitud_nombre,
    COUNT(*) AS empleados_misma_longitud,
    STRING_AGG(nombre, ', ') AS nombres_ejemplo
FROM empleados 
GROUP BY departamento_id, LEN(nombre)
HAVING COUNT(*) >= 2 AND LEN(nombre) > 4
ORDER BY departamento_id, longitud_nombre;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Desviación estándar:
--    - PostgreSQL: STDDEV()
--    - MS SQL Server: STDEV()
-- 2. Extracción de año:
--    - PostgreSQL: EXTRACT(YEAR FROM fecha)
--    - MS SQL Server: YEAR(fecha)
-- 3. Longitud de string:
--    - PostgreSQL: LENGTH()
--    - MS SQL Server: LEN()
-- 4. Valores booleanos:
--    - PostgreSQL: TRUE/FALSE
--    - MS SQL Server: 1/0
-- 5. Sintaxis básica: Idéntica para HAVING

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. WHERE filtra filas ANTES de la agrupación, HAVING filtra grupos DESPUÉS
-- 2. Usa WHERE para condiciones que no involucran funciones agregadas
-- 3. Usa HAVING para condiciones que involucran funciones agregadas
-- 4. Las condiciones en HAVING pueden usar funciones agregadas y subconsultas
-- 5. Considera el rendimiento: filtra con WHERE primero cuando sea posible
-- 6. HAVING se ejecuta después de GROUP BY pero antes de ORDER BY
-- 7. Puedes usar operadores lógicos (AND, OR) en HAVING
-- 8. Las subconsultas en HAVING pueden afectar el rendimiento
