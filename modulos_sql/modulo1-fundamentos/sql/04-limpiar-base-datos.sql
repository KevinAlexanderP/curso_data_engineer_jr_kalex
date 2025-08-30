-- =====================================================
-- Script: Limpiar Base de Datos
-- Módulo 1: Fundamentos de SQL y Bases de Datos
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- Eliminar las tablas en orden correcto (respetando las claves foráneas)
-- Primero eliminamos las tablas intermedias que dependen de otras
DROP TABLE IF EXISTS empleados_habilidades CASCADE;
DROP TABLE IF EXISTS empleados_proyectos CASCADE;

-- Luego eliminamos las tablas principales
DROP TABLE IF EXISTS habilidades CASCADE;
DROP TABLE IF EXISTS proyectos CASCADE;
DROP TABLE IF EXISTS empleados CASCADE;
DROP TABLE IF EXISTS departamentos CASCADE;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- Eliminar las tablas en orden correcto (respetando las claves foráneas)
-- Primero eliminamos las tablas intermedias que dependen de otras
IF OBJECT_ID('empleados_habilidades', 'U') IS NOT NULL
    DROP TABLE empleados_habilidades;

IF OBJECT_ID('empleados_proyectos', 'U') IS NOT NULL
    DROP TABLE empleados_proyectos;

-- Luego eliminamos las tablas principales
IF OBJECT_ID('habilidades', 'U') IS NOT NULL
    DROP TABLE habilidades;

IF OBJECT_ID('proyectos', 'U') IS NOT NULL
    DROP TABLE proyectos;

IF OBJECT_ID('empleados', 'U') IS NOT NULL
    DROP TABLE empleados;

IF OBJECT_ID('departamentos', 'U') IS NOT NULL
    DROP TABLE departamentos;
GO
*/

-- =====================================================
-- NOTAS IMPORTANTES:
-- =====================================================
-- 1. En PostgreSQL, CASCADE elimina automáticamente las dependencias
-- 2. En MS SQL Server, debes verificar si la tabla existe antes de eliminarla
-- 3. El orden de eliminación es importante: primero las tablas intermedias
-- 4. En PostgreSQL, IF EXISTS es estándar
-- 5. En MS SQL Server, debes usar IF OBJECT_ID para verificar existencia
-- 6. En MS SQL Server, usa GO para separar lotes de comandos
-- 7. Este script es útil para reiniciar el curso desde cero
