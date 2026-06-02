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

--Módulo 4: Gestión de Eventos y Sesiones Académicas
CREATE SCHEMA GestionEventosSesiones
GO

--Tabla 4.1: Sesiones
CREATE TABLE Sesiones (
	id_sesion INT IDENTITY(1,1) CONSTRAINT PK_id_sesion PRIMARY KEY
	, id_tutor INT FK_id_tutor CONSTRAINT FOREIGN KEY REFERENCES Tutores(id_tutor)
	, id_materia INT FK_id_materia CONSTRAINT FOREIGN KEY REFERENCES Materias(id_materia)
	, fecha DATE NOT NULL
	, hora_inicio DATETIME NOT NULL
	, hora_fin DATETIME NOT NULL
	, ubicacion NVARCHAR(60) NOT NULL
	, cupo_max INT NOT NULL CONSTRAINT CK_cupo_max_val CHECK(cupo_max > 0)
)
GO

--Tabla 4.2: Inscripciones
CREATE TABLE Inscripciones (
	id_inscripcion INT IDENTITY(1,1) CONSTRAINT PK_id_inscripcion PRIMARY KEY
	, id_estudiante INT FK_id_estudiante CONSTRAINT FOREIGN KEY REFERENCES Tutores(id_tutor)
	, id_sesion INT FK_id_sesion CONSTRAINT FOREIGN KEY REFERENCES Sesiones(id_sesion)
	, fecha_inscripcion DATE CONSTRAINT DF_fecha_inscripcion DEFAULT GETDATE()
	, estado BIT CONSTRAINT DF_estado DEFAULT 0
)
GO