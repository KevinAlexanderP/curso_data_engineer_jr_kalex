-- =====================================================
-- Script: Crear Base de Datos - Sistema de Empleados
-- Módulo 1: Fundamentos de SQL y Bases de Datos
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- Crear la base de datos
-- Nota: En PostgreSQL, debes estar conectado como superusuario
-- o tener permisos para crear bases de datos
CREATE DATABASE IF NOT EXISTS empresa_db;

-- Conectar a la base de datos creada
-- \c empresa_db;

-- =====================================================
-- MS SQL SERVER
-- =====================================================

-- Crear la base de datos
-- Nota: En MS SQL Server, debes tener permisos de administrador
-- CREATE DATABASE empresa_db;
-- GO

-- Usar la base de datos creada
-- USE empresa_db;
-- GO

-- =====================================================
-- NOTAS IMPORTANTES:
-- =====================================================
-- 1. En PostgreSQL, usa CREATE DATABASE IF NOT EXISTS
-- 2. En MS SQL Server, usa CREATE DATABASE (no existe IF NOT EXISTS)
-- 3. En PostgreSQL, usa \c para conectar
-- 4. En MS SQL Server, usa USE para conectar
-- 5. En MS SQL Server, usa GO para separar lotes de comandos
