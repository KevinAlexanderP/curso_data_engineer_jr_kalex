-- =====================================================
-- Script: Ejercicios Prácticos - Módulo 5
-- Módulo 5: JOINs y Relaciones entre Tablas
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- EJERCICIOS PARA PRACTICAR
-- =====================================================

-- Ejercicio 1: INNER JOIN Básico
-- Mostrar todos los empleados con su información de departamento:
-- 1. Nombre y apellido del empleado
-- 2. Salario
-- 3. Nombre del departamento
-- 4. Ubicación del departamento
-- Ordenar por apellido del empleado

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    d.ubicacion
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.apellido;

-- Ejercicio 2: LEFT JOIN con Filtros
-- Mostrar todos los departamentos y el número de empleados que tienen:
-- 1. Nombre del departamento
-- 2. Ubicación
-- 3. Presupuesto
-- 4. Número de empleados
-- Incluir departamentos sin empleados
-- Ordenar por número de empleados descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    d.presupuesto,
    COUNT(e.id) AS numero_empleados
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre, d.ubicacion, d.presupuesto
ORDER BY numero_empleados DESC;

-- Ejercicio 3: Múltiples JOINs
-- Mostrar empleados con sus proyectos asignados:
-- 1. Nombre y apellido del empleado
-- 2. Nombre del departamento
-- 3. Nombre del proyecto
-- 4. Fecha de inicio del proyecto
-- Solo empleados activos
-- Ordenar por apellido del empleado

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento,
    p.nombre AS nombre_proyecto,
    p.fecha_inicio
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
INNER JOIN empleados_proyectos ep ON e.id = ep.empleado_id
INNER JOIN proyectos p ON ep.proyecto_id = p.id
WHERE e.activo = TRUE
ORDER BY e.apellido;

-- Ejercicio 4: JOIN con Funciones Agregadas
-- Calcular estadísticas por departamento:
-- 1. Nombre del departamento
-- 2. Número de empleados
-- 3. Salario promedio
-- 4. Salario mínimo
-- 5. Salario máximo
-- Solo departamentos con al menos 2 empleados
-- Ordenar por salario promedio descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    d.nombre AS nombre_departamento,
    COUNT(e.id) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio,
    MIN(e.salario) AS salario_minimo,
    MAX(e.salario) AS salario_maximo
FROM departamentos d
INNER JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre
HAVING COUNT(e.id) >= 2
ORDER BY salario_promedio DESC;

-- Ejercicio 5: LEFT JOIN con Condiciones
-- Mostrar empleados y sus habilidades:
-- 1. Nombre y apellido del empleado
-- 2. Nombre del departamento
-- 3. Habilidades (separadas por comas)
-- 4. Número de habilidades
-- Incluir empleados sin habilidades
-- Ordenar por número de habilidades descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento,
    COALESCE(STRING_AGG(h.nombre, ', '), 'Sin habilidades') AS habilidades,
    COUNT(h.id) AS numero_habilidades
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
LEFT JOIN empleados_habilidades eh ON e.id = eh.empleado_id
LEFT JOIN habilidades h ON eh.habilidad_id = h.id
GROUP BY e.id, e.nombre, e.apellido, d.nombre
ORDER BY numero_habilidades DESC;

-- Ejercicio 6: JOIN con Subconsultas
-- Mostrar empleados que ganan más que el promedio de su departamento:
-- 1. Nombre y apellido del empleado
-- 2. Salario del empleado
-- 3. Nombre del departamento
-- 4. Salario promedio del departamento
-- 5. Diferencia con el promedio
-- Ordenar por diferencia descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    (SELECT ROUND(AVG(salario), 2) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS salario_promedio_departamento,
    e.salario - (SELECT AVG(salario) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS diferencia_promedio
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE e.salario > (
    SELECT AVG(salario) 
    FROM empleados e2 
    WHERE e2.departamento_id = e.departamento_id
)
ORDER BY diferencia_promedio DESC;

-- Ejercicio 7: FULL OUTER JOIN
-- Mostrar todos los empleados y departamentos:
-- 1. Nombre del empleado (o 'Sin empleado' si no hay)
-- 2. Nombre del departamento (o 'Sin departamento' si no hay)
-- 3. Salario del empleado
-- 4. Presupuesto del departamento
-- Ordenar por nombre del empleado

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    COALESCE(e.nombre, 'Sin empleado') AS nombre_empleado,
    COALESCE(d.nombre, 'Sin departamento') AS nombre_departamento,
    e.salario,
    d.presupuesto
FROM empleados e
FULL OUTER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY COALESCE(e.nombre, 'ZZZ');

-- Ejercicio 8: JOIN con Expresiones Condicionales
-- Clasificar empleados por nivel de salario en su departamento:
-- 1. Nombre y apellido del empleado
-- 2. Salario
-- 3. Nombre del departamento
-- 4. Nivel de salario (Alto: >120% del promedio, Bajo: <80% del promedio, Medio: resto)
-- Ordenar por departamento y salario descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
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

-- Ejercicio 9: JOIN con Múltiples Relaciones
-- Mostrar empleados con información completa:
-- 1. Nombre y apellido del empleado
-- 2. Departamento
-- 3. Habilidades (separadas por comas)
-- 4. Proyectos (separados por comas)
-- 5. Total de habilidades y proyectos
-- Ordenar por total de habilidades y proyectos descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento,
    COALESCE(STRING_AGG(DISTINCT h.nombre, ', '), 'Sin habilidades') AS habilidades,
    COALESCE(STRING_AGG(DISTINCT p.nombre, ', '), 'Sin proyectos') AS proyectos,
    COUNT(DISTINCT h.id) AS numero_habilidades,
    COUNT(DISTINCT p.id) AS numero_proyectos,
    COUNT(DISTINCT h.id) + COUNT(DISTINCT p.id) AS total_habilidades_proyectos
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
LEFT JOIN empleados_habilidades eh ON e.id = eh.empleado_id
LEFT JOIN habilidades h ON eh.habilidad_id = h.id
LEFT JOIN empleados_proyectos ep ON e.id = ep.empleado_id
LEFT JOIN proyectos p ON ep.proyecto_id = p.id
GROUP BY e.id, e.nombre, e.apellido, d.nombre
ORDER BY total_habilidades_proyectos DESC;

-- Ejercicio 10: JOIN Complejo con Análisis
-- Crear un análisis completo de empleados por departamento:
-- 1. Nombre del departamento
-- 2. Número total de empleados
-- 3. Empleados activos e inactivos
-- 4. Salario promedio, mínimo y máximo
-- 5. Empleados con teléfono
-- 6. Porcentaje de empleados activos
-- Solo departamentos con al menos 1 empleado
-- Ordenar por número de empleados descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    COUNT(e.id) AS total_empleados,
    COUNT(CASE WHEN e.activo = TRUE THEN 1 END) AS empleados_activos,
    COUNT(CASE WHEN e.activo = FALSE THEN 1 END) AS empleados_inactivos,
    ROUND(AVG(e.salario), 2) AS salario_promedio,
    MIN(e.salario) AS salario_minimo,
    MAX(e.salario) AS salario_maximo,
    COUNT(CASE WHEN e.telefono IS NOT NULL THEN 1 END) AS empleados_con_telefono,
    ROUND((COUNT(CASE WHEN e.activo = TRUE THEN 1 END) * 100.0 / COUNT(e.id)), 2) AS porcentaje_activos
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre, d.ubicacion
HAVING COUNT(e.id) >= 1
ORDER BY total_empleados DESC;

-- =====================================================
-- EJERCICIOS AVANZADOS (OPCIONALES)
-- =====================================================

-- Ejercicio Avanzado 1: SELF JOIN
-- Asumiendo que existe una columna gerente_id en la tabla empleados:
-- Mostrar empleados con sus gerentes y comparar salarios:
-- 1. Nombre del empleado
-- 2. Salario del empleado
-- 3. Nombre del gerente
-- 4. Salario del gerente
-- 5. Diferencia de salario (empleado - gerente)
-- Solo empleados que ganan más que su gerente
-- Ordenar por diferencia de salario descendente

-- Tu código aquí:
-- SELECT ...

-- Solución (comentado porque requiere modificar la tabla):
/*
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
*/

-- Ejercicio Avanzado 2: CROSS JOIN con Análisis
-- Generar una matriz de análisis de empleados vs rangos de salario:
-- 1. Rango de salario (Bajo: <60k, Medio: 60k-75k, Alto: >75k)
-- 2. Departamento
-- 3. Número de empleados en ese rango
-- 4. Salario promedio del rango
-- Ordenar por departamento y rango

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    CASE 
        WHEN r.rango = 1 THEN 'Bajo (< 60k)'
        WHEN r.rango = 2 THEN 'Medio (60k-75k)'
        WHEN r.rango = 3 THEN 'Alto (> 75k)'
    END AS rango_salario,
    d.nombre AS nombre_departamento,
    COUNT(e.id) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio_rango
FROM departamentos d
CROSS JOIN (SELECT 1 AS rango UNION SELECT 2 UNION SELECT 3) r
LEFT JOIN empleados e ON d.id = e.departamento_id AND (
    (r.rango = 1 AND e.salario < 60000) OR
    (r.rango = 2 AND e.salario BETWEEN 60000 AND 75000) OR
    (r.rango = 3 AND e.salario > 75000)
)
GROUP BY r.rango, d.id, d.nombre
ORDER BY d.nombre, r.rango;

-- =====================================================
-- NOTAS PARA MS SQL SERVER:
-- =====================================================
-- 1. Cambia TRUE por 1 para valores booleanos
-- 2. Cambia COALESCE() por ISNULL()
-- 3. Cambia STRING_AGG() por STRING_AGG() (SQL Server 2017+)
-- 4. Usa GO para separar lotes de comandos

-- =====================================================
-- SOLUCIONES ESPECÍFICAS PARA MS SQL SERVER:
-- =====================================================

/*
-- Ejercicio 2 (MS SQL Server):
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    d.presupuesto,
    COUNT(e.id) AS numero_empleados
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre, d.ubicacion, d.presupuesto
ORDER BY numero_empleados DESC;

-- Ejercicio 5 (MS SQL Server):
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento,
    ISNULL(STRING_AGG(h.nombre, ', '), 'Sin habilidades') AS habilidades,
    COUNT(h.id) AS numero_habilidades
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
LEFT JOIN empleados_habilidades eh ON e.id = eh.empleado_id
LEFT JOIN habilidades h ON eh.habilidad_id = h.id
GROUP BY e.id, e.nombre, e.apellido, d.nombre
ORDER BY numero_habilidades DESC;

-- Ejercicio 10 (MS SQL Server):
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    COUNT(e.id) AS total_empleados,
    COUNT(CASE WHEN e.activo = 1 THEN 1 END) AS empleados_activos,
    COUNT(CASE WHEN e.activo = 0 THEN 1 END) AS empleados_inactivos,
    ROUND(AVG(e.salario), 2) AS salario_promedio,
    MIN(e.salario) AS salario_minimo,
    MAX(e.salario) AS salario_maximo,
    COUNT(CASE WHEN e.telefono IS NOT NULL THEN 1 END) AS empleados_con_telefono,
    ROUND((COUNT(CASE WHEN e.activo = 1 THEN 1 END) * 100.0 / COUNT(e.id)), 2) AS porcentaje_activos
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre, d.ubicacion
HAVING COUNT(e.id) >= 1
ORDER BY total_empleados DESC;
GO
*/
