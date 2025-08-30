-- =====================================================
-- Script: Operadores y Expresiones
-- Módulo 3: Funciones y Operadores
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. OPERADORES DE COMPARACIÓN
-- Sintaxis: =, <>, !=, >, <, >=, <=

-- Comparaciones básicas
SELECT 
    nombre,
    salario,
    CASE 
        WHEN salario = 65000 THEN 'Salario exacto'
        WHEN salario <> 65000 THEN 'Salario diferente'
        ELSE 'Otro caso'
    END AS comparacion_igualdad
FROM empleados;

-- Comparaciones de rango
SELECT 
    nombre,
    salario,
    CASE 
        WHEN salario > 70000 THEN 'Salario alto'
        WHEN salario >= 60000 AND salario <= 70000 THEN 'Salario medio'
        WHEN salario < 60000 THEN 'Salario bajo'
        ELSE 'Sin clasificar'
    END AS categoria_salario
FROM empleados;

-- 2. OPERADORES LÓGICOS
-- Sintaxis: AND, OR, NOT

-- Operadores AND y OR
SELECT 
    nombre,
    departamento_id,
    salario,
    CASE 
        WHEN departamento_id = 1 AND salario > 65000 THEN 'Desarrollador senior'
        WHEN departamento_id = 1 AND salario <= 65000 THEN 'Desarrollador junior'
        WHEN departamento_id = 3 OR departamento_id = 4 THEN 'Departamento administrativo'
        ELSE 'Otro departamento'
    END AS clasificacion_empleado
FROM empleados;

-- Operador NOT
SELECT 
    nombre,
    departamento_id,
    CASE 
        WHEN NOT departamento_id = 2 THEN 'No es RRHH'
        ELSE 'Es RRHH'
    END AS es_rrhh
FROM empleados;

-- 3. OPERADORES DE CONCATENACIÓN

-- Concatenación de strings
SELECT 
    nombre,
    apellido,
    nombre || ' ' || apellido AS nombre_completo,
    'Empleado: ' || nombre || ' - Depto: ' || departamento_id AS descripcion
FROM empleados;

-- 4. EXPRESIONES CONDICIONALES CON CASE

-- CASE simple (equivalente a switch)
SELECT 
    nombre,
    departamento_id,
    CASE departamento_id
        WHEN 1 THEN 'Desarrollo'
        WHEN 2 THEN 'Recursos Humanos'
        WHEN 3 THEN 'Marketing'
        WHEN 4 THEN 'Finanzas'
        WHEN 5 THEN 'Operaciones'
        ELSE 'Desconocido'
    END AS nombre_departamento
FROM empleados;

-- CASE con condiciones (equivalente a if-else)
SELECT 
    nombre,
    salario,
    CASE 
        WHEN salario >= 80000 THEN 'Ejecutivo'
        WHEN salario >= 60000 THEN 'Profesional'
        WHEN salario >= 50000 THEN 'Técnico'
        ELSE 'Auxiliar'
    END AS nivel_empleado
FROM empleados;

-- CASE anidado
SELECT 
    nombre,
    departamento_id,
    salario,
    CASE 
        WHEN departamento_id = 1 THEN
            CASE 
                WHEN salario >= 70000 THEN 'Desarrollador Senior'
                WHEN salario >= 60000 THEN 'Desarrollador Intermedio'
                ELSE 'Desarrollador Junior'
            END
        WHEN departamento_id = 3 THEN
            CASE 
                WHEN salario >= 65000 THEN 'Marketing Senior'
                ELSE 'Marketing Junior'
            END
        ELSE 'Otro rol'
    END AS rol_detallado
FROM empleados;

-- 5. OPERADORES DE PATRÓN (LIKE, ILIKE)

-- LIKE - búsqueda con patrón (sensible a mayúsculas)
SELECT 
    nombre,
    CASE 
        WHEN nombre LIKE 'A%' THEN 'Empieza con A'
        WHEN nombre LIKE '%a%' THEN 'Contiene a'
        WHEN nombre LIKE '%z' THEN 'Termina con z'
        ELSE 'No cumple patrón'
    END AS patron_nombre
FROM empleados;

-- ILIKE - búsqueda con patrón (insensible a mayúsculas, solo PostgreSQL)
SELECT 
    nombre,
    CASE 
        WHEN nombre ILIKE 'a%' THEN 'Empieza con A/a'
        WHEN nombre ILIKE '%a%' THEN 'Contiene A/a'
        ELSE 'No cumple patrón'
    END AS patron_nombre_insensible
FROM empleados;

-- 6. OPERADORES DE INCLUSIÓN (IN, NOT IN)

-- IN - verificar si un valor está en una lista
SELECT 
    nombre,
    departamento_id,
    CASE 
        WHEN departamento_id IN (1, 3) THEN 'Departamento técnico'
        WHEN departamento_id IN (2, 4) THEN 'Departamento administrativo'
        ELSE 'Otro departamento'
    END AS tipo_departamento
FROM empleados;

-- NOT IN - verificar si un valor NO está en una lista
SELECT 
    nombre,
    departamento_id,
    CASE 
        WHEN departamento_id NOT IN (2, 5) THEN 'Departamento principal'
        ELSE 'Departamento de apoyo'
    END AS categoria_departamento
FROM empleados;

-- 7. OPERADORES DE RANGO (BETWEEN, NOT BETWEEN)

-- BETWEEN - verificar si un valor está en un rango
SELECT 
    nombre,
    salario,
    CASE 
        WHEN salario BETWEEN 50000 AND 60000 THEN 'Rango bajo'
        WHEN salario BETWEEN 60001 AND 70000 THEN 'Rango medio'
        WHEN salario BETWEEN 70001 AND 80000 THEN 'Rango alto'
        ELSE 'Rango muy alto'
    END AS rango_salario
FROM empleados;

-- NOT BETWEEN - verificar si un valor NO está en un rango
SELECT 
    nombre,
    salario,
    CASE 
        WHEN salario NOT BETWEEN 55000 AND 75000 THEN 'Salario fuera del rango estándar'
        ELSE 'Salario en rango estándar'
    END AS fuera_rango_estandar
FROM empleados;

-- 8. OPERADORES DE NULL (IS NULL, IS NOT NULL)

-- Verificar valores NULL
SELECT 
    nombre,
    telefono,
    CASE 
        WHEN telefono IS NULL THEN 'Sin teléfono'
        WHEN telefono IS NOT NULL THEN 'Con teléfono'
        ELSE 'Estado desconocido'
    END AS estado_telefono
FROM empleados;

-- 9. OPERADORES COMBINADOS

-- Combinar múltiples operadores
SELECT 
    nombre,
    departamento_id,
    salario,
    CASE 
        WHEN departamento_id = 1 AND salario > 65000 AND telefono IS NOT NULL THEN 'Desarrollador senior completo'
        WHEN departamento_id = 1 AND salario <= 65000 THEN 'Desarrollador junior'
        WHEN departamento_id IN (3, 4) AND salario BETWEEN 55000 AND 70000 THEN 'Administrativo medio'
        WHEN NOT (departamento_id = 2 OR departamento_id = 5) THEN 'Departamento principal'
        ELSE 'Otra categoría'
    END AS clasificacion_compleja
FROM empleados;

-- 10. EXPRESIONES CON FUNCIONES

-- Combinar operadores con funciones
SELECT 
    nombre,
    LENGTH(nombre) AS longitud_nombre,
    CASE 
        WHEN LENGTH(nombre) > 5 AND salario > 60000 THEN 'Nombre largo y salario alto'
        WHEN LENGTH(nombre) <= 5 OR salario <= 60000 THEN 'Nombre corto o salario bajo'
        ELSE 'Combinación mixta'
    END AS clasificacion_nombre_salario
FROM empleados;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. OPERADORES DE COMPARACIÓN
SELECT 
    nombre,
    salario,
    CASE 
        WHEN salario = 65000 THEN 'Salario exacto'
        WHEN salario <> 65000 THEN 'Salario diferente'
        ELSE 'Otro caso'
    END AS comparacion_igualdad
FROM empleados;

-- 2. OPERADORES LÓGICOS
SELECT 
    nombre,
    departamento_id,
    salario,
    CASE 
        WHEN departamento_id = 1 AND salario > 65000 THEN 'Desarrollador senior'
        WHEN departamento_id = 1 AND salario <= 65000 THEN 'Desarrollador junior'
        WHEN departamento_id = 3 OR departamento_id = 4 THEN 'Departamento administrativo'
        ELSE 'Otro departamento'
    END AS clasificacion_empleado
FROM empleados;

-- 3. OPERADORES DE CONCATENACIÓN
SELECT 
    nombre,
    apellido,
    nombre + ' ' + apellido AS nombre_completo,
    'Empleado: ' + nombre + ' - Depto: ' + CAST(departamento_id AS VARCHAR) AS descripcion
FROM empleados;

-- 4. EXPRESIONES CONDICIONALES CON CASE
SELECT 
    nombre,
    departamento_id,
    CASE departamento_id
        WHEN 1 THEN 'Desarrollo'
        WHEN 2 THEN 'Recursos Humanos'
        WHEN 3 THEN 'Marketing'
        WHEN 4 THEN 'Finanzas'
        WHEN 5 THEN 'Operaciones'
        ELSE 'Desconocido'
    END AS nombre_departamento
FROM empleados;

-- 5. OPERADORES DE PATRÓN (LIKE)
SELECT 
    nombre,
    CASE 
        WHEN nombre LIKE 'A%' THEN 'Empieza con A'
        WHEN nombre LIKE '%a%' THEN 'Contiene a'
        WHEN nombre LIKE '%z' THEN 'Termina con z'
        ELSE 'No cumple patrón'
    END AS patron_nombre
FROM empleados;

-- 6. OPERADORES DE INCLUSIÓN (IN, NOT IN)
SELECT 
    nombre,
    departamento_id,
    CASE 
        WHEN departamento_id IN (1, 3) THEN 'Departamento técnico'
        WHEN departamento_id IN (2, 4) THEN 'Departamento administrativo'
        ELSE 'Otro departamento'
    END AS tipo_departamento
FROM empleados;

-- 7. OPERADORES DE RANGO (BETWEEN, NOT BETWEEN)
SELECT 
    nombre,
    salario,
    CASE 
        WHEN salario BETWEEN 50000 AND 60000 THEN 'Rango bajo'
        WHEN salario BETWEEN 60001 AND 70000 THEN 'Rango medio'
        WHEN salario BETWEEN 70001 AND 80000 THEN 'Rango alto'
        ELSE 'Rango muy alto'
    END AS rango_salario
FROM empleados;

-- 8. OPERADORES DE NULL (IS NULL, IS NOT NULL)
SELECT 
    nombre,
    telefono,
    CASE 
        WHEN telefono IS NULL THEN 'Sin teléfono'
        WHEN telefono IS NOT NULL THEN 'Con teléfono'
        ELSE 'Estado desconocido'
    END AS estado_telefono
FROM empleados;

-- 9. OPERADORES COMBINADOS
SELECT 
    nombre,
    departamento_id,
    salario,
    CASE 
        WHEN departamento_id = 1 AND salario > 65000 AND telefono IS NOT NULL THEN 'Desarrollador senior completo'
        WHEN departamento_id = 1 AND salario <= 65000 THEN 'Desarrollador junior'
        WHEN departamento_id IN (3, 4) AND salario BETWEEN 55000 AND 70000 THEN 'Administrativo medio'
        WHEN NOT (departamento_id = 2 OR departamento_id = 5) THEN 'Departamento principal'
        ELSE 'Otra categoría'
    END AS clasificacion_compleja
FROM empleados;

-- 10. EXPRESIONES CON FUNCIONES
SELECT 
    nombre,
    LEN(nombre) AS longitud_nombre,
    CASE 
        WHEN LEN(nombre) > 5 AND salario > 60000 THEN 'Nombre largo y salario alto'
        WHEN LEN(nombre) <= 5 OR salario <= 60000 THEN 'Nombre corto o salario bajo'
        ELSE 'Combinación mixta'
    END AS clasificacion_nombre_salario
FROM empleados;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Concatenación:
--    - PostgreSQL: ||
--    - MS SQL Server: +
-- 2. Búsqueda insensible a mayúsculas:
--    - PostgreSQL: ILIKE
--    - MS SQL Server: No existe, usar UPPER() o LOWER()
-- 3. Longitud de string:
--    - PostgreSQL: LENGTH()
--    - MS SQL Server: LEN()
-- 4. Conversión de tipos:
--    - PostgreSQL: :: o CAST()
--    - MS SQL Server: CAST() o CONVERT()
-- 5. Sintaxis básica: Idéntica para operadores lógicos y comparación

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Usa paréntesis para agrupar condiciones lógicas complejas
-- 2. El orden de las condiciones en CASE puede afectar el rendimiento
-- 3. Evita usar funciones en cláusulas WHERE cuando sea posible
-- 4. Usa índices en las columnas de comparación para mejor rendimiento
-- 5. Las expresiones CASE son más legibles que múltiples IF anidados
-- 6. Ten en cuenta la precedencia de operadores
-- 7. Usa alias descriptivos para expresiones complejas
-- 8. Prueba las expresiones con diferentes tipos de datos
