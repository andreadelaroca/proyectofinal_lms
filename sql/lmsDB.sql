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

--Creación de esquemas para cada módulo
CREATE SCHEMA GestionRolesPermisos
GO

CREATE SCHEMA GestionIdentidadAcad
GO

CREATE SCHEMA GestionTutores
GO

CREATE SCHEMA GestionEventos
GO

-- Tabla 1: Roles
CREATE TABLE GestionRolesPermisos.Roles (
    id_rol INT IDENTITY(1,1) CONSTRAINT PK_roles PRIMARY KEY
	, nombre NVARCHAR(50) NOT NULL
	, descripcion NVARCHAR(255) NOT NULL
    , created_at DATETIME DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE()
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_roles_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_roles_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
)
GO

-- Tabla 2: DetallesPermisos, Detalles de permisos y operaciones disponibles
CREATE TABLE GestionRolesPermisos.DetallesPermisos (
    id_permiso INT IDENTITY(1,1) CONSTRAINT PK_DetallesPermisos PRIMARY KEY (id_permiso)
	, nombre NVARCHAR(50) NOT NULL
    , descripcion NVARCHAR(255) NOT NULL
	, created_at DATETIME DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE()
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_detalles_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_detalles_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
)
GO


-- Tabla 3: PermisosRoles, Permisos que tiene cada rol
CREATE TABLE GestionRolesPermisos.PermisosRoles (
    id_rol INT NOT NULL
    , id_permiso INT NOT NULL
    , created_at DATETIME DEFAULT GETDATE()
    , updated_at DATETIME NULL DEFAULT GETDATE()
    , deleted_at DATETIME NULL
	, CONSTRAINT PK_PermisosRoles PRIMARY KEY (id_rol, id_permiso) --restricción de clave compuesta
	, CONSTRAINT FK_Permisos_DetallesRol FOREIGN KEY (id_rol) REFERENCES GestionRolesPermisos.Roles(id_rol)
	, CONSTRAINT FK_Permisos_DetallesPermisos FOREIGN KEY (id_permiso) REFERENCES GestionRolesPermisos.DetallesPermisos(id_permiso)
    , CONSTRAINT CK_permisos_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_permisos_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
)
GO

--Tabla 4: Usuarios
CREATE TABLE GestionIdentidadAcad.Usuarios (
id_usuario INT IDENTITY(1,1) CONSTRAINT PK_Usuarios PRIMARY KEY
, email NVARCHAR(150) UNIQUE NOT NULL
, pass_hash CHAR(60) NOT NULL
, estado_usuario BIT NOT NULL DEFAULT 1
, id_rol INT NOT NULL
, created_at DATETIME DEFAULT GETDATE()
, updated_at DATETIME NULL DEFAULT GETDATE()
, deleted_at DATETIME NULL
, CONSTRAINT FK_Usuarios_Roles FOREIGN KEY (id_rol) REFERENCES GestionRolesPermisos.Roles(id_rol)
, CONSTRAINT CK_usuarios_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
, CONSTRAINT CK_usuarios_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
)
GO

--Tabla 5: PerfilesDatos
CREATE TABLE GestionIdentidadAcad.PerfilesDatos (
    id_usuario INT CONSTRAINT PK_PerfilesDatos PRIMARY KEY
    , nombres NVARCHAR(100) NOT NULL
    , apellidos NVARCHAR(100) NOT NULL
    , telefono NVARCHAR(20) NULL
    , carrera NVARCHAR(100) NULL
    , created_at DATETIME DEFAULT GETDATE()
    , updated_at DATETIME NULL DEFAULT GETDATE()
    , CONSTRAINT FK_PerfilesDatos_Usuarios FOREIGN KEY (id_usuario) REFERENCES GestionIdentidadAcad.Usuarios(id_usuario)
)
GO

--Tabla 6: Materias
CREATE TABLE GestionIdentidadAcad.Materias (
    id_materia INT IDENTITY(1,1) CONSTRAINT PK_Materias PRIMARY KEY
    , cod_materia NVARCHAR(20) UNIQUE NOT NULL
    , nombre NVARCHAR(100) NOT NULL
    , creditos INT NOT NULL CHECK(creditos >= 0)
    , created_at DATETIME DEFAULT GETDATE()
)
GO

-- Tabla 7: RegistrosAcceso, Bitácora de accesos e intentos de inicio de sesión
CREATE TABLE GestionRolesPermisos.RegistrosAcceso (
    id_log INT IDENTITY(1,1)
	, id_usuario INT NOT NULL
	, estado BIT NOT NULL
	, ip VARCHAR(50) DEFAULT (CAST(CONNECTIONPROPERTY('usuario_direccion_ip') AS VARCHAR(50)))
	, fecha_hora DATETIME NOT NULL DEFAULT GETDATE()
	, CONSTRAINT PK_RegistrosAcceso PRIMARY KEY(id_log)
    , CONSTRAINT FK_Registros_Usuarios FOREIGN KEY (id_usuario) REFERENCES GestionIdentidadAcad.Usuarios(id_usuario)
    , CONSTRAINT CK_ip CHECK(ip LIKE '%[0-9].%[0-9].%[0-9].%[0-9]' OR ip LIKE '%:%')
)
GO

-- Tabla 8: AuditoriaHistorial, Tabla general del historial de auditoría
CREATE TABLE GestionRolesPermisos.AuditoriaHistorial (
    id_audit INT IDENTITY(1,1),
    id_usuario INT NOT NULL,
    CONSTRAINT PK_AuditoriaHistorial PRIMARY KEY(id_audit),
    CONSTRAINT FK_Historial_Usuarios FOREIGN KEY(id_usuario) REFERENCES GestionIdentidadAcad.Usuarios(id_usuario)
)
GO

-- Tabla 9: Auditoria, Detalle técnico del "antes" y "después" de cada cambio en los datos
CREATE TABLE GestionRolesPermisos.Auditoria (
    id_audit INT NOT NULL
    , tabla VARCHAR(50) NOT NULL
    , columna VARCHAR(50) NOT NULL
    , tupla INT NOT NULL
    , operacion NVARCHAR(50) NOT NULL
    , estado_anterior VARCHAR(MAX) NULL
    , estado_actual VARCHAR(MAX) NULL
    , fecha DATETIME NOT NULL DEFAULT GETDATE()
    , CONSTRAINT FK_Auditoria_Historial FOREIGN KEY (id_audit) REFERENCES GestionRolesPermisos.AuditoriaHistorial(id_audit)
)
GO

--Tabla 10: Tutores
CREATE TABLE GestionTutores.Tutores (
    id_tutor INT CONSTRAINT PK_Tutores PRIMARY KEY
    , estado_tutor BIT NOT NULL DEFAULT 0
    , created_at DATETIME DEFAULT GETDATE()
    , updated_at DATETIME NULL
    , CONSTRAINT FK_Tutores_Usuarios FOREIGN KEY (id_tutor) REFERENCES GestionIdentidadAcad.Usuarios(id_usuario)
)
GO

-- Tabla 11: HorariosTutor
CREATE TABLE GestionTutores.HorariosTutor (
    id_horario INT IDENTITY(1,1) PRIMARY KEY,
    id_tutor INT NOT NULL,
    dia_semana INT NOT NULL CHECK(dia_semana BETWEEN 1 AND 7)
    , hora_inicio TIME NOT NULL
    , hora_fin TIME NOT NULL
    , created_at DATETIME NOT NULL DEFAULT GETDATE()
    , updated_at DATETIME NULL
    , CONSTRAINT FK_HorariosTutor_Tutores FOREIGN KEY (id_tutor) REFERENCES GestionTutores.Tutores(id_tutor)
    , CONSTRAINT CK_HorariosTutor_Horas CHECK(hora_fin > hora_inicio)
)
GO

-- Tabla 12: TutorMateria
CREATE TABLE GestionTutores.TutorMateria (
    id_tutor_materia INT IDENTITY(1,1) PRIMARY KEY,
    id_tutor INT NOT NULL,
    id_materia INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    CONSTRAINT CK_tutormat_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT FK_TUTOR_MATERIA_TUTORES FOREIGN KEY(id_tutor) REFERENCES GestionTutores.Tutores(id_tutor),
    CONSTRAINT FK_TUTOR_MATERIA_MATERIAS FOREIGN KEY(id_materia) REFERENCES GestionIdentidadAcad.Materias(id_materia),
    CONSTRAINT UQ_TUTOR_MATERIA UNIQUE(id_tutor, id_materia)
)
GO

-- Tabla 13: TutoresValidacion
CREATE TABLE GestionTutores.TutoresValidacion (
    id_validacion INT IDENTITY(1,1) PRIMARY KEY,
    id_tutor INT NOT NULL,
    is_valid BIT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL
    , CONSTRAINT CK_tutvalidacion_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    ,CONSTRAINT FK_TUTORES_VALIDACION_TUTORES FOREIGN KEY(id_tutor) REFERENCES GestionTutores.Tutores(id_tutor),
    CONSTRAINT UQ_TUTORES_VALIDACION UNIQUE (id_tutor)
)
GO

-- Tabla 14: Acreditaciones
CREATE TABLE GestionTutores.Acreditaciones (
    id_acreditacion INT IDENTITY(1,1) PRIMARY KEY,
    id_tutor INT NOT NULL,
    archivo VARBINARY(MAX) NOT NULL,
    file_name NVARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL
    , CONSTRAINT CK_acreditaciones_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT FK_ACREDITACIONES_TUTORES FOREIGN KEY(id_tutor) REFERENCES GestionTutores.Tutores(id_tutor)
)
GO

-- Tabla 15: PerfilTutor
CREATE TABLE GestionTutores.PerfilTutor (
    id_perfil_tutor INT IDENTITY(1,1) PRIMARY KEY,
    id_tutor INT NOT NULL,
    descripcion NVARCHAR(MAX) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL
    , CONSTRAINT CK_perfiltutor_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT FK_PERFIL_TUTOR_TUTORES FOREIGN KEY(id_tutor) REFERENCES GestionTutores.Tutores(id_tutor),
    CONSTRAINT UQ_PERFIL_TUTOR UNIQUE (id_tutor)
)
GO

-- Tabla 16: CalificacionesTutor
CREATE TABLE GestionTutores.CalificacionesTutor (
    id_calificacion INT IDENTITY(1,1) CONSTRAINT PK_CalificacionesTutor PRIMARY KEY
    , id_tutor INT NOT NULL,
    puntuacion DECIMAL(3,1) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    CONSTRAINT FK_CALIFICACIONES_TUTOR_TUTORES FOREIGN KEY(id_tutor) REFERENCES GestionTutores.Tutores(id_tutor),
    CONSTRAINT CK_CALIFICACIONES_TUTOR_PUNTUACION CHECK(puntuacion BETWEEN 0 AND 5)
)
GO

-- Tabla 17: MetricasAprendizaje
CREATE TABLE GestionTutores.MetricasAprendizaje (
    id_metrica INT IDENTITY(1,1) CONSTRAINT PK_MetricasAprendizaje PRIMARY KEY
    , periodo NVARCHAR(50) NOT NULL
    , id_materia INT NOT NULL
    , estado_sesion NVARCHAR(100) NOT NULL
    , total_inscritos INT NOT NULL DEFAULT 0
    , total_asistencias INT NOT NULL DEFAULT 0
    , promedio_puntuacion DECIMAL(3,1) NULL
    , created_at DATETIME NOT NULL DEFAULT GETDATE()
    , updated_at DATETIME NULL
    , CONSTRAINT FK_MetricasAprendizaje_Materias FOREIGN KEY (id_materia) REFERENCES GestionIdentidadAcad.Materias(id_materia)
    , CONSTRAINT CK_Metricas_TotalInscritos CHECK (total_inscritos >= 0)
    , CONSTRAINT CK_Metricas_TotalAsistencias CHECK (total_asistencias >= 0)
    , CONSTRAINT CK_Metricas_Promedio CHECK (promedio_puntuacion IS NULL OR promedio_puntuacion BETWEEN 0 AND 5)
)
GO

--Tabla 18: Sesiones
CREATE TABLE GestionEventos.Sesiones (
	id_sesion INT IDENTITY(1,1) CONSTRAINT PK_id_sesion PRIMARY KEY
    , id_tutor_materia INT CONSTRAINT FK_id_tutor_mat FOREIGN KEY REFERENCES GestionTutores.TutorMateria(id_tutor_materia)
	, fecha DATE NOT NULL
	, hora_inicio TIME NOT NULL
	, hora_fin TIME NOT NULL
	, ubicacion NVARCHAR(60) NOT NULL
	, cupo_max INT NOT NULL CONSTRAINT CK_cupo_max_val CHECK(cupo_max > 0)
	, created_at DATETIME CONSTRAINT DF_created_at_ses DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE()
	, deleted_at DATETIME NULL DEFAULT GETDATE()
    , CONSTRAINT CK_sesiones_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_sesiones_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
    , CONSTRAINT CK_sesiones_horas CHECK(hora_fin > hora_inicio)
)
GO

--Tabla 19: Inscripciones
CREATE TABLE GestionEventos.Inscripciones (
	id_inscripcion INT IDENTITY(1,1) CONSTRAINT PK_id_inscripcion PRIMARY KEY
	, id_estudiante INT CONSTRAINT FK_id_estudiante FOREIGN KEY REFERENCES GestionIdentidadAcad.Usuarios(id_usuario)
	, id_sesion INT CONSTRAINT FK_id_sesion FOREIGN KEY REFERENCES GestionEventos.Sesiones(id_sesion)
	, fecha_inscripcion DATE CONSTRAINT DF_fecha_inscripcion DEFAULT GETDATE()
	, estado BIT CONSTRAINT DF_estado DEFAULT 0
	, created_at DATETIME CONSTRAINT DF_created_at_insc DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE()
	, deleted_at DATETIME NULL DEFAULT GETDATE()
    , CONSTRAINT CK_inscripciones_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_inscripciones_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
    , CONSTRAINT UQ_Estudiante_Sesion UNIQUE(id_estudiante, id_sesion)
)
GO

--Tabla 20: Asistencias
CREATE TABLE GestionEventos.Asistencias (
	id_asistencia INT IDENTITY(1,1) CONSTRAINT PK_id_asistencia PRIMARY KEY
	, id_inscripcion INT CONSTRAINT FK_id_inscripcion FOREIGN KEY REFERENCES GestionEventos.Inscripciones(id_inscripcion)
	, estatus_asistencia NVARCHAR(30) CONSTRAINT CK_estatus_asistencia CHECK(estatus_asistencia IN ('Presente', 'Tarde', 'Falta justificada', 'Falta injustificada'))
	, participacion TINYINT CONSTRAINT CK_participacion CHECK(participacion BETWEEN 0 AND 5)
	, fecha_registro DATE NOT NULL DEFAULT GETDATE()
	, created_at DATETIME CONSTRAINT DF_created_at_asist DEFAULT GETDATE()
	, updated_at DATETIME NULL DEFAULT GETDATE()
	, deleted_at DATETIME NULL
    , CONSTRAINT CK_asistencias_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_asistencias_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)

)
GO

--Tabla 21: FeedbackEvaluaciones
CREATE TABLE GestionEventos.FeedbackEvaluaciones (
	id_feedback INT IDENTITY(1,1) CONSTRAINT PK_id_feedback PRIMARY KEY
	, id_inscripcion INT FOREIGN KEY REFERENCES GestionEventos.Inscripciones(id_inscripcion)
	, comentario NVARCHAR(255) NOT NULL
	, puntuacion_tutor TINYINT CONSTRAINT CK_participacion_tutor CHECK(puntuacion_tutor BETWEEN 0 AND 5)
)
GO

--INSERCIONES DE BD
INSERT INTO GestionRolesPermisos.Roles(nombre, descripcion) VALUES 
    ('Administrador', 'Puede gestionar usuarios, configurar ajustes generales, acceder a datos confidenciales y modificar permisos.'),
    ('Usuario ordinario', 'Permite leer, crear y modificar su propio contenido o datos, pero tiene restricciones para alterar el sistema o la información de otros.')
GO

INSERT INTO GestionRolesPermisos.DetallesPermisos(nombre, descripcion) VALUES
    ('Gestión de identidades', 'Crear, modificar o eliminar cuentas de usuario y restablecer contraseñas.'),
    ('Control de accesos', 'Otorgar o revocar permisos sobre archivos, carpetas, bases de datos y redes.'),
    ('Mantenimiento', 'Monitorizar el rendimiento del sistema, ejecutar copias de seguridad y aplicar parches críticos.'),
    ('Auditoría', 'Implementar políticas de seguridad y revisar los registros del sistema para detectar intrusiones o fallos.'),
    ('Lectura y Ejecución', 'Iniciar el programa, abrirlo y leer los archivos o bases de datos a los que tiene acceso.'),
    ('Escritura', 'Generar, editar o guardar archivos nuevos únicamente en su entorno o carpeta personal.')
GO

INSERT INTO GestionRolesPermisos.PermisosRoles(id_rol, id_permiso) VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (2, 1),
    (2, 2)
GO

INSERT INTO GestionIdentidadAcad.Usuarios(email, pass_hash, id_rol) VALUES
    ('asodelaroca@uamv.edu.ni', HASHBYTES('SHA2_256', 'papupro123'), 1),
    ('masarante@uamv.edu.ni', HASHBYTES('SHA2_256', 'lalalala362Y9ngrhjbasjn'), 2),
    ('laguirrev@uamv.edu.ni', HASHBYTES('SHA2_256', 'FBBRBRBG37478hf_h__'), 2),
    ('caaguirre@uamv.edu.ni', HASHBYTES('SHA2_256', 'contrasenia'), 2),
    ('bryansaenz@uamv.edu.ni', HASHBYTES('SHA2_256', 'brawlstars67'), 2)
GO

INSERT INTO GestionIdentidadAcad.PerfilesDatos(id_usuario, nombres, apellidos, telefono, carrera) VALUES
   (1, 'Andrea Sofía', 'de la Roca Delgado', '88888888', 'Ingeniería en Gastronomía'),
   (2, 'María Alejandra', 'Sarante Salinas', '66666666', 'Licenciatura en Francés'),
   (3, 'Luis Lenin', 'Aguirre Vílchez', '77777777', 'Ingeniería en Terraria'),
   (4, 'Charlotte', 'Aguirre Molina', '67676767', 'Ingeniería en SA2'),
   (5, 'Bryan Uriel', 'Saenz Vílchez', '11111111', 'Ingeniería Industrial')
GO

INSERT INTO GestionIdentidadAcad.Materias(cod_materia, nombre, creditos) VALUES
    ('CNU03250', 'Base de Datos I', 3),
    ('INOP0125', 'Identidad Nacional y Orgullo Patrio', 3),
    ('FIS0111', 'Física Aplicada', 3)
GO

INSERT INTO GestionRolesPermisos.RegistrosAcceso(id_usuario, estado) VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1)
GO

INSERT INTO GestionRolesPermisos.AuditoriaHistorial(id_usuario) VALUES
    (1), (2), (3), (4), (5)
GO

INSERT INTO GestionRolesPermisos.Auditoria(id_audit, tabla, columna, tupla, operacion, estado_anterior, estado_actual) VALUES
    (1, 'Usuarios', 'email', '1', 'INSERT', 'asodelaroca@uamv.edu.ni', 'asodelaroca@uamv.edu.ni')
GO

INSERT INTO GestionTutores.Tutores(id_tutor, estado_tutor) VALUES
    (2, 1),
    (3, 1)
GO

INSERT INTO GestionTutores.HorariosTutor (id_tutor, dia_semana, hora_inicio, hora_fin) VALUES
    (2,2,'08:00:00','09:00:00'),
    (2,3,'10:00:00','12:00:00'),
    (3,4,'14:00:00','15:30:00'),
    (3,3,'15:00:00','16:00:00')
GO

INSERT INTO GestionTutores.TutorMateria(id_tutor, id_materia) VALUES
    (2,1),
    (2,2),
    (3,1),
    (3,3)
GO

INSERT INTO GestionTutores.TutoresValidacion(id_tutor, is_valid) VALUES
    (2,1),
    (3,1)
GO

INSERT INTO GestionTutores.Acreditaciones (id_tutor, archivo, file_name) VALUES
    (2, 0x255044462D312E, 'certificado_mat.pdf'),
    (2, 0xFFD8FFE000104A, 'titulo_prog.jpg'),
    (3, 0x255044462D312E, 'diploma_redes.pdf'),
    (3, 0xFFD8FFE000104A, 'certificado_bd.jpg'),
    (3, 0x255044462D312E, 'curso_excel.pdf')
GO

INSERT INTO GestionTutores.PerfilTutor (id_tutor, descripcion) VALUES
    (2, 'Tutor especializado en Matemáticas y Física, experiencia universitaria.'),
    (3, 'Tutor de Programación en C# y Java, orientado a proyectos prácticos.')
GO

INSERT INTO GestionTutores.CalificacionesTutor(id_tutor, puntuacion) VALUES
    (2,4.8),
    (2,4.5),
    (3,4.2),
    (3,3.8)
GO
    
INSERT INTO GestionTutores.MetricasAprendizaje(periodo, id_materia, estado_sesion, total_inscritos, total_asistencias, promedio_puntuacion) VALUES
    ('Primer semestre 2026',1,'Finalizada',20,18,4.7),
    ('Primer semestre 2026',2,'Activa',15,12,4.3),
    ('Segundo semestre 2026',3,'Finalizada',25,22,4.6),
    ('Segundo semestre 2026',1,'Cancelada',8,0,NULL)
GO

INSERT INTO GestionEventos.Sesiones(id_tutor_materia, fecha, hora_inicio, hora_fin, ubicacion, cupo_max) VALUES
    (1, '2026-06-03', '08:00:00', '09:00:00', 'C-108', 30),
    (3, '2026-05-31', '14:00:00', '15:30:00', 'B-209', 25)
GO

INSERT INTO GestionEventos.Inscripciones(id_estudiante, id_sesion, estado) VALUES
    (4, 1, 1),
    (5, 1, 0)
GO

INSERT INTO GestionEventos.Asistencias(id_inscripcion, estatus_asistencia, participacion) VALUES
    (1, 'Presente', 5)
GO

INSERT INTO GestionEventos.FeedbackEvaluaciones (id_inscripcion, comentario, puntuacion_tutor) VALUES
    (1, 'Muy buena, me gustó mucho', 5),
    (2, 'que basura borren la cuenta', 0)
GO