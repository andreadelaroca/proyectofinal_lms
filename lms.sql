--Inicio de repositorio
	
USE master
GO

IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'lmsDB')
	BEGIN
		ALTER DATABASE lmsDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE lmsDB
	END
GO

CREATE DATABASE lmsDB
GO

USE lmsDB
GO

--Módulo 1: Gestión de Roles y Permisos
CREATE SCHEMA GestionRolesPermisos
GO

-- Tabla 1.1: Roles
CREATE TABLE GestionRolesPermisos.Roles (
    id_rol INT IDENTITY(1,1) CONSTRAINT PK_roles PRIMARY KEY
	, nombre NVARCHAR(50) NOT NULL
	, descripcion NVARCHAR(255) NOT NULL
    , created_at DATETIME DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at)
	, deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at)
)
GO

-- Tabla de permisos y operaciones disponibles
CREATE TABLE GestionRolesPermisos.DetallesPermisos (
    id_permiso INT IDENTITY(1,1)
	, nombre NVARCHAR(50) NOT NULL
    , descripcion NVARCHAR(255) NOT NULL
	, created_at DATETIME DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at)
	, deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at)
	, CONSTRAINT PK_DetallesPermisos PRIMARY KEY (id_permiso)
)
GO

-- Tabla de los permisos que tiene cada rol
CREATE TABLE GestionRolesPermisos.PermisosRoles (
    id_rol INT NOT NULL
    , id_permiso INT NOT NULL
    , created_at DATETIME DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at >= updated_at)
	, deleted_at DATETIME NULL DEFAULT GETDATE() CHECK(created_at > deleted_at)
	, CONSTRAINT PK_PermisosRoles PRIMARY KEY (id_rol, id_permiso)
	, CONSTRAINT FK_Permisos_DetallesRol FOREIGN KEY (id_rol) REFERENCES GestionRolesPermisos.Roles(id_rol)
	, CONSTRAINT FK_Permisos_DetallesPermisos FOREIGN KEY (id_permiso) REFERENCES GestionRolesPermisos.DetallesPermisos(id_permiso)
)
GO

-- Bitacora de accesos e intentos de inicio de sesión
CREATE TABLE GestionRolesPermisos.RegistrosAcceso (
    id_log INT IDENTITY(1,1)
	, id_usuario INT NOT NULL
	, estado BIT NOT NULL
	, ip NVARCHAR(45) NOT NULL
	, fecha_hora DATETIME NOT NULL DEFAULT GETDATE()
	, CONSTRAINT PK_RegistrosAcceso PRIMARY KEY (id_log)
	, CONSTRAINT FK_Registros_Usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
    , CONSTRAINT CK_ip CHECK(ip like '%.%.%.%')
)
GO

-- Tabla general del historial de auditoría
CREATE TABLE GestionRolesPermisos.AuditoriaHistorial (
    id_audit INT IDENTITY(1,1),
    id_usuario INT
	NOT NULL,

    CONSTRAINT PK_AuditoriaHistorial
	PRIMARY KEY (id_audit),
    CONSTRAINT FK_Historial_Usuarios
	FOREIGN KEY (id_usuario)
	REFERENCES Usuarios(id_usuario)
)
GO

-- Detalle técnico del "antes" y "después" de cada cambio en los datos
CREATE TABLE GestionRolesPermisos.Auditoria (
    id_audit INT 
	NOT NULL,
    tabla VARCHAR(50) 
	NOT NULL,
    columna VARCHAR(50) 
	NOT NULL,
    tupla INT NOT NULL,
    id_operacion INT 
	NOT NULL,
    estado_anterior VARCHAR(MAX),
    estado_actual VARCHAR(MAX),
    fecha DATETIME 
	NOT NULL,
    
    CONSTRAINT FK_Auditoria_Historial
	FOREIGN KEY (id_audit)
	REFERENCES AuditoriaHistorial(id_audit)
)
GO

CREATE SCHEMA GestionIdentidadAcad
GO

CREATE SCHEMA GestionTutores
GO

--Módulo 4: Gesti�n de Eventos y Sesiones Acad�micas
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
CREATE SCHEMA GestionEventosSesiones
GO

