-- =====================================================
-- Script: Conceptos de JOINs
-- Módulo 5: JOINs y Relaciones entre Tablas
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. CONCEPTOS BÁSICOS DE JOINs
-- Un JOIN es una operación que combina filas de dos o más tablas
-- basándose en una condición de relación entre ellas.

-- 2. TIPOS DE RELACIONES ENTRE TABLAS

-- Relación Uno a Muchos (1:N)
-- Ejemplo: Un departamento puede tener muchos empleados
-- - departamentos (1) ←→ empleados (N)
-- - La clave foránea está en la tabla "muchos" (empleados.departamento_id)

-- Relación Muchos a Muchos (N:N)
-- Ejemplo: Un empleado puede trabajar en varios proyectos y un proyecto puede tener varios empleados
-- - empleados (N) ←→ empleados_proyectos ←→ proyectos (N)
-- - Se necesita una tabla intermedia (empleados_proyectos)

-- Relación Uno a Uno (1:1)
-- Ejemplo: Un empleado tiene un perfil de usuario
-- - empleados (1) ←→ perfiles_usuarios (1)

-- 3. CLAVES PRIMARIAS Y FORÁNEAS

-- Clave Primaria (Primary Key):
-- - Identifica de manera única cada fila en una tabla
-- - No puede ser NULL
-- - Debe ser única
-- - Ejemplo: empleados.id

-- Clave Foránea (Foreign Key):
-- - Referencia a una clave primaria en otra tabla
-- - Establece la relación entre tablas
-- - Puede ser NULL (dependiendo del diseño)
-- - Ejemplo: empleados.departamento_id referencia departamentos.id

-- 4. PRODUCTO CARTESIANO vs JOINs

-- PRODUCTO CARTESIANO (NO RECOMENDADO):
-- Combina cada fila de la primera tabla con cada fila de la segunda tabla
-- Resultado: número_filas_tabla1 × número_filas_tabla2

-- Ejemplo de producto cartesiano (incorrecto):
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento
FROM empleados e, departamentos d;
-- ⚠️ ADVERTENCIA: Esto genera 10 empleados × 5 departamentos = 50 filas
-- No es lo que queremos para mostrar empleados con sus departamentos

-- JOIN CORRECTO:
-- Combina solo las filas que cumplen la condición de relación
SELECT 
    e.nombre,
    e.apellido,
    d.nombre AS nombre_departamento
FROM empleados e
JOIN departamentos d ON e.departamento_id = d.id;
-- ✅ Resultado: Solo 10 filas (una por empleado con su departamento correspondiente)

-- 5. SINTAXIS BÁSICA DE JOINs

-- Sintaxis estándar:
-- SELECT columnas FROM tabla1
-- JOIN tabla2 ON condicion_relacion
-- JOIN tabla3 ON condicion_relacion
-- WHERE condiciones_filtro
-- GROUP BY columnas_agrupacion
-- HAVING condiciones_grupo
-- ORDER BY columnas_ordenamiento;

-- 6. TIPOS DE JOINs

-- INNER JOIN:
-- - Solo incluye filas que tienen coincidencias en AMBAS tablas
-- - Es el tipo de JOIN más común

-- LEFT OUTER JOIN:
-- - Incluye TODAS las filas de la tabla izquierda
-- - Solo incluye filas de la tabla derecha que coinciden
-- - Si no hay coincidencia, las columnas de la tabla derecha son NULL

-- RIGHT OUTER JOIN:
-- - Incluye TODAS las filas de la tabla derecha
-- - Solo incluye filas de la tabla izquierda que coinciden
-- - Si no hay coincidencia, las columnas de la tabla izquierda son NULL

-- FULL OUTER JOIN:
-- - Incluye TODAS las filas de AMBAS tablas
-- - Si no hay coincidencia, las columnas de la otra tabla son NULL

-- CROSS JOIN:
-- - Producto cartesiano (todas las combinaciones posibles)
-- - No requiere condición ON

-- 7. EJEMPLO PRÁCTICO DE RELACIONES

-- Ver la estructura de las tablas relacionadas:
SELECT 
    'empleados' AS tabla,
    COUNT(*) AS numero_filas,
    'departamento_id referencia departamentos.id' AS relacion
FROM empleados
UNION ALL
SELECT 
    'departamentos' AS tabla,
    COUNT(*) AS numero_filas,
    'id es referenciado por empleados.departamento_id' AS relacion
FROM departamentos
UNION ALL
SELECT 
    'empleados_proyectos' AS tabla,
    COUNT(*) AS numero_filas,
    'empleado_id referencia empleados.id, proyecto_id referencia proyectos.id' AS relacion
FROM empleados_proyectos
UNION ALL
SELECT 
    'proyectos' AS tabla,
    COUNT(*) AS numero_filas,
    'id es referenciado por empleados_proyectos.proyecto_id' AS relacion
FROM proyectos;

-- 8. VERIFICAR INTEGRIDAD REFERENCIAL

-- Verificar que todos los empleados tienen departamentos válidos:
SELECT 
    'Empleados sin departamento válido' AS verificacion,
    COUNT(*) AS numero_empleados
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
WHERE d.id IS NULL

UNION ALL

-- Verificar que todos los departamentos tienen empleados:
SELECT 
    'Departamentos sin empleados' AS verificacion,
    COUNT(*) AS numero_departamentos
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
WHERE e.id IS NULL;

-- 9. DIAGRAMA DE RELACIONES (CONSULTA)

-- Crear un resumen visual de las relaciones:
SELECT 
    'RELACIONES ENTRE TABLAS' AS titulo,
    '' AS detalle
UNION ALL
SELECT 
    'departamentos (1) ←→ empleados (N)' AS titulo,
    'departamentos.id ← empleados.departamento_id' AS detalle
UNION ALL
SELECT 
    'empleados (N) ←→ empleados_proyectos ←→ proyectos (N)' AS titulo,
    'empleados.id ← empleados_proyectos.empleado_id' AS detalle
UNION ALL
SELECT 
    'proyectos (N) ←→ empleados_proyectos ←→ empleados (N)' AS titulo,
    'proyectos.id ← empleados_proyectos.proyecto_id' AS detalle
UNION ALL
SELECT 
    'empleados (N) ←→ empleados_habilidades ←→ habilidades (N)' AS titulo,
    'empleados.id ← empleados_habilidades.empleado_id' AS detalle
UNION ALL
SELECT 
    'habilidades (N) ←→ empleados_habilidades ←→ empleados (N)' AS titulo,
    'habilidades.id ← empleados_habilidades.habilidad_id' AS detalle;

-- 10. MEJORES PRÁCTICAS PARA JOINs

-- 1. Siempre especifica el tipo de JOIN (INNER, LEFT, RIGHT, FULL)
-- 2. Usa alias descriptivos para las tablas
-- 3. La condición ON debe ser clara y eficiente
-- 4. Evita el producto cartesiano (usar comas en lugar de JOIN)
-- 5. Considera el rendimiento: usa índices en las columnas de JOIN
-- 6. Ten en cuenta el orden de los JOINs para optimización
-- 7. Usa JOIN en lugar de subconsultas cuando sea posible
-- 8. Verifica la integridad referencial antes de hacer JOINs

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- Los conceptos son idénticos en MS SQL Server
-- Solo cambian algunas funciones específicas del sistema

-- Ejemplo de verificación de integridad referencial:
SELECT 
    'Empleados sin departamento válido' AS verificacion,
    COUNT(*) AS numero_empleados
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
WHERE d.id IS NULL

UNION ALL

SELECT 
    'Departamentos sin empleados' AS verificacion,
    COUNT(*) AS numero_departamentos
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
WHERE e.id IS NULL;

-- Diagrama de relaciones:
SELECT 
    'RELACIONES ENTRE TABLAS' AS titulo,
    '' AS detalle
UNION ALL
SELECT 
    'departamentos (1) ←→ empleados (N)' AS titulo,
    'departamentos.id ← empleados.departamento_id' AS detalle
UNION ALL
SELECT 
    'empleados (N) ←→ empleados_proyectos ←→ proyectos (N)' AS titulo,
    'empleados.id ← empleados_proyectos.empleado_id' AS detalle;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Sintaxis básica: Idéntica para JOINs estándar
-- 2. Funciones específicas: Pueden variar
-- 3. Optimización: Diferentes motores de consulta
-- 4. Índices: Diferentes tipos y estrategias
-- 5. Rendimiento: Puede variar entre sistemas

-- =====================================================
-- RESUMEN DE CONCEPTOS:
-- =====================================================
-- 1. JOINs combinan datos de múltiples tablas basándose en relaciones
-- 2. Las relaciones se establecen mediante claves primarias y foráneas
-- 3. INNER JOIN es el más común y solo incluye coincidencias
-- 4. OUTER JOINs incluyen filas sin coincidencias
-- 5. Evita el producto cartesiano usando JOINs apropiados
-- 6. Considera el rendimiento y usa índices en columnas de JOIN
-- 7. Verifica la integridad referencial antes de hacer JOINs complejos
