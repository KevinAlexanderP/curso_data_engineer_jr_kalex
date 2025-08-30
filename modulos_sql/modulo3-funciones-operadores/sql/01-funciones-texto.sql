-- =====================================================
-- Script: Funciones de Texto
-- Módulo 3: Funciones y Operadores
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. CONCATENACIÓN DE STRINGS
-- Sintaxis: string1 || string2 || string3

-- Concatenar nombre y apellido
SELECT 
    nombre || ' ' || apellido AS nombre_completo
FROM empleados;

-- Concatenar múltiples campos con separadores
SELECT 
    'Empleado: ' || nombre || ' ' || apellido || ' - Depto: ' || departamento_id AS info_empleado
FROM empleados;

-- Concatenar con valores NULL (NULL se convierte en string vacío)
SELECT 
    nombre || ' ' || apellido || ' - Tel: ' || COALESCE(telefono, 'Sin teléfono') AS contacto
FROM empleados;

-- 2. FUNCIONES DE LONGITUD Y POSICIÓN

-- LENGTH() - longitud de un string
SELECT 
    nombre,
    LENGTH(nombre) AS longitud_nombre
FROM empleados;

-- POSITION() - posición de un substring
SELECT 
    email,
    POSITION('@' IN email) AS posicion_arroba
FROM empleados;

-- STRPOS() - posición de un substring (alternativa a POSITION)
SELECT 
    email,
    STRPOS(email, '@') AS posicion_arroba
FROM empleados;

-- 3. FUNCIONES DE EXTRACCIÓN

-- SUBSTRING() - extraer parte de un string
-- Sintaxis: SUBSTRING(string FROM start [FOR length])
SELECT 
    email,
    SUBSTRING(email FROM 1 FOR POSITION('@' IN email) - 1) AS nombre_usuario,
    SUBSTRING(email FROM POSITION('@' IN email) + 1) AS dominio
FROM empleados;

-- LEFT() y RIGHT() - extraer desde la izquierda o derecha
SELECT 
    nombre,
    LEFT(nombre, 3) AS primeras_3_letras,
    RIGHT(nombre, 2) AS ultimas_2_letras
FROM empleados;

-- 4. FUNCIONES DE CONVERSIÓN DE MAYÚSCULAS/MINÚSCULAS

-- UPPER() - convertir a mayúsculas
SELECT 
    nombre,
    UPPER(nombre) AS nombre_mayusculas
FROM empleados;

-- LOWER() - convertir a minúsculas
SELECT 
    email,
    LOWER(email) AS email_minusculas
FROM empleados;

-- INITCAP() - primera letra de cada palabra en mayúscula
SELECT 
    nombre || ' ' || apellido AS nombre_completo,
    INITCAP(nombre || ' ' || apellido) AS nombre_formateado
FROM empleados;

-- 5. FUNCIONES DE BÚSQUEDA Y REEMPLAZO

-- REPLACE() - reemplazar texto
SELECT 
    email,
    REPLACE(email, '@empresa.com', '@nuevaempresa.com') AS nuevo_email
FROM empleados;

-- TRANSLATE() - reemplazar caracteres uno por uno
SELECT 
    telefono,
    TRANSLATE(telefono, '-', '') AS telefono_sin_guiones
FROM empleados;

-- 6. FUNCIONES DE TRIM Y PADDING

-- TRIM() - eliminar espacios en blanco
SELECT 
    '   ' || nombre || '   ' AS nombre_con_espacios,
    TRIM('   ' || nombre || '   ') AS nombre_sin_espacios
FROM empleados;

-- LTRIM() y RTRIM() - eliminar espacios a la izquierda o derecha
SELECT 
    '   ' || nombre AS nombre_con_espacios_izquierda,
    LTRIM('   ' || nombre) AS nombre_sin_espacios_izquierda
FROM empleados;

-- LPAD() y RPAD() - agregar caracteres de relleno
SELECT 
    nombre,
    LPAD(nombre, 15, '*') AS nombre_pad_izquierda,
    RPAD(nombre, 15, '*') AS nombre_pad_derecha
FROM empleados;

-- 7. FUNCIONES DE DIVISIÓN Y UNIÓN

-- SPLIT_PART() - dividir string por delimitador
SELECT 
    email,
    SPLIT_PART(email, '@', 1) AS nombre_usuario,
    SPLIT_PART(email, '@', 2) AS dominio
FROM empleados;

-- STRING_AGG() - unir múltiples filas en una sola
SELECT 
    departamento_id,
    STRING_AGG(nombre, ', ') AS nombres_empleados
FROM empleados 
GROUP BY departamento_id;

-- 8. FUNCIONES DE COMPARACIÓN Y BÚSQUEDA

-- SIMILAR TO - búsqueda con expresiones regulares simples
SELECT 
    nombre,
    CASE 
        WHEN nombre SIMILAR TO 'A%' THEN 'Empieza con A'
        WHEN nombre SIMILAR TO '%a%' THEN 'Contiene a'
        ELSE 'No cumple patrón'
    END AS patron_nombre
FROM empleados;

-- REGEXP_MATCHES() - búsqueda con expresiones regulares
SELECT 
    email,
    REGEXP_MATCHES(email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') AS es_email_valido
FROM empleados;

-- 9. FUNCIONES DE FORMATO

-- TO_CHAR() - convertir a string con formato
SELECT 
    salario,
    TO_CHAR(salario, 'FM$999,999.00') AS salario_formateado
FROM empleados;

-- 10. FUNCIONES COMBINADAS

-- Crear un identificador único combinando múltiples funciones
SELECT 
    nombre,
    apellido,
    UPPER(LEFT(nombre, 1) || LEFT(apellido, 3) || departamento_id) AS id_empleado
FROM empleados;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. CONCATENACIÓN DE STRINGS
-- Sintaxis: string1 + string2 + string3

-- Concatenar nombre y apellido
SELECT 
    nombre + ' ' + apellido AS nombre_completo
FROM empleados;

-- Concatenar múltiples campos con separadores
SELECT 
    'Empleado: ' + nombre + ' ' + apellido + ' - Depto: ' + CAST(departamento_id AS VARCHAR) AS info_empleado
FROM empleados;

-- Concatenar con valores NULL usando ISNULL()
SELECT 
    nombre + ' ' + apellido + ' - Tel: ' + ISNULL(telefono, 'Sin teléfono') AS contacto
FROM empleados;

-- 2. FUNCIONES DE LONGITUD Y POSICIÓN

-- LEN() - longitud de un string
SELECT 
    nombre,
    LEN(nombre) AS longitud_nombre
FROM empleados;

-- CHARINDEX() - posición de un substring
SELECT 
    email,
    CHARINDEX('@', email) AS posicion_arroba
FROM empleados;

-- 3. FUNCIONES DE EXTRACCIÓN

-- SUBSTRING() - extraer parte de un string
-- Sintaxis: SUBSTRING(string, start, length)
SELECT 
    email,
    SUBSTRING(email, 1, CHARINDEX('@', email) - 1) AS nombre_usuario,
    SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS dominio
FROM empleados;

-- LEFT() y RIGHT() - extraer desde la izquierda o derecha
SELECT 
    nombre,
    LEFT(nombre, 3) AS primeras_3_letras,
    RIGHT(nombre, 2) AS ultimas_2_letras
FROM empleados;

-- 4. FUNCIONES DE CONVERSIÓN DE MAYÚSCULAS/MINÚSCULAS

-- UPPER() - convertir a mayúsculas
SELECT 
    nombre,
    UPPER(nombre) AS nombre_mayusculas
FROM empleados;

-- LOWER() - convertir a minúsculas
SELECT 
    email,
    LOWER(email) AS email_minusculas
FROM empleados;

-- 5. FUNCIONES DE BÚSQUEDA Y REEMPLAZO

-- REPLACE() - reemplazar texto
SELECT 
    email,
    REPLACE(email, '@empresa.com', '@nuevaempresa.com') AS nuevo_email
FROM empleados;

-- 6. FUNCIONES DE TRIM Y PADDING

-- LTRIM() y RTRIM() - eliminar espacios a la izquierda o derecha
SELECT 
    '   ' + nombre AS nombre_con_espacios_izquierda,
    LTRIM('   ' + nombre) AS nombre_sin_espacios_izquierda
FROM empleados;

-- 7. FUNCIONES DE DIVISIÓN Y UNIÓN

-- STRING_SPLIT() - dividir string por delimitador (SQL Server 2016+)
SELECT 
    email,
    value AS parte_email
FROM empleados
CROSS APPLY STRING_SPLIT(email, '@');

-- STRING_AGG() - unir múltiples filas en una sola (SQL Server 2017+)
SELECT 
    departamento_id,
    STRING_AGG(nombre, ', ') AS nombres_empleados
FROM empleados 
GROUP BY departamento_id;

-- 8. FUNCIONES DE FORMATO

-- FORMAT() - formatear con patrones (SQL Server 2012+)
SELECT 
    salario,
    FORMAT(salario, 'C') AS salario_formateado
FROM empleados;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Concatenación:
--    - PostgreSQL: ||
--    - MS SQL Server: +
-- 2. Longitud de string:
--    - PostgreSQL: LENGTH()
--    - MS SQL Server: LEN()
-- 3. Posición de substring:
--    - PostgreSQL: POSITION() o STRPOS()
--    - MS SQL Server: CHARINDEX()
-- 4. Extracción de substring:
--    - PostgreSQL: SUBSTRING(string FROM start FOR length)
--    - MS SQL Server: SUBSTRING(string, start, length)
-- 5. Manejo de NULL en concatenación:
--    - PostgreSQL: COALESCE()
--    - MS SQL Server: ISNULL()
-- 6. Funciones avanzadas:
--    - PostgreSQL: Más funciones nativas
--    - MS SQL Server: Algunas funciones requieren versiones más recientes

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Usa COALESCE() o ISNULL() para manejar valores NULL en concatenación
-- 2. Las funciones de string son sensibles a mayúsculas/minúsculas
-- 3. Considera el rendimiento al usar funciones en cláusulas WHERE
-- 4. Usa índices en columnas de texto cuando sea posible
-- 5. Las expresiones regulares pueden ser lentas en tablas grandes
-- 6. STRING_AGG() es más eficiente que múltiples concatenaciones
-- 7. Ten en cuenta las diferencias de sintaxis entre sistemas
-- 8. Prueba las funciones en tu sistema específico antes de usar en producción
