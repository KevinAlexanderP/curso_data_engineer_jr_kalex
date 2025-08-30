-- =====================================================
-- Script: Filtrado con WHERE
-- Módulo 2: Consultas Básicas SELECT
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. Filtrado básico con operadores de comparación
-- Sintaxis: SELECT * FROM tabla WHERE condicion;

-- Empleados con salario mayor a 70,000
SELECT nombre, apellido, salario 
FROM empleados 
WHERE salario > 70000;

-- Empleados con salario menor o igual a 60,000
SELECT nombre, apellido, salario 
FROM empleados 
WHERE salario <= 60000;

-- Empleados con salario exactamente 65,000
SELECT nombre, apellido, salario 
FROM empleados 
WHERE salario = 65000;

-- Empleados con salario diferente a 65,000
SELECT nombre, apellido, salario 
FROM empleados 
WHERE salario <> 65000;

-- 2. Filtrado con operadores lógicos AND, OR, NOT

-- Empleados del departamento 1 con salario mayor a 60,000
SELECT nombre, apellido, salario, departamento_id 
FROM empleados 
WHERE departamento_id = 1 AND salario > 60000;

-- Empleados del departamento 1 O del departamento 3
SELECT nombre, apellido, departamento_id 
FROM empleados 
WHERE departamento_id = 1 OR departamento_id = 3;

-- Empleados que NO están en el departamento 2
SELECT nombre, apellido, departamento_id 
FROM empleados 
WHERE NOT departamento_id = 2;

-- Empleados con salario entre 50,000 y 70,000
SELECT nombre, apellido, salario 
FROM empleados 
WHERE salario >= 50000 AND salario <= 70000;

-- 3. Filtrado con IN y BETWEEN

-- Empleados en departamentos específicos usando IN
SELECT nombre, apellido, departamento_id 
FROM empleados 
WHERE departamento_id IN (1, 3, 5);

-- Empleados con salario en un rango usando BETWEEN
SELECT nombre, apellido, salario 
FROM empleados 
WHERE salario BETWEEN 55000 AND 75000;

-- Empleados con salario fuera del rango usando NOT BETWEEN
SELECT nombre, apellido, salario 
FROM empleados 
WHERE salario NOT BETWEEN 55000 AND 75000;

-- 4. Filtrado de valores NULL

-- Empleados sin teléfono (teléfono es NULL)
SELECT nombre, apellido, telefono 
FROM empleados 
WHERE telefono IS NULL;

-- Empleados con teléfono (teléfono NO es NULL)
SELECT nombre, apellido, telefono 
FROM empleados 
WHERE telefono IS NOT NULL;

-- 5. Filtrado con LIKE para búsquedas de texto

-- Empleados cuyo nombre empiece con 'A'
SELECT nombre, apellido 
FROM empleados 
WHERE nombre LIKE 'A%';

-- Empleados cuyo apellido termine con 'z'
SELECT nombre, apellido 
FROM empleados 
WHERE apellido LIKE '%z';

-- Empleados cuyo nombre contenga 'a' en cualquier posición
SELECT nombre, apellido 
FROM empleados 
WHERE nombre LIKE '%a%';

-- Empleados cuyo nombre tenga exactamente 3 caracteres
SELECT nombre, apellido 
FROM empleados 
WHERE nombre LIKE '___';

-- 6. Filtrado con fechas

-- Empleados contratados en 2024
SELECT nombre, apellido, fecha_contratacion 
FROM empleados 
WHERE fecha_contratacion >= '2024-01-01' AND fecha_contratacion < '2025-01-01';

-- Empleados nacidos antes de 1990
SELECT nombre, apellido, fecha_nacimiento 
FROM empleados 
WHERE fecha_nacimiento < '1990-01-01';

-- 7. Filtrado combinando múltiples condiciones

-- Empleados del departamento 1 con salario alto O del departamento 3 con salario bajo
SELECT nombre, apellido, departamento_id, salario 
FROM empleados 
WHERE (departamento_id = 1 AND salario > 70000) 
   OR (departamento_id = 3 AND salario < 60000);

-- Empleados activos con salario entre 50,000 y 80,000, excluyendo departamento 2
SELECT nombre, apellido, departamento_id, salario 
FROM empleados 
WHERE activo = TRUE 
  AND salario BETWEEN 50000 AND 80000 
  AND departamento_id != 2;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. Filtrado básico con operadores de comparación
SELECT nombre, apellido, salario 
FROM empleados 
WHERE salario > 70000;

-- 2. Filtrado con operadores lógicos AND, OR, NOT
SELECT nombre, apellido, salario, departamento_id 
FROM empleados 
WHERE departamento_id = 1 AND salario > 60000;

-- 3. Filtrado con IN y BETWEEN
SELECT nombre, apellido, departamento_id 
FROM empleados 
WHERE departamento_id IN (1, 3, 5);

-- 4. Filtrado de valores NULL
SELECT nombre, apellido, telefono 
FROM empleados 
WHERE telefono IS NULL;

-- 5. Filtrado con LIKE para búsquedas de texto
SELECT nombre, apellido 
FROM empleados 
WHERE nombre LIKE 'A%';

-- 6. Filtrado con fechas
SELECT nombre, apellido, fecha_contratacion 
FROM empleados 
WHERE fecha_contratacion >= '2024-01-01' AND fecha_contratacion < '2025-01-01';

-- 7. Filtrado combinando múltiples condiciones
SELECT nombre, apellido, departamento_id, salario 
FROM empleados 
WHERE (departamento_id = 1 AND salario > 70000) 
   OR (departamento_id = 3 AND salario < 60000);

-- Empleados activos con salario entre 50,000 y 80,000, excluyendo departamento 2
SELECT nombre, apellido, departamento_id, salario 
FROM empleados 
WHERE activo = 1 
  AND salario BETWEEN 50000 AND 80000 
  AND departamento_id != 2;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Valores booleanos:
--    - PostgreSQL: TRUE/FALSE
--    - MS SQL Server: 1/0
-- 2. Sintaxis de LIKE: Idéntica en ambos
-- 3. Operadores de comparación: Idénticos
-- 4. Filtrado de NULL: Idéntico (IS NULL, IS NOT NULL)
-- 5. Fechas: Formato idéntico 'YYYY-MM-DD'

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Usa paréntesis para agrupar condiciones lógicas complejas
-- 2. Coloca las condiciones más restrictivas primero para mejor rendimiento
-- 3. Usa BETWEEN en lugar de >= AND <= para rangos
-- 4. Usa IN para múltiples valores iguales
-- 5. Ten cuidado con LIKE '%patrón%' en tablas grandes
-- 6. Siempre verifica si las columnas pueden ser NULL
-- 7. Usa índices en las columnas del WHERE para mejor rendimiento
