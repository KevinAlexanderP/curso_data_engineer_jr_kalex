-- =====================================================
-- Script: Funciones Agregadas
-- Módulo 4: Agregación y Agrupación
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. FUNCIÓN COUNT - Contar filas
-- Sintaxis: COUNT(*), COUNT(columna), COUNT(DISTINCT columna)

-- Contar todos los empleados
SELECT COUNT(*) AS total_empleados FROM empleados;

-- Contar empleados con teléfono (excluyendo NULL)
SELECT COUNT(telefono) AS empleados_con_telefono FROM empleados;

-- Contar empleados sin teléfono (usando CASE)
SELECT COUNT(CASE WHEN telefono IS NULL THEN 1 END) AS empleados_sin_telefono FROM empleados;

-- Contar departamentos únicos donde trabajan empleados
SELECT COUNT(DISTINCT departamento_id) AS departamentos_activos FROM empleados;

-- 2. FUNCIÓN SUM - Sumar valores
-- Sintaxis: SUM(columna)

-- Suma total de salarios
SELECT SUM(salario) AS total_salarios FROM empleados;

-- Suma de salarios por departamento
SELECT 
    departamento_id,
    SUM(salario) AS total_salarios_departamento
FROM empleados 
GROUP BY departamento_id;

-- Suma condicional (solo empleados activos)
SELECT SUM(CASE WHEN activo = TRUE THEN salario ELSE 0 END) AS total_salarios_activos FROM empleados;

-- 3. FUNCIÓN AVG - Promedio
-- Sintaxis: AVG(columna)

-- Salario promedio de todos los empleados
SELECT AVG(salario) AS salario_promedio FROM empleados;

-- Salario promedio por departamento
SELECT 
    departamento_id,
    ROUND(AVG(salario), 2) AS salario_promedio_departamento
FROM empleados 
GROUP BY departamento_id;

-- Salario promedio excluyendo valores extremos (top y bottom 10%)
SELECT 
    ROUND(AVG(salario), 2) AS salario_promedio_ajustado
FROM (
    SELECT salario 
    FROM empleados 
    ORDER BY salario 
    LIMIT (SELECT COUNT(*) FROM empleados) - 2
    OFFSET 1
) AS salarios_ajustados;

-- 4. FUNCIÓN MIN - Valor mínimo
-- Sintaxis: MIN(columna)

-- Salario mínimo
SELECT MIN(salario) AS salario_minimo FROM empleados;

-- Salario mínimo por departamento
SELECT 
    departamento_id,
    MIN(salario) AS salario_minimo_departamento
FROM empleados 
GROUP BY departamento_id;

-- Empleado con menor salario (incluyendo información)
SELECT 
    nombre,
    apellido,
    salario,
    departamento_id
FROM empleados 
WHERE salario = (SELECT MIN(salario) FROM empleados);

-- 5. FUNCIÓN MAX - Valor máximo
-- Sintaxis: MAX(columna)

-- Salario máximo
SELECT MAX(salario) AS salario_maximo FROM empleados;

-- Salario máximo por departamento
SELECT 
    departamento_id,
    MAX(salario) AS salario_maximo_departamento
FROM empleados 
GROUP BY departamento_id;

-- Empleado con mayor salario (incluyendo información)
SELECT 
    nombre,
    apellido,
    salario,
    departamento_id
FROM empleados 
WHERE salario = (SELECT MAX(salario) FROM empleados);

-- 6. FUNCIONES AGREGADAS COMBINADAS

-- Estadísticas completas de salarios
SELECT 
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    SUM(salario) AS total_salarios,
    ROUND(STDDEV(salario), 2) AS desviacion_estandar
FROM empleados;

-- Estadísticas por departamento
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    SUM(salario) AS total_salarios
FROM empleados 
GROUP BY departamento_id
ORDER BY departamento_id;

-- 7. FUNCIONES AGREGADAS CONDICIONALES

-- Contar empleados por rango de salario
SELECT 
    CASE 
        WHEN salario < 60000 THEN 'Bajo (< 60k)'
        WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
        ELSE 'Alto (> 75k)'
    END AS rango_salario,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_rango
FROM empleados 
GROUP BY 
    CASE 
        WHEN salario < 60000 THEN 'Bajo (< 60k)'
        WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
        ELSE 'Alto (> 75k)'
    END
ORDER BY 
    CASE 
        WHEN 'Bajo (< 60k)' THEN 1
        WHEN 'Medio (60k-75k)' THEN 2
        ELSE 3
    END;

-- 8. FUNCIONES AGREGADAS CON FECHAS

-- Estadísticas por año de contratación
SELECT 
    EXTRACT(YEAR FROM fecha_contratacion) AS año_contratacion,
    COUNT(*) AS empleados_contratados,
    ROUND(AVG(salario), 2) AS salario_promedio_año
FROM empleados 
GROUP BY EXTRACT(YEAR FROM fecha_contratacion)
ORDER BY año_contratacion;

-- 9. FUNCIONES AGREGADAS CON STRINGS

-- Análisis de nombres por longitud
SELECT 
    LENGTH(nombre) AS longitud_nombre,
    COUNT(*) AS frecuencia,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM empleados)), 2) AS porcentaje
FROM empleados 
GROUP BY LENGTH(nombre)
ORDER BY longitud_nombre;

-- 10. FUNCIONES AGREGADAS AVANZADAS

-- Percentiles de salario
SELECT 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salario) AS percentil_25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salario) AS mediana,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) AS percentil_75
FROM empleados;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. FUNCIÓN COUNT - Contar filas
SELECT COUNT(*) AS total_empleados FROM empleados;
SELECT COUNT(telefono) AS empleados_con_telefono FROM empleados;
SELECT COUNT(CASE WHEN telefono IS NULL THEN 1 END) AS empleados_sin_telefono FROM empleados;
SELECT COUNT(DISTINCT departamento_id) AS departamentos_activos FROM empleados;

-- 2. FUNCIÓN SUM - Sumar valores
SELECT SUM(salario) AS total_salarios FROM empleados;
SELECT 
    departamento_id,
    SUM(salario) AS total_salarios_departamento
FROM empleados 
GROUP BY departamento_id;

-- 3. FUNCIÓN AVG - Promedio
SELECT AVG(salario) AS salario_promedio FROM empleados;
SELECT 
    departamento_id,
    ROUND(AVG(salario), 2) AS salario_promedio_departamento
FROM empleados 
GROUP BY departamento_id;

-- 4. FUNCIÓN MIN - Valor mínimo
SELECT MIN(salario) AS salario_minimo FROM empleados;
SELECT 
    departamento_id,
    MIN(salario) AS salario_minimo_departamento
FROM empleados 
GROUP BY departamento_id;

-- 5. FUNCIÓN MAX - Valor máximo
SELECT MAX(salario) AS salario_maximo FROM empleados;
SELECT 
    departamento_id,
    MAX(salario) AS salario_maximo_departamento
FROM empleados 
GROUP BY departamento_id;

-- 6. FUNCIONES AGREGADAS COMBINADAS
SELECT 
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    SUM(salario) AS total_salarios,
    ROUND(STDEV(salario), 2) AS desviacion_estandar
FROM empleados;

-- 7. FUNCIONES AGREGADAS CONDICIONALES
SELECT 
    CASE 
        WHEN salario < 60000 THEN 'Bajo (< 60k)'
        WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
        ELSE 'Alto (> 75k)'
    END AS rango_salario,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_rango
FROM empleados 
GROUP BY 
    CASE 
        WHEN salario < 60000 THEN 'Bajo (< 60k)'
        WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
        ELSE 'Alto (> 75k)'
    END;

-- 8. FUNCIONES AGREGADAS CON FECHAS
SELECT 
    YEAR(fecha_contratacion) AS año_contratacion,
    COUNT(*) AS empleados_contratados,
    ROUND(AVG(salario), 2) AS salario_promedio_año
FROM empleados 
GROUP BY YEAR(fecha_contratacion)
ORDER BY año_contratacion;

-- 9. FUNCIONES AGREGADAS CON STRINGS
SELECT 
    LEN(nombre) AS longitud_nombre,
    COUNT(*) AS frecuencia,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM empleados)), 2) AS porcentaje
FROM empleados 
GROUP BY LEN(nombre)
ORDER BY longitud_nombre;

-- 10. FUNCIONES AGREGADAS AVANZADAS
-- Percentiles en SQL Server
SELECT 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salario) OVER() AS percentil_25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salario) OVER() AS mediana,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) OVER() AS percentil_75
FROM empleados;
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
-- 4. Percentiles:
--    - PostgreSQL: PERCENTILE_CONT() WITHIN GROUP
--    - MS SQL Server: PERCENTILE_CONT() WITHIN GROUP OVER()
-- 5. Sintaxis básica: Idéntica para funciones agregadas estándar

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Usa COUNT(*) para contar filas, COUNT(columna) para valores no NULL
-- 2. Las funciones agregadas ignoran valores NULL por defecto
-- 3. Usa DISTINCT dentro de funciones agregadas para valores únicos
-- 4. Considera el rendimiento: las funciones agregadas pueden ser lentas en tablas grandes
-- 5. Usa índices en las columnas de agrupación para mejor rendimiento
-- 6. Las funciones agregadas se ejecutan después de WHERE pero antes de ORDER BY
-- 7. Usa alias descriptivos para resultados de funciones agregadas
-- 8. Ten en cuenta que las funciones agregadas devuelven una sola fila por grupo
