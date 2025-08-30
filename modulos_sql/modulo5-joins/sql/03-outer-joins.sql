-- =====================================================
-- Script: OUTER JOINs
-- Módulo 5: JOINs y Relaciones entre Tablas
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. LEFT OUTER JOIN (LEFT JOIN)
-- Incluye TODAS las filas de la tabla izquierda y solo las coincidencias de la derecha
-- Si no hay coincidencia, las columnas de la tabla derecha son NULL

-- Todos los empleados (incluso los que no tienen departamento asignado)
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento,
    COALESCE(d.ubicacion, 'No especificada') AS ubicacion_departamento
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.apellido, e.nombre;

-- Departamentos con todos sus empleados (incluyendo departamentos sin empleados)
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    d.presupuesto,
    COUNT(e.id) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre, d.ubicacion, d.presupuesto
ORDER BY d.nombre;

-- 2. RIGHT OUTER JOIN (RIGHT JOIN)
-- Incluye TODAS las filas de la tabla derecha y solo las coincidencias de la izquierda
-- Si no hay coincidencia, las columnas de la tabla izquierda son NULL

-- Todos los departamentos con información de empleados (incluyendo departamentos sin empleados)
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    d.presupuesto,
    COALESCE(e.nombre, 'Sin empleados') AS nombre_empleado,
    e.salario
FROM empleados e
RIGHT JOIN departamentos d ON e.departamento_id = d.id
ORDER BY d.nombre, e.nombre;

-- 3. FULL OUTER JOIN
-- Incluye TODAS las filas de AMBAS tablas
-- Si no hay coincidencia, las columnas de la otra tabla son NULL

-- Todos los empleados y departamentos (incluyendo empleados sin departamento y departamentos sin empleados)
SELECT 
    COALESCE(e.nombre, 'Sin empleado') AS nombre_empleado,
    COALESCE(e.apellido, '') AS apellido_empleado,
    e.salario,
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento,
    COALESCE(d.ubicacion, 'No especificada') AS ubicacion_departamento
FROM empleados e
FULL OUTER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY COALESCE(e.apellido, 'ZZZ'), COALESCE(d.nombre, 'ZZZ');

-- 4. LEFT JOIN CON FILTROS

-- Empleados activos con información de departamento (incluyendo los sin departamento)
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    e.activo,
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
WHERE e.activo = TRUE
ORDER BY e.salario DESC;

-- 5. LEFT JOIN CON FUNCIONES AGREGADAS

-- Estadísticas de empleados por departamento (incluyendo departamentos sin empleados)
SELECT 
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento,
    COUNT(e.id) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio,
    SUM(COALESCE(e.salario, 0)) AS total_salarios
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre
ORDER BY numero_empleados DESC;

-- 6. LEFT JOIN CON MÚLTIPLES TABLAS

-- Empleados con departamento y proyectos (incluyendo empleados sin proyectos)
SELECT 
    e.nombre,
    e.apellido,
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento,
    STRING_AGG(COALESCE(p.nombre, 'Sin proyectos'), ', ') AS proyectos_asignados
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
LEFT JOIN empleados_proyectos ep ON e.id = ep.empleado_id
LEFT JOIN proyectos p ON ep.proyecto_id = p.id
GROUP BY e.id, e.nombre, e.apellido, d.nombre
ORDER BY e.apellido, e.nombre;

-- 7. LEFT JOIN CON SUBCONSULTAS

-- Empleados con información de departamento y comparación con el promedio del departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento,
    CASE 
        WHEN d.id IS NOT NULL THEN
            ROUND(e.salario - (SELECT AVG(salario) FROM empleados e2 WHERE e2.departamento_id = d.id), 2)
        ELSE NULL
    END AS diferencia_promedio_departamento
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.salario DESC;

-- 8. LEFT JOIN CON EXPRESIONES CONDICIONALES

-- Análisis de empleados por departamento con clasificación
SELECT 
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento,
    COUNT(e.id) AS total_empleados,
    COUNT(CASE WHEN e.activo = TRUE THEN 1 END) AS empleados_activos,
    COUNT(CASE WHEN e.activo = FALSE THEN 1 END) AS empleados_inactivos,
    ROUND((COUNT(CASE WHEN e.activo = TRUE THEN 1 END) * 100.0 / COUNT(e.id)), 2) AS porcentaje_activos
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre
ORDER BY total_empleados DESC;

-- 9. LEFT JOIN CON FECHAS

-- Empleados contratados por año con información de departamento
SELECT 
    EXTRACT(YEAR FROM e.fecha_contratacion) AS año_contratacion,
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento,
    COUNT(e.id) AS empleados_contratados,
    ROUND(AVG(e.salario), 2) AS salario_promedio_año
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
WHERE EXTRACT(YEAR FROM e.fecha_contratacion) >= 2020
GROUP BY EXTRACT(YEAR FROM e.fecha_contratacion), d.id, d.nombre
ORDER BY año_contratacion DESC, nombre_departamento;

-- 10. LEFT JOIN CON MÚLTIPLES CONDICIONES

-- Empleados con habilidades y proyectos (incluyendo empleados sin habilidades o proyectos)
SELECT 
    e.nombre,
    e.apellido,
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento,
    COALESCE(STRING_AGG(DISTINCT h.nombre, ', '), 'Sin habilidades') AS habilidades,
    COALESCE(STRING_AGG(DISTINCT p.nombre, ', '), 'Sin proyectos') AS proyectos
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
LEFT JOIN empleados_habilidades eh ON e.id = eh.empleado_id
LEFT JOIN habilidades h ON eh.habilidad_id = h.id
LEFT JOIN empleados_proyectos ep ON e.id = ep.empleado_id
LEFT JOIN proyectos p ON ep.proyecto_id = p.id
GROUP BY e.id, e.nombre, e.apellido, d.nombre
ORDER BY e.apellido, e.nombre;

-- 11. LEFT JOIN CON COMPARACIONES COMPLEJAS

-- Empleados con análisis de salario relativo a su departamento
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento,
    CASE 
        WHEN d.id IS NOT NULL THEN
            CASE 
                WHEN e.salario > (SELECT AVG(salario) * 1.2 FROM empleados e2 WHERE e2.departamento_id = d.id) THEN 'Alto'
                WHEN e.salario < (SELECT AVG(salario) * 0.8 FROM empleados e2 WHERE e2.departamento_id = d.id) THEN 'Bajo'
                ELSE 'Medio'
            END
        ELSE 'No aplica'
    END AS nivel_salario_departamento
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.salario DESC;

-- 12. LEFT JOIN CON VERIFICACIÓN DE INTEGRIDAD

-- Verificar integridad referencial: empleados sin departamento válido
SELECT 
    'Empleados sin departamento válido' AS tipo_problema,
    COUNT(*) AS numero_registros
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
WHERE d.id IS NULL

UNION ALL

-- Departamentos sin empleados
SELECT 
    'Departamentos sin empleados' AS tipo_problema,
    COUNT(*) AS numero_registros
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
WHERE e.id IS NULL;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. LEFT OUTER JOIN (LEFT JOIN)
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    ISNULL(d.nombre, 'Sin departamento') AS nombre_departamento,
    ISNULL(d.ubicacion, 'No especificada') AS ubicacion_departamento
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.apellido, e.nombre;

-- 2. RIGHT OUTER JOIN (RIGHT JOIN)
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    d.presupuesto,
    ISNULL(e.nombre, 'Sin empleados') AS nombre_empleado,
    e.salario
FROM empleados e
RIGHT JOIN departamentos d ON e.departamento_id = d.id
ORDER BY d.nombre, e.nombre;

-- 3. FULL OUTER JOIN
SELECT 
    ISNULL(e.nombre, 'Sin empleado') AS nombre_empleado,
    ISNULL(e.apellido, '') AS apellido_empleado,
    e.salario,
    ISNULL(d.nombre, 'Sin departamento') AS nombre_departamento,
    ISNULL(d.ubicacion, 'No especificada') AS ubicacion_departamento
FROM empleados e
FULL OUTER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY ISNULL(e.apellido, 'ZZZ'), ISNULL(d.nombre, 'ZZZ');

-- 4. LEFT JOIN CON FILTROS
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    e.activo,
    ISNULL(d.nombre, 'Sin departamento') AS nombre_departamento
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
WHERE e.activo = 1
ORDER BY e.salario DESC;

-- 5. LEFT JOIN CON FUNCIONES AGREGADAS
SELECT 
    ISNULL(d.nombre, 'Sin departamento') AS nombre_departamento,
    COUNT(e.id) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio,
    SUM(ISNULL(e.salario, 0)) AS total_salarios
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre
ORDER BY numero_empleados DESC;

-- 6. LEFT JOIN CON MÚLTIPLES TABLAS
SELECT 
    e.nombre,
    e.apellido,
    ISNULL(d.nombre, 'Sin departamento') AS nombre_departamento,
    STRING_AGG(ISNULL(p.nombre, 'Sin proyectos'), ', ') AS proyectos_asignados
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
LEFT JOIN empleados_proyectos ep ON e.id = ep.empleado_id
LEFT JOIN proyectos p ON ep.proyecto_id = p.id
GROUP BY e.id, e.nombre, e.apellido, d.nombre
ORDER BY e.apellido, e.nombre;

-- 7. LEFT JOIN CON SUBCONSULTAS
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    ISNULL(d.nombre, 'Sin departamento') AS nombre_departamento,
    CASE 
        WHEN d.id IS NOT NULL THEN
            ROUND(e.salario - (SELECT AVG(salario) FROM empleados e2 WHERE e2.departamento_id = d.id), 2)
        ELSE NULL
    END AS diferencia_promedio_departamento
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.salario DESC;

-- 8. LEFT JOIN CON EXPRESIONES CONDICIONALES
SELECT 
    ISNULL(d.nombre, 'Sin departamento') AS nombre_departamento,
    COUNT(e.id) AS total_empleados,
    COUNT(CASE WHEN e.activo = 1 THEN 1 END) AS empleados_activos,
    COUNT(CASE WHEN e.activo = 0 THEN 1 END) AS empleados_inactivos,
    ROUND((COUNT(CASE WHEN e.activo = 1 THEN 1 END) * 100.0 / COUNT(e.id)), 2) AS porcentaje_activos
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre
ORDER BY total_empleados DESC;

-- 9. LEFT JOIN CON FECHAS
SELECT 
    YEAR(e.fecha_contratacion) AS año_contratacion,
    ISNULL(d.nombre, 'Sin departamento') AS nombre_departamento,
    COUNT(e.id) AS empleados_contratados,
    ROUND(AVG(e.salario), 2) AS salario_promedio_año
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
WHERE YEAR(e.fecha_contratacion) >= 2020
GROUP BY YEAR(e.fecha_contratacion), d.id, d.nombre
ORDER BY año_contratacion DESC, nombre_departamento;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Manejo de NULL:
--    - PostgreSQL: COALESCE()
--    - MS SQL Server: ISNULL()
-- 2. Valores booleanos:
--    - PostgreSQL: TRUE/FALSE
--    - MS SQL Server: 1/0
-- 3. Extracción de año:
--    - PostgreSQL: EXTRACT(YEAR FROM fecha)
--    - MS SQL Server: YEAR(fecha)
-- 4. Funciones de agregación de strings:
--    - PostgreSQL: STRING_AGG() nativo
--    - MS SQL Server: STRING_AGG() (SQL Server 2017+)
-- 5. Sintaxis básica: Idéntica para OUTER JOINs

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Usa LEFT JOIN cuando quieras incluir TODAS las filas de la tabla izquierda
-- 2. Usa RIGHT JOIN cuando quieras incluir TODAS las filas de la tabla derecha
-- 3. Usa FULL OUTER JOIN cuando quieras incluir TODAS las filas de AMBAS tablas
-- 4. Maneja los valores NULL apropiadamente con COALESCE() o ISNULL()
-- 5. Considera el rendimiento: OUTER JOINs pueden ser más lentos que INNER JOINs
-- 6. Usa índices en las columnas de JOIN para mejor rendimiento
-- 7. Ten en cuenta que OUTER JOINs incluyen filas sin coincidencias
-- 8. Verifica la integridad referencial antes de hacer OUTER JOINs complejos
