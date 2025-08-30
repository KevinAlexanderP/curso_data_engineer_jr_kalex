-- =====================================================
-- Script: Ejercicios Prácticos - Módulo 3
-- Módulo 3: Funciones y Operadores
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- EJERCICIOS PARA PRACTICAR
-- =====================================================

-- Ejercicio 1: Funciones de Texto
-- Crear un identificador único para cada empleado con el formato:
-- "EMP-[Primera letra del nombre][Primeras 3 letras del apellido]-[ID departamento]"
-- Ejemplo: "EMP-AGAR-1" para Ana García del departamento 1

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre,
    apellido,
    departamento_id,
    'EMP-' || LEFT(nombre, 1) || LEFT(apellido, 3) || '-' || departamento_id AS id_empleado
FROM empleados;

-- Ejercicio 2: Funciones Numéricas
-- Calcular el salario anual, bonificación (15% del salario) y salario total
-- para empleados del departamento de Desarrollo (ID = 1)
-- Ordenar por salario total descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre,
    apellido,
    salario,
    salario * 12 AS salario_anual,
    salario * 0.15 AS bonificacion,
    salario * 12 + (salario * 0.15) AS salario_total
FROM empleados 
WHERE departamento_id = 1
ORDER BY salario_total DESC;

-- Ejercicio 3: Funciones de Fecha
-- Calcular la edad actual de cada empleado y cuántos años lleva en la empresa
-- Mostrar también en qué estación del año fue contratado

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre,
    apellido,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_nacimiento) AS edad_actual,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) AS años_en_empresa,
    CASE 
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (12, 1, 2) THEN 'Invierno'
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (3, 4, 5) THEN 'Primavera'
        WHEN EXTRACT(MONTH FROM fecha_contratacion) IN (6, 7, 8) THEN 'Verano'
        ELSE 'Otoño'
    END AS estacion_contratacion
FROM empleados;

-- Ejercicio 4: Operadores y Expresiones
-- Clasificar empleados por nivel de experiencia basado en:
-- - Antigüedad: < 2 años = Junior, 2-5 años = Intermedio, > 5 años = Senior
-- - Salario: < 60k = Bajo, 60k-75k = Medio, > 75k = Alto
-- Combinar ambas clasificaciones

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre,
    apellido,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) AS años_antiguedad,
    CASE 
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) < 2 THEN 'Junior'
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) <= 5 THEN 'Intermedio'
        ELSE 'Senior'
    END AS nivel_antiguedad,
    CASE 
        WHEN salario < 60000 THEN 'Bajo'
        WHEN salario <= 75000 THEN 'Medio'
        ELSE 'Alto'
    END AS nivel_salario,
    CASE 
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) < 2 AND salario < 60000 THEN 'Junior Bajo'
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM CURRENT_DATE) < 2 AND salario <= 75000 THEN 'Junior Medio'
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) < 2 AND salario > 75000 THEN 'Junior Alto'
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) <= 5 AND salario < 60000 THEN 'Intermedio Bajo'
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) <= 5 AND salario <= 75000 THEN 'Intermedio Medio'
        WHEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) <= 5 AND salario > 75000 THEN 'Intermedio Alto'
        WHEN salario < 60000 THEN 'Senior Bajo'
        WHEN salario <= 75000 THEN 'Senior Medio'
        ELSE 'Senior Alto'
    END AS clasificacion_completa
FROM empleados;

-- Ejercicio 5: Funciones Combinadas
-- Crear un reporte de empleados que incluya:
-- 1. Nombre completo en formato "Apellido, Nombre"
-- 2. Email formateado (solo el nombre de usuario, sin dominio)
-- 3. Salario formateado con separadores de miles
-- 4. Categoría de empleado basada en departamento y salario

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    apellido || ', ' || nombre AS nombre_completo,
    SUBSTRING(email FROM 1 FOR POSITION('@' IN email) - 1) AS usuario_email,
    TO_CHAR(salario, 'FM999,999.00') AS salario_formateado,
    CASE 
        WHEN departamento_id = 1 AND salario > 70000 THEN 'Desarrollador Senior'
        WHEN departamento_id = 1 AND salario <= 70000 THEN 'Desarrollador'
        WHEN departamento_id = 2 THEN 'Recursos Humanos'
        WHEN departamento_id = 3 AND salario > 65000 THEN 'Marketing Senior'
        WHEN departamento_id = 3 THEN 'Marketing'
        WHEN departamento_id = 4 THEN 'Finanzas'
        WHEN departamento_id = 5 THEN 'Operaciones'
        ELSE 'Otro'
    END AS categoria_empleado
FROM empleados;

-- Ejercicio 6: Análisis de Texto
-- Analizar los nombres de los empleados:
-- 1. Longitud del nombre
-- 2. Si empieza con vocal o consonante
-- 3. Si contiene la letra 'a' (insensible a mayúsculas)
-- 4. Crear un código de seguridad basado en el nombre

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre,
    LENGTH(nombre) AS longitud_nombre,
    CASE 
        WHEN UPPER(LEFT(nombre, 1)) IN ('A', 'E', 'I', 'O', 'U') THEN 'Vocal'
        ELSE 'Consonante'
    END AS tipo_inicial,
    CASE 
        WHEN nombre ILIKE '%a%' THEN 'Sí contiene A'
        ELSE 'No contiene A'
    END AS contiene_a,
    UPPER(LEFT(nombre, 2) || RIGHT(nombre, 1) || LENGTH(nombre)) AS codigo_seguridad
FROM empleados;

-- Ejercicio 7: Cálculos Matemáticos Avanzados
-- Calcular para cada empleado:
-- 1. Salario por hora (asumiendo 40 horas por semana)
-- 2. Salario por día (asumiendo 5 días por semana)
-- 3. Porcentaje del salario respecto al salario máximo de la empresa
-- 4. Salario ajustado por inflación (asumiendo 3% anual)

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre,
    apellido,
    salario,
    ROUND(salario / (40 * 52), 2) AS salario_por_hora,
    ROUND(salario / (5 * 52), 2) AS salario_por_dia,
    ROUND((salario / (SELECT MAX(salario) FROM empleados)) * 100, 2) AS porcentaje_salario_maximo,
    ROUND(salario * POWER(1.03, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion)), 2) AS salario_ajustado_inflacion
FROM empleados;

-- Ejercicio 8: Manipulación de Fechas
-- Crear un calendario de revisión de empleados:
-- 1. Próxima revisión (6 meses después de la contratación)
-- 2. Si ya pasó la fecha de revisión, mostrar cuántos días de retraso
-- 3. Categorizar por urgencia de revisión

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre,
    apellido,
    fecha_contratacion,
    fecha_contratacion + INTERVAL '6 months' AS proxima_revision,
    CASE 
        WHEN fecha_contratacion + INTERVAL '6 months' < CURRENT_DATE THEN 
            CURRENT_DATE - (fecha_contratacion + INTERVAL '6 months')
        ELSE 0
    END AS dias_retraso,
    CASE 
        WHEN fecha_contratacion + INTERVAL '6 months' < CURRENT_DATE - INTERVAL '30 days' THEN 'Urgente'
        WHEN fecha_contratacion + INTERVAL '6 months' < CURRENT_DATE THEN 'Atrasado'
        WHEN fecha_contratacion + INTERVAL '6 months' <= CURRENT_DATE + INTERVAL '30 days' THEN 'Próximo'
        ELSE 'En tiempo'
    END AS estado_revision
FROM empleados;

-- Ejercicio 9: Expresiones Condicionales Complejas
-- Crear un sistema de puntuación para empleados basado en:
-- - Antigüedad: 1 punto por año
-- - Salario: 1 punto por cada 10k sobre 50k
-- - Departamento: Desarrollo (3 pts), Marketing (2 pts), Otros (1 pt)
-- - Estado: Activo (2 pts), Inactivo (0 pts)

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre,
    apellido,
    departamento_id,
    activo,
    EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion) AS antiguedad,
    CASE 
        WHEN salario > 50000 THEN FLOOR((salario - 50000) / 10000)
        ELSE 0
    END AS puntos_salario,
    CASE 
        WHEN departamento_id = 1 THEN 3
        WHEN departamento_id = 3 THEN 2
        ELSE 1
    END AS puntos_departamento,
    CASE 
        WHEN activo = TRUE THEN 2
        ELSE 0
    END AS puntos_estado,
    (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM fecha_contratacion)) +
    CASE 
        WHEN salario > 50000 THEN FLOOR((salario - 50000) / 10000)
        ELSE 0
    END +
    CASE 
        WHEN departamento_id = 1 THEN 3
        WHEN departamento_id = 3 THEN 2
        ELSE 1
    END +
    CASE 
        WHEN activo = TRUE THEN 2
        ELSE 0
    END AS puntuacion_total
FROM empleados
ORDER BY puntuacion_total DESC;

-- Ejercicio 10: Funciones de Agregación (Preparación para Módulo 4)
-- Calcular estadísticas por departamento:
-- 1. Número de empleados
-- 2. Salario promedio
-- 3. Salario mínimo y máximo
-- 4. Total de salarios
-- 5. Desviación estándar del salario

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    departamento_id,
    COUNT(*) AS numero_empleados,
    ROUND(AVG(salario), 2) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo,
    SUM(salario) AS total_salarios,
    ROUND(STDDEV(salario), 2) AS desviacion_estandar
FROM empleados 
GROUP BY departamento_id
ORDER BY departamento_id;

-- =====================================================
-- EJERCICIOS AVANZADOS (OPCIONALES)
-- =====================================================

-- Ejercicio Avanzado 1: Generación de Datos
-- Crear una tabla temporal con datos generados:
-- 1. Números del 1 al 100
-- 2. Para cada número, generar un nombre aleatorio
-- 3. Calcular si es par o impar
-- 4. Calcular si es primo o no

-- Tu código aquí:
-- WITH numeros AS (
--     SELECT generate_series(1, 100) AS numero
-- )
-- SELECT ...

-- Solución:
WITH numeros AS (
    SELECT generate_series(1, 100) AS numero
)
SELECT 
    numero,
    CASE 
        WHEN numero % 2 = 0 THEN 'Par'
        ELSE 'Impar'
    END AS paridad,
    CASE 
        WHEN numero IN (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97) THEN 'Primo'
        ELSE 'No primo'
    END AS primalidad
FROM numeros
ORDER BY numero;

-- Ejercicio Avanzado 2: Análisis de Patrones
-- Analizar patrones en los nombres de empleados:
-- 1. Frecuencia de letras iniciales
-- 2. Nombres más comunes (longitud)
-- 3. Patrones de vocales y consonantes

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    LEFT(nombre, 1) AS letra_inicial,
    COUNT(*) AS frecuencia,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM empleados)), 2) AS porcentaje
FROM empleados 
GROUP BY LEFT(nombre, 1)
ORDER BY frecuencia DESC;

-- =====================================================
-- NOTAS PARA MS SQL SERVER:
-- =====================================================
-- 1. Cambia || por + para concatenación
-- 2. Cambia LENGTH() por LEN()
-- 3. Cambia ILIKE por UPPER() + LIKE
-- 4. Cambia EXTRACT() por YEAR(), MONTH(), DAY()
-- 5. Cambia INTERVAL por DATEADD()
-- 6. Cambia generate_series() por una tabla de números
-- 7. Cambia STDDEV() por STDEV()
-- 8. Usa GO para separar lotes de comandos

-- =====================================================
-- SOLUCIONES ESPECÍFICAS PARA MS SQL SERVER:
-- =====================================================

/*
-- Ejercicio 1 (MS SQL Server):
SELECT 
    nombre,
    apellido,
    departamento_id,
    'EMP-' + LEFT(nombre, 1) + LEFT(apellido, 3) + '-' + CAST(departamento_id AS VARCHAR) AS id_empleado
FROM empleados;

-- Ejercicio 6 (MS SQL Server):
SELECT 
    nombre,
    LEN(nombre) AS longitud_nombre,
    CASE 
        WHEN UPPER(LEFT(nombre, 1)) IN ('A', 'E', 'I', 'O', 'U') THEN 'Vocal'
        ELSE 'Consonante'
    END AS tipo_inicial,
    CASE 
        WHEN UPPER(nombre) LIKE '%A%' THEN 'Sí contiene A'
        ELSE 'No contiene A'
    END AS contiene_a,
    UPPER(LEFT(nombre, 2) + RIGHT(nombre, 1) + CAST(LEN(nombre) AS VARCHAR)) AS codigo_seguridad
FROM empleados;

-- Ejercicio 8 (MS SQL Server):
SELECT 
    nombre,
    apellido,
    fecha_contratacion,
    DATEADD(MONTH, 6, fecha_contratacion) AS proxima_revision,
    CASE 
        WHEN DATEADD(MONTH, 6, fecha_contratacion) < GETDATE() THEN 
            DATEDIFF(DAY, DATEADD(MONTH, 6, fecha_contratacion), GETDATE())
        ELSE 0
    END AS dias_retraso,
    CASE 
        WHEN DATEADD(MONTH, 6, fecha_contratacion) < DATEADD(DAY, -30, GETDATE()) THEN 'Urgente'
        WHEN DATEADD(MONTH, 6, fecha_contratacion) < GETDATE() THEN 'Atrasado'
        WHEN DATEADD(MONTH, 6, fecha_contratacion) <= DATEADD(DAY, 30, GETDATE()) THEN 'Próximo'
        ELSE 'En tiempo'
    END AS estado_revision
FROM empleados;
GO
*/
