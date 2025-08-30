-- =====================================================
-- Script: Ordenamiento con ORDER BY
-- Módulo 2: Consultas Básicas SELECT
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. Ordenamiento básico ascendente (ASC es el valor por defecto)
-- Sintaxis: SELECT * FROM tabla ORDER BY columna [ASC|DESC];

-- Empleados ordenados por nombre (ascendente)
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre;

-- Empleados ordenados por nombre (ascendente explícito)
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre ASC;

-- 2. Ordenamiento descendente (DESC)

-- Empleados ordenados por salario de mayor a menor
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY salario DESC;

-- Empleados ordenados por fecha de contratación (más recientes primero)
SELECT nombre, apellido, fecha_contratacion 
FROM empleados 
ORDER BY fecha_contratacion DESC;

-- 3. Ordenamiento por múltiples columnas

-- Empleados ordenados por departamento y luego por salario descendente
SELECT nombre, apellido, departamento_id, salario 
FROM empleados 
ORDER BY departamento_id ASC, salario DESC;

-- Empleados ordenados por apellido y luego por nombre
SELECT nombre, apellido, email 
FROM empleados 
ORDER BY apellido ASC, nombre ASC;

-- 4. Ordenamiento por posición de columna

-- Ordenamiento por la primera y tercera columna seleccionada
SELECT nombre, apellido, salario, departamento_id 
FROM empleados 
ORDER BY 1, 3 DESC;

-- ⚠️ ADVERTENCIA: El ordenamiento por posición puede ser confuso
-- Es mejor usar nombres de columnas para mayor claridad

-- 5. Ordenamiento con alias

-- Ordenamiento usando alias de columnas
SELECT 
    nombre AS nombre_empleado,
    apellido AS apellido_empleado,
    salario AS salario_mensual
FROM empleados 
ORDER BY nombre_empleado, apellido_empleado;

-- 6. Ordenamiento con expresiones

-- Empleados ordenados por salario anual (salario * 12)
SELECT nombre, apellido, salario, salario * 12 AS salario_anual
FROM empleados 
ORDER BY salario * 12 DESC;

-- Empleados ordenados por longitud del nombre
SELECT nombre, apellido, LENGTH(nombre) AS longitud_nombre
FROM empleados 
ORDER BY LENGTH(nombre) DESC;

-- 7. Ordenamiento con CASE para ordenamiento personalizado

-- Empleados ordenados por prioridad de departamento
SELECT nombre, apellido, departamento_id, salario
FROM empleados 
ORDER BY 
    CASE departamento_id
        WHEN 1 THEN 1  -- Desarrollo de Software (prioridad alta)
        WHEN 3 THEN 2  -- Marketing
        WHEN 4 THEN 3  -- Finanzas
        WHEN 5 THEN 4  -- Operaciones
        WHEN 2 THEN 5  -- Recursos Humanos (prioridad baja)
    END;

-- 8. Ordenamiento con valores NULL

-- Empleados ordenados por teléfono (NULL al final)
SELECT nombre, apellido, telefono 
FROM empleados 
ORDER BY telefono NULLS LAST;

-- Empleados ordenados por teléfono (NULL al principio)
SELECT nombre, apellido, telefono 
FROM empleados 
ORDER BY telefono NULLS FIRST;

-- 9. Ordenamiento combinado con WHERE

-- Empleados activos ordenados por salario descendente
SELECT nombre, apellido, salario, departamento_id 
FROM empleados 
WHERE activo = TRUE 
ORDER BY salario DESC;

-- Empleados del departamento 1 ordenados por fecha de contratación
SELECT nombre, apellido, fecha_contratacion 
FROM empleados 
WHERE departamento_id = 1 
ORDER BY fecha_contratacion ASC;

-- 10. Ordenamiento con DISTINCT

-- Departamentos únicos ordenados por presupuesto
SELECT DISTINCT departamento_id 
FROM empleados 
ORDER BY departamento_id;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. Ordenamiento básico ascendente
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY nombre;

-- 2. Ordenamiento descendente
SELECT nombre, apellido, salario 
FROM empleados 
ORDER BY salario DESC;

-- 3. Ordenamiento por múltiples columnas
SELECT nombre, apellido, departamento_id, salario 
FROM empleados 
ORDER BY departamento_id ASC, salario DESC;

-- 4. Ordenamiento por posición de columna
SELECT nombre, apellido, salario, departamento_id 
FROM empleados 
ORDER BY 1, 3 DESC;

-- 5. Ordenamiento con alias
SELECT 
    nombre AS nombre_empleado,
    apellido AS apellido_empleado,
    salario AS salario_mensual
FROM empleados 
ORDER BY nombre_empleado, apellido_empleado;

-- 6. Ordenamiento con expresiones
SELECT nombre, apellido, salario, salario * 12 AS salario_anual
FROM empleados 
ORDER BY salario * 12 DESC;

-- Empleados ordenados por longitud del nombre
SELECT nombre, apellido, LEN(nombre) AS longitud_nombre
FROM empleados 
ORDER BY LEN(nombre) DESC;

-- 7. Ordenamiento con CASE para ordenamiento personalizado
SELECT nombre, apellido, departamento_id, salario
FROM empleados 
ORDER BY 
    CASE departamento_id
        WHEN 1 THEN 1  -- Desarrollo de Software (prioridad alta)
        WHEN 3 THEN 2  -- Marketing
        WHEN 4 THEN 3  -- Finanzas
        WHEN 5 THEN 4  -- Operaciones
        WHEN 2 THEN 5  -- Recursos Humanos (prioridad baja)
    END;

-- 8. Ordenamiento con valores NULL
-- En MS SQL Server, NULL se ordena al principio por defecto
SELECT nombre, apellido, telefono 
FROM empleados 
ORDER BY telefono;

-- Para poner NULL al final, usa CASE
SELECT nombre, apellido, telefono 
FROM empleados 
ORDER BY 
    CASE WHEN telefono IS NULL THEN 1 ELSE 0 END,
    telefono;

-- 9. Ordenamiento combinado con WHERE
SELECT nombre, apellido, salario, departamento_id 
FROM empleados 
WHERE activo = 1 
ORDER BY salario DESC;

-- 10. Ordenamiento con DISTINCT
SELECT DISTINCT departamento_id 
FROM empleados 
ORDER BY departamento_id;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Función de longitud de string:
--    - PostgreSQL: LENGTH()
--    - MS SQL Server: LEN()
-- 2. Ordenamiento de NULL:
--    - PostgreSQL: NULLS FIRST/LAST
--    - MS SQL Server: CASE WHEN para controlar orden de NULL
-- 3. Sintaxis básica de ORDER BY: Idéntica
-- 4. Ordenamiento por posición: Idéntico
-- 5. Ordenamiento con CASE: Idéntico

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Siempre especifica ASC o DESC para mayor claridad
-- 2. Evita el ordenamiento por posición de columna
-- 3. Usa alias descriptivos para expresiones complejas
-- 4. Considera el rendimiento: ordenar por columnas indexadas
-- 5. Ten en cuenta que ORDER BY se ejecuta al final de la consulta
-- 6. Usa CASE para ordenamiento personalizado complejo
-- 7. El ordenamiento por múltiples columnas va de izquierda a derecha
-- 8. Los valores NULL se ordenan de manera diferente en cada sistema
