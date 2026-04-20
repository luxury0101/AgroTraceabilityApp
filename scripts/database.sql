-- ============================================================
-- AgroTraceability - Script de Base de Datos MySQL
-- Sistema Móvil de Gestión y Trazabilidad Agrícola
-- Barbosa, Santander
-- ============================================================

DROP DATABASE IF EXISTS agrotraceability_db;
CREATE DATABASE agrotraceability_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE agrotraceability_db;

-- ============================================================
-- TABLA: roles
-- ============================================================
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: users
-- ============================================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    username VARCHAR(80) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role_id INT NOT NULL DEFAULT 2,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: productores
-- ============================================================
CREATE TABLE productores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    documento VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    municipio VARCHAR(100) DEFAULT 'Barbosa',
    departamento VARCHAR(100) DEFAULT 'Santander',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_productores_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: lotes
-- ============================================================
CREATE TABLE lotes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    productor_id INT NOT NULL,
    codigo VARCHAR(20) NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    ubicacion VARCHAR(255),
    area_hectareas DECIMAL(10,2),
    tipo_cultivo VARCHAR(100),
    variedad VARCHAR(100),
    fecha_siembra_estimada DATE,
    fecha_cosecha_estimada DATE,
    estado ENUM('activo','en_produccion','cosechado','inactivo') DEFAULT 'activo',
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_lotes_productor FOREIGN KEY (productor_id) REFERENCES productores(id),
    UNIQUE KEY uk_lote_codigo_productor (productor_id, codigo)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: tipos_evento
-- ============================================================
CREATE TABLE tipos_evento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    icono VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: eventos_productivos
-- ============================================================
CREATE TABLE eventos_productivos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lote_id INT NOT NULL,
    tipo_evento_id INT NOT NULL,
    usuario_id INT NOT NULL,
    fecha_evento DATE NOT NULL,
    descripcion TEXT,
    observaciones TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_eventos_lote FOREIGN KEY (lote_id) REFERENCES lotes(id),
    CONSTRAINT fk_eventos_tipo FOREIGN KEY (tipo_evento_id) REFERENCES tipos_evento(id),
    CONSTRAINT fk_eventos_usuario FOREIGN KEY (usuario_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: insumos
-- ============================================================
CREATE TABLE insumos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    tipo VARCHAR(80),
    unidad_medida VARCHAR(30),
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: evento_insumos (tabla intermedia)
-- ============================================================
CREATE TABLE evento_insumos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evento_id INT NOT NULL,
    insumo_id INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ei_evento FOREIGN KEY (evento_id) REFERENCES eventos_productivos(id),
    CONSTRAINT fk_ei_insumo FOREIGN KEY (insumo_id) REFERENCES insumos(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: evidencias
-- ============================================================
CREATE TABLE evidencias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evento_id INT NOT NULL,
    tipo_archivo VARCHAR(50),
    nombre_archivo VARCHAR(255),
    url_archivo TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_evidencias_evento FOREIGN KEY (evento_id) REFERENCES eventos_productivos(id)
) ENGINE=InnoDB;

-- ============================================================
-- TABLA: auditoria
-- ============================================================
CREATE TABLE auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    entidad VARCHAR(80) NOT NULL,
    entidad_id INT,
    operacion ENUM('CREATE','UPDATE','DELETE') NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auditoria_usuario FOREIGN KEY (usuario_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- ============================================================
-- DATOS SEMILLA
-- ============================================================

-- Roles
INSERT INTO roles (nombre, descripcion) VALUES
('admin', 'Administrador del sistema'),
('productor', 'Productor agrícola'),
('operario', 'Operario de campo');

-- Tipos de evento
INSERT INTO tipos_evento (nombre, descripcion, icono) VALUES
('Siembra', 'Actividad de siembra en el lote', 'seedling'),
('Riego', 'Aplicación de riego al cultivo', 'water'),
('Fertilización', 'Aplicación de fertilizantes', 'flask'),
('Control de plagas', 'Aplicación de pesticidas o control biológico', 'bug'),
('Cosecha', 'Recolección de la producción', 'basket'),
('Incidencia', 'Novedad o evento no planificado', 'alert'),
('Poda', 'Actividad de poda del cultivo', 'scissors'),
('Preparación de suelo', 'Preparación y acondicionamiento del terreno', 'shovel');

SELECT 'Base de datos creada exitosamente.' AS resultado;