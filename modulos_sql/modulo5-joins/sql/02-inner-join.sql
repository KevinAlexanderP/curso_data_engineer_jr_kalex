-- =====================================================
-- Script: INNER JOIN
-- Módulo 5: JOINs y Relaciones entre Tablas
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. INNER JOIN BÁSICO
-- Sintaxis: SELECT columnas FROM tabla1 INNER JOIN tabla2 ON condicion

-- Empleados con información de su departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    d.ubicacion AS ubicacion_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.apellido, e.nombre;

-- 2. INNER JOIN CON MÚLTIPLES CONDICIONES

-- Empleados activos con información de departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    e.activo,
    d.nombre AS nombre_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE e.activo = TRUE
ORDER BY e.salario DESC;

-- 3. INNER JOIN CON MÁS DE DOS TABLAS

-- Empleados con departamento y proyectos asignados
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento,
    p.nombre AS nombre_proyecto,
    p.fecha_inicio,
    p.fecha_fin
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
INNER JOIN empleados_proyectos ep ON e.id = ep.empleado_id
INNER JOIN proyectos p ON ep.proyecto_id = p.id
ORDER BY e.apellido, p.nombre;

-- 4. INNER JOIN CON FUNCIONES AGREGADAS

-- Estadísticas de empleados por departamento
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    COUNT(e.id) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio,
    SUM(e.salario) AS total_salarios
FROM departamentos d
INNER JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre, d.ubicacion
ORDER BY numero_empleados DESC;

-- 5. INNER JOIN CON SUBCONSULTAS

-- Empleados con salario mayor al promedio de su departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    (SELECT ROUND(AVG(salario), 2) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS salario_promedio_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE e.salario > (
    SELECT AVG(salario) 
    FROM empleados e2 
    WHERE e2.departamento_id = e.departamento_id
)
ORDER BY e.salario DESC;

-- 6. INNER JOIN CON EXPRESIONES CONDICIONALES

-- Empleados clasificados por nivel de salario en su departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    CASE 
        WHEN e.salario > (SELECT AVG(salario) * 1.2 FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) THEN 'Alto'
        WHEN e.salario < (SELECT AVG(salario) * 0.8 FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) THEN 'Bajo'
        ELSE 'Medio'
    END AS nivel_salario_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY d.nombre, e.salario DESC;

-- 7. INNER JOIN CON MÚLTIPLES RELACIONES

-- Empleados con todas sus habilidades y proyectos
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento,
    STRING_AGG(DISTINCT h.nombre, ', ') AS habilidades,
    STRING_AGG(DISTINCT p.nombre, ', ') AS proyectos
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
INNER JOIN empleados_habilidades eh ON e.id = eh.empleado_id
INNER JOIN habilidades h ON eh.habilidad_id = h.id
INNER JOIN empleados_proyectos ep ON e.id = ep.empleado_id
INNER JOIN proyectos p ON ep.proyecto_id = p.id
GROUP BY e.id, e.nombre, e.apellido, d.nombre
ORDER BY e.apellido, e.nombre;

-- 8. INNER JOIN CON FILTROS COMPLEJOS

-- Empleados de departamentos con presupuesto alto y salario por encima del promedio
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    d.presupuesto,
    ROUND((e.salario / d.presupuesto) * 100, 4) AS porcentaje_presupuesto
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE 
    d.presupuesto > 300000 AND
    e.salario > (SELECT AVG(salario) FROM empleados)
ORDER BY porcentaje_presupuesto DESC;

-- 9. INNER JOIN CON AGRUPACIÓN Y FILTROS

-- Departamentos con empleados de alto rendimiento
SELECT 
    d.nombre AS nombre_departamento,
    COUNT(e.id) AS total_empleados,
    COUNT(CASE WHEN e.salario > 70000 THEN 1 END) AS empleados_alto_salario,
    ROUND((COUNT(CASE WHEN e.salario > 70000 THEN 1 END) * 100.0 / COUNT(e.id)), 2) AS porcentaje_alto_salario
FROM departamentos d
INNER JOIN empleados e ON d.id = e.departamento_id
WHERE e.activo = TRUE
GROUP BY d.id, d.nombre
HAVING COUNT(e.id) >= 2
ORDER BY porcentaje_alto_salario DESC;

-- 10. INNER JOIN CON FUNCIONES DE FECHA

-- Empleados contratados en años específicos con información de departamento
SELECT 
    EXTRACT(YEAR FROM e.fecha_contratacion) AS año_contratacion,
    d.nombre AS nombre_departamento,
    COUNT(e.id) AS empleados_contratados,
    ROUND(AVG(e.salario), 2) AS salario_promedio_año
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE EXTRACT(YEAR FROM e.fecha_contratacion) >= 2020
GROUP BY EXTRACT(YEAR FROM e.fecha_contratacion), d.id, d.nombre
ORDER BY año_contratacion DESC, nombre_departamento;

-- 11. INNER JOIN CON COMPARACIONES COMPLEJAS

-- Empleados con salario en el top 25% de su departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    e.salario - (SELECT AVG(salario) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS diferencia_promedio
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE e.salario >= (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) 
    FROM empleados e2 
    WHERE e2.departamento_id = e.departamento_id
)
ORDER BY d.nombre, e.salario DESC;

-- 12. INNER JOIN CON MÚLTIPLES CONDICIONES DE JOIN

-- Empleados con proyectos activos y habilidades específicas
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento,
    p.nombre AS nombre_proyecto,
    h.nombre AS habilidad_requerida
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
INNER JOIN empleados_proyectos ep ON e.id = ep.empleado_id
INNER JOIN proyectos p ON ep.proyecto_id = p.id
INNER JOIN empleados_habilidades eh ON e.id = eh.empleado_id
INNER JOIN habilidades h ON eh.habilidad_id = h.id
WHERE 
    p.estado = 'Activo' AND
    h.categoria = 'Técnica' AND
    e.activo = TRUE
ORDER BY e.apellido, p.nombre;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. INNER JOIN BÁSICO
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    d.ubicacion AS ubicacion_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.apellido, e.nombre;

-- 2. INNER JOIN CON MÚLTIPLES CONDICIONES
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    e.activo,
    d.nombre AS nombre_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE e.activo = 1
ORDER BY e.salario DESC;

-- 3. INNER JOIN CON MÁS DE DOS TABLAS
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento,
    p.nombre AS nombre_proyecto,
    p.fecha_inicio,
    p.fecha_fin
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
INNER JOIN empleados_proyectos ep ON e.id = ep.empleado_id
INNER JOIN proyectos p ON ep.proyecto_id = p.id
ORDER BY e.apellido, p.nombre;

-- 4. INNER JOIN CON FUNCIONES AGREGADAS
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    COUNT(e.id) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio,
    SUM(e.salario) AS total_salarios
FROM departamentos d
INNER JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre, d.ubicacion
ORDER BY numero_empleados DESC;

-- 5. INNER JOIN CON SUBCONSULTAS
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    (SELECT ROUND(AVG(salario), 2) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS salario_promedio_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE e.salario > (
    SELECT AVG(salario) 
    FROM empleados e2 
    WHERE e2.departamento_id = e.departamento_id
)
ORDER BY e.salario DESC;

-- 6. INNER JOIN CON EXPRESIONES CONDICIONALES
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    CASE 
        WHEN e.salario > (SELECT AVG(salario) * 1.2 FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) THEN 'Alto'
        WHEN e.salario < (SELECT AVG(salario) * 0.8 FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) THEN 'Bajo'
        ELSE 'Medio'
    END AS nivel_salario_departamento
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY d.nombre, e.salario DESC;

-- 7. INNER JOIN CON MÚLTIPLES RELACIONES
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento,
    STRING_AGG(DISTINCT h.nombre, ', ') AS habilidades,
    STRING_AGG(DISTINCT p.nombre, ', ') AS proyectos
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
INNER JOIN empleados_habilidades eh ON e.id = eh.empleado_id
INNER JOIN habilidades h ON eh.habilidad_id = h.id
INNER JOIN empleados_proyectos ep ON e.id = ep.empleado_id
INNER JOIN proyectos p ON ep.proyecto_id = p.id
GROUP BY e.id, e.nombre, e.apellido, d.nombre
ORDER BY e.apellido, e.nombre;

-- 8. INNER JOIN CON FILTROS COMPLEJOS
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    d.presupuesto,
    ROUND((e.salario / d.presupuesto) * 100, 4) AS porcentaje_presupuesto
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE 
    d.presupuesto > 300000 AND
    e.salario > (SELECT AVG(salario) FROM empleados)
ORDER BY porcentaje_presupuesto DESC;

-- 9. INNER JOIN CON AGRUPACIÓN Y FILTROS
SELECT 
    d.nombre AS nombre_departamento,
    COUNT(e.id) AS total_empleados,
    COUNT(CASE WHEN e.salario > 70000 THEN 1 END) AS empleados_alto_salario,
    ROUND((COUNT(CASE WHEN e.salario > 70000 THEN 1 END) * 100.0 / COUNT(e.id)), 2) AS porcentaje_alto_salario
FROM departamentos d
INNER JOIN empleados e ON d.id = e.departamento_id
WHERE e.activo = 1
GROUP BY d.id, d.nombre
HAVING COUNT(e.id) >= 2
ORDER BY porcentaje_alto_salario DESC;

-- 10. INNER JOIN CON FUNCIONES DE FECHA
SELECT 
    YEAR(e.fecha_contratacion) AS año_contratacion,
    d.nombre AS nombre_departamento,
    COUNT(e.id) AS empleados_contratados,
    ROUND(AVG(e.salario), 2) AS salario_promedio_año
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE YEAR(e.fecha_contratacion) >= 2020
GROUP BY YEAR(e.fecha_contratacion), d.id, d.nombre
ORDER BY año_contratacion DESC, nombre_departamento;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Valores booleanos:
--    - PostgreSQL: TRUE/FALSE
--    - MS SQL Server: 1/0
-- 2. Extracción de año:
--    - PostgreSQL: EXTRACT(YEAR FROM fecha)
--    - MS SQL Server: YEAR(fecha)
-- 3. Funciones de agregación de strings:
--    - PostgreSQL: STRING_AGG() nativo
--    - MS SQL Server: STRING_AGG() (SQL Server 2017+)
-- 4. Percentiles:
--    - PostgreSQL: PERCENTILE_CONT() WITHIN GROUP
--    - MS SQL Server: PERCENTILE_CONT() WITHIN GROUP OVER()
-- 5. Sintaxis básica: Idéntica para INNER JOIN

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Siempre especifica INNER JOIN (aunque JOIN solo también funciona)
-- 2. Usa alias descriptivos para las tablas
-- 3. La condición ON debe ser clara y eficiente
-- 4. Considera el orden de los JOINs para optimización
-- 5. Usa índices en las columnas de JOIN para mejor rendimiento
-- 6. Evita JOINs innecesarios
-- 7. Ten en cuenta que INNER JOIN solo incluye coincidencias
-- 8. Usa JOIN en lugar de subconsultas cuando sea posible
