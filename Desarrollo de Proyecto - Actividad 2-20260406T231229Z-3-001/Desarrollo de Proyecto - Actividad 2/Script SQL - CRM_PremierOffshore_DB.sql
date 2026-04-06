-- Creación y uso de la base de datos
CREATE DATABASE IF NOT EXISTS CRM_PremierOffshore;
USE CRM_PremierOffshore;

-- 1. Tabla de Roles y Usuarios (Basado en RF-12 y RNF-03)
CREATE TABLE Roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL -- Agente, Supervisor, Administrador
);

CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena_hash VARCHAR(255) NOT NULL,
    id_rol INT NOT NULL,
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol)
);

-- 2. Tabla de Contactos / Clientes (Basado en RF-01 y RF-02)
CREATE TABLE Contactos (
    id_contacto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    empresa VARCHAR(100),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    pais VARCHAR(50),
    idioma_preferido VARCHAR(20),
    estado VARCHAR(20) DEFAULT 'Activo', -- Activo/Inactivo
    id_agente_asignado INT, -- Conecta con el Agente (RF-12)
    FOREIGN KEY (id_agente_asignado) REFERENCES Usuarios(id_usuario)
);

-- 3. Tabla de Interacciones (Basado en RF-04 y RF-05)
CREATE TABLE Interacciones (
    id_interaccion INT AUTO_INCREMENT PRIMARY KEY,
    id_contacto INT NOT NULL,
    id_usuario INT NOT NULL, -- Agente que realizó la interacción
    tipo_interaccion VARCHAR(20) NOT NULL, -- Llamada, Correo, Chat
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP, -- devuelve la fecha y hora actuales del sistema en formato 'YYYY-MM-DD HH:MM:SS'
    duracion_minutos INT,
    resultado TEXT,
    FOREIGN KEY (id_contacto) REFERENCES Contactos(id_contacto) ON DELETE CASCADE, -- restricción de clave foránea, automatiza eliminación de registros. Cuando se elimina un registro en una tabla principal (padre), todos los registros relacionados en la tabla dependiente (hijo) se borran automáticamente, asegura integridad referencial, evita datos huérfanos.
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

-- 4. Tabla de Oportunidades / Pipeline (Basado en RF-06)
CREATE TABLE Oportunidades (
    id_oportunidad INT AUTO_INCREMENT PRIMARY KEY,
    id_contacto INT NOT NULL,
    id_usuario INT NOT NULL,
    etapa VARCHAR(50) NOT NULL, -- Prospecto, Contactado, Propuesta, Negociación, Cerrado
    monto_estimado DECIMAL(10,2), -- (Agregado por recomendación analítica)
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_contacto) REFERENCES Contactos(id_contacto) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

-- 5. Tabla de Tareas (Basado en RF-07 y RF-08)
CREATE TABLE Tareas (
    id_tarea INT AUTO_INCREMENT PRIMARY KEY,
    descripcion TEXT NOT NULL, -- Este campo debe tener texto obligatoriamente
    fecha_limite DATETIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'Pendiente',
    id_usuario_asignado INT NOT NULL, -- Asignada a agentes específicos
    id_contacto INT, -- Contacto relacionado a la tarea (Opcional)
    FOREIGN KEY (id_usuario_asignado) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_contacto) REFERENCES Contactos(id_contacto) ON DELETE CASCADE
);

-- 6. Tabla de Log de Auditoría (Basado en RF-13)
CREATE TABLE Log_Auditoria (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    accion VARCHAR(50) NOT NULL, -- Edición, Eliminación
    tabla_afectada VARCHAR(50) NOT NULL,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);


-- ==========================================================
-- SCRIPT DE INSERCIÓN DE DATOS DE PRUEBA
-- ==========================================================

-- 1. Insertar Roles (Basado en requerimiento RF-12) [cite: 31]
INSERT INTO Roles (nombre_rol) VALUES 
('Agente'), 
('Supervisor'), 
('Administrador');

-- 2. Insertar Usuarios (datos ficticios)
-- Contraseñas ejemplo de cómo se vería un hash (ej. bcrypt) [cite: 35]
INSERT INTO Usuarios (nombre, correo, contrasena_hash, id_rol) VALUES 
('Marcos Valdez', 'mvaldez@premieroffshore.com', '$2y$10$EjemploHashSeguro12345', 3), -- Admin
('Daniela Rosario', 'drosario@premieroffshore.com', '$2y$10$EjemploHashSeguro12345', 2), -- Supervisor
('Javier Castillo', 'jcastillo@premieroffshore.com', '$2y$10$EjemploHashSeguro12345', 1), -- Agente
('Sofia Reyes', 'sreyes@premieroffshore.com', '$2y$10$EjemploHashSeguro12345', 1); -- Agente

-- 3. Insertar Contactos / Clientes Internacionales
INSERT INTO Contactos (nombre, empresa, telefono, correo, pais, idioma_preferido, estado, id_agente_asignado) VALUES 
('John Smith', 'TechGlobal USA', '+1-555-0198', 'jsmith@techglobal.com', 'Estados Unidos', 'Inglés', 'Activo', 3),
('Sarah Jenkins', 'London Logistics', '+44-20-7946', 'sjenkins@londonlogistics.co.uk', 'Reino Unido', 'Inglés', 'Activo', 4),
('Miguel Santos', 'Importaciones DR', '+1-809-555-1234', 'msantos@impdr.com', 'República Dominicana', 'Español', 'Inactivo', 3);

-- 4. Insertar Interacciones (Basado en RF-04) [cite: 31]
INSERT INTO Interacciones (id_contacto, id_usuario, tipo_interaccion, duracion_minutos, resultado) VALUES 
(1, 3, 'Llamada', 15, 'El cliente está interesado en el servicio de soporte Tier 1. Solicita propuesta.'),
(2, 4, 'Correo', 0, 'Se envió el brochure de servicios bilingües. A la espera de respuesta.'),
(1, 3, 'Chat', 5, 'Resolución de dudas rápidas sobre horarios de cobertura.');

-- 5. Insertar Oportunidades / Pipeline (Basado en RF-06) [cite: 31]
INSERT INTO Oportunidades (id_contacto, id_usuario, etapa, monto_estimado) VALUES 
(1, 3, 'Propuesta', 15000.00),
(2, 4, 'Contactado', 8500.50),
(3, 3, 'Cerrado', 0.00); -- Oportunidad perdida/inactiva

-- 6. Insertar Tareas (Basado en RF-07) [cite: 31]
-- Usamos fechas futuras para las fechas límite
INSERT INTO Tareas (descripcion, fecha_limite, estado, id_usuario_asignado, id_contacto) VALUES 
('Llamar a John para dar seguimiento a la propuesta enviada', '2026-03-20 10:00:00', 'Pendiente', 3, 1),
('Preparar contrato de servicios para London Logistics', '2026-03-15 14:30:00', 'Pendiente', 4, 2);

-- 7. Insertar Log de Auditoría (Basado en RF-13) [cite: 31]
INSERT INTO Log_Auditoria (id_usuario, accion, tabla_afectada) VALUES 
(1, 'Creación de Rol', 'Roles'),
(2, 'Edición de Estado de Contacto', 'Contactos');