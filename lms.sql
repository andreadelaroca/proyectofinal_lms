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
CREATE SCHEMA GestionEventos
GO

--Tabla 4.1: Sesiones
CREATE TABLE GestionEventos.Sesiones (
	id_sesion INT IDENTITY(1,1) CONSTRAINT PK_id_sesion PRIMARY KEY
	, id_tutor INT CONSTRAINT FK_id_tutor FOREIGN KEY REFERENCES GestionTutores.Tutores(id_tutor)
	, id_materia INT CONSTRAINT FK_id_materia FOREIGN KEY REFERENCES GestionIdentidadCad.Materias(id_materia)
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
CREATE TABLE GestionEventos.Inscripciones (
	id_inscripcion INT IDENTITY(1,1) CONSTRAINT PK_id_inscripcion PRIMARY KEY
	, id_estudiante INT CONSTRAINT FK_id_estudiante FOREIGN KEY REFERENCES GestionTutores.Tutores(id_tutor)
	, id_sesion INT CONSTRAINT FK_id_sesion FOREIGN KEY REFERENCES GestionEventos.Sesiones(id_sesion)
	, fecha_inscripcion DATE CONSTRAINT DF_fecha_inscripcion DEFAULT GETDATE()
	, estado BIT CONSTRAINT DF_estado DEFAULT 0
	, created_at DATETIME CONSTRAINT DF_created_at_ses DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at)
	, deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at)
)
GO

--Tabla 4.3: Asistencias
CREATE TABLE GestionEventos.Asistencias (
	id_asistencia INT IDENTITY(1,1) CONSTRAINT PK_id_inscripcion PRIMARY KEY
	, id_inscripcion INT CONSTRAINT FK_id_inscripcion FOREIGN KEY REFERENCES GestionEventos.Inscripciones(id_inscripcion)
	, estatus_asistencia NVARCHAR(30) CONSTRAINT CK_estatus_asistencia CHECK(estatus_asistencia IN ('Presente', 'Tarde', 'Falta justificada', 'Falta injustificada'))
	, participacion TINYINT CONSTRAINT CK_participacion CHECK(participacion BETWEEN 0 AND 5)
	, fecha_registro DATE NOT NULL
	, created_at DATETIME CONSTRAINT DF_created_at_ses DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at)
	, deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at)
)
GO

--Tabla 4.4: FeedbackEvaluaciones
CREATE TABLE GestionEventos.FeedbackEvaluaciones (
	id_feedback INT IDENTITY(1,1) CONSTRAINT PK_id_feedback PRIMARY KEY
	, id_inscripcion INT FOREIGN KEY REFERENCES GestionEventos.Inscripciones(id_inscripcion)
	, comentario NVARCHAR(255) NOT NULL
	, puntuacion_tutor TINYINT CONSTRAINT CK_participacion_tutor CHECK(puntuacion_tutor BETWEEN 0 AND 5)
)
GO