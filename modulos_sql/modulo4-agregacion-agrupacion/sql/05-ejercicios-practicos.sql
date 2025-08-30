-- =====================================================
-- Script: Ejercicios Prácticos - Módulo 4
-- Módulo 4: Agregación y Agrupación
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- EJERCICIOS PARA PRACTICAR
-- =====================================================

-- Ejercicio 1: Funciones Agregadas Básicas
-- Calcular estadísticas completas de la empresa:
-- 1. Total de empleados
-- 2. Salario promedio
-- 3. Salario mínimo y máximo
-- 4. Total de salarios
-- 5. Desviación estándar

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    COUNT(*) AS total_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    SUM(salario) AS total_salarios,
    ROUND(STDDEV(salario), 2) AS desviacion_estandar
FROM empleados;

-- Ejercicio 2: Agrupación por Departamento
-- Mostrar para cada departamento:
-- 1. Número de empleados
-- 2. Salario promedio
-- 3. Salario mínimo y máximo
-- 4. Total de salarios
-- Solo incluir departamentos con más de 1 empleado

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    SUM(salario) AS total_salarios
FROM empleados 
GROUP BY departamento_id
HAVING COUNT(*) > 1
ORDER BY departamento_id;

-- Ejercicio 3: Análisis por Año de Contratación
-- Agrupar empleados por año de contratación y mostrar:
-- 1. Año de contratación
-- 2. Número de empleados contratados
-- 3. Salario promedio del año
-- 4. Salario total del año
-- Solo años con más de 1 empleado

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    EXTRACT(YEAR FROM fecha_contratacion) AS año_contratacion,
    COUNT(*) AS empleados_contratados,
    ROUND(AVG(salario), 2) AS salario_promedio_año,
    SUM(salario) AS salario_total_año
FROM empleados 
GROUP BY EXTRACT(YEAR FROM fecha_contratacion)
HAVING COUNT(*) > 1
ORDER BY año_contratacion;

-- Ejercicio 4: Análisis de Salarios por Rango
-- Crear rangos de salario y agrupar empleados:
-- 1. Rango: < 60k, 60k-75k, > 75k
-- 2. Número de empleados en cada rango
-- 3. Salario promedio del rango
-- 4. Porcentaje del total de empleados

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    CASE 
        WHEN salario < 60000 THEN 'Bajo (< 60k)'
        WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
        ELSE 'Alto (> 75k)'
    END AS rango_salario,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_rango,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM empleados)), 2) AS porcentaje_total
FROM empleados 
GROUP BY 
    CASE 
        WHEN salario < 60000 THEN 'Bajo (< 60k)'
        WHEN salario BETWEEN 60000 AND 75000 THEN 'Medio (60k-75k)'
        ELSE 'Alto (> 75k)'
    END
ORDER BY 
    CASE 
        WHEN 'Bajo (< 60k)' THEN 1
        WHEN 'Medio (60k-75k)' THEN 2
        ELSE 3
    END;

-- Ejercicio 5: Análisis de Empleados Activos vs Inactivos
-- Comparar empleados activos e inactivos por departamento:
-- 1. Departamento
-- 2. Total de empleados
-- 3. Empleados activos
-- 4. Empleados inactivos
-- 5. Porcentaje de empleados activos

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    departamento_id,
    COUNT(*) AS total_empleados,
    COUNT(CASE WHEN activo = TRUE THEN 1 END) AS empleados_activos,
    COUNT(CASE WHEN activo = FALSE THEN 1 END) AS empleados_inactivos,
    ROUND((COUNT(CASE WHEN activo = TRUE THEN 1 END) * 100.0 / COUNT(*)), 2) AS porcentaje_activos
FROM empleados 
GROUP BY departamento_id
ORDER BY departamento_id;

-- Ejercicio 6: Análisis de Empleados con Teléfono
-- Analizar empleados que tienen teléfono registrado:
-- 1. Departamento
-- 2. Total de empleados
-- 3. Empleados con teléfono
-- 4. Empleados sin teléfono
-- Solo departamentos con al menos 2 empleados

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    departamento_id,
    COUNT(*) AS total_empleados,
    COUNT(CASE WHEN telefono IS NOT NULL THEN 1 END) AS con_telefono,
    COUNT(CASE WHEN telefono IS NULL THEN 1 END) AS sin_telefono,
    ROUND((COUNT(CASE WHEN telefono IS NOT NULL THEN 1 END) * 100.0 / COUNT(*)), 2) AS porcentaje_con_telefono
FROM empleados 
GROUP BY departamento_id
HAVING COUNT(*) >= 2
ORDER BY departamento_id;

-- Ejercicio 7: Análisis de Salarios por Estación de Contratación
-- Agrupar por estación del año en que fueron contratados:
-- 1. Estación del año
-- 2. Número de empleados
-- 3. Salario promedio
-- 4. Salario total

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (12, 1, 2) THEN 'Invierno'
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (3, 4, 5) THEN 'Primavera'
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (6, 7, 8) THEN 'Verano'
        ELSE 'Otoño'
    END AS estacion_contratacion,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_estacion,
    SUM(salario) AS salario_total_estacion
FROM empleados 
GROUP BY 
    CASE 
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (12, 1, 2) THEN 'Invierno'
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (3, 4, 5) THEN 'Primavera'
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (6, 7, 8) THEN 'Verano'
        ELSE 'Otoño'
    END
ORDER BY 
    CASE 
        WHEN 'Invierno' THEN 1
        WHEN 'Primavera' THEN 2
        WHEN 'Verano' THEN 3
        ELSE 4
    END;

-- Ejercicio 8: Análisis de Empleados por Longitud de Nombre
-- Agrupar empleados por la longitud de su nombre:
-- 1. Longitud del nombre
-- 2. Número de empleados
-- 3. Salario promedio
-- 4. Ejemplos de nombres

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    LENGTH(nombre) AS longitud_nombre,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_longitud,
    STRING_AGG(nombre, ', ') AS nombres_ejemplo
FROM empleados 
GROUP BY LENGTH(nombre)
HAVING COUNT(*) >= 1
ORDER BY longitud_nombre;

-- Ejercicio 9: Análisis de Departamentos con JOIN
-- Usar JOIN para mostrar información completa de departamentos:
-- 1. Nombre del departamento
-- 2. Número de empleados
-- 3. Salario promedio
-- 4. Presupuesto del departamento
-- Solo departamentos con empleados

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    d.nombre AS nombre_departamento,
    d.ubicacion,
    d.presupuesto,
    COUNT(e.id) AS numero_empleados,
    ROUND(AVG(e.salario), 2) AS salario_promedio_departamento,
    SUM(e.salario) AS total_salarios_departamento
FROM departamentos d
JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre, d.ubicacion, d.presupuesto
ORDER BY numero_empleados DESC;

-- Ejercicio 10: Análisis Complejo con Múltiples Condiciones
-- Crear un análisis completo que incluya:
-- 1. Departamento
-- 2. Solo empleados activos contratados desde 2020
-- 3. Estadísticas por departamento
-- 4. Solo departamentos con salario promedio > 60k y al menos 2 empleados

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    departamento_id,
    COUNT(*) AS total_empleados_calificados,
    COUNT(CASE WHEN telefono IS NOT NULL THEN 1 END) AS con_telefono,
    ROUND(AVG(salario), 2) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    ROUND(STDDEV(salario), 2) AS desviacion_estandar
FROM empleados 
WHERE 
    activo = TRUE AND
    fecha_contratacion >= '2020-01-01'
GROUP BY departamento_id
HAVING 
    AVG(salario) > 60000 AND
    COUNT(*) >= 2
ORDER BY salario_promedio DESC;

-- =====================================================
-- EJERCICIOS AVANZADOS (OPCIONALES)
-- =====================================================

-- Ejercicio Avanzado 1: Análisis de Percentiles por Departamento
-- Calcular percentiles de salario por departamento:
-- 1. Departamento
-- 2. Número de empleados
-- 3. Percentil 25, 50 (mediana), 75
-- 4. Rango intercuartil (P75 - P25)

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salario) AS percentil_25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salario) AS mediana,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) AS percentil_75,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) - 
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salario) AS rango_intercuartil
FROM empleados 
GROUP BY departamento_id
HAVING COUNT(*) >= 2
ORDER BY departamento_id;

-- Ejercicio Avanzado 2: Análisis de Crecimiento de Salarios
-- Analizar el crecimiento de salarios por año de contratación:
-- 1. Año de contratación
-- 2. Número de empleados
-- 3. Salario promedio del año
-- 4. Diferencia con el año anterior (si aplica)

-- Tu código aquí:
-- SELECT ...

-- Solución:
WITH salarios_por_año AS (
    SELECT 
        EXTRACT(YEAR FROM fecha_contratacion) AS año_contratacion,
        COUNT(*) AS numero_empleados,
        ROUND(AVG(salario), 2) AS salario_promedio_año
    FROM empleados 
    GROUP BY EXTRACT(YEAR FROM fecha_contratacion)
)
SELECT 
    año_contratacion,
    numero_empleados,
    salario_promedio_año,
    LAG(salario_promedio_año) OVER (ORDER BY año_contratacion) AS salario_año_anterior,
    salario_promedio_año - LAG(salario_promedio_año) OVER (ORDER BY año_contratacion) AS diferencia_año_anterior,
    CASE 
        WHEN LAG(salario_promedio_año) OVER (ORDER BY año_contratacion) IS NOT NULL THEN
            ROUND(((salario_promedio_año - LAG(salario_promedio_año) OVER (ORDER BY año_contratacion)) / 
                   LAG(salario_promedio_año) OVER (ORDER BY año_contratacion)) * 100, 2)
        ELSE NULL
    END AS porcentaje_cambio
FROM salarios_por_año
ORDER BY año_contratacion;

-- =====================================================
-- NOTAS PARA MS SQL SERVER:
-- =====================================================
-- 1. Cambia STDDEV() por STDEV()
-- 2. Cambia EXTRACT(YEAR FROM fecha) por YEAR(fecha)
-- 3. Cambia EXTRACT(MONTH FROM fecha) por MONTH(fecha)
-- 4. Cambia TRUE por 1 para valores booleanos
-- 5. Cambia STRING_AGG() por STRING_AGG() (SQL Server 2017+)
-- 6. Cambia PERCENTILE_CONT() WITHIN GROUP por PERCENTILE_CONT() WITHIN GROUP OVER()
-- 7. Usa GO para separar lotes de comandos

-- =====================================================
-- SOLUCIONES ESPECÍFICAS PARA MS SQL SERVER:
-- =====================================================

/*
-- Ejercicio 1 (MS SQL Server):
SELECT 
    COUNT(*) AS total_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    SUM(salario) AS total_salarios,
    ROUND(STDEV(salario), 2) AS desviacion_estandar
FROM empleados;

-- Ejercicio 3 (MS SQL Server):
SELECT 
    YEAR(fecha_contratacion) AS año_contratacion,
    COUNT(*) AS empleados_contratados,
    ROUND(AVG(salario), 2) AS salario_promedio_año,
    SUM(salario) AS salario_total_año
FROM empleados 
GROUP BY YEAR(fecha_contratacion)
HAVING COUNT(*) > 1
ORDER BY año_contratacion;

-- Ejercicio 5 (MS SQL Server):
SELECT 
    departamento_id,
    COUNT(*) AS total_empleados,
    COUNT(CASE WHEN activo = 1 THEN 1 END) AS empleados_activos,
    COUNT(CASE WHEN activo = 0 THEN 1 END) AS empleados_inactivos,
    ROUND((COUNT(CASE WHEN activo = 1 THEN 1 END) * 100.0 / COUNT(*)), 2) AS porcentaje_activos
FROM empleados 
GROUP BY departamento_id
ORDER BY departamento_id;

-- Ejercicio 7 (MS SQL Server):
SELECT 
    CASE 
        WHEN MONTH(fecha_contratacion) IN (12, 1, 2) THEN 'Invierno'
        WHEN MONTH(fecha_contratacion) IN (3, 4, 5) THEN 'Primavera'
        WHEN MONTH(fecha_contratacion) IN (6, 7, 8) THEN 'Verano'
        ELSE 'Otoño'
    END AS estacion_contratacion,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_estacion,
    SUM(salario) AS salario_total_estacion
FROM empleados 
GROUP BY 
    CASE 
        WHEN MONTH(fecha_contratacion) IN (12, 1, 2) THEN 'Invierno'
        WHEN MONTH(fecha_contratacion) IN (3, 4, 5) THEN 'Primavera'
        WHEN MONTH(fecha_contratacion) IN (6, 7, 8) THEN 'Verano'
        ELSE 'Otoño'
    END;

-- Ejercicio 8 (MS SQL Server):
SELECT 
    LEN(nombre) AS longitud_nombre,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio_longitud,
    STRING_AGG(nombre, ', ') AS nombres_ejemplo
FROM empleados 
GROUP BY LEN(nombre)
HAVING COUNT(*) >= 1
ORDER BY longitud_nombre;

-- Ejercicio Avanzado 1 (MS SQL Server):
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salario) OVER (PARTITION BY departamento_id) AS percentil_25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salario) OVER (PARTITION BY departamento_id) AS mediana,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salario) OVER (PARTITION BY departamento_id) AS percentil_75
FROM empleados 
GROUP BY departamento_id, salario
HAVING COUNT(*) >= 2;
GO
*/
