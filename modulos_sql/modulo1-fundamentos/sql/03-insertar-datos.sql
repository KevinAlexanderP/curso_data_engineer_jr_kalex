-- =====================================================
-- Script: Insertar Datos de Ejemplo
-- Módulo 1: Fundamentos de SQL y Bases de Datos
-- Curso: SQL para Ingenieros de Datos Junior
-- =====================================================

-- =====================================================
-- POSTGRESQL
-- =====================================================

-- Insertar departamentos
INSERT INTO departamentos (nombre, ubicacion, presupuesto) VALUES
('Desarrollo de Software', 'Edificio A, Piso 3', 500000.00),
('Recursos Humanos', 'Edificio B, Piso 1', 200000.00),
('Marketing', 'Edificio A, Piso 2', 300000.00),
('Finanzas', 'Edificio B, Piso 2', 400000.00),
('Operaciones', 'Edificio C, Piso 1', 350000.00);

-- Insertar empleados
INSERT INTO empleados (nombre, apellido, email, telefono, salario, fecha_nacimiento, departamento_id) VALUES
('Ana', 'García', 'ana.garcia@empresa.com', '555-0101', 65000.00, '1990-05-15', 1),
('Carlos', 'López', 'carlos.lopez@empresa.com', '555-0102', 70000.00, '1988-03-22', 1),
('María', 'Rodríguez', 'maria.rodriguez@empresa.com', '555-0103', 55000.00, '1992-07-10', 2),
('Juan', 'Martínez', 'juan.martinez@empresa.com', '555-0104', 60000.00, '1985-11-30', 3),
('Laura', 'Fernández', 'laura.fernandez@empresa.com', '555-0105', 75000.00, '1987-09-18', 1),
('Roberto', 'Sánchez', 'roberto.sanchez@empresa.com', '555-0106', 68000.00, '1991-12-05', 4),
('Carmen', 'González', 'carmen.gonzalez@empresa.com', '555-0107', 52000.00, '1993-04-25', 2),
('Diego', 'Pérez', 'diego.perez@empresa.com', '555-0108', 72000.00, '1989-06-12', 1),
('Sofia', 'Hernández', 'sofia.hernandez@empresa.com', '555-0109', 58000.00, '1994-01-08', 3),
('Miguel', 'Torres', 'miguel.torres@empresa.com', '555-0110', 80000.00, '1986-08-20', 5);

-- Insertar proyectos
INSERT INTO proyectos (nombre, descripcion, fecha_inicio, fecha_fin, presupuesto, estado) VALUES
('Sistema de Gestión ERP', 'Desarrollo de un sistema ERP completo para la empresa', '2024-01-15', '2024-12-31', 150000.00, 'En Progreso'),
('Portal Web Corporativo', 'Rediseño del portal web de la empresa', '2024-03-01', '2024-08-31', 80000.00, 'En Progreso'),
('App Móvil de Ventas', 'Aplicación móvil para el equipo de ventas', '2024-02-01', '2024-07-31', 120000.00, 'En Progreso'),
('Migración a la Nube', 'Migración de sistemas legacy a la nube', '2024-04-01', '2024-11-30', 200000.00, 'Planificado'),
('Análisis de Datos', 'Implementación de herramientas de análisis de datos', '2024-05-01', '2024-10-31', 90000.00, 'Planificado');

-- Insertar habilidades
INSERT INTO habilidades (nombre, categoria, descripcion) VALUES
('Python', 'Lenguajes de Programación', 'Lenguaje de programación de alto nivel'),
('Java', 'Lenguajes de Programación', 'Lenguaje de programación orientado a objetos'),
('SQL', 'Bases de Datos', 'Lenguaje de consulta estructurada'),
('PostgreSQL', 'Bases de Datos', 'Sistema de gestión de bases de datos relacional'),
('React', 'Frontend', 'Biblioteca de JavaScript para interfaces de usuario'),
('Node.js', 'Backend', 'Entorno de ejecución de JavaScript del lado del servidor'),
('Docker', 'DevOps', 'Plataforma para contenerización de aplicaciones'),
('AWS', 'Cloud Computing', 'Servicios de computación en la nube de Amazon'),
('Machine Learning', 'Inteligencia Artificial', 'Técnicas de aprendizaje automático'),
('Análisis de Datos', 'Analytics', 'Procesamiento y análisis de datos');

-- Insertar asignaciones de empleados a proyectos
INSERT INTO empleados_proyectos (empleado_id, proyecto_id, rol, horas_asignadas) VALUES
(1, 1, 'Líder de Proyecto', 160),
(2, 1, 'Desarrollador Senior', 120),
(5, 1, 'Desarrollador', 100),
(8, 1, 'Desarrollador', 100),
(1, 2, 'Arquitecto de Software', 80),
(2, 2, 'Desarrollador Frontend', 120),
(5, 2, 'Desarrollador Backend', 100),
(3, 3, 'Analista de Negocios', 80),
(4, 3, 'Diseñador UX/UI', 100),
(9, 3, 'Desarrollador Móvil', 120),
(6, 4, 'Arquitecto de Soluciones', 160),
(8, 4, 'DevOps Engineer', 120),
(10, 4, 'Ingeniero de Sistemas', 100),
(7, 5, 'Analista de Datos', 120),
(9, 5, 'Científico de Datos', 100);

-- Insertar habilidades de empleados
INSERT INTO empleados_habilidades (empleado_id, habilidad_id, nivel_experiencia, fecha_certificacion) VALUES
(1, 1, 5, '2023-06-15'),  -- Ana: Python nivel 5
(1, 3, 5, '2023-08-20'),  -- Ana: SQL nivel 5
(1, 4, 4, '2023-09-10'),  -- Ana: PostgreSQL nivel 4
(2, 2, 5, '2023-07-01'),  -- Carlos: Java nivel 5
(2, 3, 4, '2023-08-15'),  -- Carlos: SQL nivel 4
(2, 6, 4, '2023-10-05'),  -- Carlos: Node.js nivel 4
(5, 1, 4, '2023-05-20'),  -- Laura: Python nivel 4
(5, 5, 4, '2023-06-30'),  -- Laura: React nivel 4
(5, 5, 3, '2023-07-15'),  -- Laura: SQL nivel 3
(8, 1, 4, '2023-08-01'),  -- Diego: Python nivel 4
(8, 7, 4, '2023-09-20'),  -- Diego: Docker nivel 4
(8, 8, 3, '2023-10-10'),  -- Diego: AWS nivel 3
(10, 9, 5, '2023-11-01'), -- Miguel: Machine Learning nivel 5
(10, 10, 5, '2023-12-01'), -- Miguel: Análisis de Datos nivel 5
(10, 3, 4, '2023-11-15'); -- Miguel: SQL nivel 4

-- =====================================================
-- MS SQL SERVER
-- =====================================================

/*
-- Insertar departamentos
INSERT INTO departamentos (nombre, ubicacion, presupuesto) VALUES
('Desarrollo de Software', 'Edificio A, Piso 3', 500000.00),
('Recursos Humanos', 'Edificio B, Piso 1', 200000.00),
('Marketing', 'Edificio A, Piso 2', 300000.00),
('Finanzas', 'Edificio B, Piso 2', 400000.00),
('Operaciones', 'Edificio C, Piso 1', 350000.00);

-- Insertar empleados
INSERT INTO empleados (nombre, apellido, email, telefono, salario, fecha_nacimiento, departamento_id) VALUES
('Ana', 'García', 'ana.garcia@empresa.com', '555-0101', 65000.00, '1990-05-15', 1),
('Carlos', 'López', 'carlos.lopez@empresa.com', '555-0102', 70000.00, '1988-03-22', 1),
('María', 'Rodríguez', 'maria.rodriguez@empresa.com', '555-0103', 55000.00, '1992-07-10', 2),
('Juan', 'Martínez', 'juan.martinez@empresa.com', '555-0104', 60000.00, '1985-11-30', 3),
('Laura', 'Fernández', 'laura.fernandez@empresa.com', '555-0105', 75000.00, '1987-09-18', 1),
('Roberto', 'Sánchez', 'roberto.sanchez@empresa.com', '555-0106', 68000.00, '1991-12-05', 4),
('Carmen', 'González', 'carmen.gonzalez@empresa.com', '555-0107', 52000.00, '1993-04-25', 2),
('Diego', 'Pérez', 'diego.perez@empresa.com', '555-0108', 72000.00, '1989-06-12', 1),
('Sofia', 'Hernández', 'sofia.hernandez@empresa.com', '555-0109', 58000.00, '1994-01-08', 3),
('Miguel', 'Torres', 'miguel.torres@empresa.com', '555-0110', 80000.00, '1986-08-20', 5);

-- Insertar proyectos
INSERT INTO proyectos (nombre, descripcion, fecha_inicio, fecha_fin, presupuesto, estado) VALUES
('Sistema de Gestión ERP', 'Desarrollo de un sistema ERP completo para la empresa', '2024-01-15', '2024-12-31', 150000.00, 'En Progreso'),
('Portal Web Corporativo', 'Rediseño del portal web de la empresa', '2024-03-01', '2024-08-31', 80000.00, 'En Progreso'),
('App Móvil de Ventas', 'Aplicación móvil para el equipo de ventas', '2024-02-01', '2024-07-31', 120000.00, 'En Progreso'),
('Migración a la Nube', 'Migración de sistemas legacy a la nube', '2024-04-01', '2024-11-30', 200000.00, 'Planificado'),
('Análisis de Datos', 'Implementación de herramientas de análisis de datos', '2024-05-01', '2024-10-31', 90000.00, 'Planificado');

-- Insertar habilidades
INSERT INTO habilidades (nombre, categoria, descripcion) VALUES
('Python', 'Lenguajes de Programación', 'Lenguaje de programación de alto nivel'),
('Java', 'Lenguajes de Programación', 'Lenguaje de programación orientado a objetos'),
('SQL', 'Bases de Datos', 'Lenguaje de consulta estructurada'),
('PostgreSQL', 'Bases de Datos', 'Sistema de gestión de bases de datos relacional'),
('React', 'Frontend', 'Biblioteca de JavaScript para interfaces de usuario'),
('Node.js', 'Backend', 'Entorno de ejecución de JavaScript del lado del servidor'),
('Docker', 'DevOps', 'Plataforma para contenerización de aplicaciones'),
('AWS', 'Cloud Computing', 'Servicios de computación en la nube de Amazon'),
('Machine Learning', 'Inteligencia Artificial', 'Técnicas de aprendizaje automático'),
('Análisis de Datos', 'Analytics', 'Procesamiento y análisis de datos');

-- Insertar asignaciones de empleados a proyectos
INSERT INTO empleados_proyectos (empleado_id, proyecto_id, rol, horas_asignadas) VALUES
(1, 1, 'Líder de Proyecto', 160),
(2, 1, 'Desarrollador Senior', 120),
(5, 1, 'Desarrollador', 100),
(8, 1, 'Desarrollador', 100),
(1, 2, 'Arquitecto de Software', 80),
(2, 2, 'Desarrollador Frontend', 120),
(5, 2, 'Desarrollador Backend', 100),
(3, 3, 'Analista de Negocios', 80),
(4, 3, 'Diseñador UX/UI', 100),
(9, 3, 'Desarrollador Móvil', 120),
(6, 4, 'Arquitecto de Soluciones', 160),
(8, 4, 'DevOps Engineer', 120),
(10, 4, 'Ingeniero de Sistemas', 100),
(7, 5, 'Analista de Datos', 120),
(9, 5, 'Científico de Datos', 100);

-- Insertar habilidades de empleados
INSERT INTO empleados_habilidades (empleado_id, habilidad_id, nivel_experiencia, fecha_certificacion) VALUES
(1, 1, 5, '2023-06-15'),  -- Ana: Python nivel 5
(1, 3, 5, '2023-08-20'),  -- Ana: SQL nivel 5
(1, 4, 4, '2023-09-10'),  -- Ana: PostgreSQL nivel 4
(2, 2, 5, '2023-07-01'),  -- Carlos: Java nivel 5
(2, 3, 4, '2023-08-15'),  -- Carlos: SQL nivel 4
(2, 6, 4, '2023-10-05'),  -- Carlos: Node.js nivel 4
(5, 1, 4, '2023-05-20'),  -- Laura: Python nivel 4
(5, 5, 4, '2023-06-30'),  -- Laura: React nivel 4
(5, 5, 3, '2023-07-15'),  -- Laura: SQL nivel 3
(8, 1, 4, '2023-08-01'),  -- Diego: Python nivel 4
(8, 7, 4, '2023-09-20'),  -- Diego: Docker nivel 4
(8, 8, 3, '2023-10-10'),  -- Diego: AWS nivel 3
(10, 9, 5, '2023-11-01'), -- Miguel: Machine Learning nivel 5
(10, 10, 5, '2023-12-01'), -- Miguel: Análisis de Datos nivel 5
(10, 3, 4, '2023-11-15'); -- Miguel: SQL nivel 4
GO
*/

-- =====================================================
-- NOTAS IMPORTANTES:
-- =====================================================
-- 1. En PostgreSQL, las fechas se escriben como 'YYYY-MM-DD'
-- 2. En MS SQL Server, las fechas también se escriben como 'YYYY-MM-DD'
-- 3. En PostgreSQL, los valores booleanos son TRUE/FALSE
-- 4. En MS SQL Server, los valores bit son 1/0
-- 5. En PostgreSQL, no es necesario usar GO
-- 6. En MS SQL Server, es recomendable usar GO para separar lotes
-- 7. Los datos de ejemplo incluyen 10 empleados, 5 departamentos, 5 proyectos y 10 habilidades
-- 8. Las relaciones están configuradas para demostrar diferentes tipos de JOINs
