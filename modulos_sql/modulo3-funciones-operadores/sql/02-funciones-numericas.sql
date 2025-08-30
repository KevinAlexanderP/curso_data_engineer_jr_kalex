-- =====================================================
-- Script: Funciones Numéricas y Matemáticas
-- Módulo 3: Funciones y Operadores
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- 1. OPERACIONES MATEMÁTICAS BÁSICAS
-- Sintaxis: +, -, *, /, %, ^ (potencia)

-- Operaciones básicas con salarios
SELECT 
    nombre,
    salario,
    salario + 1000 AS salario_aumentado,
    salario - 500 AS salario_reducido,
    salario * 1.1 AS salario_10_porciento,
    salario / 12 AS salario_semanal,
    salario % 1000 AS residuo_division
FROM empleados;

-- Potencia y raíz cuadrada
SELECT 
    salario,
    salario ^ 2 AS salario_cuadrado,
    SQRT(salario) AS raiz_salario
FROM empleados;

-- 2. FUNCIONES DE REDONDEO Y TRUNCAMIENTO

-- ROUND() - redondear a un número específico de decimales
SELECT 
    salario,
    ROUND(salario, 0) AS salario_redondeado,
    ROUND(salario, -3) AS salario_redondeado_miles
FROM empleados;

-- CEIL() - redondear hacia arriba (techo)
SELECT 
    salario,
    CEIL(salario / 1000) * 1000 AS salario_redondeado_arriba_miles
FROM empleados;

-- FLOOR() - redondear hacia abajo (piso)
SELECT 
    salario,
    FLOOR(salario / 1000) * 1000 AS salario_redondeado_abajo_miles
FROM empleados;

-- TRUNC() - truncar decimales
SELECT 
    salario,
    TRUNC(salario, 0) AS salario_truncado,
    TRUNC(salario, -3) AS salario_truncado_miles
FROM empleados;

-- 3. FUNCIONES DE VALOR ABSOLUTO Y SIGNO

-- ABS() - valor absoluto
SELECT 
    salario - 70000 AS diferencia_salario,
    ABS(salario - 70000) AS diferencia_absoluta
FROM empleados;

-- SIGN() - signo del número (-1, 0, 1)
SELECT 
    salario - 70000 AS diferencia_salario,
    SIGN(salario - 70000) AS signo_diferencia
FROM empleados;

-- 4. FUNCIONES TRIGONOMÉTRICAS

-- Funciones trigonométricas básicas (los valores están en radianes)
SELECT 
    PI() AS pi,
    SIN(PI()/2) AS seno_90_grados,
    COS(PI()) AS coseno_180_grados,
    TAN(PI()/4) AS tangente_45_grados
FROM empleados
LIMIT 1;

-- Conversión de grados a radianes y viceversa
SELECT 
    RADIANS(90) AS noventa_grados_en_radianes,
    DEGREES(PI()/2) AS pi_medios_en_grados
FROM empleados
LIMIT 1;

-- 5. FUNCIONES LOGARÍTMICAS Y EXPONENCIALES

-- Funciones logarítmicas
SELECT 
    salario,
    LN(salario) AS logaritmo_natural,
    LOG(10, salario) AS logaritmo_base_10
FROM empleados;

-- Funciones exponenciales
SELECT 
    salario,
    EXP(1) AS numero_e,
    POWER(2, 10) AS dos_elevado_10
FROM empleados;

-- 6. FUNCIONES DE NÚMEROS ALEATORIOS

-- RANDOM() - número aleatorio entre 0 y 1
SELECT 
    nombre,
    RANDOM() AS numero_aleatorio,
    ROUND(RANDOM() * 100, 2) AS porcentaje_aleatorio
FROM empleados;

-- Generar números aleatorios en un rango específico
SELECT 
    nombre,
    FLOOR(RANDOM() * 100) + 1 AS numero_1_a_100,
    ROUND(RANDOM() * (100000 - 50000) + 50000, 2) AS salario_aleatorio_50k_a_100k
FROM empleados;

-- 7. FUNCIONES DE MÁXIMO Y MÍNIMO

-- GREATEST() y LEAST() - máximo y mínimo entre valores
SELECT 
    nombre,
    salario,
    GREATEST(salario, 60000, 70000) AS mayor_entre_salario_60k_70k,
    LEAST(salario, 60000, 70000) AS menor_entre_salario_60k_70k
FROM empleados;

-- 8. FUNCIONES DE MODULO Y DIVISIÓN ENTERA

-- MOD() - residuo de la división
SELECT 
    salario,
    MOD(salario, 1000) AS residuo_division_1000,
    salario - MOD(salario, 1000) AS salario_redondeado_abajo_1000
FROM empleados;

-- 9. FUNCIONES DE FORMATO NUMÉRICO

-- TO_CHAR() - formatear números como texto
SELECT 
    salario,
    TO_CHAR(salario, 'FM$999,999.00') AS salario_formateado,
    TO_CHAR(salario, 'FM999,999') AS salario_sin_decimales
FROM empleados;

-- 10. FUNCIONES COMBINADAS PARA CÁLCULOS COMPLEJOS

-- Calcular bonificación basada en salario y departamento
SELECT 
    nombre,
    departamento_id,
    salario,
    CASE 
        WHEN departamento_id = 1 THEN salario * 0.15  -- Desarrollo: 15%
        WHEN departamento_id = 3 THEN salario * 0.10  -- Marketing: 10%
        WHEN departamento_id = 4 THEN salario * 0.12  -- Finanzas: 12%
        ELSE salario * 0.08  -- Otros: 8%
    END AS bonificacion,
    salario + CASE 
        WHEN departamento_id = 1 THEN salario * 0.15
        WHEN departamento_id = 3 THEN salario * 0.10
        WHEN departamento_id = 4 THEN salario * 0.12
        ELSE salario * 0.08
    END AS salario_total_con_bonificacion
FROM empleados;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- 1. OPERACIONES MATEMÁTICAS BÁSICAS
SELECT 
    nombre,
    salario,
    salario + 1000 AS salario_aumentado,
    salario - 500 AS salario_reducido,
    salario * 1.1 AS salario_10_porciento,
    salario / 12 AS salario_semanal,
    salario % 1000 AS residuo_division
FROM empleados;

-- Potencia y raíz cuadrada
SELECT 
    salario,
    POWER(salario, 2) AS salario_cuadrado,
    SQRT(salario) AS raiz_salario
FROM empleados;

-- 2. FUNCIONES DE REDONDEO Y TRUNCAMIENTO

-- ROUND() - redondear a un número específico de decimales
SELECT 
    salario,
    ROUND(salario, 0) AS salario_redondeado,
    ROUND(salario, -3) AS salario_redondeado_miles
FROM empleados;

-- CEILING() - redondear hacia arriba (techo)
SELECT 
    salario,
    CEILING(salario / 1000.0) * 1000 AS salario_redondeado_arriba_miles
FROM empleados;

-- FLOOR() - redondear hacia abajo (piso)
SELECT 
    salario,
    FLOOR(salario / 1000.0) * 1000 AS salario_redondeado_abajo_miles
FROM empleados;

-- 3. FUNCIONES DE VALOR ABSOLUTO Y SIGNO

-- ABS() - valor absoluto
SELECT 
    salario - 70000 AS diferencia_salario,
    ABS(salario - 70000) AS diferencia_absoluta
FROM empleados;

-- SIGN() - signo del número (-1, 0, 1)
SELECT 
    salario - 70000 AS diferencia_salario,
    SIGN(salario - 70000) AS signo_diferencia
FROM empleados;

-- 4. FUNCIONES TRIGONOMÉTRICAS

-- Funciones trigonométricas básicas
SELECT 
    PI() AS pi,
    SIN(PI()/2) AS seno_90_grados,
    COS(PI()) AS coseno_180_grados,
    TAN(PI()/4) AS tangente_45_grados
FROM empleados;

-- Conversión de grados a radianes y viceversa
SELECT 
    RADIANS(90) AS noventa_grados_en_radianes,
    DEGREES(PI()/2) AS pi_medios_en_grados
FROM empleados;

-- 5. FUNCIONES LOGARÍTMICAS Y EXPONENCIALES

-- Funciones logarítmicas
SELECT 
    salario,
    LOG(salario) AS logaritmo_natural,
    LOG10(salario) AS logaritmo_base_10
FROM empleados;

-- Funciones exponenciales
SELECT 
    salario,
    EXP(1) AS numero_e,
    POWER(2, 10) AS dos_elevado_10
FROM empleados;

-- 6. FUNCIONES DE NÚMEROS ALEATORIOS

-- RAND() - número aleatorio entre 0 y 1
SELECT 
    nombre,
    RAND() AS numero_aleatorio,
    ROUND(RAND() * 100, 2) AS porcentaje_aleatorio
FROM empleados;

-- Generar números aleatorios en un rango específico
SELECT 
    nombre,
    FLOOR(RAND() * 100) + 1 AS numero_1_a_100,
    ROUND(RAND() * (100000 - 50000) + 50000, 2) AS salario_aleatorio_50k_a_100k
FROM empleados;

-- 7. FUNCIONES DE MÁXIMO Y MÍNIMO

-- IIF() para máximo y mínimo (SQL Server 2012+)
SELECT 
    nombre,
    salario,
    IIF(salario > 60000, salario, 60000) AS mayor_entre_salario_60k,
    IIF(salario < 60000, salario, 60000) AS menor_entre_salario_60k
FROM empleados;

-- 8. FUNCIONES DE MODULO Y DIVISIÓN ENTERA

-- % - residuo de la división
SELECT 
    salario,
    salario % 1000 AS residuo_division_1000,
    salario - (salario % 1000) AS salario_redondeado_abajo_1000
FROM empleados;

-- 9. FUNCIONES DE FORMATO NUMÉRICO

-- FORMAT() - formatear números (SQL Server 2012+)
SELECT 
    salario,
    FORMAT(salario, 'C') AS salario_formateado,
    FORMAT(salario, 'N0') AS salario_sin_decimales
FROM empleados;

-- 10. FUNCIONES COMBINADAS PARA CÁLCULOS COMPLEJOS

-- Calcular bonificación basada en salario y departamento
SELECT 
    nombre,
    departamento_id,
    salario,
    CASE 
        WHEN departamento_id = 1 THEN salario * 0.15  -- Desarrollo: 15%
        WHEN departamento_id = 3 THEN salario * 0.10  -- Marketing: 10%
        WHEN departamento_id = 4 THEN salario * 0.12  -- Finanzas: 12%
        ELSE salario * 0.08  -- Otros: 8%
    END AS bonificacion,
    salario + CASE 
        WHEN departamento_id = 1 THEN salario * 0.15
        WHEN departamento_id = 3 THEN salario * 0.10
        WHEN departamento_id = 4 THEN salario * 0.12
        ELSE salario * 0.08
    END AS salario_total_con_bonificacion
FROM empleados;
GO
*/

-- =====================================================
-- DIFERENCIAS CLAVE ENTRE POSTGRESQL Y MS SQL SERVER:
-- =====================================================
-- 1. Potencia:
--    - PostgreSQL: ^
--    - MS SQL Server: POWER()
-- 2. Redondeo hacia arriba:
--    - PostgreSQL: CEIL()
--    - MS SQL Server: CEILING()
-- 3. Logaritmo natural:
--    - PostgreSQL: LN()
--    - MS SQL Server: LOG()
-- 4. Logaritmo base 10:
--    - PostgreSQL: LOG(10, x)
--    - MS SQL Server: LOG10()
-- 5. Números aleatorios:
--    - PostgreSQL: RANDOM()
--    - MS SQL Server: RAND()
-- 6. Máximo y mínimo:
--    - PostgreSQL: GREATEST(), LEAST()
--    - MS SQL Server: IIF() o CASE
-- 7. Formateo:
--    - PostgreSQL: TO_CHAR()
--    - MS SQL Server: FORMAT()

-- =====================================================
-- MEJORES PRÁCTICAS:
-- =====================================================
-- 1. Usa funciones matemáticas en lugar de operaciones manuales cuando sea posible
-- 2. Ten cuidado con la división por cero
-- 3. Las funciones trigonométricas usan radianes, no grados
-- 4. RANDOM() y RAND() generan diferentes valores en cada fila
-- 5. Considera el rendimiento al usar funciones en cláusulas WHERE
-- 6. Usa CAST() o :: para conversiones de tipo explícitas
-- 7. Las funciones de redondeo pueden afectar la precisión de cálculos financieros
-- 8. Prueba las funciones en tu sistema específico antes de usar en producción
