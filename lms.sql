--Inicio de repositorio

USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'lmsDB')
	BEGIN
		DROP DATABASE lmsDB
	END
GO

CREATE DATABASE lmsDB
GO

USE lmsDB
GO

CREATE SCHEMA GestionRolesPermisos
GO

CREATE SCHEMA GestionIdentidadAcad
GO

-- Modulo 2: Gestion de identidad academica
CREATE SCHEMA GestionIdentidadAcad
GO

-- Tabla Usuarios
CREATE TABLE GestionIdentidadAcad.Usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(150) UNIQUE NOT NULL,           
    pass_hash NVARCHAR(255) NOT NULL,               
    estado_usuario BIT NOT NULL DEFAULT 1,          
    id_rol INT NOT NULL, 
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at),
	deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at),
    CONSTRAINT FK_Usuarios_Roles FOREIGN KEY (id_rol)
        REFERENCES GestionRolesPermisos.Roles(id_rol)                  
)
GO

-- Tabla Perfil de datos de los usuarios
CREATE TABLE GestionIdentidadAcad.Perfiles_Datos (
    id_perfil INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre NVARCHAR(100) NOT NULL,
    apellido NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20) NULL,
    carrera NVARCHAR(100) NULL,
    cif NVARCHAR(20) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at),
    deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at),
    CONSTRAINT FK_Perfiles_Usuarios FOREIGN KEY (id_usuario)
        REFERENCES GestionIdentidadAcad.Usuarios(id_usuario)
)
GO

-- Tabla materias
CREATE TABLE GestionIdentidadAcad.Materias (
    id_mat INT IDENTITY(1,1) PRIMARY KEY,      
    nombre_materia NVARCHAR(100) UNIQUE NOT NULL,  
    id_usuario INT NOT NULL,  
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at),
	deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at),
    CONSTRAINT FK_Materias_Usuarios FOREIGN KEY (id_usuario)
        REFERENCES GestionIdentidadAcad.Usuarios(id_usuario)
)
GO

-- Tabla de Disponibilidad
CREATE TABLE GestionIdentidadAcad.Disponibilidad (
    id_disp INT IDENTITY(1,1) PRIMARY KEY,
    id_tutor INT NOT NULL,
    dia_semana NVARCHAR(15) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at),
    deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at),
    CONSTRAINT FK_Disponibilidad_Tutor FOREIGN KEY (id_tutor)
        REFERENCES GestionIdentidadAcad.Usuarios(id_usuario),
    CONSTRAINT CK_Horas_Validas CHECK (hora_inicio < hora_fin)
)
GO

-- Tabla de Sesiones
CREATE TABLE GestionIdentidadAcad.Sesiones (
    id_sesion INT IDENTITY(1,1) PRIMARY KEY,
    id_tutor INT NOT NULL,
    id_mat INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    lugar NVARCHAR(255) NULL,
    cupo_maximo INT NOT NULL CHECK (cupo_maximo > 0),
    estado BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at),
    deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at),
    CONSTRAINT FK_Sesiones_Tutor FOREIGN KEY (id_tutor)
        REFERENCES GestionIdentidadAcad.Usuarios(id_usuario),
    CONSTRAINT FK_Sesiones_Materia FOREIGN KEY (id_mat)
        REFERENCES GestionIdentidadAcad.Materias(id_mat)
)
GO

-- Tabla de inscripciones
CREATE TABLE GestionIdentidadAcad.Inscripciones (
    id_inscripcion INT IDENTITY(1,1) PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_sesion INT NOT NULL,
    fecha_inscripcion DATETIME DEFAULT GETDATE(),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at),
    deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at),
    CONSTRAINT FK_Inscripciones_Estudiante FOREIGN KEY (id_estudiante)
        REFERENCES GestionIdentidadAcad.Usuarios(id_usuario),
    CONSTRAINT FK_Inscripciones_Sesion FOREIGN KEY (id_sesion)
        REFERENCES GestionIdentidadAcad.Sesiones(id_sesion),
    CONSTRAINT UQ_Inscripcion UNIQUE (id_estudiante, id_sesion)
)
GO

CREATE SCHEMA GestionTutores
GO

CREATE SCHEMA GestionEventosSesiones
GO