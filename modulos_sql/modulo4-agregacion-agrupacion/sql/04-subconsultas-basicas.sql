-- =====================================================
-- Script: Subconsultas Básicas
-- Módulo 4: Agregación y Agrupación
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. SUBCONSULTAS EN SELECT
-- Sintaxis: SELECT columna, (subconsulta) AS alias FROM tabla

-- Empleados con su salario y el salario promedio de la empresa
SELECT 
    nombre,
    apellido,
    salario,
    (SELECT ROUND(AVG(salario), 2) FROM empleados) AS salario_promedio_empresa,
    salario - (SELECT AVG(salario) FROM empleados) AS diferencia_promedio
FROM empleados;

-- Empleados con su salario y el salario promedio de su departamento
SELECT 
    nombre,
    apellido,
    departamento_id,
    salario,
    (SELECT ROUND(AVG(salario), 2) FROM empleados e2 WHERE e2.departamento_id = e1.departamento_id) AS salario_promedio_departamento
FROM empleados e1;

-- 2. SUBCONSULTAS EN WHERE

-- Empleados con salario mayor al promedio
SELECT 
    nombre,
    apellido,
    salario
FROM empleados 
WHERE salario > (SELECT AVG(salario) FROM empleados)
ORDER BY salario DESC;

-- Empleados del departamento con mayor salario promedio
SELECT 
    nombre,
    apellido,
    departamento_id,
    salario
FROM empleados 
WHERE departamento_id = (
    SELECT departamento_id 
    FROM empleados 
    GROUP BY departamento_id 
    ORDER BY AVG(salario) DESC 
    LIMIT 1
);

-- 3. SUBCONSULTAS EN FROM

-- Análisis de departamentos con estadísticas
SELECT 
    d.nombre AS nombre_departamento,
    stats.numero_empleados,
    stats.salario_promedio,
    stats.total_salarios
FROM departamentos d
JOIN (
    SELECT 
        departamento_id,
        COUNT(*) AS numero_empleados,
        ROUND(AVG(salario), 2) AS salario_promedio,
        SUM(salario) AS total_salarios
    FROM empleados 
    GROUP BY departamento_id
) stats ON d.id = stats.departamento_id
ORDER BY stats.salario_promedio DESC;

-- 4. SUBCONSULTAS CORRELACIONADAS

-- Empleados con salario mayor al promedio de su departamento
SELECT 
    nombre,
    apellido,
    departamento_id,
    salario
FROM empleados e1
WHERE salario > (
    SELECT AVG(salario) 
    FROM empleados e2 
    WHERE e2.departamento_id = e1.departamento_id
)
ORDER BY departamento_id, salario DESC;

-- 5. SUBCONSULTAS CON EXISTS

-- Departamentos que tienen empleados con salario > 70,000
SELECT 
    id,
    nombre,
    ubicacion
FROM departamentos d
WHERE EXISTS (
    SELECT 1 
    FROM empleados e 
    WHERE e.departamento_id = d.id 
    AND e.salario > 70000
);

-- Departamentos que NO tienen empleados
SELECT 
    id,
    nombre,
    ubicacion
FROM departamentos d
WHERE NOT EXISTS (
    SELECT 1 
    FROM empleados e 
    WHERE e.departamento_id = d.id
);

-- 6. SUBCONSULTAS CON IN

-- Empleados que trabajan en departamentos con presupuesto > 300,000
SELECT 
    nombre,
    apellido,
    departamento_id,
    salario
FROM empleados 
WHERE departamento_id IN (
    SELECT id 
    FROM departamentos 
    WHERE presupuesto > 300000
);

-- 7. SUBCONSULTAS CON ANY/ALL

-- Empleados con salario mayor a TODOS los empleados del departamento 2
SELECT 
    nombre,
    apellido,
    salario,
    departamento_id
FROM empleados 
WHERE salario > ALL (
    SELECT salario 
    FROM empleados 
    WHERE departamento_id = 2
);

-- Empleados con salario mayor a ALGÚN empleado del departamento 1
SELECT 
    nombre,
    apellido,
    salario,
    departamento_id
FROM empleados 
WHERE salario > ANY (
    SELECT salario 
    FROM empleados 
    WHERE departamento_id = 1
);

-- 8. SUBCONSULTAS ESCALARES

-- Empleados con información del departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    (SELECT d.nombre FROM departamentos d WHERE d.id = e.departamento_id) AS nombre_departamento,
    (SELECT d.ubicacion FROM departamentos d WHERE d.id = e.departamento_id) AS ubicacion_departamento
FROM empleados e;

-- 9. SUBCONSULTAS CON FUNCIONES AGREGADAS

-- Empleados con salario en el top 25% de la empresa
SELECT 
    nombre,
    apellido,
    salario
FROM empleados 
WHERE salario >= (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) 
    FROM empleados
)
ORDER BY salario DESC;

-- 10. SUBCONSULTAS ANIDADAS

-- Empleados del departamento con mayor número de empleados
SELECT 
    nombre,
    apellido,
    departamento_id,
    salario
FROM empleados 
WHERE departamento_id = (
    SELECT departamento_id 
    FROM (
        SELECT 
            departamento_id,
            COUNT(*) AS numero_empleados
        FROM empleados 
        GROUP BY departamento_id
        ORDER BY numero_empleados DESC
        LIMIT 1
    ) AS dept_mas_empleados
);

-- 11. SUBCONSULTAS CON CASE

-- Clasificar empleados por su salario relativo al departamento
SELECT 
    nombre,
    apellido,
    departamento_id,
    salario,
    CASE 
        WHEN salario > (SELECT AVG(salario) * 1.2 FROM empleados e2 WHERE e2.departamento_id = e1.departamento_id) THEN 'Alto'
        WHEN salario < (SELECT AVG(salario) * 0.8 FROM empleados e2 WHERE e2.departamento_id = e1.departamento_id) THEN 'Bajo'
        ELSE 'Medio'
    END AS categoria_salario_departamento
FROM empleados e1;

-- 12. SUBCONSULTAS CON LIMIT

-- Top 3 empleados por departamento
SELECT 
    e1.nombre,
    e1.apellido,
    e1.departamento_id,
    e1.salario,
    (SELECT COUNT(*) + 1 FROM empleados e2 
     WHERE e2.departamento_id = e1.departamento_id AND e2.salario > e1.salario) AS ranking_departamento
FROM empleados e1
WHERE (
    SELECT COUNT(*) FROM empleados e2 
    WHERE e2.departamento_id = e1.departamento_id AND e2.salario > e1.salario
) < 3
ORDER BY e1.departamento_id, e1.salario DESC;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. SUBCONSULTAS EN SELECT
SELECT 
    nombre,
    apellido,
    salario,
    (SELECT ROUND(AVG(salario), 2) FROM empleados) AS salario_promedio_empresa,
    salario - (SELECT AVG(salario) FROM empleados) AS diferencia_promedio
FROM empleados;

-- 2. SUBCONSULTAS EN WHERE
SELECT 
    nombre,
    apellido,
    salario
FROM empleados 
WHERE salario > (SELECT AVG(salario) FROM empleados)
ORDER BY salario DESC;

-- 3. SUBCONSULTAS EN FROM
SELECT 
    d.nombre AS nombre_departamento,
    stats.numero_empleados,
    stats.salario_promedio,
    stats.total_salarios
FROM departamentos d
JOIN (
    SELECT 
        departamento_id,
        COUNT(*) AS numero_empleados,
        ROUND(AVG(salario), 2) AS salario_promedio,
        SUM(salario) AS total_salarios
    FROM empleados 
    GROUP BY departamento_id
) stats ON d.id = stats.departamento_id
ORDER BY stats.salario_promedio DESC;

-- 4. SUBCONSULTAS CORRELACIONADAS
SELECT 
    nombre,
    apellido,
    departamento_id,
    salario
FROM empleados e1
WHERE salario > (
    SELECT AVG(salario) 
    FROM empleados e2 
    WHERE e2.departamento_id = e1.departamento_id
)
ORDER BY departamento_id, salario DESC;

-- 5. SUBCONSULTAS CON EXISTS
SELECT 
    id,
    nombre,
    ubicacion
FROM departamentos d
WHERE EXISTS (
    SELECT 1 
    FROM empleados e 
    WHERE e.departamento_id = d.id 
    AND e.salario > 70000
);

-- 6. SUBCONSULTAS CON IN
SELECT 
    nombre,
    apellido,
    departamento_id,
    salario
FROM empleados 
WHERE departamento_id IN (
    SELECT id 
    FROM departamentos 
    WHERE presupuesto > 300000
);

-- 7. SUBCONSULTAS CON ANY/ALL
SELECT 
    nombre,
    apellido,
    salario,
    departamento_id
FROM empleados 
WHERE salario > ALL (
    SELECT salario 
    FROM empleados 
    WHERE departamento_id = 2
);

-- 8. SUBCONSULTAS ESCALARES
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    (SELECT d.nombre FROM departamentos d WHERE d.id = e.departamento_id) AS nombre_departamento,
    (SELECT d.ubicacion FROM departamentos d WHERE d.id = e.departamento_id) AS ubicacion_departamento
FROM empleados e;

-- 9. SUBCONSULTAS CON FUNCIONES AGREGADAS
-- Top 25% en SQL Server
SELECT 
    nombre,
    apellido,
    salario
FROM empleados e1
WHERE salario >= (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) OVER()
    FROM empleados
)
ORDER BY salario DESC;

-- 10. SUBCONSULTAS ANIDADAS
SELECT 
    nombre,
    apellido,
    departamento_id,
    salario
FROM empleados 
WHERE departamento_id = (
    SELECT TOP 1 departamento_id 
    FROM (
        SELECT 
            departamento_id,
            COUNT(*) AS numero_empleados
        FROM empleados 
        GROUP BY departamento_id
    ) AS dept_mas_empleados
    ORDER BY numero_empleados DESC
);

-- 11. SUBCONSULTAS CON CASE
SELECT 
    nombre,
    apellido,
    departamento_id,
    salario,
    CASE 
        WHEN salario > (SELECT AVG(salario) * 1.2 FROM empleados e2 WHERE e2.departamento_id = e1.departamento_id) THEN 'Alto'
        WHEN salario < (SELECT AVG(salario) * 0.8 FROM empleados e2 WHERE e2.departamento_id = e1.departamento_id) THEN 'Bajo'
        ELSE 'Medio'
    END AS categoria_salario_departamento
FROM empleados e1;

-- 12. SUBCONSULTAS CON TOP
-- Top 3 empleados por departamento usando ROW_NUMBER()
SELECT 
    e1.nombre,
    e1.apellido,
    e1.departamento_id,
    e1.salario,
    e1.ranking_departamento
FROM (
    SELECT 
        nombre,
        apellido,
        departamento_id,
        salario,
        ROW_NUMBER() OVER (PARTITION BY departamento_id ORDER BY salario DESC) AS ranking_departamento
    FROM empleados
) e1
WHERE e1.ranking_departamento <= 3
ORDER BY e1.departamento_id, e1.ranking_departamento;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Percentiles:
--    - PostgreSQL: PERCENTILE_CONT() WITHIN GROUP
--    - MS SQL Server: PERCENTILE_CONT() WITHIN GROUP OVER()
-- 2. Top N:
--    - PostgreSQL: LIMIT
--    - MS SQL Server: TOP o ROW_NUMBER()
-- 3. Sintaxis básica: Idéntica para subconsultas estándar
-- 4. Funciones de ventana: Más avanzadas en PostgreSQL
-- 5. Rendimiento: Puede variar entre sistemas

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Las subconsultas escalares deben devolver una sola fila y columna
-- 2. Las subconsultas correlacionadas pueden ser lentas en tablas grandes
-- 3. Usa EXISTS en lugar de IN para mejor rendimiento
-- 4. Considera usar JOINs en lugar de subconsultas cuando sea posible
-- 5. Las subconsultas anidadas pueden ser difíciles de mantener
-- 6. Usa alias descriptivos para subconsultas
-- 7. Ten en cuenta el orden de ejecución: FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
-- 8. Las subconsultas en SELECT se ejecutan para cada fila
