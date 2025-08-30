# 1.2 Conceptos de Bases de Datos Relacionales

## 🏗️ ¿Qué es una Base de Datos Relacional?

Una **base de datos relacional** es un tipo de base de datos que organiza los datos en **tablas** (también llamadas relaciones) que están relacionadas entre sí mediante **claves**.

## 📊 Componentes Principales

### 1. **Tablas (Tables)**
- **Definición**: Estructuras que almacenan datos organizados en filas y columnas
- **Ejemplo**: Una tabla `empleados` con columnas: id, nombre, apellido, salario, departamento_id

### 2. **Filas (Rows) o Registros**
- **Definición**: Cada fila representa un registro individual
- **Ejemplo**: Un empleado específico con sus datos completos

### 3. **Columnas (Columns) o Campos**
- **Definición**: Cada columna representa un atributo o característica
- **Ejemplo**: nombre, apellido, salario

## 🔑 Tipos de Claves

### **Clave Primaria (Primary Key)**
- **Propósito**: Identifica de manera única cada fila en una tabla
- **Características**:
  - No puede ser NULL
  - Debe ser única
  - Solo una por tabla
- **Ejemplo**: `id` en la tabla `empleados`

```sql
-- PostgreSQL
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,  -- SERIAL es auto-incrementable
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL
);

-- MS SQL Server
CREATE TABLE empleados (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- IDENTITY es auto-incrementable
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL
);
```

### **Clave Foránea (Foreign Key)**
- **Propósito**: Establece relaciones entre tablas
- **Características**:
  - Referencia a una clave primaria en otra tabla
  - Puede ser NULL (dependiendo del diseño)
  - Mantiene la integridad referencial

```sql
-- PostgreSQL
CREATE TABLE departamentos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento_id INTEGER REFERENCES departamentos(id)
);

-- MS SQL Server
CREATE TABLE departamentos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE empleados (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento_id INT FOREIGN KEY REFERENCES departamentos(id)
);
```

## 🔗 Tipos de Relaciones

### 1. **Uno a Uno (1:1)**
- **Definición**: Una fila en la tabla A se relaciona con exactamente una fila en la tabla B
- **Ejemplo**: Un empleado tiene exactamente un perfil de usuario

### 2. **Uno a Muchos (1:N)**
- **Definición**: Una fila en la tabla A se relaciona con múltiples filas en la tabla B
- **Ejemplo**: Un departamento tiene muchos empleados

### 3. **Muchos a Muchos (M:N)**
- **Definición**: Múltiples filas en la tabla A se relacionan con múltiples filas en la tabla B
- **Ejemplo**: Un empleado puede trabajar en múltiples proyectos, y un proyecto puede tener múltiples empleados

## 📐 Normalización Básica

### **¿Qué es la Normalización?**
Es el proceso de organizar los datos en tablas para reducir la redundancia y mejorar la integridad de los datos.

### **Primera Forma Normal (1NF)**
- **Regla**: Cada columna debe contener valores atómicos (indivisibles)
- **Ejemplo**: En lugar de una columna "direccion" con "Calle 123, Ciudad, País", usar columnas separadas

```sql
-- ❌ Mal: Una columna con múltiples valores
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    direccion_completa TEXT  -- Contiene múltiples valores
);

-- ✅ Bien: Columnas separadas
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    calle VARCHAR(200),
    ciudad VARCHAR(100),
    pais VARCHAR(100)
);
```

### **Segunda Forma Normal (2NF)**
- **Regla**: La tabla debe estar en 1NF y no debe tener dependencias parciales
- **Ejemplo**: Si tienes una tabla de pedidos con información del cliente, separar en dos tablas

### **Tercera Forma Normal (3NF)**
- **Regla**: La tabla debe estar en 2NF y no debe tener dependencias transitivas
- **Ejemplo**: Si tienes una tabla de empleados con información del departamento, separar en dos tablas

## 🎯 Ejemplo Práctico: Sistema de Empleados

```sql
-- PostgreSQL
-- Tabla de departamentos
CREATE TABLE departamentos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(100)
);

-- Tabla de empleados
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    salario DECIMAL(10,2),
    fecha_contratacion DATE DEFAULT CURRENT_DATE,
    departamento_id INTEGER REFERENCES departamentos(id)
);

-- Tabla de proyectos
CREATE TABLE proyectos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE
);

-- Tabla intermedia para relación muchos a muchos
CREATE TABLE empleados_proyectos (
    empleado_id INTEGER REFERENCES empleados(id),
    proyecto_id INTEGER REFERENCES proyectos(id),
    fecha_asignacion DATE DEFAULT CURRENT_DATE,
    rol VARCHAR(100),
    PRIMARY KEY (empleado_id, proyecto_id)
);
```

## 🔍 Diferencias entre PostgreSQL y MS SQL Server

| Concepto | PostgreSQL | MS SQL Server |
|----------|------------|---------------|
| **Auto-incremento** | `SERIAL` o `BIGSERIAL` | `IDENTITY(1,1)` |
| **Tipos de texto** | `VARCHAR`, `TEXT` | `VARCHAR`, `NVARCHAR`, `TEXT` |
| **Tipos numéricos** | `INTEGER`, `DECIMAL` | `INT`, `DECIMAL` |
| **Fechas** | `DATE`, `TIMESTAMP` | `DATE`, `DATETIME2` |
| **Referencias** | `REFERENCES` | `FOREIGN KEY REFERENCES` |

## 💡 Mejores Prácticas

1. **Nombres descriptivos**: Usa nombres claros para tablas y columnas
2. **Consistencia**: Mantén un estándar de nomenclatura
3. **Documentación**: Comenta tu esquema de base de datos
4. **Índices**: Crea índices en claves foráneas para mejorar el rendimiento
5. **Restricciones**: Usa restricciones para mantener la integridad de los datos

## 🎯 Resumen

Las bases de datos relacionales son la base del SQL. Comprender estos conceptos te permitirá:
- Diseñar esquemas de base de datos eficientes
- Escribir consultas más efectivas
- Mantener la integridad de los datos
- Optimizar el rendimiento de las consultas

---

**¡Siguiente paso: Instalación y Configuración!** 🛠️
