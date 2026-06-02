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