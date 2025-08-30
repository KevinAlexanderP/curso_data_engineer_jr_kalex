-- =====================================================
-- Script: Sintaxis Básica de SELECT
-- Módulo 2: Consultas Básicas SELECT
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. SELECT básico - seleccionar todas las columnas
-- Sintaxis: SELECT * FROM nombre_tabla;
SELECT * FROM empleados;

-- 2. SELECT específico - seleccionar columnas específicas
-- Sintaxis: SELECT columna1, columna2 FROM nombre_tabla;
SELECT nombre, apellido, salario FROM empleados;

-- 3. SELECT con alias para columnas
-- Sintaxis: SELECT columna AS alias FROM nombre_tabla;
SELECT 
    nombre AS nombre_empleado,
    apellido AS apellido_empleado,
    salario AS salario_anual
FROM empleados;

-- 4. SELECT con alias para tabla
-- Sintaxis: SELECT alias.columna FROM nombre_tabla AS alias;
SELECT 
    e.nombre,
    e.apellido,
    e.salario
FROM empleados AS e;

-- 5. SELECT con alias abreviado (sin AS)
SELECT 
    e.nombre nombre_emp,
    e.apellido apellido_emp,
    e.salario salario_emp
FROM empleados e;

-- 6. SELECT con cálculos y alias
SELECT 
    nombre,
    apellido,
    salario,
    salario * 12 AS salario_anual,
    salario * 0.15 AS bonificacion_15_porciento
FROM empleados;

-- 7. SELECT con concatenación de strings
-- En PostgreSQL usamos || para concatenar
SELECT 
    nombre || ' ' || apellido AS nombre_completo,
    email,
    telefono
FROM empleados;

-- 8. SELECT con DISTINCT para valores únicos
SELECT DISTINCT departamento_id FROM empleados;

-- 9. SELECT con múltiples tablas (producto cartesiano - NO recomendado)
-- ⚠️ ADVERTENCIA: Esto puede generar muchos resultados
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento
FROM empleados e, departamentos d;

-- 10. SELECT con comentarios en línea
SELECT 
    nombre,           -- Nombre del empleado
    apellido,         -- Apellido del empleado
    salario           -- Salario mensual
FROM empleados;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. SELECT básico - seleccionar todas las columnas
SELECT * FROM empleados;

-- 2. SELECT específico - seleccionar columnas específicas
SELECT nombre, apellido, salario FROM empleados;

-- 3. SELECT con alias para columnas
SELECT 
    nombre AS nombre_empleado,
    apellido AS apellido_empleado,
    salario AS salario_anual
FROM empleados;

-- 4. SELECT con alias para tabla
SELECT 
    e.nombre,
    e.apellido,
    e.salario
FROM empleados AS e;

-- 5. SELECT con alias abreviado (sin AS)
SELECT 
    e.nombre nombre_emp,
    e.apellido apellido_emp,
    e.salario salario_emp
FROM empleados e;

-- 6. SELECT con cálculos y alias
SELECT 
    nombre,
    apellido,
    salario,
    salario * 12 AS salario_anual,
    salario * 0.15 AS bonificacion_15_porciento
FROM empleados;

-- 7. SELECT con concatenación de strings
-- En MS SQL Server usamos + para concatenar
SELECT 
    nombre + ' ' + apellido AS nombre_completo,
    email,
    telefono
FROM empleados;

-- 8. SELECT con DISTINCT para valores únicos
SELECT DISTINCT departamento_id FROM empleados;

-- 9. SELECT con múltiples tablas (producto cartesiano - NO recomendado)
-- ⚠️ ADVERTENCIA: Esto puede generar muchos resultados
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento
FROM empleados e, departamentos d;

-- 10. SELECT con comentarios en línea
SELECT 
    nombre,           -- Nombre del empleado
    apellido,         -- Apellido del empleado
    salario           -- Salario mensual
FROM empleados;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Concatenación de strings:
--    - PostgreSQL: ||
--    - MS SQL Server: +
-- 2. Comentarios: Ambos usan -- para comentarios de línea
-- 3. Alias: Ambos soportan AS opcional
-- 4. Sintaxis básica: Idéntica para consultas simples
-- 5. En MS SQL Server, usa GO para separar lotes de comandos

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Siempre especifica las columnas que necesitas (evita SELECT *)
-- 2. Usa alias descriptivos para columnas y tablas
-- 3. Comenta tu código SQL para mayor claridad
-- 4. Evita el producto cartesiano (usarás JOINs en el módulo 5)
-- 5. Usa DISTINCT solo cuando sea necesario
-- 6. Mantén consistencia en el formato de tu código
