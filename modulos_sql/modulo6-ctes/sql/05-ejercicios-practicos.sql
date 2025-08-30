-- =====================================================
-- Script: Ejercicios Prácticos - CTEs
-- Módulo 6: Common Table Expressions (CTEs)
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- =====================================================
-- EJERCICIO 1: ANÁLISIS DE EMPLEADOS POR DEPARTAMENTO
-- =====================================================

-- Objetivo: Crear una CTE que calcule estadísticas por departamento
-- y luego clasifique empleados según su salario relativo

-- Tu código aquí:
-- 1. Crea una CTE llamada 'estadisticas_dept' que calcule:
--    - Número de empleados por departamento
--    - Salario promedio, mínimo y máximo por departamento
-- 2. Crea una CTE llamada 'empleados_clasificados' que:
--    - Clasifique empleados como 'Alto', 'Medio' o 'Bajo' según su salario
--    - Compare con el promedio del departamento
-- 3. Muestra el resultado final con nombre, departamento, salario y clasificación

-- Solución:
WITH 
    estadisticas_dept AS (
        SELECT 
            departamento_id,
            COUNT(*) AS num_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio,
            MIN(salario) AS salario_minimo,
            MAX(salario) AS salario_maximo
        FROM empleados
        GROUP BY departamento_id
    ),
    empleados_clasificados AS (
        SELECT 
            e.nombre,
            e.apellido,
            e.salario,
            d.nombre AS departamento,
            ed.salario_promedio,
            CASE 
                WHEN e.salario > ed.salario_promedio * 1.2 THEN 'Alto'
                WHEN e.salario < ed.salario_promedio * 0.8 THEN 'Bajo'
                ELSE 'Medio'
            END AS clasificacion
        FROM empleados e
        INNER JOIN departamentos d ON e.departamento_id = d.id
        INNER JOIN estadisticas_dept ed ON e.departamento_id = ed.departamento_id
    )
SELECT 
    nombre,
    apellido,
    salario,
    departamento,
    salario_promedio,
    clasificacion
FROM empleados_clasificados
ORDER BY departamento, salario DESC;

-- =====================================================
-- EJERCICIO 2: ANÁLISIS DE PROYECTOS Y HABILIDADES
-- =====================================================

-- Objetivo: Usar CTEs para analizar la relación entre proyectos y habilidades requeridas

-- Tu código aquí:
-- 1. Crea una CTE llamada 'proyectos_info' que obtenga:
--    - Información básica del proyecto
--    - Número de empleados asignados
-- 2. Crea una CTE llamada 'habilidades_proyecto' que calcule:
--    - Habilidades únicas requeridas por proyecto
--    - Número de empleados con cada habilidad
-- 3. Combina ambas CTEs para mostrar un análisis completo

-- Solución:
WITH 
    proyectos_info AS (
        SELECT 
            p.id,
            p.nombre AS nombre_proyecto,
            p.descripcion,
            p.fecha_inicio,
            p.fecha_fin,
            COUNT(DISTINCT ep.empleado_id) AS num_empleados_asignados
        FROM proyectos p
        LEFT JOIN empleados_proyectos ep ON p.id = ep.proyecto_id
        GROUP BY p.id, p.nombre, p.descripcion, p.fecha_inicio, p.fecha_fin
    ),
    habilidades_proyecto AS (
        SELECT 
            p.id AS proyecto_id,
            h.nombre AS habilidad,
            COUNT(DISTINCT eh.empleado_id) AS num_empleados_con_habilidad
        FROM proyectos p
        INNER JOIN empleados_proyectos ep ON p.id = ep.proyecto_id
        INNER JOIN empleados_habilidades eh ON ep.empleado_id = eh.empleado_id
        INNER JOIN habilidades h ON eh.habilidad_id = h.id
        GROUP BY p.id, h.nombre
    )
SELECT 
    pi.nombre_proyecto,
    pi.num_empleados_asignados,
    STRING_AGG(hp.habilidad, ', ') AS habilidades_requeridas,
    COUNT(DISTINCT hp.habilidad) AS num_habilidades_unicas,
    ROUND(AVG(hp.num_empleados_con_habilidad), 2) AS prom_empleados_por_habilidad
FROM proyectos_info pi
LEFT JOIN habilidades_proyecto hp ON pi.id = hp.proyecto_id
GROUP BY pi.id, pi.nombre_proyecto, pi.num_empleados_asignados
ORDER BY pi.num_empleados_asignados DESC;

-- =====================================================
-- EJERCICIO 3: ANÁLISIS TEMPORAL DE CONTRATACIONES
-- =====================================================

-- Objetivo: Crear CTEs para analizar patrones de contratación por año y mes

-- Tu código aquí:
-- 1. Crea una CTE llamada 'contrataciones_por_mes' que calcule:
--    - Número de contrataciones por año y mes
--    - Salario promedio por período
-- 2. Crea una CTE llamada 'tendencia_contrataciones' que:
--    - Calcule la tendencia de contrataciones (creciente/decreciente)
--    - Compare con el mes anterior
-- 3. Muestra el análisis temporal completo

-- Solución:
WITH 
    contrataciones_por_mes AS (
        SELECT 
            EXTRACT(YEAR FROM fecha_contratacion) AS año,
            EXTRACT(MONTH FROM fecha_contratacion) AS mes,
            COUNT(*) AS num_contrataciones,
            ROUND(AVG(salario), 2) AS salario_promedio,
            MIN(salario) AS salario_minimo,
            MAX(salario) AS salario_maximo
        FROM empleados
        GROUP BY 
            EXTRACT(YEAR FROM fecha_contratacion),
            EXTRACT(MONTH FROM fecha_contratacion)
        ORDER BY año, mes
    ),
    tendencia_contrataciones AS (
        SELECT 
            *,
            LAG(num_contrataciones) OVER (ORDER BY año, mes) AS contrataciones_mes_anterior,
            LAG(salario_promedio) OVER (ORDER BY año, mes) AS salario_mes_anterior,
            CASE 
                WHEN LAG(num_contrataciones) OVER (ORDER BY año, mes) IS NULL THEN 'Primer mes'
                WHEN num_contrataciones > LAG(num_contrataciones) OVER (ORDER BY año, mes) THEN 'Creciente'
                WHEN num_contrataciones < LAG(num_contrataciones) OVER (ORDER BY año, mes) THEN 'Decreciente'
                ELSE 'Estable'
            END AS tendencia_contrataciones,
            CASE 
                WHEN LAG(salario_promedio) OVER (ORDER BY año, mes) IS NULL THEN 0
                ELSE ROUND(((salario_promedio - LAG(salario_promedio) OVER (ORDER BY año, mes)) / LAG(salario_promedio) OVER (ORDER BY año, mes)) * 100, 2)
            END AS variacion_salario_porcentual
        FROM contrataciones_por_mes
    )
SELECT 
    año,
    mes,
    TO_CHAR(TO_DATE(año || '-' || LPAD(mes::TEXT, 2, '0') || '-01', 'YYYY-MM-DD'), 'Month YYYY') AS periodo,
    num_contrataciones,
    contrataciones_mes_anterior,
    tendencia_contrataciones,
    salario_promedio,
    salario_mes_anterior,
    variacion_salario_porcentual,
    CASE 
        WHEN variacion_salario_porcentual > 5 THEN 'Subida significativa'
        WHEN variacion_salario_porcentual < -5 THEN 'Bajada significativa'
        WHEN variacion_salario_porcentual BETWEEN -5 AND 5 THEN 'Estable'
        ELSE 'Sin datos'
    END AS clasificacion_variacion
FROM tendencia_contrataciones
ORDER BY año, mes;

-- =====================================================
-- EJERCICIO 4: ANÁLISIS DE DEPARTAMENTOS CON CTEs ANIDADAS
-- =====================================================

-- Objetivo: Crear múltiples CTEs anidadas para análisis complejo de departamentos

-- Tu código aquí:
-- 1. Crea una CTE llamada 'empleados_activos' que filtre empleados activos
-- 2. Crea una CTE llamada 'stats_por_dept' que calcule estadísticas por departamento
-- 3. Crea una CTE llamada 'ranking_dept' que rankee departamentos por diferentes métricas
-- 4. Crea una CTE llamada 'analisis_final' que combine toda la información
-- 5. Muestra un ranking completo de departamentos

-- Solución:
WITH 
    empleados_activos AS (
        SELECT 
            id,
            nombre,
            apellido,
            salario,
            departamento_id,
            fecha_contratacion
        FROM empleados
        WHERE activo = TRUE
    ),
    stats_por_dept AS (
        SELECT 
            d.id,
            d.nombre AS nombre_departamento,
            d.ubicacion,
            COUNT(ea.id) AS num_empleados,
            ROUND(AVG(ea.salario), 2) AS salario_promedio,
            MIN(ea.salario) AS salario_minimo,
            MAX(ea.salario) AS salario_maximo,
            STDDEV(ea.salario) AS desviacion_salario,
            MIN(ea.fecha_contratacion) AS empleado_mas_antiguo,
            MAX(ea.fecha_contratacion) AS empleado_mas_nuevo
        FROM departamentos d
        LEFT JOIN empleados_activos ea ON d.id = ea.departamento_id
        GROUP BY d.id, d.nombre, d.ubicacion
    ),
    ranking_dept AS (
        SELECT 
            *,
            ROW_NUMBER() OVER (ORDER BY salario_promedio DESC) AS ranking_salario,
            ROW_NUMBER() OVER (ORDER BY num_empleados DESC) AS ranking_tamaño,
            ROW_NUMBER() OVER (ORDER BY desviacion_salario DESC) AS ranking_variabilidad,
            ROW_NUMBER() OVER (ORDER BY empleado_mas_antiguo) AS ranking_antiguedad
        FROM stats_por_dept
    ),
    analisis_final AS (
        SELECT 
            *,
            (ranking_salario + ranking_tamaño + ranking_variabilidad + ranking_antiguedad) AS puntuacion_total,
            ROW_NUMBER() OVER (ORDER BY (ranking_salario + ranking_tamaño + ranking_variabilidad + ranking_antiguedad)) AS ranking_general
        FROM ranking_dept
    )
SELECT 
    ranking_general,
    nombre_departamento,
    ubicacion,
    num_empleados,
    salario_promedio,
    salario_minimo,
    salario_maximo,
    ROUND(desviacion_salario, 2) AS desviacion_salario,
    ranking_salario,
    ranking_tamaño,
    ranking_variabilidad,
    ranking_antiguedad,
    puntuacion_total,
    CASE 
        WHEN ranking_general <= 2 THEN 'Excelente'
        WHEN ranking_general <= 4 THEN 'Bueno'
        ELSE 'Mejorable'
    END AS clasificacion_general
FROM analisis_final
ORDER BY ranking_general;

-- =====================================================
-- EJERCICIO 5: CTE RECURSIVA PARA ANÁLISIS JERÁRQUICO
-- =====================================================

-- Objetivo: Crear una CTE recursiva para analizar la estructura organizacional

-- Tu código aquí:
-- 1. Crea una tabla temporal con estructura jerárquica simulada
-- 2. Crea una CTE recursiva que muestre la jerarquía completa
-- 3. Calcula métricas por nivel jerárquico
-- 4. Muestra el análisis jerárquico completo

-- Solución:
-- Crear tabla temporal con jerarquía simulada
CREATE TEMP TABLE estructura_organizacional AS
SELECT 
    id,
    nombre,
    apellido,
    salario,
    departamento_id,
    -- Simular jerarquía: empleados 1-3 son ejecutivos, 4-6 son gerentes, resto son empleados
    CASE 
        WHEN id <= 3 THEN NULL
        WHEN id <= 6 THEN (id % 3) + 1
        ELSE (id % 6) + 1
    END AS supervisor_id
FROM empleados;

-- CTE recursiva para análisis jerárquico
WITH RECURSIVE jerarquia_completa AS (
    -- Caso base: ejecutivos (nivel 0)
    SELECT 
        id,
        nombre,
        apellido,
        salario,
        departamento_id,
        supervisor_id,
        0 AS nivel_jerarquico,
        ARRAY[id] AS ruta_jerarquica,
        nombre || ' ' || apellido AS ruta_nombres,
        salario AS salario_acumulado
    FROM estructura_organizacional
    WHERE supervisor_id IS NULL
    
    UNION ALL
    
    -- Caso recursivo: subordinados
    SELECT 
        eo.id,
        eo.nombre,
        eo.apellido,
        eo.salario,
        eo.departamento_id,
        eo.supervisor_id,
        jc.nivel_jerarquico + 1,
        jc.ruta_jerarquica || eo.id,
        jc.ruta_nombres || ' > ' || eo.nombre || ' ' || eo.apellido,
        jc.salario_acumulado + eo.salario
    FROM estructura_organizacional eo
    INNER JOIN jerarquia_completa jc ON eo.supervisor_id = jc.id
    WHERE jc.nivel_jerarquico < 3 -- Limitar a 3 niveles
)
SELECT 
    nivel_jerarquico,
    COUNT(*) AS num_empleados_nivel,
    ROUND(AVG(salario), 2) AS salario_promedio_nivel,
    MIN(salario) AS salario_minimo_nivel,
    MAX(salario) AS salario_maximo_nivel,
    ROUND(SUM(salario), 2) AS salario_total_nivel,
    ROUND(AVG(salario_acumulado), 2) AS salario_acumulado_promedio,
    STRING_AGG(nombre || ' ' || apellido, ', ') AS empleados_nivel
FROM jerarquia_completa
GROUP BY nivel_jerarquico
ORDER BY nivel_jerarquico;

-- Mostrar empleados individuales con su jerarquía
SELECT 
    nivel_jerarquico,
    REPEAT('  ', nivel_jerarquico) || nombre || ' ' || apellido AS empleado_indentado,
    salario,
    ruta_nombres,
    ruta_jerarquica
FROM jerarquia_completa
ORDER BY ruta_jerarquica;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- Los ejercicios son muy similares en MS SQL Server
-- Solo cambian algunas funciones específicas

-- Ejemplo de ejercicio adaptado:
WITH 
    estadisticas_dept AS (
        SELECT 
            departamento_id,
            COUNT(*) AS num_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio,
            MIN(salario) AS salario_minimo,
            MAX(salario) AS salario_maximo
        FROM empleados
        GROUP BY departamento_id
    ),
    empleados_clasificados AS (
        SELECT 
            e.nombre,
            e.apellido,
            e.salario,
            d.nombre AS departamento,
            ed.salario_promedio,
            CASE 
                WHEN e.salario > ed.salario_promedio * 1.2 THEN 'Alto'
                WHEN e.salario < ed.salario_promedio * 0.8 THEN 'Bajo'
                ELSE 'Medio'
            END AS clasificacion
        FROM empleados e
        INNER JOIN departamentos d ON e.departamento_id = d.id
        INNER JOIN estadisticas_dept ed ON e.departamento_id = ed.departamento_id
    )
SELECT 
    nombre,
    apellido,
    salario,
    departamento,
    salario_promedio,
    clasificacion
FROM empleados_clasificados
ORDER BY departamento, salario DESC;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Funciones de fecha:
--    - PostgreSQL: EXTRACT(), TO_CHAR(), DATE_TRUNC()
--    - MS SQL Server: YEAR(), MONTH(), FORMAT(), DATEPART()
-- 2. Funciones de texto:
--    - PostgreSQL: STRING_AGG()
--    - MS SQL Server: STRING_AGG() (SQL Server 2017+)
-- 3. Funciones estadísticas:
--    - PostgreSQL: STDDEV()
--    - MS SQL Server: STDEV()
-- 4. Arrays:
--    - PostgreSQL: ARRAY[], || (concatenación)
--    - MS SQL Server: No soporte nativo
-- 5. CTEs recursivas: Sintaxis idéntica en ambos sistemas

-- =====================================================
-- CONSEJOS PARA LOS EJERCICIOS:
-- =====================================================
-- 1. Empieza con CTEs simples y ve añadiendo complejidad
-- 2. Usa nombres descriptivos para las CTEs
-- 3. Comenta cada paso de tu lógica
-- 4. Prueba cada CTE individualmente antes de combinarlas
-- 5. Usa LIMIT/TOP para probar con pocos datos primero
-- 6. Las CTEs anidadas mejoran la legibilidad del código
-- 7. Las CTEs recursivas son potentes pero pueden ser costosas
-- 8. Siempre incluye condiciones de parada en CTEs recursivas
-- 9. Usa CTEs para dividir consultas complejas en pasos manejables
-- 10. Las CTEs son excelentes para ETL y transformaciones de datos
