-- =====================================================
-- Script: CTEs Recursivas
-- Módulo 6: Common Table Expressions (CTEs)
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. CTE RECURSIVA BÁSICA - SERIE NUMÉRICA

-- Generar una serie del 1 al 10
WITH RECURSIVE serie_numeros AS (
    -- Caso base: primer número
    SELECT 1 AS numero
    
    UNION ALL
    
    -- Caso recursivo: siguiente número
    SELECT numero + 1
    FROM serie_numeros
    WHERE numero < 10
)
SELECT numero FROM serie_numeros
ORDER BY numero;

-- Generar serie con paso personalizado (de 5 en 5 hasta 50)
WITH RECURSIVE serie_paso AS (
    -- Caso base
    SELECT 5 AS numero
    
    UNION ALL
    
    -- Caso recursivo
    SELECT numero + 5
    FROM serie_paso
    WHERE numero < 50
)
SELECT numero FROM serie_paso
ORDER BY numero;

-- 2. CTE RECURSIVA PARA FECHAS

-- Generar fechas de una semana
WITH RECURSIVE fechas_semana AS (
    -- Caso base: fecha inicial
    SELECT CURRENT_DATE AS fecha
    
    UNION ALL
    
    -- Caso recursivo: siguiente fecha
    SELECT fecha + INTERVAL '1 day'
    FROM fechas_semana
    WHERE fecha < CURRENT_DATE + INTERVAL '6 days'
)
SELECT 
    fecha,
    EXTRACT(DOW FROM fecha) AS dia_semana,
    TO_CHAR(fecha, 'Day') AS nombre_dia
FROM fechas_semana
ORDER BY fecha;

-- Generar fechas del mes actual
WITH RECURSIVE fechas_mes AS (
    -- Caso base: primer día del mes
    SELECT DATE_TRUNC('month', CURRENT_DATE) AS fecha
    
    UNION ALL
    
    -- Caso recursivo: siguiente día
    SELECT fecha + INTERVAL '1 day'
    FROM fechas_mes
    WHERE fecha < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' - INTERVAL '1 day'
)
SELECT 
    fecha,
    EXTRACT(DAY FROM fecha) AS dia_mes,
    TO_CHAR(fecha, 'DD/MM/YYYY') AS fecha_formateada
FROM fechas_mes
ORDER BY fecha;

-- 3. CTE RECURSIVA PARA JERARQUÍAS - EMPLEADOS Y GERENTES

-- Primero, vamos a crear una tabla temporal con estructura jerárquica
-- (Asumiendo que tenemos una columna gerente_id en la tabla empleados)

-- Crear tabla temporal para demostración
CREATE TEMP TABLE empleados_jerarquia AS
SELECT 
    id,
    nombre,
    apellido,
    salario,
    departamento_id,
    -- Simular jerarquía: empleados con ID 1, 2, 3 son gerentes
    CASE 
        WHEN id IN (1, 2, 3) THEN NULL
        ELSE (id % 3) + 1
    END AS gerente_id
FROM empleados;

-- CTE recursiva para mostrar jerarquía organizacional
WITH RECURSIVE jerarquia_empleados AS (
    -- Caso base: empleados sin gerente (nivel 0)
    SELECT 
        id,
        nombre,
        apellido,
        salario,
        departamento_id,
        gerente_id,
        0 AS nivel,
        ARRAY[id] AS ruta_hierarquica,
        nombre || ' ' || apellido AS ruta_nombres
    FROM empleados_jerarquia
    WHERE gerente_id IS NULL
    
    UNION ALL
    
    -- Caso recursivo: empleados con gerente
    SELECT 
        ej.id,
        ej.nombre,
        ej.apellido,
        ej.salario,
        ej.departamento_id,
        ej.gerente_id,
        je.nivel + 1,
        je.ruta_hierarquica || ej.id,
        je.ruta_nombres || ' > ' || ej.nombre || ' ' || ej.apellido
    FROM empleados_jerarquia ej
    INNER JOIN jerarquia_empleados je ON ej.gerente_id = je.id
)
SELECT 
    nivel,
    nombre,
    apellido,
    salario,
    ruta_nombres,
    ruta_hierarquica
FROM jerarquia_empleados
ORDER BY ruta_hierarquica;

-- 4. CTE RECURSIVA PARA ÁRBOLES DE CATEGORÍAS

-- Crear tabla temporal para categorías anidadas
CREATE TEMP TABLE categorias AS (
    SELECT 1 AS id, 'Tecnología' AS nombre, NULL AS categoria_padre_id, 0 AS nivel
    UNION ALL SELECT 2, 'Desarrollo', 1, 1
    UNION ALL SELECT 3, 'Base de Datos', 1, 1
    UNION ALL SELECT 4, 'Frontend', 2, 2
    UNION ALL SELECT 5, 'Backend', 2, 2
    UNION ALL SELECT 6, 'SQL', 3, 2
    UNION ALL SELECT 7, 'NoSQL', 3, 2
    UNION ALL SELECT 8, 'React', 4, 3
    UNION ALL SELECT 9, 'Vue', 4, 3
    UNION ALL SELECT 10, 'Python', 5, 3
    UNION ALL SELECT 11, 'Java', 5, 3
    UNION ALL SELECT 12, 'PostgreSQL', 6, 3
    UNION ALL SELECT 13, 'MySQL', 6, 3
    UNION ALL SELECT 14, 'MongoDB', 7, 3
    UNION ALL SELECT 15, 'Redis', 7, 3
);

-- CTE recursiva para mostrar árbol de categorías
WITH RECURSIVE arbol_categorias AS (
    -- Caso base: categorías raíz (sin padre)
    SELECT 
        id,
        nombre,
        categoria_padre_id,
        nivel,
        nombre AS ruta_completa,
        ARRAY[id] AS ruta_ids,
        nivel AS profundidad
    FROM categorias
    WHERE categoria_padre_id IS NULL
    
    UNION ALL
    
    -- Caso recursivo: categorías hijas
    SELECT 
        c.id,
        c.nombre,
        c.categoria_padre_id,
        c.nivel,
        ac.ruta_completa || ' > ' || c.nombre,
        ac.ruta_ids || c.id,
        ac.profundidad + 1
    FROM categorias c
    INNER JOIN arbol_categorias ac ON c.categoria_padre_id = ac.id
)
SELECT 
    profundidad,
    REPEAT('  ', profundidad) || nombre AS nombre_indentado,
    ruta_completa,
    ruta_ids
FROM arbol_categorias
ORDER BY ruta_ids;

-- 5. CTE RECURSIVA PARA RUTAS EN GRAFOS

-- Crear tabla temporal para conexiones entre ciudades
CREATE TEMP TABLE conexiones_ciudades AS (
    SELECT 'Madrid' AS origen, 'Barcelona' AS destino, 500 AS distancia
    UNION ALL SELECT 'Madrid', 'Valencia', 300
    UNION ALL SELECT 'Barcelona', 'Valencia', 300
    UNION ALL SELECT 'Valencia', 'Sevilla', 400
    UNION ALL SELECT 'Sevilla', 'Málaga', 200
    UNION ALL SELECT 'Barcelona', 'Zaragoza', 300
    UNION ALL SELECT 'Zaragoza', 'Madrid', 300
);

-- CTE recursiva para encontrar todas las rutas posibles
WITH RECURSIVE rutas_ciudades AS (
    -- Caso base: rutas directas
    SELECT 
        origen,
        destino,
        distancia,
        1 AS num_paradas,
        ARRAY[origen, destino] AS ruta,
        origen || ' -> ' || destino AS ruta_texto
    FROM conexiones_ciudades
    
    UNION ALL
    
    -- Caso recursivo: rutas con paradas intermedias
    SELECT 
        rc.origen,
        cc.destino,
        rc.distancia + cc.distancia,
        rc.num_paradas + 1,
        rc.ruta || cc.destino,
        rc.ruta_texto || ' -> ' || cc.destino
    FROM rutas_ciudades rc
    INNER JOIN conexiones_ciudades cc ON rc.destino = cc.origen
    WHERE 
        cc.destino != ALL(rc.ruta) -- Evitar ciclos
        AND rc.num_paradas < 4     -- Limitar profundidad
)
SELECT 
    origen,
    destino,
    distancia,
    num_paradas,
    ruta_texto
FROM rutas_ciudades
ORDER BY num_paradas, distancia;

-- 6. CTE RECURSIVA PARA FACTORIAL Y SECUENCIAS MATEMÁTICAS

-- Calcular factorial de números del 1 al 10
WITH RECURSIVE factorial AS (
    -- Caso base: factorial de 1
    SELECT 1 AS numero, 1 AS factorial
    
    UNION ALL
    
    -- Caso recursivo: siguiente factorial
    SELECT 
        numero + 1,
        factorial * (numero + 1)
    FROM factorial
    WHERE numero < 10
)
SELECT 
    numero,
    factorial,
    TO_CHAR(factorial, '999,999,999,999') AS factorial_formateado
FROM factorial
ORDER BY numero;

-- Secuencia de Fibonacci
WITH RECURSIVE fibonacci AS (
    -- Caso base: primeros dos números
    SELECT 1 AS posicion, 1 AS numero_fibonacci, 1 AS numero_anterior
    
    UNION ALL
    
    -- Caso recursivo: siguiente número de Fibonacci
    SELECT 
        posicion + 1,
        numero_fibonacci + numero_anterior,
        numero_fibonacci
    FROM fibonacci
    WHERE posicion < 20
)
SELECT 
    posicion,
    numero_fibonacci,
    ROUND(numero_fibonacci * 1.0 / LAG(numero_fibonacci) OVER (ORDER BY posicion), 6) AS ratio_oro
FROM fibonacci
ORDER BY posicion;

-- 7. CTE RECURSIVA PARA LIMPIEZA DE DATOS

-- Crear tabla temporal con datos anidados
CREATE TEMP TABLE datos_anidados AS (
    SELECT 1 AS id, 'Juan' AS nombre, '{"padre": "Carlos", "madre": "Ana"}' AS familia
    UNION ALL SELECT 2, 'María', '{"padre": "Pedro", "madre": "Carmen"}'
    UNION ALL SELECT 3, 'Luis', '{"padre": "Miguel", "madre": "Isabel"}'
);

-- CTE recursiva para extraer información de JSON anidado
WITH RECURSIVE extraccion_json AS (
    -- Caso base: extraer padre
    SELECT 
        id,
        nombre,
        familia,
        JSON_EXTRACT_PATH_TEXT(familia, 'padre') AS miembro_familia,
        'padre' AS tipo_miembro,
        1 AS nivel
    FROM datos_anidados
    
    UNION ALL
    
    -- Caso recursivo: extraer madre
    SELECT 
        id,
        nombre,
        familia,
        JSON_EXTRACT_PATH_TEXT(familia, 'madre') AS miembro_familia,
        'madre' AS tipo_miembro,
        2 AS nivel
    FROM datos_anidados
    
    UNION ALL
    
    -- Caso recursivo: extraer otros miembros si existieran
    SELECT 
        ej.id,
        ej.nombre,
        ej.familia,
        JSON_EXTRACT_PATH_TEXT(ej.familia, 'hijo') AS miembro_familia,
        'hijo' AS tipo_miembro,
        ej.nivel + 1
    FROM extraccion_json ej
    WHERE ej.nivel = 2 AND JSON_EXTRACT_PATH_TEXT(ej.familia, 'hijo') IS NOT NULL
)
SELECT 
    id,
    nombre,
    tipo_miembro,
    miembro_familia,
    nivel
FROM extraccion_json
ORDER BY id, nivel;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- Las CTEs recursivas en MS SQL Server son muy similares
-- Solo cambian algunas funciones específicas

-- Ejemplo básico:
WITH RECURSIVE serie_numeros AS (
    -- Caso base
    SELECT 1 AS numero
    
    UNION ALL
    
    -- Caso recursivo
    SELECT numero + 1
    FROM serie_numeros
    WHERE numero < 10
)
SELECT numero FROM serie_numeros
ORDER BY numero;

-- Para fechas en MS SQL Server:
WITH RECURSIVE fechas_semana AS (
    -- Caso base
    SELECT CAST(GETDATE() AS DATE) AS fecha
    
    UNION ALL
    
    -- Caso recursivo
    SELECT DATEADD(DAY, 1, fecha)
    FROM fechas_semana
    WHERE fecha < DATEADD(DAY, 6, CAST(GETDATE() AS DATE))
)
SELECT 
    fecha,
    DATEPART(WEEKDAY, fecha) AS dia_semana,
    DATENAME(WEEKDAY, fecha) AS nombre_dia
FROM fechas_semana
ORDER BY fecha;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Sintaxis: Idéntica para CTEs recursivas
-- 2. Fechas:
--    - PostgreSQL: CURRENT_DATE, INTERVAL, DATE_TRUNC
--    - MS SQL Server: GETDATE(), DATEADD, DATEPART
-- 3. JSON:
--    - PostgreSQL: JSON_EXTRACT_PATH_TEXT
--    - MS SQL Server: JSON_VALUE
-- 4. Arrays:
--    - PostgreSQL: ARRAY[], || (concatenación)
--    - MS SQL Server: No soporte nativo de arrays
-- 5. Funciones de ventana: Idénticas en ambos sistemas

-- =====================================================
-- MEJORES PRÁCTICAS PARA CTEs RECURSIVAS:
-- =====================================================
-- 1. Siempre incluye una condición de parada clara
-- 2. Evita recursiones infinitas con límites de profundidad
-- 3. Usa CTEs recursivas para:
--    - Jerarquías organizacionales
--    - Árboles de categorías
--    - Rutas en grafos
--    - Secuencias matemáticas
--    - Fechas y series temporales
-- 4. Considera el rendimiento: las CTEs recursivas pueden ser costosas
-- 5. Usa índices apropiados en las columnas de unión
-- 6. Limita la profundidad máxima cuando sea posible
-- 7. Las CTEs recursivas son útiles para ETL y transformaciones jerárquicas
-- 8. Prueba con conjuntos de datos pequeños antes de escalar
