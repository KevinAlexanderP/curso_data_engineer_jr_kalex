-- =====================================================
-- Script: Conceptos de CTEs
-- Módulo 6: Common Table Expressions (CTEs)
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. ¿QUÉ SON LAS COMMON TABLE EXPRESSIONS (CTEs)?

-- Las CTEs son consultas temporales que se definen dentro de una consulta principal
-- usando la cláusula WITH. Son como "vistas temporales" que existen solo durante
-- la ejecución de la consulta.

-- Sintaxis básica:
-- WITH nombre_cte AS (
--     SELECT ... FROM tabla WHERE ...
-- )
-- SELECT ... FROM nombre_cte;

-- 2. BENEFICIOS DE USAR CTEs

-- 2.1 MEJOR LEGIBILIDAD
-- Sin CTE (difícil de leer):
SELECT 
    d.nombre AS nombre_departamento,
    COUNT(e.id) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio
FROM departamentos d
INNER JOIN empleados e ON d.id = e.departamento_id
WHERE e.activo = TRUE
GROUP BY d.id, d.nombre
HAVING COUNT(e.id) >= 2
ORDER BY salario_promedio DESC;

-- Con CTE (más legible):
WITH estadisticas_departamento AS (
    SELECT 
        d.id,
        d.nombre,
        COUNT(e.id) AS numero_empleados,
        ROUND(AVG(e.salario), 2) AS salario_promedio
    FROM departamentos d
    INNER JOIN empleados e ON d.id = e.departamento_id
    WHERE e.activo = TRUE
    GROUP BY d.id, d.nombre
    HAVING COUNT(e.id) >= 2
)
SELECT 
    nombre AS nombre_departamento,
    numero_empleados,
    salario_promedio
FROM estadisticas_departamento
ORDER BY salario_promedio DESC;

-- 2.2 REUTILIZACIÓN DE CÓDIGO
-- Sin CTE (código duplicado):
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    (SELECT ROUND(AVG(salario), 2) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS salario_promedio_dept,
    e.salario - (SELECT AVG(salario) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id) AS diferencia_promedio
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
WHERE e.salario > (SELECT AVG(salario) FROM empleados e2 WHERE e2.departamento_id = e.departamento_id);

-- Con CTE (código reutilizable):
WITH promedios_departamento AS (
    SELECT 
        departamento_id,
        ROUND(AVG(salario), 2) AS salario_promedio
    FROM empleados 
    GROUP BY departamento_id
)
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    pd.salario_promedio AS salario_promedio_dept,
    e.salario - pd.salario_promedio AS diferencia_promedio
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
INNER JOIN promedios_departamento pd ON e.departamento_id = pd.departamento_id
WHERE e.salario > pd.salario_promedio;

-- 2.3 MANTENIMIENTO MÁS FÁCIL
-- Si necesitas cambiar la lógica, solo cambias en un lugar

-- 3. SINTAXIS BÁSICA DE CTEs

-- 3.1 CTE SIMPLE
WITH empleados_activos AS (
    SELECT * FROM empleados WHERE activo = TRUE
)
SELECT 
    nombre,
    apellido,
    salario
FROM empleados_activos
ORDER BY salario DESC;

-- 3.2 MÚLTIPLES CTEs
WITH 
    empleados_activos AS (
        SELECT * FROM empleados WHERE activo = TRUE
    ),
    departamentos_con_empleados AS (
        SELECT * FROM departamentos WHERE id IN (SELECT DISTINCT departamento_id FROM empleados_activos)
    )
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento
FROM empleados_activos e
INNER JOIN departamentos_con_empleados d ON e.departamento_id = d.id
ORDER BY e.salario DESC;

-- 4. CTEs CON FUNCIONES AGREGADAS

-- Análisis de salarios por departamento usando CTEs
WITH 
    estadisticas_salarios AS (
        SELECT 
            departamento_id,
            COUNT(*) AS numero_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio,
            MIN(salario) AS salario_minimo,
            MAX(salario) AS salario_maximo,
            STDDEV(salario) AS desviacion_estandar
        FROM empleados 
        GROUP BY departamento_id
    ),
    departamentos_info AS (
        SELECT 
            id,
            nombre,
            ubicacion,
            presupuesto
        FROM departamentos
    )
SELECT 
    di.nombre AS nombre_departamento,
    di.ubicacion,
    di.presupuesto,
    es.numero_empleados,
    es.salario_promedio,
    es.salario_minimo,
    es.salario_maximo,
    ROUND(es.desviacion_estandar, 2) AS desviacion_estandar,
    ROUND((es.salario_promedio / di.presupuesto) * 100, 4) AS porcentaje_presupuesto
FROM departamentos_info di
INNER JOIN estadisticas_salarios es ON di.id = es.departamento_id
ORDER BY es.salario_promedio DESC;

-- 5. CTEs CON JOINs

-- Análisis de empleados con proyectos usando CTEs
WITH 
    empleados_proyectos_count AS (
        SELECT 
            empleado_id,
            COUNT(*) AS numero_proyectos
        FROM empleados_proyectos 
        GROUP BY empleado_id
    ),
    empleados_habilidades_count AS (
        SELECT 
            empleado_id,
            COUNT(*) AS numero_habilidades
        FROM empleados_habilidades 
        GROUP BY empleado_id
    )
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento,
    COALESCE(epc.numero_proyectos, 0) AS proyectos_asignados,
    COALESCE(ehc.numero_habilidades, 0) AS habilidades_poseidas,
    COALESCE(epc.numero_proyectos, 0) + COALESCE(ehc.numero_habilidades, 0) AS total_actividades
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
LEFT JOIN empleados_proyectos_count epc ON e.id = epc.empleado_id
LEFT JOIN empleados_habilidades_count ehc ON e.id = ehc.empleado_id
ORDER BY total_actividades DESC;

-- 6. CTEs CON SUBCONSULTAS

-- Análisis de empleados con métricas complejas usando CTEs
WITH 
    salarios_por_departamento AS (
        SELECT 
            departamento_id,
            AVG(salario) AS salario_promedio,
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) AS percentil_75,
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salario) AS percentil_25
        FROM empleados 
        GROUP BY departamento_id
    ),
    empleados_clasificados AS (
        SELECT 
            e.id,
            e.nombre,
            e.apellido,
            e.salario,
            e.departamento_id,
            CASE 
                WHEN e.salario > spd.percentil_75 THEN 'Alto'
                WHEN e.salario < spd.percentil_25 THEN 'Bajo'
                ELSE 'Medio'
            END AS clasificacion_salario
        FROM empleados e
        INNER JOIN salarios_por_departamento spd ON e.departamento_id = spd.departamento_id
    )
SELECT 
    ec.nombre,
    ec.apellido,
    ec.salario,
    d.nombre AS nombre_departamento,
    ec.clasificacion_salario,
    spd.salario_promedio,
    ROUND((ec.salario / spd.salario_promedio) * 100, 2) AS porcentaje_promedio
FROM empleados_clasificados ec
INNER JOIN departamentos d ON ec.departamento_id = d.id
INNER JOIN salarios_por_departamento spd ON ec.departamento_id = spd.departamento_id
ORDER BY ec.salario DESC;

-- 7. CTEs CON EXPRESIONES CONDICIONALES

-- Análisis de empleados por categorías usando CTEs
WITH 
    categorias_empleados AS (
        SELECT 
            id,
            nombre,
            apellido,
            salario,
            departamento_id,
            CASE 
                WHEN salario < 60000 THEN 'Junior'
                WHEN salario BETWEEN 60000 AND 75000 THEN 'Intermedio'
                ELSE 'Senior'
            END AS categoria_salario,
            CASE 
                WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) < 2 THEN 'Nuevo'
                WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) <= 5 THEN 'Experto'
                ELSE 'Veterano'
            END AS categoria_antiguedad
        FROM empleados
    ),
    resumen_categorias AS (
        SELECT 
            categoria_salario,
            categoria_antiguedad,
            COUNT(*) AS numero_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio
        FROM categorias_empleados
        GROUP BY categoria_salario, categoria_antiguedad
    )
SELECT 
    categoria_salario,
    categoria_antiguedad,
    numero_empleados,
    salario_promedio,
    ROUND((numero_empleados * 100.0 / SUM(numero_empleados) OVER()), 2) AS porcentaje_total
FROM resumen_categorias
ORDER BY categoria_salario, categoria_antiguedad;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- Los conceptos son idénticos en MS SQL Server
-- Solo cambian algunas funciones específicas del sistema

-- Ejemplo de CTE simple:
WITH empleados_activos AS (
    SELECT * FROM empleados WHERE activo = 1
)
SELECT 
    nombre,
    apellido,
    salario
FROM empleados_activos
ORDER BY salario DESC;

-- Ejemplo de múltiples CTEs:
WITH 
    empleados_activos AS (
        SELECT * FROM empleados WHERE activo = 1
    ),
    departamentos_con_empleados AS (
        SELECT * FROM departamentos WHERE id IN (SELECT DISTINCT departamento_id FROM empleados_activos)
    )
SELECT 
    e.nombre,
    e.apellido,
    e.salario,
    d.nombre AS nombre_departamento
FROM empleados_activos e
INNER JOIN departamentos_con_empleados d ON e.departamento_id = d.id
ORDER BY e.salario DESC;

-- Ejemplo de CTE con funciones agregadas:
WITH 
    estadisticas_salarios AS (
        SELECT 
            departamento_id,
            COUNT(*) AS numero_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio,
            MIN(salario) AS salario_minimo,
            MAX(salario) AS salario_maximo,
            STDEV(salario) AS desviacion_estandar
        FROM empleados 
        GROUP BY departamento_id
    )
SELECT * FROM estadisticas_salarios;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Valores booleanos:
--    - PostgreSQL: TRUE/FALSE
--    - MS SQL Server: 1/0
-- 2. Desviación estándar:
--    - PostgreSQL: STDDEV()
--    - MS SQL Server: STDEV()
-- 3. Extracción de año:
--    - PostgreSQL: EXTRACT(YEAR FROM fecha)
--    - MS SQL Server: YEAR(fecha)
-- 4. Percentiles:
--    - PostgreSQL: PERCENTILE_CONT() WITHIN GROUP
--    - MS SQL Server: PERCENTILE_CONT() WITHIN GROUP OVER()
-- 5. Sintaxis básica: Idéntica para CTEs

-- =====================================================
-- RESUMEN DE CONCEPTOS:
-- =====================================================
-- 1. Las CTEs son consultas temporales definidas con WITH
-- 2. Mejoran la legibilidad y mantenibilidad del código
-- 3. Permiten reutilizar lógica en una sola consulta
-- 4. Pueden ser simples o múltiples
-- 5. Son útiles para consultas complejas y análisis
-- 6. Existen solo durante la ejecución de la consulta
-- 7. Pueden referenciar otras CTEs en la misma consulta
-- 8. Son una alternativa más legible a subconsultas anidadas
