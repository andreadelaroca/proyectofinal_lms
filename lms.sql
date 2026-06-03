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

CREATE SCHEMA GestionTutores
GO

CREATE SCHEMA GestionEventosSesiones
GO