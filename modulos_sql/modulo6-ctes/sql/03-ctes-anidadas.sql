-- =====================================================
-- Script: CTEs Anidadas y Complejas
-- Módulo 6: Common Table Expressions (CTEs)
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. CTEs QUE REFERENCIAN OTRAS CTEs

-- Análisis complejo de empleados por departamento y categoría
WITH 
    -- Primera CTE: Estadísticas básicas por departamento
    estadisticas_departamento AS (
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
    -- Segunda CTE: Clasificación de empleados (usa la primera CTE)
    empleados_clasificados AS (
        SELECT 
            e.id,
            e.nombre,
            e.apellido,
            e.salario,
            e.departamento_id,
            CASE 
                WHEN e.salario > ed.salario_promedio * 1.2 THEN 'Alto'
                WHEN e.salario < ed.salario_promedio * 0.8 THEN 'Bajo'
                ELSE 'Medio'
            END AS categoria_salario,
            ed.salario_promedio AS salario_promedio_dept
        FROM empleados e
        INNER JOIN estadisticas_departamento ed ON e.departamento_id = ed.departamento_id
    ),
    -- Tercera CTE: Resumen por categoría (usa la segunda CTE)
    resumen_categorias AS (
        SELECT 
            departamento_id,
            categoria_salario,
            COUNT(*) AS numero_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio_categoria
        FROM empleados_clasificados
        GROUP BY departamento_id, categoria_salario
    )
-- Consulta principal que usa todas las CTEs
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    ed.numero_empleados,
    ed.salario_promedio AS salario_promedio_departamento,
    rc.categoria_salario,
    rc.numero_empleados AS empleados_en_categoria,
    rc.salario_promedio_categoria,
    ROUND((rc.numero_empleados * 100.0 / ed.numero_empleados), 2) AS porcentaje_categoria
FROM departamentos d
INNER JOIN estadisticas_departamento ed ON d.id = ed.departamento_id
INNER JOIN resumen_categorias rc ON d.id = rc.departamento_id
ORDER BY d.nombre, 
    CASE 
        WHEN rc.categoria_salario = 'Alto' THEN 1
        WHEN rc.categoria_salario = 'Medio' THEN 2
        ELSE 3
    END;

-- 2. CTEs CON MÚLTIPLES NIVELES DE ANIDACIÓN

-- Análisis de empleados con proyectos y habilidades
WITH 
    -- Nivel 1: Empleados básicos
    empleados_basicos AS (
        SELECT 
            id,
            nombre,
            apellido,
            salario,
            departamento_id,
            activo
        FROM empleados
        WHERE activo = TRUE
    ),
    -- Nivel 2: Empleados con departamento (usa nivel 1)
    empleados_con_dept AS (
        SELECT 
            eb.*,
            d.nombre AS nombre_departamento,
            d.ubicacion
        FROM empleados_basicos eb
        INNER JOIN departamentos d ON eb.departamento_id = d.id
    ),
    -- Nivel 3: Empleados con proyectos (usa nivel 2)
    empleados_con_proyectos AS (
        SELECT 
            ecd.*,
            COUNT(ep.proyecto_id) AS numero_proyectos,
            STRING_AGG(p.nombre, ', ') AS nombres_proyectos
        FROM empleados_con_dept ecd
        LEFT JOIN empleados_proyectos ep ON ecd.id = ep.empleado_id
        LEFT JOIN proyectos p ON ep.proyecto_id = p.id
        GROUP BY ecd.id, ecd.nombre, ecd.apellido, ecd.salario, ecd.departamento_id, ecd.activo, ecd.nombre_departamento, ecd.ubicacion
    ),
    -- Nivel 4: Empleados con habilidades (usa nivel 2)
    empleados_con_habilidades AS (
        SELECT 
            ecd.*,
            COUNT(eh.habilidad_id) AS numero_habilidades,
            STRING_AGG(h.nombre, ', ') AS nombres_habilidades
        FROM empleados_con_dept ecd
        LEFT JOIN empleados_habilidades eh ON ecd.id = eh.empleado_id
        LEFT JOIN habilidades h ON eh.habilidad_id = h.id
        GROUP BY ecd.id, ecd.nombre, ecd.apellido, ecd.salario, ecd.departamento_id, ecd.activo, ecd.nombre_departamento, ecd.ubicacion
    ),
    -- Nivel 5: Resumen final (usa niveles 3 y 4)
    resumen_final AS (
        SELECT 
            ecp.id,
            ecp.nombre,
            ecp.apellido,
            ecp.salario,
            ecp.nombre_departamento,
            ecp.ubicacion,
            ecp.numero_proyectos,
            ecp.nombres_proyectos,
            ech.numero_habilidades,
            ech.nombres_habilidades,
            ecp.numero_proyectos + ech.numero_habilidades AS total_actividades
        FROM empleados_con_proyectos ecp
        INNER JOIN empleados_con_habilidades ech ON ecp.id = ech.id
    )
-- Consulta principal
SELECT 
    nombre,
    apellido,
    salario,
    nombre_departamento,
    ubicacion,
    numero_proyectos,
    nombres_proyectos,
    numero_habilidades,
    nombres_habilidades,
    total_actividades
FROM resumen_final
ORDER BY total_actividades DESC, salario DESC;

-- 3. CTEs CON SUBCONSULTAS COMPLEJAS

-- Análisis de empleados con métricas avanzadas
WITH 
    -- CTE para percentiles por departamento
    percentiles_departamento AS (
        SELECT 
            departamento_id,
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salario) AS percentil_25,
            PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salario) AS mediana,
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) AS percentil_75,
            PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY salario) AS percentil_90
        FROM empleados 
        GROUP BY departamento_id
    ),
    -- CTE para empleados con clasificación avanzada
    empleados_clasificacion_avanzada AS (
        SELECT 
            e.id,
            e.nombre,
            e.apellido,
            e.salario,
            e.departamento_id,
            pd.percentil_25,
            pd.mediana,
            pd.percentil_75,
            pd.percentil_90,
            CASE 
                WHEN e.salario < pd.percentil_25 THEN 'Muy Bajo'
                WHEN e.salario < pd.mediana THEN 'Bajo'
                WHEN e.salario < pd.percentil_75 THEN 'Medio'
                WHEN e.salario < pd.percentil_90 THEN 'Alto'
                ELSE 'Muy Alto'
            END AS clasificacion_detallada,
            ROUND((e.salario - pd.mediana) / pd.mediana * 100, 2) AS variacion_mediana
        FROM empleados e
        INNER JOIN percentiles_departamento pd ON e.departamento_id = pd.departamento_id
    ),
    -- CTE para análisis de distribución
    distribucion_salarios AS (
        SELECT 
            departamento_id,
            clasificacion_detallada,
            COUNT(*) AS numero_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio_clase,
            MIN(salario) AS salario_minimo_clase,
            MAX(salario) AS salario_maximo_clase
        FROM empleados_clasificacion_avanzada
        GROUP BY departamento_id, clasificacion_detallada
    )
-- Consulta principal con análisis completo
SELECT 
    d.nombre AS nombre_departamento,
    ds.clasificacion_detallada,
    ds.numero_empleados,
    ds.salario_promedio_clase,
    ds.salario_minimo_clase,
    ds.salario_maximo_clase,
    ROUND((ds.numero_empleados * 100.0 / SUM(ds.numero_empleados) OVER (PARTITION BY d.id)), 2) AS porcentaje_departamento,
    ROUND((ds.numero_empleados * 100.0 / SUM(ds.numero_empleados) OVER ()), 2) AS porcentaje_total
FROM distribucion_salarios ds
INNER JOIN departamentos d ON ds.departamento_id = d.id
ORDER BY d.nombre, 
    CASE 
        WHEN ds.clasificacion_detallada = 'Muy Bajo' THEN 1
        WHEN ds.clasificacion_detallada = 'Bajo' THEN 2
        WHEN ds.clasificacion_detallada = 'Medio' THEN 3
        WHEN ds.clasificacion_detallada = 'Alto' THEN 4
        ELSE 5
    END;

-- 4. CTEs CON FUNCIONES DE VENTANA

-- Análisis de empleados con ranking y comparaciones
WITH 
    -- CTE para ranking por departamento
    ranking_empleados AS (
        SELECT 
            id,
            nombre,
            apellido,
            salario,
            departamento_id,
            ROW_NUMBER() OVER (PARTITION BY departamento_id ORDER BY salario DESC) AS ranking_salario_dept,
            RANK() OVER (PARTITION BY departamento_id ORDER BY salario DESC) AS rango_salario_dept,
            DENSE_RANK() OVER (PARTITION BY departamento_id ORDER BY salario DESC) AS rango_denso_dept,
            LAG(salario) OVER (PARTITION BY departamento_id ORDER BY salario DESC) AS salario_anterior,
            LEAD(salario) OVER (PARTITION BY departamento_id ORDER BY salario DESC) AS salario_siguiente
        FROM empleados
    ),
    -- CTE para estadísticas de ranking
    estadisticas_ranking AS (
        SELECT 
            departamento_id,
            COUNT(*) AS total_empleados,
            AVG(ranking_salario_dept) AS ranking_promedio,
            MAX(ranking_salario_dept) AS ranking_maximo
        FROM ranking_empleados
        GROUP BY departamento_id
    ),
    -- CTE para análisis de gaps salariales
    gaps_salariales AS (
        SELECT 
            re.*,
            er.total_empleados,
            er.ranking_promedio,
            CASE 
                WHEN re.salario_anterior IS NOT NULL THEN re.salario - re.salario_anterior
                ELSE 0
            END AS gap_con_anterior,
            CASE 
                WHEN re.salario_siguiente IS NOT NULL THEN re.salario - re.salario_siguiente
                ELSE 0
            END AS gap_con_siguiente
        FROM ranking_empleados re
        INNER JOIN estadisticas_ranking er ON re.departamento_id = er.departamento_id
    )
-- Consulta principal con análisis de ranking
SELECT 
    gs.nombre,
    gs.apellido,
    gs.salario,
    d.nombre AS nombre_departamento,
    gs.ranking_salario_dept,
    gs.rango_salario_dept,
    gs.total_empleados,
    gs.ranking_promedio,
    gs.gap_con_anterior,
    gs.gap_con_siguiente,
    CASE 
        WHEN gs.ranking_salario_dept <= 3 THEN 'Top 3'
        WHEN gs.ranking_salario_dept <= gs.total_empleados * 0.25 THEN 'Top 25%'
        WHEN gs.ranking_salario_dept <= gs.total_empleados * 0.50 THEN 'Top 50%'
        ELSE 'Bottom 50%'
    END AS categoria_ranking
FROM gaps_salariales gs
INNER JOIN departamentos d ON gs.departamento_id = d.id
ORDER BY d.nombre, gs.ranking_salario_dept;

-- 5. CTEs CON EXPRESIONES CONDICIONALES COMPLEJAS

-- Análisis de empleados con múltiples criterios de clasificación
WITH 
    -- CTE para criterios de clasificación
    criterios_clasificacion AS (
        SELECT 
            id,
            nombre,
            apellido,
            salario,
            departamento_id,
            fecha_contratacion,
            activo,
            -- Criterio 1: Salario
            CASE 
                WHEN salario < 60000 THEN 'Junior'
                WHEN salario BETWEEN 60000 AND 75000 THEN 'Intermedio'
                ELSE 'Senior'
            END AS categoria_salario,
            -- Criterio 2: Antigüedad
            CASE 
                WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) < 2 THEN 'Nuevo'
                WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) <= 5 THEN 'Experto'
                ELSE 'Veterano'
            END AS categoria_antiguedad,
            -- Criterio 3: Estado
            CASE 
                WHEN activo = TRUE THEN 'Activo'
                ELSE 'Inactivo'
            END AS estado_empleado
        FROM empleados
    ),
    -- CTE para combinaciones de criterios
    combinaciones_criterios AS (
        SELECT 
            *,
            categoria_salario || ' - ' || categoria_antiguedad AS combinacion_principal,
            categoria_salario || ' - ' || categoria_antiguedad || ' - ' || estado_empleado AS combinacion_completa
        FROM criterios_clasificacion
    ),
    -- CTE para resumen de combinaciones
    resumen_combinaciones AS (
        SELECT 
            combinacion_principal,
            combinacion_completa,
            COUNT(*) AS numero_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio,
            MIN(salario) AS salario_minimo,
            MAX(salario) AS salario_maximo
        FROM combinaciones_criterios
        GROUP BY combinacion_principal, combinacion_completa
    )
-- Consulta principal con análisis de combinaciones
SELECT 
    combinacion_principal,
    combinacion_completa,
    numero_empleados,
    salario_promedio,
    salario_minimo,
    salario_maximo,
    ROUND((numero_empleados * 100.0 / SUM(numero_empleados) OVER ()), 2) AS porcentaje_total,
    ROUND((salario_promedio / AVG(salario_promedio) OVER ()) * 100, 2) AS porcentaje_salario_promedio
FROM resumen_combinaciones
ORDER BY numero_empleados DESC, salario_promedio DESC;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- Los conceptos son idénticos en MS SQL Server
-- Solo cambian algunas funciones específicas del sistema

-- Ejemplo de CTEs anidadas:
WITH 
    estadisticas_departamento AS (
        SELECT 
            departamento_id,
            COUNT(*) AS numero_empleados,
            ROUND(AVG(salario), 2) AS salario_promedio,
            MIN(salario) AS salario_minimo,
            MAX(salario) AS salario_maximo,
            STDEV(salario) AS desviacion_estandar
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
                WHEN e.salario > ed.salario_promedio * 1.2 THEN 'Alto'
                WHEN e.salario < ed.salario_promedio * 0.8 THEN 'Bajo'
                ELSE 'Medio'
            END AS categoria_salario,
            ed.salario_promedio AS salario_promedio_dept
        FROM empleados e
        INNER JOIN estadisticas_departamento ed ON e.departamento_id = ed.departamento_id
    )
SELECT 
    ec.*,
    d.nombre AS nombre_departamento
FROM empleados_clasificados ec
INNER JOIN departamentos d ON ec.departamento_id = d.id
ORDER BY ec.salario DESC;
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
-- 3. Percentiles:
--    - PostgreSQL: PERCENTILE_CONT() WITHIN GROUP
--    - MS SQL Server: PERCENTILE_CONT() WITHIN GROUP OVER()
-- 4. Sintaxis básica: Idéntica para CTEs anidadas
-- 5. Funciones de ventana: Idénticas en ambos sistemas

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Usa CTEs anidadas para dividir lógica compleja en pasos manejables
-- 2. Nombra las CTEs de manera descriptiva y secuencial
-- 3. Las CTEs pueden referenciar otras CTEs definidas anteriormente
-- 4. Considera el rendimiento: las CTEs se ejecutan cada vez que se referencian
-- 5. Usa CTEs anidadas para consultas de análisis complejas
-- 6. Las CTEs anidadas mejoran la legibilidad del código
-- 7. Puedes usar funciones de ventana dentro de CTEs
-- 8. Las CTEs anidadas son útiles para ETL y transformaciones de datos
