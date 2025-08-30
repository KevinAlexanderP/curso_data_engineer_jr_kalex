-- =====================================================
-- Generación de Datos Incremental - Respetando Datos Existentes
-- Estrategia: Expandir sin Romper
-- =====================================================

-- =====================================================
-- PASO 1: ANÁLISIS DEL ESTADO ACTUAL
-- =====================================================

-- Antes de generar datos, siempre entendamos qué tenemos
-- Esta consulta nos da el "mapa" actual de nuestra base de datos

SELECT 'ANÁLISIS DEL ESTADO ACTUAL' as reporte;

WITH estado_tablas AS (
    -- Todas las columnas deben ser del mismo tipo en cada SELECT del UNION
    -- Convertimos todo a TEXT para consistencia y flexibilidad de reporte
    SELECT 
        'empleados' as tabla,
        COUNT(*)::text as registros,           -- Conversión explícita a text
        MIN(id)::text as min_id,               -- Conversión explícita a text
        MAX(id)::text as max_id,               -- Conversión explícita a text
        COUNT(DISTINCT departamento_id)::text as valor_distintivo
    FROM empleados
    
    UNION ALL
    
    SELECT 
        'departamentos' as tabla,
        COUNT(*)::text as registros,
        MIN(id)::text as min_id,
        MAX(id)::text as max_id,
        COUNT(DISTINCT nombre)::text as valor_distintivo
    FROM departamentos
    
    UNION ALL
    
    SELECT 
        'proyectos' as tabla,
        COUNT(*)::text as registros,
        MIN(id)::text as min_id,
        MAX(id)::text as max_id,
        COUNT(DISTINCT estado)::text as valor_distintivo
    FROM proyectos
    
    UNION ALL
    
    SELECT 
        'habilidades' as tabla,
        COUNT(*)::text as registros,
        MIN(id)::text as min_id,
        MAX(id)::text as max_id,
        COUNT(DISTINCT categoria)::text as valor_distintivo
    FROM habilidades
)
SELECT 
    tabla,
    registros,
    min_id,
    max_id,
    valor_distintivo
FROM estado_tablas;

-- Análisis detallado de distribución actual
SELECT 
    'DISTRIBUCIÓN POR DEPARTAMENTO' as análisis,
    d.nombre as departamento,
    COUNT(e.id) as empleados_actuales,
    ROUND(AVG(e.salario), 2) as salario_promedio_actual
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre
ORDER BY empleados_actuales DESC;

-- =====================================================
-- PASO 2: GENERACIÓN INCREMENTAL DE EMPLEADOS
-- =====================================================

-- Estrategia: Generar empleados nuevos usando IDs seguros
-- Empezamos desde el ID siguiente al máximo actual

WITH estado_actual AS (
    -- Capturar el estado para generar datos sin colisiones
    SELECT 
        COALESCE(MAX(id), 0) as max_empleado_id,
        COUNT(*) as empleados_existentes
    FROM empleados
),
empleados_nuevos_batch AS (
    -- Generar 1000 empleados nuevos con IDs garantizadamente únicos
    SELECT 
        ea.max_empleado_id + gs.secuencia as nuevo_id,
        
        -- Nombres realistas con variación
        (ARRAY['Ana', 'Carlos', 'María', 'Juan', 'Laura', 'Roberto', 'Carmen', 'Diego', 'Sofia', 'Miguel',
               'Elena', 'Fernando', 'Patricia', 'Ricardo', 'Valeria', 'Andrés', 'Gabriela', 'Sebastián', 'Daniela', 
               'Alejandro', 'Isabella', 'Nicolás', 'Camila', 'Mateo', 'Valentina', 'Santiago', 'Mariana', 'Emilio',
               'Paula', 'Joaquín', 'Antonella', 'Benjamín', 'Regina', 'Adrián', 'Constanza'])[
            1 + (random() * 34)::integer
        ] AS nombre,
        
        (ARRAY['García', 'López', 'Rodríguez', 'Martínez', 'Fernández', 'Sánchez', 'González', 'Pérez', 
               'Hernández', 'Torres', 'Jiménez', 'Morales', 'Castro', 'Vargas', 'Ramos', 'Cruz', 'Mendoza',
               'Flores', 'Rivera', 'Reyes', 'Ortiz', 'Ramírez', 'Guerrero', 'Medina', 'Silva', 'Ruiz',
               'Herrera', 'Delgado', 'Aguilar', 'Vega', 'Romero', 'Gutiérrez'])[
            1 + (random() * 31)::integer
        ] AS apellido,
        
        -- Email único usando el nuevo ID para garantizar unicidad
        LOWER(
            (ARRAY['ana', 'carlos', 'maria', 'juan', 'laura', 'roberto', 'diego', 'sofia'])[1 + (random() * 7)::integer] || 
            '.' || 
            (ARRAY['garcia', 'lopez', 'rodriguez', 'martinez', 'fernandez'])[1 + (random() * 4)::integer] ||
            '.' || (ea.max_empleado_id + gs.secuencia) ||  -- ID único garantiza email único
            '@empresa.com'
        ) as email,
        
        -- Teléfono con formato consistente pero único
        '555-' || LPAD(((ea.max_empleado_id + gs.secuencia) % 10000)::text, 4, '0') as telefono,
        
        -- Distribución salarial realista basada en tu estructura actual
        CASE 
            -- 20% salarios junior (similar al rango que ya tienes)
            WHEN random() < 0.2 THEN 50000 + (random() * 10000)::integer  
            -- 50% salarios medios (corazón de tu distribución actual)
            WHEN random() < 0.7 THEN 60000 + (random() * 15000)::integer  
            -- 25% salarios senior (refleja tu estructura actual)
            WHEN random() < 0.95 THEN 75000 + (random() * 15000)::integer  
            -- 5% salarios ejecutivos (algunos como Miguel que ya tienes)
            ELSE 90000 + (random() * 20000)::integer                       
        END as salario,
        
        -- Fechas de nacimiento lógicas (empleados entre 25 y 55 años)
        CURRENT_DATE - INTERVAL '25 years' - (random() * INTERVAL '30 years') as fecha_nacimiento,
        
        -- Fechas de contratación escalonadas (algunos antiguos, muchos recientes)
        CASE 
            WHEN random() < 0.3 THEN CURRENT_DATE - (random() * INTERVAL '5 years')   -- 30% contratados últimos 5 años
            WHEN random() < 0.7 THEN CURRENT_DATE - (random() * INTERVAL '10 years')  -- 40% últimos 10 años
            ELSE CURRENT_DATE - (random() * INTERVAL '15 years')                      -- 30% más antiguos
        END as fecha_contratacion,
        
        -- Distribución departamental proporcional a tu estructura actual
        -- Respeta la lógica de que Desarrollo es el más grande
        CASE 
            WHEN random() < 0.4 THEN 1   -- 40% Desarrollo (mantienes que sea el mayor)
            WHEN random() < 0.55 THEN 2  -- 15% RRHH
            WHEN random() < 0.75 THEN 3  -- 20% Marketing
            WHEN random() < 0.9 THEN 4   -- 15% Finanzas
            ELSE 5                       -- 10% Operaciones
        END as departamento_id,
        
        -- 95% activos (distribución realista)
        CASE WHEN random() < 0.95 THEN TRUE ELSE FALSE END as activo
        
    FROM estado_actual ea
    CROSS JOIN generate_series(1, 1000) AS gs(secuencia)  -- Generar 1000 empleados nuevos
)
INSERT INTO empleados (nombre, apellido, email, telefono, salario, fecha_nacimiento, fecha_contratacion, departamento_id, activo)
SELECT 
    nombre, apellido, email, telefono, salario, 
    fecha_nacimiento, fecha_contratacion, departamento_id, activo
FROM empleados_nuevos_batch;

-- Verificar la inserción
SELECT 
    'RESULTADO INSERCIÓN EMPLEADOS' as reporte,
    COUNT(*) as total_empleados_ahora,
    COUNT(*) - 10 as empleados_nuevos_agregados,  -- Sabemos que empezamos con 10
    COUNT(DISTINCT departamento_id) as departamentos_con_empleados
FROM empleados;

-- =====================================================
-- PASO 3: EXPANDIR PROYECTOS DE FORMA INTELIGENTE
-- =====================================================

-- Generar proyectos adicionales que complementen los existentes
-- Usar nombres que no colisionen con los 5 proyectos actuales

WITH proyectos_adicionales AS (
    SELECT 
        gs.numero,
        -- Nombres de proyectos que no colisionen con los existentes
        (ARRAY['Modernización', 'Optimización', 'Automatización', 'Integración', 'Digitalización'])[
            1 + ((gs.numero - 1) % 5)
        ] || ' ' ||
        (ARRAY['Backend', 'Frontend', 'Database', 'Infrastructure', 'Security', 'Mobile', 'Analytics', 'Cloud'])[
            1 + ((gs.numero - 1) % 8)
        ] || ' ' || gs.numero as nombre_proyecto,
        
        'Proyecto de expansión generado automáticamente - Fase ' || gs.numero as descripcion,
        
        -- Fechas escalonadas que no interfieran con proyectos existentes
        CURRENT_DATE - INTERVAL '6 months' + (gs.numero * INTERVAL '2 weeks') as fecha_inicio,
        CURRENT_DATE + INTERVAL '6 months' + (gs.numero * INTERVAL '2 weeks') as fecha_fin,
        
        -- Presupuestos variados pero realistas
        (50000 + random() * 100000)::decimal(12,2) as presupuesto,
        
        -- Estados distribuidos realistamente
        CASE 
            WHEN random() < 0.4 THEN 'En Progreso'
            WHEN random() < 0.7 THEN 'Planificado'
            WHEN random() < 0.9 THEN 'En Pausa'
            ELSE 'Completado'
        END as estado
        
    FROM generate_series(1, 50) AS gs(numero)  -- 50 proyectos adicionales
)
INSERT INTO proyectos (nombre, descripcion, fecha_inicio, fecha_fin, presupuesto, estado)
SELECT nombre_proyecto, descripcion, fecha_inicio, fecha_fin, presupuesto, estado
FROM proyectos_adicionales;

-- =====================================================
-- PASO 4: ASIGNAR EMPLEADOS A PROYECTOS CON LÓGICA DE NEGOCIO
-- =====================================================

-- Crear asignaciones inteligentes que respeten la carga de trabajo
-- y las habilidades de los empleados

WITH empleados_disponibles AS (
    -- Empleados que no están sobrecargados de proyectos
    SELECT 
        e.id as empleado_id,
        e.nombre,
        e.apellido,
        e.departamento_id,
        e.salario,
        COALESCE(asignaciones_actuales.proyectos_asignados, 0) as proyectos_actuales
    FROM empleados e
    LEFT JOIN (
        SELECT 
            empleado_id,
            COUNT(*) as proyectos_asignados
        FROM empleados_proyectos
        GROUP BY empleado_id
    ) asignaciones_actuales ON e.id = asignaciones_actuales.empleado_id
    WHERE 
        e.activo = TRUE 
        AND COALESCE(asignaciones_actuales.proyectos_asignados, 0) < 4  -- Máximo 4 proyectos por empleado
),
proyectos_necesitan_recursos AS (
    -- Proyectos que necesitan más gente
    SELECT 
        p.id as proyecto_id,
        p.nombre as proyecto_nombre,
        p.estado,
        COALESCE(recursos_actuales.empleados_asignados, 0) as empleados_asignados
    FROM proyectos p
    LEFT JOIN (
        SELECT 
            proyecto_id,
            COUNT(*) as empleados_asignados
        FROM empleados_proyectos
        GROUP BY proyecto_id
    ) recursos_actuales ON p.id = recursos_actuales.proyecto_id
    WHERE 
        p.estado IN ('En Progreso', 'Planificado')
        AND COALESCE(recursos_actuales.empleados_asignados, 0) < 6  -- Máximo 6 personas por proyecto
),
asignaciones_inteligentes AS (
    SELECT DISTINCT ON (ed.empleado_id, pn.proyecto_id)
        ed.empleado_id,
        pn.proyecto_id,
        -- Asignar roles basados en salario y departamento
        CASE 
            WHEN ed.salario >= 80000 AND ed.departamento_id = 1 THEN 
                (ARRAY['Tech Lead', 'Arquitecto Senior', 'Líder Técnico'])[1 + (random() * 2)::integer]
            WHEN ed.salario >= 70000 THEN 
                (ARRAY['Desarrollador Senior', 'Analista Senior', 'Especialista Senior'])[1 + (random() * 2)::integer]
            WHEN ed.salario >= 60000 THEN 
                (ARRAY['Desarrollador', 'Analista', 'Especialista'])[1 + (random() * 2)::integer]
            ELSE 
                (ARRAY['Desarrollador Junior', 'Analista Junior', 'Asistente'])[1 + (random() * 2)::integer]
        END as rol,
        
        -- Horas proporcionales al nivel del empleado
        CASE 
            WHEN ed.salario >= 80000 THEN 60 + (random() * 80)::integer   -- Líderes: menos horas directas
            WHEN ed.salario >= 70000 THEN 80 + (random() * 60)::integer   -- Seniors: horas balanceadas
            WHEN ed.salario >= 60000 THEN 100 + (random() * 40)::integer  -- Medios: más horas
            ELSE 120 + (random() * 40)::integer                           -- Juniors: máximas horas
        END as horas_asignadas,
        
        -- Fecha de asignación reciente pero variada
        CURRENT_DATE - (random() * INTERVAL '60 days') as fecha_asignacion
        
    FROM empleados_disponibles ed
    CROSS JOIN proyectos_necesitan_recursos pn
    WHERE 
        -- Probabilidad de asignación basada en compatibilidad departamento-proyecto
        (
            -- Desarrollo siempre muy compatible
            (ed.departamento_id = 1 AND random() < 0.6) OR  
            -- Marketing compatible con algunos proyectos
            (ed.departamento_id = 3 AND random() < 0.3) OR  
            -- Otros departamentos ocasionalmente
            (ed.departamento_id IN (2,4,5) AND random() < 0.15)
        )
        -- Controlar el volumen total de asignaciones
        AND random() < 0.25  -- 25% de las combinaciones posibles se materializan
)
INSERT INTO empleados_proyectos (empleado_id, proyecto_id, rol, horas_asignadas, fecha_asignacion)
SELECT empleado_id, proyecto_id, rol, horas_asignadas, fecha_asignacion
FROM asignaciones_inteligentes;

-- =====================================================
-- PASO 5: EXPANDIR HABILIDADES DE EMPLEADOS
-- =====================================================

-- Asignar habilidades a los empleados nuevos basándose en su departamento
-- y nivel salarial (como proxy de experiencia)

WITH empleados_nuevos AS (
    -- Solo empleados que no tienen habilidades asignadas aún
    SELECT 
        e.id,
        e.departamento_id,
        e.salario
    FROM empleados e
    LEFT JOIN empleados_habilidades eh ON e.id = eh.empleado_id
    WHERE eh.empleado_id IS NULL  -- Empleados sin habilidades
),
habilidades_por_depto AS (
    -- Mapear habilidades relevantes por departamento
    SELECT 
        1 as depto_id, 
        ARRAY[1, 2, 3, 4, 5, 6, 7, 8] as habilidades_compatibles  -- Desarrollo: Python, Java, SQL, PostgreSQL, React, Node.js, Docker, AWS
    UNION ALL
    SELECT 2, ARRAY[3, 10]  -- RRHH: SQL, Análisis de Datos
    UNION ALL  
    SELECT 3, ARRAY[3, 10]  -- Marketing: SQL, Análisis de Datos
    UNION ALL
    SELECT 4, ARRAY[3, 4, 10]  -- Finanzas: SQL, PostgreSQL, Análisis de Datos
    UNION ALL
    SELECT 5, ARRAY[3, 7, 8]  -- Operaciones: SQL, Docker, AWS
),
asignaciones_habilidades AS (
    SELECT 
        en.id as empleado_id,
        unnest(hpd.habilidades_compatibles) as habilidad_id,
        -- Nivel basado en salario (más salario = más experiencia)
        CASE 
            WHEN en.salario >= 80000 THEN 4 + (random() * 1)::integer  -- Nivel 4-5
            WHEN en.salario >= 70000 THEN 3 + (random() * 1)::integer  -- Nivel 3-4
            WHEN en.salario >= 60000 THEN 2 + (random() * 2)::integer  -- Nivel 2-4
            ELSE 1 + (random() * 2)::integer                           -- Nivel 1-3
        END as nivel_experiencia,
        
        -- Fecha de certificación simulada
        CURRENT_DATE - (random() * INTERVAL '2 years') as fecha_certificacion
        
    FROM empleados_nuevos en
    INNER JOIN habilidades_por_depto hpd ON en.departamento_id = hpd.depto_id
    WHERE random() < 0.7  -- 70% de probabilidad de tener cada habilidad compatible
)
INSERT INTO empleados_habilidades (empleado_id, habilidad_id, nivel_experiencia, fecha_certificacion)
SELECT DISTINCT empleado_id, habilidad_id, nivel_experiencia, fecha_certificacion
FROM asignaciones_habilidades;

-- =====================================================
-- PASO 6: REPORTE FINAL DE RESULTADOS
-- =====================================================

SELECT 'REPORTE FINAL - DATOS EXPANDIDOS EXITOSAMENTE' as resumen;

-- Estado final de todas las tablas
WITH resumen_final AS (
    SELECT 'empleados' as tabla, COUNT(*) as registros_totales
    FROM empleados
    
    UNION ALL
    
    SELECT 'proyectos', COUNT(*)
    FROM proyectos
    
    UNION ALL
    
    SELECT 'empleados_proyectos', COUNT(*)
    FROM empleados_proyectos
    
    UNION ALL
    
    SELECT 'empleados_habilidades', COUNT(*)
    FROM empleados_habilidades
)
SELECT * FROM resumen_final ORDER BY registros_totales DESC;

-- Distribución final por departamento
SELECT 
    d.nombre as departamento,
    COUNT(e.id) as total_empleados,
    ROUND(AVG(e.salario), 2) as salario_promedio,
    COUNT(CASE WHEN e.activo = TRUE THEN 1 END) as empleados_activos
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre
ORDER BY total_empleados DESC;

-- =====================================================
-- CONCLUSIÓN EDUCATIVA
-- =====================================================

SELECT 
    'MISIÓN CUMPLIDA' as estado,
    'Se expandieron los datos respetando la estructura existente' as resultado,
    'Los nuevos datos son coherentes con los patrones originales' as calidad,
    'Listos para análisis avanzado con volumen significativo' as siguiente_paso;