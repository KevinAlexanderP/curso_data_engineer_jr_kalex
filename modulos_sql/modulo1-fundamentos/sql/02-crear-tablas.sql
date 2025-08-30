-- =====================================================
-- Script: Crear Tablas - Sistema de Empleados
-- Módulo 1: Fundamentos de SQL y Bases de Datos
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- Crear tabla de departamentos
CREATE TABLE IF NOT EXISTS departamentos (
    id SERIAL PRIMARY KEY,                    -- Clave primaria auto-incrementable
    nombre VARCHAR(100) NOT NULL,             -- Nombre del departamento (obligatorio)
    ubicacion VARCHAR(100),                   -- Ubicación del departamento
    presupuesto DECIMAL(12,2),                -- Presupuesto anual del departamento
    fecha_creacion DATE DEFAULT CURRENT_DATE  -- Fecha de creación del departamento
);

-- Crear tabla de empleados
CREATE TABLE IF NOT EXISTS empleados (
    id SERIAL PRIMARY KEY,                    -- Clave primaria auto-incrementable
    nombre VARCHAR(100) NOT NULL,             -- Nombre del empleado (obligatorio)
    apellido VARCHAR(100) NOT NULL,           -- Apellido del empleado (obligatorio)
    email VARCHAR(255) UNIQUE,                -- Email único del empleado
    telefono VARCHAR(20),                     -- Teléfono del empleado
    salario DECIMAL(10,2),                    -- Salario del empleado
    fecha_contratacion DATE DEFAULT CURRENT_DATE,  -- Fecha de contratación
    fecha_nacimiento DATE,                    -- Fecha de nacimiento
    departamento_id INTEGER REFERENCES departamentos(id),  -- Clave foránea al departamento
    activo BOOLEAN DEFAULT TRUE               -- Estado del empleado
);

-- Crear tabla de proyectos
CREATE TABLE IF NOT EXISTS proyectos (
    id SERIAL PRIMARY KEY,                    -- Clave primaria auto-incrementable
    nombre VARCHAR(200) NOT NULL,             -- Nombre del proyecto (obligatorio)
    descripcion TEXT,                         -- Descripción del proyecto
    fecha_inicio DATE,                        -- Fecha de inicio del proyecto
    fecha_fin DATE,                           -- Fecha de finalización del proyecto
    presupuesto DECIMAL(12,2),                -- Presupuesto del proyecto
    estado VARCHAR(50) DEFAULT 'Activo'       -- Estado del proyecto
);

-- Crear tabla intermedia para relación muchos a muchos entre empleados y proyectos
CREATE TABLE IF NOT EXISTS empleados_proyectos (
    empleado_id INTEGER REFERENCES empleados(id),      -- Clave foránea al empleado
    proyecto_id INTEGER REFERENCES proyectos(id),      -- Clave foránea al proyecto
    fecha_asignacion DATE DEFAULT CURRENT_DATE,        -- Fecha de asignación al proyecto
    rol VARCHAR(100),                                  -- Rol del empleado en el proyecto
    horas_asignadas INTEGER DEFAULT 0,                 -- Horas asignadas al proyecto
    PRIMARY KEY (empleado_id, proyecto_id)             -- Clave primaria compuesta
);

-- Crear tabla de habilidades
CREATE TABLE IF NOT EXISTS habilidades (
    id SERIAL PRIMARY KEY,                    -- Clave primaria auto-incrementable
    nombre VARCHAR(100) NOT NULL,             -- Nombre de la habilidad
    categoria VARCHAR(100),                   -- Categoría de la habilidad
    descripcion TEXT                          -- Descripción de la habilidad
);

-- Crear tabla intermedia para relación muchos a muchos entre empleados y habilidades
CREATE TABLE IF NOT EXISTS empleados_habilidades (
    empleado_id INTEGER REFERENCES empleados(id),      -- Clave foránea al empleado
    habilidad_id INTEGER REFERENCES habilidades(id),   -- Clave foránea a la habilidad
    nivel_experiencia INTEGER DEFAULT 1,               -- Nivel de experiencia (1-5)
    fecha_certificacion DATE,                          -- Fecha de certificación
    PRIMARY KEY (empleado_id, habilidad_id)            -- Clave primaria compuesta
);

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- Crear tabla de departamentos
CREATE TABLE departamentos (
    id INT IDENTITY(1,1) PRIMARY KEY,         -- Clave primaria auto-incrementable
    nombre NVARCHAR(100) NOT NULL,            -- Nombre del departamento (obligatorio)
    ubicacion NVARCHAR(100),                  -- Ubicación del departamento
    presupuesto DECIMAL(12,2),                -- Presupuesto anual del departamento
    fecha_creacion DATE DEFAULT GETDATE()     -- Fecha de creación del departamento
);

-- Crear tabla de empleados
CREATE TABLE empleados (
    id INT IDENTITY(1,1) PRIMARY KEY,         -- Clave primaria auto-incrementable
    nombre NVARCHAR(100) NOT NULL,            -- Nombre del empleado (obligatorio)
    apellido NVARCHAR(100) NOT NULL,          -- Apellido del empleado (obligatorio)
    email NVARCHAR(255) UNIQUE,               -- Email único del empleado
    telefono NVARCHAR(20),                    -- Teléfono del empleado
    salario DECIMAL(10,2),                    -- Salario del empleado
    fecha_contratacion DATE DEFAULT GETDATE(), -- Fecha de contratación
    fecha_nacimiento DATE,                    -- Fecha de nacimiento
    departamento_id INT FOREIGN KEY REFERENCES departamentos(id),  -- Clave foránea
    activo BIT DEFAULT 1                       -- Estado del empleado (1=activo, 0=inactivo)
);

-- Crear tabla de proyectos
CREATE TABLE proyectos (
    id INT IDENTITY(1,1) PRIMARY KEY,         -- Clave primaria auto-incrementable
    nombre NVARCHAR(200) NOT NULL,            -- Nombre del proyecto (obligatorio)
    descripcion NTEXT,                        -- Descripción del proyecto
    fecha_inicio DATE,                        -- Fecha de inicio del proyecto
    fecha_fin DATE,                           -- Fecha de finalización del proyecto
    presupuesto DECIMAL(12,2),                -- Presupuesto del proyecto
    estado NVARCHAR(50) DEFAULT 'Activo'      -- Estado del proyecto
);

-- Crear tabla intermedia para relación muchos a muchos
CREATE TABLE empleados_proyectos (
    empleado_id INT FOREIGN KEY REFERENCES empleados(id),      -- Clave foránea
    proyecto_id INT FOREIGN KEY REFERENCES proyectos(id),      -- Clave foránea
    fecha_asignacion DATE DEFAULT GETDATE(),                   -- Fecha de asignación
    rol NVARCHAR(100),                                         -- Rol del empleado
    horas_asignadas INT DEFAULT 0,                             -- Horas asignadas
    PRIMARY KEY (empleado_id, proyecto_id)                     -- Clave primaria compuesta
);

-- Crear tabla de habilidades
CREATE TABLE habilidades (
    id INT IDENTITY(1,1) PRIMARY KEY,         -- Clave primaria auto-incrementable
    nombre NVARCHAR(100) NOT NULL,            -- Nombre de la habilidad
    categoria NVARCHAR(100),                  -- Categoría de la habilidad
    descripcion NTEXT                          -- Descripción de la habilidad
);

-- Crear tabla intermedia para relación muchos a muchos
CREATE TABLE empleados_habilidades (
    empleado_id INT FOREIGN KEY REFERENCES empleados(id),      -- Clave foránea
    habilidad_id INT FOREIGN KEY REFERENCES habilidades(id),   -- Clave foránea
    nivel_experiencia INT DEFAULT 1,                           -- Nivel de experiencia
    fecha_certificacion DATE,                                  -- Fecha de certificación
    PRIMARY KEY (empleado_id, habilidad_id)                    -- Clave primaria compuesta
);
GO
*/

-- =====================================================
-- NOTAS IMPORTANTES:
-- =====================================================
-- 1. En PostgreSQL, usa SERIAL para auto-incremento
-- 2. En MS SQL Server, usa IDENTITY(1,1) para auto-incremento
-- 3. En PostgreSQL, usa BOOLEAN para valores true/false
-- 4. En MS SQL Server, usa BIT para valores 1/0
-- 5. En PostgreSQL, usa CURRENT_DATE para fecha actual
-- 6. En MS SQL Server, usa GETDATE() para fecha actual
-- 7. En PostgreSQL, usa TEXT para texto largo
-- 8. En MS SQL Server, usa NTEXT para texto largo
-- 9. En PostgreSQL, usa VARCHAR para texto variable
-- 10. En MS SQL Server, usa NVARCHAR para texto variable con soporte Unicode
