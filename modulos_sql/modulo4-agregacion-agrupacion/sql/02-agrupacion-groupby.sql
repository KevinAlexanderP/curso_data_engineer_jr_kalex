-- =====================================================
-- Script: Agrupación con GROUP BY
-- Módulo 4: Agregación y Agrupación
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. AGRUPACIÓN BÁSICA POR UNA COLUMNA
-- Sintaxis: SELECT columna, funcion_agregada() FROM tabla GROUP BY columna

-- Agrupar empleados por departamento
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY departamento_id
ORDER BY departamento_id;

-- 2. AGRUPACIÓN POR MÚLTIPLES COLUMNAS

-- Agrupar por departamento y estado activo
SELECT 
    departamento_id,
    activo,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY departamento_id, activo
ORDER BY departamento_id, activo;

-- 3. AGRUPACIÓN CON FUNCIONES

-- Agrupar por año de contratación
SELECT 
    EXTRACT(YEAR FROM fecha_contratacion) AS año_contratacion,
    COUNT(*) AS empleados_contratados,
    ROUND(AVG(salario), 2) AS salario_promedio_año
FROM empleados 
GROUP BY EXTRACT(YEAR FROM fecha_contratacion)
ORDER BY año_contratacion;

-- 4. AGRUPACIÓN CON EXPRESIONES CONDICIONALES

-- Agrupar por rango de salario
SELECT 
    CASE 
        WHEN salario < 60000 THEN 'Bajo (< 60k)'
        WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
        ELSE 'Alto (> 75k)'
    END AS rango_salario,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_rango,
    MIN(salario) AS salario_minimo_rango,
    MAX(salario) AS salario_maximo_rango
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

-- 5. AGRUPACIÓN CON FUNCIONES DE STRING

-- Agrupar por longitud del nombre
SELECT 
    LENGTH(nombre) AS longitud_nombre,
    COUNT(*) AS frecuencia,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM empleados)), 2) AS porcentaje,
    STRING_AGG(nombre, ', ') AS nombres_ejemplo
FROM empleados 
GROUP BY LENGTH(nombre)
ORDER BY longitud_nombre;

-- 6. AGRUPACIÓN CON FECHAS

-- Agrupar por mes de contratación
SELECT 
    EXTRACT(MONTH FROM fecha_contratacion) AS mes_contratacion,
    TO_CHAR(fecha_contratacion, 'Month') AS nombre_mes,
    COUNT(*) AS empleados_contratados,
    ROUND(AVG(salario), 2) AS salario_promedio_mes
FROM empleados 
GROUP BY EXTRACT(MONTH FROM fecha_contratacion), TO_CHAR(fecha_contratacion, 'Month')
ORDER BY mes_contratacion;

-- 7. AGRUPACIÓN CON MÚLTIPLES FUNCIONES AGREGADAS

-- Estadísticas completas por departamento
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    COUNT(CASE WHEN activo = TRUE THEN 1 END) AS empleados_activos,
    COUNT(CASE WHEN telefono IS NOT NULL THEN 1 END) AS empleados_con_telefono,
    ROUND(AVG(salario), 2) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    SUM(salario) AS total_salarios,
    ROUND(STDDEV(salario), 2) AS desviacion_estandar
FROM empleados 
GROUP BY departamento_id
ORDER BY departamento_id;

-- 8. AGRUPACIÓN CON SUBCONSULTAS

-- Agrupar por departamento y mostrar el nombre del departamento
SELECT 
    e.departamento_id,
    d.nombre AS nombre_departamento,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio
FROM empleados e
JOIN departamentos d ON e.departamento_id = d.id
GROUP BY e.departamento_id, d.nombre
ORDER BY e.departamento_id;

-- 9. AGRUPACIÓN CON FILTROS COMPLEJOS

-- Agrupar empleados activos por departamento, excluyendo departamentos con menos de 2 empleados
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
WHERE activo = TRUE
GROUP BY departamento_id
HAVING COUNT(*) >= 2
ORDER BY departamento_id;

-- 10. AGRUPACIÓN AVANZADA CON ROLLUP

-- Agrupar por departamento y año, con totales
SELECT 
    COALESCE(departamento_id::TEXT, 'TOTAL') AS departamento,
    COALESCE(EXTRACT(YEAR FROM fecha_contratacion)::TEXT, 'TODOS') AS año,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY ROLLUP(departamento_id, EXTRACT(YEAR FROM fecha_contratacion))
ORDER BY departamento_id, año;

-- 11. AGRUPACIÓN CON CUBE

-- Agrupar por departamento y estado activo, con todas las combinaciones
SELECT 
    COALESCE(departamento_id::TEXT, 'TOTAL') AS departamento,
    COALESCE(CASE WHEN activo THEN 'Activo' ELSE 'Inactivo' END, 'TODOS') AS estado,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY CUBE(departamento_id, activo)
ORDER BY departamento_id, activo;

-- 12. AGRUPACIÓN CON GROUPING SETS

-- Agrupar por diferentes combinaciones específicas
SELECT 
    COALESCE(departamento_id::TEXT, 'TOTAL') AS departamento,
    COALESCE(EXTRACT(YEAR FROM fecha_contratacion)::TEXT, 'TODOS') AS año,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY GROUPING SETS (
    (departamento_id, EXTRACT(YEAR FROM fecha_contratacion)),
    (departamento_id),
    (EXTRACT(YEAR FROM fecha_contratacion)),
    ()
)
ORDER BY departamento_id, año;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. AGRUPACIÓN BÁSICA POR UNA COLUMNA
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY departamento_id
ORDER BY departamento_id;

-- 2. AGRUPACIÓN POR MÚLTIPLES COLUMNAS
SELECT 
    departamento_id,
    activo,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY departamento_id, activo
ORDER BY departamento_id, activo;

-- 3. AGRUPACIÓN CON FUNCIONES
SELECT 
    YEAR(fecha_contratacion) AS año_contratacion,
    COUNT(*) AS empleados_contratados,
    ROUND(AVG(salario), 2) AS salario_promedio_año
FROM empleados 
GROUP BY YEAR(fecha_contratacion)
ORDER BY año_contratacion;

-- 4. AGRUPACIÓN CON EXPRESIONES CONDICIONALES
SELECT 
    CASE 
        WHEN salario < 60000 THEN 'Bajo (< 60k)'
        WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
        ELSE 'Alto (> 75k)'
    END AS rango_salario,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_rango,
    MIN(salario) AS salario_minimo_rango,
    MAX(salario) AS salario_maximo_rango
FROM empleados 
GROUP BY 
    CASE 
        WHEN salario < 60000 THEN 'Bajo (< 60k)'
        WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
        ELSE 'Alto (> 75k)'
    END;

-- 5. AGRUPACIÓN CON FUNCIONES DE STRING
SELECT 
    LEN(nombre) AS longitud_nombre,
    COUNT(*) AS frecuencia,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM empleados)), 2) AS porcentaje,
    STRING_AGG(nombre, ', ') AS nombres_ejemplo
FROM empleados 
GROUP BY LEN(nombre)
ORDER BY longitud_nombre;

-- 6. AGRUPACIÓN CON FECHAS
SELECT 
    MONTH(fecha_contratacion) AS mes_contratacion,
    DATENAME(MONTH, fecha_contratacion) AS nombre_mes,
    COUNT(*) AS empleados_contratados,
    ROUND(AVG(salario), 2) AS salario_promedio_mes
FROM empleados 
GROUP BY MONTH(fecha_contratacion), DATENAME(MONTH, fecha_contratacion)
ORDER BY mes_contratacion;

-- 7. AGRUPACIÓN CON MÚLTIPLES FUNCIONES AGREGADAS
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    COUNT(CASE WHEN activo = 1 THEN 1 END) AS empleados_activos,
    COUNT(CASE WHEN telefono IS NOT NULL THEN 1 END) AS empleados_con_telefono,
    ROUND(AVG(salario), 2) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    SUM(salario) AS total_salarios,
    ROUND(STDEV(salario), 2) AS desviacion_estandar
FROM empleados 
GROUP BY departamento_id
ORDER BY departamento_id;

-- 8. AGRUPACIÓN CON SUBCONSULTAS
SELECT 
    e.departamento_id,
    d.nombre AS nombre_departamento,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio
FROM empleados e
JOIN departamentos d ON e.departamento_id = d.id
GROUP BY e.departamento_id, d.nombre
ORDER BY e.departamento_id;

-- 9. AGRUPACIÓN CON FILTROS COMPLEJOS
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
WHERE activo = 1
GROUP BY departamento_id
HAVING COUNT(*) >= 2
ORDER BY departamento_id;

-- 10. AGRUPACIÓN AVANZADA CON ROLLUP
SELECT 
    ISNULL(CAST(departamento_id AS VARCHAR), 'TOTAL') AS departamento,
    ISNULL(CAST(YEAR(fecha_contratacion) AS VARCHAR), 'TODOS') AS año,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio
FROM empleados 
GROUP BY ROLLUP(departamento_id, YEAR(fecha_contratacion))
ORDER BY departamento_id, año;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Extracción de año:
--    - PostgreSQL: EXTRACT(YEAR FROM fecha)
--    - MS SQL Server: YEAR(fecha)
-- 2. Extracción de mes:
--    - PostgreSQL: EXTRACT(MONTH FROM fecha)
--    - MS SQL Server: MONTH(fecha)
-- 3. Nombre del mes:
--    - PostgreSQL: TO_CHAR(fecha, 'Month')
--    - MS SQL Server: DATENAME(MONTH, fecha)
-- 4. Longitud de string:
--    - PostgreSQL: LENGTH()
--    - MS SQL Server: LEN()
-- 5. Concatenación de strings:
--    - PostgreSQL: STRING_AGG()
--    - MS SQL Server: STRING_AGG() (SQL Server 2017+)
-- 6. Valores booleanos:
--    - PostgreSQL: TRUE/FALSE
--    - MS SQL Server: 1/0
-- 7. Conversión de tipos:
--    - PostgreSQL: ::TEXT
--    - MS SQL Server: CAST() o CONVERT()

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Siempre incluye ORDER BY después de GROUP BY para resultados predecibles
-- 2. Usa alias descriptivos para columnas calculadas
-- 3. Las columnas en SELECT deben estar en GROUP BY o ser funciones agregadas
-- 4. Considera el rendimiento: agrupar por columnas indexadas
-- 5. ROLLUP, CUBE y GROUPING SETS son útiles para reportes jerárquicos
-- 6. Usa HAVING para filtrar grupos, WHERE para filtrar filas individuales
-- 7. Las funciones agregadas se ejecutan después de GROUP BY
-- 8. Ten en cuenta que GROUP BY puede ser lento en tablas grandes
