-- =====================================================
-- Script: Funciones de Fecha y Hora
-- Módulo 3: Funciones y Operadores
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. FUNCIONES DE FECHA ACTUAL
-- Sintaxis: CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP, NOW()

-- Obtener fecha y hora actual
SELECT 
    CURRENT_DATE AS fecha_actual,
    CURRENT_TIME AS hora_actual,
    CURRENT_TIMESTAMP AS timestamp_actual,
    NOW() AS ahora;

-- 2. EXTRACCIÓN DE COMPONENTES DE FECHA

-- EXTRACT() - extraer componentes específicos
SELECT 
    nombre,
    fecha_contratacion,
    EXTRACT(YEAR FROM fecha_contratacion) AS año_contratacion,
    EXTRACT(MONTH FROM fecha_contratacion) AS mes_contratacion,
    EXTRACT(DAY FROM fecha_contratacion) AS dia_contratacion,
    EXTRACT(DOW FROM fecha_contratacion) AS dia_semana,  -- 0=Domingo, 1=Lunes, etc.
    EXTRACT(DOY FROM fecha_contratacion) AS dia_año      -- Día del año (1-366)
FROM empleados;

-- 3. FUNCIONES DE FECHA ESPECÍFICAS

-- YEAR(), MONTH(), DAY() - extraer año, mes y día
SELECT 
    nombre,
    fecha_contratacion,
    DATE_PART('year', fecha_contratacion) AS año,
    DATE_PART('month', fecha_contratacion) AS mes,
    DATE_PART('day', fecha_contratacion) AS dia
FROM empleados;

-- 4. CÁLCULOS CON FECHAS

-- AGE() - calcular edad entre dos fechas
SELECT 
    nombre,
    fecha_nacimiento,
    fecha_contratacion,
    AGE(fecha_contratacion, fecha_nacimiento) AS edad_al_contratar,
    AGE(CURRENT_DATE, fecha_nacimiento) AS edad_actual
FROM empleados;

-- Operaciones aritméticas con fechas
SELECT 
    nombre,
    fecha_contratacion,
    fecha_contratacion + INTERVAL '1 year' AS un_año_despues,
    fecha_contratacion - INTERVAL '6 months' AS seis_meses_antes,
    fecha_contratacion + 30 AS treinta_dias_despues
FROM empleados;

-- 5. FUNCIONES DE FORMATO DE FECHA

-- TO_CHAR() - formatear fechas como texto
SELECT 
    nombre,
    fecha_contratacion,
    TO_CHAR(fecha_contratacion, 'DD/MM/YYYY') AS fecha_formato_español,
    TO_CHAR(fecha_contratacion, 'Month DD, YYYY') AS fecha_formato_ingles,
    TO_CHAR(fecha_contratacion, 'Day, DD Month YYYY') AS fecha_formato_completo
FROM empleados;

-- 6. FUNCIONES DE COMPARACIÓN DE FECHAS

-- Comparar fechas
SELECT 
    nombre,
    fecha_contratacion,
    CASE 
        WHEN fecha_contratacion < '2020-01-01' THEN 'Veterano'
        WHEN fecha_contratacion < '2023-01-01' THEN 'Intermedio'
        ELSE 'Nuevo'
    END AS categoria_empleado
FROM empleados;

-- 7. FUNCIONES DE MANIPULACIÓN DE FECHAS

-- DATE_TRUNC() - truncar fecha a una precisión específica
SELECT 
    fecha_contratacion,
    DATE_TRUNC('year', fecha_contratacion) AS inicio_año,
    DATE_TRUNC('month', fecha_contratacion) AS inicio_mes,
    DATE_TRUNC('week', fecha_contratacion) AS inicio_semana
FROM empleados;

-- 8. FUNCIONES DE DIFERENCIA ENTRE FECHAS

-- Calcular días entre fechas
SELECT 
    nombre,
    fecha_contratacion,
    CURRENT_DATE - fecha_contratacion AS dias_desde_contratacion,
    EXTRACT(DAYS FROM CURRENT_DATE - fecha_contratacion) AS dias_desde_contratacion_2
FROM empleados;

-- 9. FUNCIONES DE ZONA HORARIA

-- Trabajar con zonas horarias
SELECT 
    CURRENT_TIMESTAMP AS timestamp_local,
    CURRENT_TIMESTAMP AT TIME ZONE 'UTC' AS timestamp_utc,
    CURRENT_TIMESTAMP AT TIME ZONE 'America/New_York' AS timestamp_ny
FROM empleados
LIMIT 1;

-- 10. FUNCIONES COMBINADAS PARA ANÁLISIS DE FECHAS

-- Análisis completo de fechas de empleados
SELECT 
    nombre,
    fecha_nacimiento,
    fecha_contratacion,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_nacimiento) AS edad_aproximada,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) AS años_en_empresa,
    CASE 
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (12, 1, 2) THEN 'Invierno'
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (3, 4, 5) THEN 'Primavera'
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (6, 7, 8) THEN 'Verano'
        ELSE 'Otoño'
    END AS estacion_contratacion
FROM empleados;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. FUNCIONES DE FECHA ACTUAL
-- Sintaxis: GETDATE(), GETUTCDATE(), SYSDATETIME()

-- Obtener fecha y hora actual
SELECT 
    GETDATE() AS fecha_actual,
    GETUTCDATE() AS fecha_utc,
    SYSDATETIME() AS timestamp_actual;

-- 2. EXTRACCIÓN DE COMPONENTES DE FECHA

-- YEAR(), MONTH(), DAY() - extraer año, mes y día
SELECT 
    nombre,
    fecha_contratacion,
    YEAR(fecha_contratacion) AS año_contratacion,
    MONTH(fecha_contratacion) AS mes_contratacion,
    DAY(fecha_contratacion) AS dia_contratacion,
    DATEPART(WEEKDAY, fecha_contratacion) AS dia_semana,  -- 1=Domingo, 2=Lunes, etc.
    DATEPART(DAYOFYEAR, fecha_contratacion) AS dia_año    -- Día del año (1-366)
FROM empleados;

-- 3. FUNCIONES DE FECHA ESPECÍFICAS

-- DATEPART() - extraer componentes específicos
SELECT 
    nombre,
    fecha_contratacion,
    DATEPART(YEAR, fecha_contratacion) AS año,
    DATEPART(MONTH, fecha_contratacion) AS mes,
    DATEPART(DAY, fecha_contratacion) AS dia
FROM empleados;

-- 4. CÁLCULOS CON FECHAS

-- DATEDIFF() - calcular diferencia entre fechas
SELECT 
    nombre,
    fecha_nacimiento,
    fecha_contratacion,
    DATEDIFF(YEAR, fecha_nacimiento, fecha_contratacion) AS edad_al_contratar,
    DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) AS edad_actual
FROM empleados;

-- Operaciones aritméticas con fechas
SELECT 
    nombre,
    fecha_contratacion,
    DATEADD(YEAR, 1, fecha_contratacion) AS un_año_despues,
    DATEADD(MONTH, -6, fecha_contratacion) AS seis_meses_antes,
    DATEADD(DAY, 30, fecha_contratacion) AS treinta_dias_despues
FROM empleados;

-- 5. FUNCIONES DE FORMATO DE FECHA

-- FORMAT() - formatear fechas (SQL Server 2012+)
SELECT 
    nombre,
    fecha_contratacion,
    FORMAT(fecha_contratacion, 'dd/MM/yyyy') AS fecha_formato_español,
    FORMAT(fecha_contratacion, 'MMMM dd, yyyy') AS fecha_formato_ingles,
    FORMAT(fecha_contratacion, 'dddd, dd MMMM yyyy') AS fecha_formato_completo
FROM empleados;

-- 6. FUNCIONES DE COMPARACIÓN DE FECHAS

-- Comparar fechas
SELECT 
    nombre,
    fecha_contratacion,
    CASE 
        WHEN fecha_contratacion < '2020-01-01' THEN 'Veterano'
        WHEN fecha_contratacion < '2023-01-01' THEN 'Intermedio'
        ELSE 'Nuevo'
    END AS categoria_empleado
FROM empleados;

-- 7. FUNCIONES DE MANIPULACIÓN DE FECHAS

-- EOMONTH() - último día del mes (SQL Server 2012+)
SELECT 
    fecha_contratacion,
    EOMONTH(fecha_contratacion) AS ultimo_dia_mes,
    EOMONTH(fecha_contratacion, 1) AS ultimo_dia_siguiente_mes
FROM empleados;

-- 8. FUNCIONES DE DIFERENCIA ENTRE FECHAS

-- Calcular días entre fechas
SELECT 
    nombre,
    fecha_contratacion,
    DATEDIFF(DAY, fecha_contratacion, GETDATE()) AS dias_desde_contratacion
FROM empleados;

-- 9. FUNCIONES DE ZONA HORARIA

-- Trabajar con zonas horarias (SQL Server 2016+)
SELECT 
    GETDATE() AS timestamp_local,
    GETUTCDATE() AS timestamp_utc,
    SWITCHOFFSET(GETDATE(), '-05:00') AS timestamp_ny
FROM empleados;

-- 10. FUNCIONES COMBINADAS PARA ANÁLISIS DE FECHAS

-- Análisis completo de fechas de empleados
SELECT 
    nombre,
    fecha_nacimiento,
    fecha_contratacion,
    DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) AS edad_aproximada,
    DATEDIFF(YEAR, fecha_contratacion, GETDATE()) AS años_en_empresa,
    CASE 
        WHEN MONTH(fecha_contratacion) IN (12, 1, 2) THEN 'Invierno'
        WHEN MONTH(fecha_contratacion) IN (3, 4, 5) THEN 'Primavera'
        WHEN MONTH(fecha_contratacion) IN (6, 7, 8) THEN 'Verano'
        ELSE 'Otoño'
    END AS estacion_contratacion
FROM empleados;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Fecha actual:
--    - PostgreSQL: CURRENT_DATE, NOW()
--    - MS SQL Server: GETDATE(), SYSDATETIME()
-- 2. Extracción de componentes:
--    - PostgreSQL: EXTRACT() o DATE_PART()
--    - MS SQL Server: YEAR(), MONTH(), DAY() o DATEPART()
-- 3. Cálculos de diferencia:
--    - PostgreSQL: AGE() o operaciones aritméticas
--    - MS SQL Server: DATEDIFF()
-- 4. Operaciones aritméticas:
--    - PostgreSQL: + INTERVAL, - INTERVAL
--    - MS SQL Server: DATEADD()
-- 5. Formateo:
--    - PostgreSQL: TO_CHAR()
--    - MS SQL Server: FORMAT()
-- 6. Truncamiento:
--    - PostgreSQL: DATE_TRUNC()
--    - MS SQL Server: EOMONTH() para fin de mes
-- 7. Zonas horarias:
--    - PostgreSQL: AT TIME ZONE
--    - MS SQL Server: SWITCHOFFSET()

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Usa funciones nativas en lugar de conversiones manuales
-- 2. Ten en cuenta las zonas horarias en aplicaciones globales
-- 3. Las fechas se almacenan internamente como números, no como texto
-- 4. Usa índices en columnas de fecha para mejor rendimiento
-- 5. Considera el formato de fecha al importar/exportar datos
-- 6. Las funciones de fecha pueden ser lentas en tablas grandes
-- 7. Prueba las funciones en tu sistema específico antes de usar en producción
-- 8. Ten cuidado con años bisiestos en cálculos de edad
