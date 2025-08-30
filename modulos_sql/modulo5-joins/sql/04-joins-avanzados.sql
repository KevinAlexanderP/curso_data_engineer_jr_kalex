-- =====================================================
-- Script: JOINs Avanzados
-- Módulo 5: JOINs y Relaciones entre Tablas
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. SELF JOIN
-- Un SELF JOIN es cuando una tabla se une consigo misma
-- Útil para relaciones jerárquicas o comparaciones internas

-- Empleados con sus gerentes (asumiendo que hay una columna gerente_id)
-- Primero, vamos a agregar algunos datos de ejemplo para gerentes
/*
-- Agregar columna gerente_id a la tabla empleados
ALTER TABLE empleados ADD COLUMN gerente_id INTEGER REFERENCES empleados(id);

-- Actualizar algunos empleados para que tengan gerentes
UPDATE empleados SET gerente_id = 1 WHERE id IN (2, 3, 4);
UPDATE empleados SET gerente_id = 2 WHERE id IN (5, 6);
UPDATE empleados SET gerente_id = 3 WHERE id IN (7, 8);
*/

-- SELF JOIN para mostrar empleados con sus gerentes
SELECT 
    e.nombre AS nombre_empleado,
    e.apellido AS apellido_empleado,
    e.salario AS salario_empleado,
    g.nombre AS nombre_gerente,
    g.apellido AS apellido_gerente,
    g.salario AS salario_gerente
FROM empleados e
LEFT JOIN empleados g ON e.gerente_id = g.id
ORDER BY e.apellido, e.nombre;

-- 2. SELF JOIN CON COMPARACIONES

-- Empleados que ganan más que su gerente
SELECT 
    e.nombre AS nombre_empleado,
    e.apellido AS apellido_empleado,
    e.salario AS salario_empleado,
    g.nombre AS nombre_gerente,
    g.apellido AS apellido_gerente,
    g.salario AS salario_gerente,
    e.salario - g.salario AS diferencia_salario
FROM empleados e
INNER JOIN empleados g ON e.gerente_id = g.id
WHERE e.salario > g.salario
ORDER BY diferencia_salario DESC;

-- 3. SELF JOIN CON AGRUPACIÓN

-- Estadísticas de empleados por gerente
SELECT 
    g.nombre AS nombre_gerente,
    g.apellido AS apellido_gerente,
    COUNT(e.id) AS empleados_a_cargo,
    ROUND(AVG(e.salario), 2) AS salario_promedio_equipo,
    SUM(e.salario) AS total_salarios_equipo
FROM empleados g
LEFT JOIN empleados e ON g.id = e.gerente_id
WHERE e.id IS NOT NULL
GROUP BY g.id, g.nombre, g.apellido
ORDER BY empleados_a_cargo DESC;

-- 4. CROSS JOIN
-- Producto cartesiano de dos tablas
-- Útil para generar combinaciones o cuando no hay relación directa

-- Generar todas las combinaciones posibles de departamentos y rangos de salario
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    CASE 
        WHEN r.rango = 1 THEN 'Bajo (< 60k)'
        WHEN r.rango = 2 THEN 'Medio (60k-75k)'
        WHEN r.rango = 3 THEN 'Alto (> 75k)'
    END AS rango_salario
FROM departamentos d
CROSS JOIN (SELECT 1 AS rango UNION SELECT 2 UNION SELECT 3) r
ORDER BY d.nombre, r.rango;

-- 5. CROSS JOIN CON FUNCIONES

-- Generar fechas de los últimos 12 meses para análisis
SELECT 
    d.nombre AS nombre_departamento,
    TO_CHAR(fecha_generada, 'YYYY-MM') AS mes_año,
    TO_CHAR(fecha_generada, 'Month YYYY') AS nombre_mes
FROM departamentos d
CROSS JOIN (
    SELECT generate_series(
        CURRENT_DATE - INTERVAL '11 months',
        CURRENT_DATE,
        INTERVAL '1 month'
    )::date AS fecha_generada
) meses
ORDER BY d.nombre, fecha_generada;

-- 6. CROSS JOIN CON CONDICIONES

-- Generar matriz de empleados vs habilidades (para identificar gaps)
SELECT 
    e.nombre AS nombre_empleado,
    e.apellido AS apellido_empleado,
    h.nombre AS nombre_habilidad,
    CASE 
        WHEN eh.empleado_id IS NOT NULL THEN 'Sí tiene'
        ELSE 'No tiene'
    END AS tiene_habilidad
FROM empleados e
CROSS JOIN habilidades h
LEFT JOIN empleados_habilidades eh ON e.id = eh.empleado_id AND h.id = eh.habilidad_id
WHERE h.categoria = 'Técnica'
ORDER BY e.apellido, h.nombre;

-- 7. JOIN CON SUBCONSULTAS EN FROM

-- Empleados con información de departamento y estadísticas del departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    stats.numero_empleados_departamento,
    stats.salario_promedio_departamento,
    ROUND((e.salario / stats.salario_promedio_departamento) * 100, 2) AS porcentaje_promedio
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
INNER JOIN (
    SELECT 
        departamento_id,
        COUNT(*) AS numero_empleados_departamento,
        ROUND(AVG(salario), 2) AS salario_promedio_departamento
    FROM empleados 
    GROUP BY departamento_id
) stats ON e.departamento_id = stats.departamento_id
ORDER BY e.salario DESC;

-- 8. JOIN CON SUBCONSULTAS EN WHERE

-- Empleados que ganan más que el promedio de su departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE e.salario > (
    SELECT AVG(salario) 
    FROM empleados e2 
    WHERE e2.departamento_id = e.departamento_id
)
ORDER BY e.salario DESC;

-- 9. JOIN CON MÚLTIPLES SUBCONSULTAS

-- Análisis completo de empleados con múltiples métricas
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    (SELECT COUNT(*) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS total_empleados_departamento,
    (SELECT ROUND(AVG(salario), 2) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS salario_promedio_departamento,
    (SELECT COUNT(*) FROM empleados_proyectos ep WHERE ep.empleado_id = e.id) AS proyectos_asignados,
    (SELECT COUNT(*) FROM empleados_habilidades eh WHERE eh.empleado_id = e.id) AS habilidades_poseidas
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.salario DESC;

-- 10. JOIN CON FUNCIONES DE VENTANA

-- Empleados con ranking dentro de su departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    ROW_NUMBER() OVER (PARTITION BY e.departamento_id ORDER BY e.salario DESC) AS ranking_departamento,
    RANK() OVER (PARTITION BY e.departamento_id ORDER BY e.salario DESC) AS rango_departamento,
    DENSE_RANK() OVER (PARTITION BY e.departamento_id ORDER BY e.salario DESC) AS rango_denso_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY d.nombre, e.salario DESC;

-- 11. JOIN CON EXPRESIONES CONDICIONALES COMPLEJAS

-- Análisis de empleados con múltiples criterios de clasificación
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    CASE 
        WHEN e.salario > (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) FROM empleados) THEN 'Top 25%'
        WHEN e.salario > (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salario) FROM empleados) THEN 'Top 50%'
        ELSE 'Bottom 50%'
    END AS clasificacion_salario_empresa,
    CASE 
        WHEN e.salario > (SELECT AVG(salario) * 1.2 FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) THEN 'Alto en departamento'
        WHEN e.salario < (SELECT AVG(salario) * 0.8 FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) THEN 'Bajo en departamento'
        ELSE 'Promedio en departamento'
    END AS clasificacion_salario_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.salario DESC;

-- 12. JOIN CON MÚLTIPLES RELACIONES Y AGRUPACIÓN

-- Resumen completo de empleados con todas sus relaciones
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    STRING_AGG(DISTINCT h.nombre, ', ') AS habilidades,
    STRING_AGG(DISTINCT p.nombre, ', ') AS proyectos,
    COUNT(DISTINCT h.id) AS numero_habilidades,
    COUNT(DISTINCT p.id) AS numero_proyectos
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
LEFT JOIN empleados_habilidades eh ON e.id = eh.empleado_id
LEFT JOIN habilidades h ON eh.habilidad_id = h.id
LEFT JOIN empleados_proyectos ep ON e.id = ep.empleado_id
LEFT JOIN proyectos p ON ep.proyecto_id = p.id
GROUP BY e.id, e.nombre, e.apellido, e.salario, d.nombre
ORDER BY e.salario DESC;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. SELF JOIN
SELECT 
    e.nombre AS nombre_empleado,
    e.apellido AS apellido_empleado,
    e.salario AS salario_empleado,
    g.nombre AS nombre_gerente,
    g.apellido AS apellido_gerente,
    g.salario AS salario_gerente
FROM empleados e
LEFT JOIN empleados g ON e.gerente_id = g.id
ORDER BY e.apellido, e.nombre;

-- 2. SELF JOIN CON COMPARACIONES
SELECT 
    e.nombre AS nombre_empleado,
    e.apellido AS apellido_empleado,
    e.salario AS salario_empleado,
    g.nombre AS nombre_gerente,
    g.apellido AS apellido_gerente,
    g.salario AS salario_gerente,
    e.salario - g.salario AS diferencia_salario
FROM empleados e
INNER JOIN empleados g ON e.gerente_id = g.id
WHERE e.salario > g.salario
ORDER BY diferencia_salario DESC;

-- 3. SELF JOIN CON AGRUPACIÓN
SELECT 
    g.nombre AS nombre_gerente,
    g.apellido AS apellido_gerente,
    COUNT(e.id) AS empleados_a_cargo,
    ROUND(AVG(e.salario), 2) AS salario_promedio_equipo,
    SUM(e.salario) AS total_salarios_equipo
FROM empleados g
LEFT JOIN empleados e ON g.id = e.gerente_id
WHERE e.id IS NOT NULL
GROUP BY g.id, g.nombre, g.apellido
ORDER BY empleados_a_cargo DESC;

-- 4. CROSS JOIN
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    CASE 
        WHEN r.rango = 1 THEN 'Bajo (< 60k)'
        WHEN r.rango = 2 THEN 'Medio (60k-75k)'
        WHEN r.rango = 3 THEN 'Alto (> 75k)'
    END AS rango_salario
FROM departamentos d
CROSS JOIN (SELECT 1 AS rango UNION SELECT 2 UNION SELECT 3) r
ORDER BY d.nombre, r.rango;

-- 5. CROSS JOIN CON FUNCIONES
-- Generar fechas de los últimos 12 meses
SELECT 
    d.nombre AS nombre_departamento,
    FORMAT(fecha_generada, 'yyyy-MM') AS mes_año,
    FORMAT(fecha_generada, 'MMMM yyyy') AS nombre_mes
FROM departamentos d
CROSS JOIN (
    SELECT DATEADD(MONTH, -n, GETDATE()) AS fecha_generada
    FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11)) AS meses(n)
) meses
ORDER BY d.nombre, fecha_generada;

-- 6. CROSS JOIN CON CONDICIONES
SELECT 
    e.nombre AS nombre_empleado,
    e.apellido AS apellido_empleado,
    h.nombre AS nombre_habilidad,
    CASE 
        WHEN eh.empleado_id IS NOT NULL THEN 'Sí tiene'
        ELSE 'No tiene'
    END AS tiene_habilidad
FROM empleados e
CROSS JOIN habilidades h
LEFT JOIN empleados_habilidades eh ON e.id = eh.empleado_id AND h.id = eh.habilidad_id
WHERE h.categoria = 'Técnica'
ORDER BY e.apellido, h.nombre;

-- 7. JOIN CON SUBCONSULTAS EN FROM
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    stats.numero_empleados_departamento,
    stats.salario_promedio_departamento,
    ROUND((e.salario / stats.salario_promedio_departamento) * 100, 2) AS porcentaje_promedio
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
INNER JOIN (
    SELECT 
        departamento_id,
        COUNT(*) AS numero_empleados_departamento,
        ROUND(AVG(salario), 2) AS salario_promedio_departamento
    FROM empleados 
    GROUP BY departamento_id
) stats ON e.departamento_id = stats.departamento_id
ORDER BY e.salario DESC;

-- 8. JOIN CON SUBCONSULTAS EN WHERE
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE e.salario > (
    SELECT AVG(salario) 
    FROM empleados e2 
    WHERE e2.departamento_id = e.departamento_id
)
ORDER BY e.salario DESC;

-- 9. JOIN CON MÚLTIPLES SUBCONSULTAS
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    (SELECT COUNT(*) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS total_empleados_departamento,
    (SELECT ROUND(AVG(salario), 2) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS salario_promedio_departamento,
    (SELECT COUNT(*) FROM empleados_proyectos ep WHERE ep.empleado_id = e.id) AS proyectos_asignados,
    (SELECT COUNT(*) FROM empleados_habilidades eh WHERE eh.empleado_id = e.id) AS habilidades_poseidas
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.salario DESC;

-- 10. JOIN CON FUNCIONES DE VENTANA
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    ROW_NUMBER() OVER (PARTITION BY e.departamento_id ORDER BY e.salario DESC) AS ranking_departamento,
    RANK() OVER (PARTITION BY e.departamento_id ORDER BY e.salario DESC) AS rango_departamento,
    DENSE_RANK() OVER (PARTITION BY e.departamento_id ORDER BY e.salario DESC) AS rango_denso_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY d.nombre, e.salario DESC;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Generación de series:
--    - PostgreSQL: generate_series()
--    - MS SQL Server: VALUES con DATEADD()
-- 2. Formato de fechas:
--    - PostgreSQL: TO_CHAR()
--    - MS SQL Server: FORMAT()
-- 3. Funciones de ventana: Idénticas en ambos sistemas
-- 4. Percentiles:
--    - PostgreSQL: PERCENTILE_CONT() WITHIN GROUP
--    - MS SQL Server: PERCENTILE_CONT() WITHIN GROUP OVER()
-- 5. Sintaxis básica: Idéntica para JOINs avanzados

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. SELF JOIN es útil para relaciones jerárquicas
-- 2. CROSS JOIN puede generar muchas filas, úsalo con precaución
-- 3. Las subconsultas en FROM pueden mejorar la legibilidad
-- 4. Las funciones de ventana son poderosas para análisis
-- 5. Considera el rendimiento al usar JOINs complejos
-- 6. Usa índices en las columnas de JOIN para mejor rendimiento
-- 7. Las subconsultas en WHERE pueden afectar el rendimiento
-- 8. Ten en cuenta el orden de ejecución de las consultas
