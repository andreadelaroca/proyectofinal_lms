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

CREATE SCHEMA GestionTutores
GO

CREATE SCHEMA GestionEventosSesiones
GO

-- Modulo 1: GestionRolesPermisos

CREATE TABLE GestionRolesPermisos.Roles (
    id_rol INT IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    
    CONSTRAINT PK_Roles 
	PRIMARY KEY (id_rol),
)
GO

-- Tabla de los permisos que tiene cada rol
CREATE TABLE GestionRolesPermisos.PermisosRoles (
    id_rol INT NOT NULL,
    id_permiso INT NOT NULL,
    
    CONSTRAINT PK_PermisosRoles 
	PRIMARY KEY (id_rol, id_permiso),
    CONSTRAINT FK_Permisos_DetallesRol 
	FOREIGN KEY (id_rol) 
	REFERENCES DetallesRol(id_rol),
    CONSTRAINT FK_Permisos_DetallesPermisos 
	FOREIGN KEY (id_permiso) 
	REFERENCES DetallesPermisos(id_permiso)
)
GO

-- Tabla de permisos y operaciones disponibles
CREATE TABLE GestionRolesPermisos.DetallesPermisos (
    id_permiso INT IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),

    CONSTRAINT PK_DetallesPermisos
	PRIMARY KEY (id_permiso)
)
GO


-- Bitacora de accesos e intentos de inicio de sesión
CREATE TABLE GestionRolesPermisos.RegistrosAcceso (
    id_log INT IDENTITY(1,1),
    id_usuario INT NOT NULL,
    estado BIT NOT NULL,
    ip VARCHAR(45) NOT NULL,
    hora DATETIME NOT NULL,

    CONSTRAINT PK_RegistrosAcceso 
	PRIMARY KEY (id_log),
    CONSTRAINT FK_Registros_Usuarios
	FOREIGN KEY (id_usuario) 
	REFERENCES Usuarios(id_usuario)
    CONSTRAINT CK_ip
	CHECK(ip like '%.%.%.%')
)
GO

-- Tabla general del historial de auditoría
CREATE TABLE GestionRolesPermisos.AuditoriaHistorial (
    id_audit INT IDENTITY(1,1),
    id_usuario INT NOT NULL,

    CONSTRAINT PK_AuditoriaHistorial
	PRIMARY KEY (id_audit),
    CONSTRAINT FK_Historial_Usuarios
	FOREIGN KEY (id_usuario)
	REFERENCES Usuarios(id_usuario)
)
GO

-- Detalle técnico del "antes" y "después" de cada cambio en los datos
CREATE TABLE GestionRolesPermisos.Auditoria (
    id_audit INT NOT NULL,
    tabla VARCHAR(50) NOT NULL,
    columna VARCHAR(50) NOT NULL,
    tupla INT NOT NULL,
    id_operacion INT NOT NULL,
    estado_anterior VARCHAR(MAX),
    estado_actual VARCHAR(MAX),
    fecha DATETIME NOT NULL,
    
    CONSTRAINT FK_Auditoria_Historial
	FOREIGN KEY (id_audit)
	REFERENCES AuditoriaHistorial(id_audit)
)
GO
