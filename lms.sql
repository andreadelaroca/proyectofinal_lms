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
	, id_tutor INT CONSTRAINT FK_id_tutor FOREIGN KEY REFERENCES Tutores(id_tutor)
	, id_materia INT CONSTRAINT FK_id_materia FOREIGN KEY REFERENCES Materias(id_materia)
	, fecha DATE NOT NULL
	, hora_inicio DATETIME NOT NULL
	, hora_fin DATETIME NOT NULL
	, ubicacion NVARCHAR(60) NOT NULL
	, cupo_max INT NOT NULL CONSTRAINT CK_cupo_max_val CHECK(cupo_max > 0)
	, created_at DATETIME CONSTRAINT DF_created_at_ses DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at)
	, deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at)
)
GO

--Tabla 4.2: Inscripciones
CREATE TABLE Inscripciones (
	id_inscripcion INT IDENTITY(1,1) CONSTRAINT PK_id_inscripcion PRIMARY KEY
	, id_estudiante INT CONSTRAINT FK_id_estudiante FOREIGN KEY REFERENCES Tutores(id_tutor)
	, id_sesion INT CONSTRAINT FK_id_sesion FOREIGN KEY REFERENCES Sesiones(id_sesion)
	, fecha_inscripcion DATE CONSTRAINT DF_fecha_inscripcion DEFAULT GETDATE()
	, estado BIT CONSTRAINT DF_estado DEFAULT 0
	, created_at DATETIME CONSTRAINT DF_created_at_ses DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at)
	, deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at)
)
GO

--Tabla 4.3: Asistencias
CREATE TABLE Asistencias (
	id_asistencia INT IDENTITY(1,1) CONSTRAINT PK_id_inscripcion PRIMARY KEY
	, id_inscripcion INT CONSTRAINT FK_id_inscripcion FOREIGN KEY REFERENCES Inscripciones(id_inscripcion)
	, estatus_asistencia NVARCHAR(30) CONSTRAINT CK_estatus_asistencia CHECK(estatus_asistencia IN ('Presente', 'Tarde', 'Falta justificada', 'Falta injustificada'))
	, participacion DECIMAL(2,2) CONSTRAINT CK_participacion CHECK(participacion BETWEEN 0.0 AND 10.0)
	, fecha_registro DATE NOT NULL
	, created_at DATETIME CONSTRAINT DF_created_at_ses DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at)
	, deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at)
)
GO