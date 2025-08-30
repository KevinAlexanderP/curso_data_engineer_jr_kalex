-- =====================================================
-- Script: Ejercicios Prácticos - Módulo 2
-- Módulo 2: Consultas Básicas SELECT
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- EJERCICIOS PARA PRACTICAR
-- =====================================================

-- Ejercicio 1: Consulta Básica
-- Obtener el nombre completo (nombre + apellido) y salario de todos los empleados
-- Ordenar por salario de mayor a menor

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre || ' ' || apellido AS nombre_completo,
    salario
FROM empleados 
ORDER BY salario DESC;

-- Ejercicio 2: Filtrado con WHERE
-- Obtener empleados del departamento de Desarrollo de Software (ID = 1)
-- que tengan un salario mayor a 60,000
-- Mostrar solo nombre, apellido, salario y departamento_id

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    salario, 
    departamento_id
FROM empleados 
WHERE departamento_id = 1 AND salario > 60000;

-- Ejercicio 3: Filtrado con IN y BETWEEN
-- Obtener empleados que trabajen en Marketing (ID = 3) o Finanzas (ID = 4)
-- y que tengan un salario entre 50,000 y 70,000
-- Ordenar por salario ascendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    salario, 
    departamento_id
FROM empleados 
WHERE departamento_id IN (3, 4) 
  AND salario BETWEEN 50000 AND 70000
ORDER BY salario ASC;

-- Ejercicio 4: Filtrado con LIKE
-- Obtener empleados cuyo nombre empiece con 'A' o 'L'
-- y cuyo apellido termine con 'z'
-- Mostrar nombre, apellido y email

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    email
FROM empleados 
WHERE (nombre LIKE 'A%' OR nombre LIKE 'L%')
  AND apellido LIKE '%z';

-- Ejercicio 5: Filtrado con fechas
-- Obtener empleados contratados en 2024
-- que tengan más de 30 años (nacidos antes de 1994)
-- Ordenar por fecha de contratación descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    fecha_contratacion, 
    fecha_nacimiento
FROM empleados 
WHERE fecha_contratacion >= '2024-01-01' 
  AND fecha_contratacion < '2025-01-01'
  AND fecha_nacimiento < '1994-01-01'
ORDER BY fecha_contratacion DESC;

-- Ejercicio 6: Limitación de resultados
-- Obtener los 3 empleados con mayor salario
-- que NO estén en el departamento de Recursos Humanos (ID = 2)
-- Mostrar nombre, apellido, salario y departamento_id

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    salario, 
    departamento_id
FROM empleados 
WHERE departamento_id != 2
ORDER BY salario DESC 
LIMIT 3;

-- Ejercicio 7: Ordenamiento complejo
-- Obtener empleados ordenados primero por departamento (ascendente)
-- y luego por salario (descendente) dentro de cada departamento
-- Mostrar nombre, apellido, departamento_id y salario

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    departamento_id, 
    salario
FROM empleados 
ORDER BY departamento_id ASC, salario DESC;

-- Ejercicio 8: Filtrado con valores NULL
-- Obtener empleados que NO tengan teléfono registrado
-- y que estén activos
-- Ordenar por nombre ascendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    telefono, 
    activo
FROM empleados 
WHERE telefono IS NULL 
  AND activo = TRUE
ORDER BY nombre ASC;

-- Ejercicio 9: Paginación
-- Obtener empleados de la segunda página (filas 6-10)
-- ordenados por apellido ascendente
-- Mostrar nombre, apellido y salario

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    salario
FROM empleados 
ORDER BY apellido ASC 
LIMIT 5 OFFSET 5;

-- Ejercicio 10: Consulta combinada
-- Obtener empleados que cumplan TODAS estas condiciones:
-- 1. Salario mayor a 55,000
-- 2. Departamento 1, 3 o 5
-- 3. Nombre de 4 o más caracteres
-- 4. Activos
-- Ordenar por salario descendente
-- Limitar a 5 resultados

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    salario, 
    departamento_id
FROM empleados 
WHERE salario > 55000
  AND departamento_id IN (1, 3, 5)
  AND LENGTH(nombre) >= 4
  AND activo = TRUE
ORDER BY salario DESC 
LIMIT 5;

-- =====================================================
-- EJERCICIOS AVANZADOS (OPCIONALES)
-- =====================================================

-- Ejercicio Avanzado 1: Ordenamiento personalizado
-- Obtener empleados ordenados por prioridad de departamento:
-- 1. Desarrollo de Software (ID = 1) - prioridad alta
-- 2. Marketing (ID = 3) - prioridad media
-- 3. Finanzas (ID = 4) - prioridad media
-- 4. Operaciones (ID = 5) - prioridad baja
-- 5. Recursos Humanos (ID = 2) - prioridad baja
-- Dentro de cada prioridad, ordenar por salario descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    departamento_id, 
    salario
FROM empleados 
ORDER BY 
    CASE departamento_id
        WHEN 1 THEN 1  -- Desarrollo (prioridad alta)
        WHEN 3 THEN 2  -- Marketing (prioridad media)
        WHEN 4 THEN 2  -- Finanzas (prioridad media)
        WHEN 5 THEN 3  -- Operaciones (prioridad baja)
        WHEN 2 THEN 3  -- RRHH (prioridad baja)
    END,
    salario DESC;

-- Ejercicio Avanzado 2: Filtrado con expresiones
-- Obtener empleados cuyo salario anual (salario * 12) esté entre 600,000 y 900,000
-- y que tengan más de 25 años (nacidos antes de 1999)
-- Mostrar nombre, apellido, salario, salario anual y edad aproximada
-- Ordenar por salario anual descendente

-- Tu código aquí:
-- SELECT ...

-- Solución:
SELECT 
    nombre, 
    apellido, 
    salario, 
    salario * 12 AS salario_anual,
    2024 - EXTRACT(YEAR FROM fecha_nacimiento) AS edad_aproximada
FROM empleados 
WHERE salario * 12 BETWEEN 600000 AND 900000
  AND fecha_nacimiento < '1999-01-01'
ORDER BY salario_anual DESC;

-- =====================================================
-- NOTAS PARA MS SQL SERVER:
-- =====================================================
-- 1. Cambia || por + para concatenación de strings
-- 2. Cambia LENGTH() por LEN()
-- 3. Cambia LIMIT por TOP
-- 4. Cambia TRUE por 1 para valores booleanos
-- 5. Cambia EXTRACT(YEAR FROM fecha) por YEAR(fecha)
-- 6. Usa GO para separar lotes de comandos

-- =====================================================
-- SOLUCIONES ESPECÍFICAS PARA MS SQL SERVER:
-- =====================================================

/*
-- Ejercicio 1 (MS SQL Server):
SELECT 
    nombre + ' ' + apellido AS nombre_completo,
    salario
FROM empleados 
ORDER BY salario DESC;

-- Ejercicio 10 (MS SQL Server):
SELECT TOP 5
    nombre, 
    apellido, 
    salario, 
    departamento_id
FROM empleados 
WHERE salario > 55000
  AND departamento_id IN (1, 3, 5)
  AND LEN(nombre) >= 4
  AND activo = 1
ORDER BY salario DESC;

-- Ejercicio Avanzado 2 (MS SQL Server):
SELECT TOP 10
    nombre, 
    apellido, 
    salario, 
    salario * 12 AS salario_anual,
    2024 - YEAR(fecha_nacimiento) AS edad_aproximada
FROM empleados 
WHERE salario * 12 BETWEEN 600000 AND 900000
  AND fecha_nacimiento < '1999-01-01'
ORDER BY salario_anual DESC;
GO
*/
