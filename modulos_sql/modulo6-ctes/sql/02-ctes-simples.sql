-- =====================================================
-- Script: CTEs Simples
-- Módulo 6: Common Table Expressions (CTEs)
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. CTE SIMPLE PARA MEJORAR LEGIBILIDAD

-- Sin CTE (consulta compleja):
SELECT 
    d.nombre AS nombre_departamento,
    COUNT(e.id) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio,
    MIN(e.salario) AS salario_minimo,
    MAX(e.salario) AS salario_maximo
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
        ROUND(AVG(e.salario), 2) AS salario_promedio,
        MIN(e.salario) AS salario_minimo,
        MAX(e.salario) AS salario_maximo
    FROM departamentos d
    INNER JOIN empleados e ON d.id = e.departamento_id
    WHERE e.activo = TRUE
    GROUP BY d.id, d.nombre
    HAVING COUNT(e.id) >= 2
)
SELECT 
    nombre AS nombre_departamento,
    numero_empleados,
    salario_promedio,
    salario_minimo,
    salario_maximo
FROM estadisticas_departamento
ORDER BY salario_promedio DESC;

-- 2. CTE PARA REUTILIZAR CÁLCULOS

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

-- 3. MÚLTIPLES CTEs EN UNA CONSULTA

-- Análisis de empleados por departamento y rango de salario
WITH 
    empleados_activos AS (
        SELECT * FROM empleados WHERE activo = TRUE
    ),
    rangos_salario AS (
        SELECT 
            id,
            nombre,
            apellido,
            salario,
            departamento_id,
            CASE 
                WHEN salario < 60000 THEN 'Bajo (< 60k)'
                WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
                ELSE 'Alto (> 75k)'
            END AS rango_salario
        FROM empleados_activos
    ),
    departamentos_info AS (
        SELECT 
            id,
            nombre,
            ubicacion
        FROM departamentos
    )
SELECT 
    di.nombre AS nombre_departamento,
    rs.rango_salario,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(rs.salario), 2) AS salario_promedio_rango
FROM rangos_salario rs
INNER JOIN departamentos_info di ON rs.departamento_id = di.id
GROUP BY di.nombre, rs.rango_salario
ORDER BY di.nombre, 
    CASE 
        WHEN rs.rango_salario = 'Bajo (< 60k)' THEN 1
        WHEN rs.rango_salario = 'Medio (60k-75k)' THEN 2
        ELSE 3
    END;

-- 4. CTE CON FUNCIONES AGREGADAS

-- Análisis de empleados por año de contratación
WITH 
    empleados_por_año AS (
        SELECT 
            EXTRACT(YEAR FROM fecha_contratacion) AS año_contratacion,
            COUNT(*) AS numero_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio_año,
            SUM(salario) AS salario_total_año
        FROM empleados 
        GROUP BY EXTRACT(YEAR FROM fecha_contratacion)
    ),
    estadisticas_generales AS (
        SELECT 
            COUNT(*) AS total_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio_general
        FROM empleados
    )
SELECT 
    aya.año_contratacion,
    aya.numero_empleados,
    aya.salario_promedio_año,
    aya.salario_total_año,
    eg.total_empleados,
    eg.salario_promedio_general,
    ROUND((aya.numero_empleados * 100.0 / eg.total_empleados), 2) AS porcentaje_empleados,
    ROUND((aya.salario_promedio_año / eg.salario_promedio_general) * 100, 2) AS porcentaje_salario_promedio
FROM empleados_por_año aya
CROSS JOIN estadisticas_generales eg
ORDER BY aya.año_contratacion;

-- 5. CTE CON FILTROS Y CONDICIONES

-- Análisis de empleados con teléfono por departamento
WITH 
    empleados_con_telefono AS (
        SELECT 
            id,
            nombre,
            apellido,
            salario,
            departamento_id
        FROM empleados 
        WHERE telefono IS NOT NULL
    ),
    empleados_sin_telefono AS (
        SELECT 
            id,
            nombre,
            apellido,
            salario,
            departamento_id
        FROM empleados 
        WHERE telefono IS NULL
    ),
    resumen_telefonos AS (
        SELECT 
            departamento_id,
            COUNT(*) AS total_empleados,
            COUNT(CASE WHEN id IN (SELECT id FROM empleados_con_telefono) THEN 1 END) AS con_telefono,
            COUNT(CASE WHEN id IN (SELECT id FROM empleados_sin_telefono) THEN 1 END) AS sin_telefono
        FROM empleados
        GROUP BY departamento_id
    )
SELECT 
    d.nombre AS nombre_departamento,
    rt.total_empleados,
    rt.con_telefono,
    rt.sin_telefono,
    ROUND((rt.con_telefono * 100.0 / rt.total_empleados), 2) AS porcentaje_con_telefono
FROM resumen_telefonos rt
INNER JOIN departamentos d ON rt.departamento_id = d.id
ORDER BY porcentaje_con_telefono DESC;

-- 6. CTE CON EXPRESIONES CONDICIONALES

-- Clasificación de empleados por múltiples criterios
WITH 
    clasificacion_empleados AS (
        SELECT 
            id,
            nombre,
            apellido,
            salario,
            departamento_id,
            activo,
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
    resumen_clasificacion AS (
        SELECT 
            categoria_salario,
            categoria_antiguedad,
            COUNT(*) AS numero_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio
        FROM clasificacion_empleados
        GROUP BY categoria_salario, categoria_antiguedad
    )
SELECT 
    categoria_salario,
    categoria_antiguedad,
    numero_empleados,
    salario_promedio,
    ROUND((numero_empleados * 100.0 / SUM(numero_empleados) OVER()), 2) AS porcentaje_total
FROM resumen_clasificacion
ORDER BY categoria_salario, categoria_antiguedad;

-- 7. CTE CON JOINs SIMPLES

-- Análisis de empleados y sus proyectos
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

-- 8. CTE CON SUBCONSULTAS SIMPLES

-- Análisis de empleados con métricas de departamento
WITH 
    metricas_departamento AS (
        SELECT 
            departamento_id,
            COUNT(*) AS numero_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio,
            MIN(salario) AS salario_minimo,
            MAX(salario) AS salario_maximo
        FROM empleados 
        GROUP BY departamento_id
    ),
    empleados_analizados AS (
        SELECT 
            e.id,
            e.nombre,
            e.apellido,
            e.salario,
            e.departamento_id,
            md.numero_empleados AS empleados_en_dept,
            md.salario_promedio AS salario_promedio_dept,
            e.salario - md.salario_promedio AS diferencia_promedio
        FROM empleados e
        INNER JOIN metricas_departamento md ON e.departamento_id = md.departamento_id
    )
SELECT 
    ea.nombre,
    ea.apellido,
    ea.salario,
    d.nombre AS nombre_departamento,
    ea.empleados_en_dept,
    ea.salario_promedio_dept,
    ea.diferencia_promedio,
    CASE 
        WHEN ea.diferencia_promedio > 0 THEN 'Por encima del promedio'
        WHEN ea.diferencia_promedio < 0 THEN 'Por debajo del promedio'
        ELSE 'En el promedio'
    END AS estado_salario
FROM empleados_analizados ea
INNER JOIN departamentos d ON ea.departamento_id = d.id
ORDER BY ea.diferencia_promedio DESC;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- Los conceptos son idénticos en MS SQL Server
-- Solo cambian algunas funciones específicas del sistema

-- Ejemplo de CTE simple:
WITH estadisticas_departamento AS (
    SELECT 
        d.id,
        d.nombre,
        COUNT(e.id) AS numero_empleados,
        ROUND(AVG(e.salario), 2) AS salario_promedio,
        MIN(e.salario) AS salario_minimo,
        MAX(e.salario) AS salario_maximo
    FROM departamentos d
    INNER JOIN empleados e ON d.id = e.departamento_id
    WHERE e.activo = 1
    GROUP BY d.id, d.nombre
    HAVING COUNT(e.id) >= 2
)
SELECT 
    nombre AS nombre_departamento,
    numero_empleados,
    salario_promedio,
    salario_minimo,
    salario_maximo
FROM estadisticas_departamento
ORDER BY salario_promedio DESC;

-- Ejemplo de múltiples CTEs:
WITH 
    empleados_activos AS (
        SELECT * FROM empleados WHERE activo = 1
    ),
    rangos_salario AS (
        SELECT 
            id,
            nombre,
            apellido,
            salario,
            departamento_id,
            CASE 
                WHEN salario < 60000 THEN 'Bajo (< 60k)'
                WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
                ELSE 'Alto (> 75k)'
            END AS rango_salario
        FROM empleados_activos
    )
SELECT 
    rs.rango_salario,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(rs.salario), 2) AS salario_promedio_rango
FROM rangos_salario rs
GROUP BY rs.rango_salario
ORDER BY 
    CASE 
        WHEN rs.rango_salario = 'Bajo (< 60k)' THEN 1
        WHEN rs.rango_salario = 'Medio (60k-75k)' THEN 2
        ELSE 3
    END;
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
-- 3. Sintaxis básica: Idéntica para CTEs
-- 4. Funciones de ventana: Idénticas en ambos sistemas

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Usa CTEs para mejorar la legibilidad de consultas complejas
-- 2. Nombra las CTEs de manera descriptiva
-- 3. Usa múltiples CTEs para dividir lógica compleja
-- 4. Las CTEs pueden referenciar otras CTEs en la misma consulta
-- 5. Considera el rendimiento: las CTEs se ejecutan cada vez que se referencian
-- 6. Usa CTEs para reutilizar cálculos en la misma consulta
-- 7. Las CTEs son temporales y solo existen durante la ejecución
-- 8. Son una alternativa más legible a subconsultas anidadas
