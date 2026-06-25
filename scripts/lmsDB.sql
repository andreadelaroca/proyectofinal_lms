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
    , deleted_at DATETIME NULL
    , CONSTRAINT FK_PerfilesDatos_Usuarios FOREIGN KEY (id_usuario) REFERENCES GestionIdentidadAcad.Usuarios(id_usuario)
    , CONSTRAINT CK_perfdat_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_perfdat_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
)
GO

--Tabla 6: Materias
CREATE TABLE GestionIdentidadAcad.Materias (
    id_materia INT IDENTITY(1,1) CONSTRAINT PK_Materias PRIMARY KEY
    , cod_materia NVARCHAR(20) UNIQUE NOT NULL
    , nombre NVARCHAR(100) NOT NULL
    , creditos INT NOT NULL CHECK(creditos >= 0)
    , created_at DATETIME DEFAULT GETDATE()
    , updated_at DATETIME NULL DEFAULT GETDATE()
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_materias_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_materias_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
)
GO

-- Tabla 7: RegistrosAcceso, Bitácora de accesos e intentos de inicio de sesión
CREATE TABLE GestionRolesPermisos.RegistrosAcceso (
    id_log INT IDENTITY(1,1)
	, id_usuario INT NOT NULL
	, estado BIT NOT NULL
	, ip VARCHAR(50) DEFAULT (CAST(CONNECTIONPROPERTY('client_net_address') AS VARCHAR(50)))
	, fecha_hora DATETIME NOT NULL DEFAULT GETDATE()
    , created_at DATETIME DEFAULT GETDATE()
    , updated_at DATETIME NULL DEFAULT GETDATE()
    , deleted_at DATETIME NULL
	, CONSTRAINT PK_RegistrosAcceso PRIMARY KEY(id_log)
    , CONSTRAINT FK_Registros_Usuarios FOREIGN KEY (id_usuario) REFERENCES GestionIdentidadAcad.Usuarios(id_usuario)
    , CONSTRAINT CK_ip CHECK(ip LIKE '%[0-9].%[0-9].%[0-9].%[0-9]' OR ip LIKE '%:%')
    , CONSTRAINT CK_regacc_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_regacc_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
)
GO

-- Tabla 8: Auditoria, Detalle técnico del "antes" y "después" de cada cambio en los datos
CREATE TABLE GestionRolesPermisos.Auditoria (
    id_audit INT IDENTITY(1,1)
    , tabla VARCHAR(50) NOT NULL
    , columna VARCHAR(50) NOT NULL
    , tupla INT NOT NULL
    , operacion NVARCHAR(50) NOT NULL
    , estado_anterior VARCHAR(MAX) NULL
    , estado_actual VARCHAR(MAX) NULL
    , fecha DATETIME NOT NULL DEFAULT GETDATE()
    , created_at DATETIME DEFAULT GETDATE()
    , updated_at DATETIME NULL DEFAULT GETDATE()
    , deleted_at DATETIME NULL
    , CONSTRAINT PK_Auditoria PRIMARY KEY(id_audit)
    , CONSTRAINT CK_audit_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_audit_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
)
GO

-- Tabla 9: AuditoriaHistorial, Tabla general del historial de auditoría
CREATE TABLE GestionRolesPermisos.AuditoriaHistorial (
    id_historial INT IDENTITY(1,1) CONSTRAINT PK_AuditoriaHistorial PRIMARY KEY
    , id_audit INT NOT NULL
    , id_usuario INT NOT NULL
    , CONSTRAINT FK_Auditoria_Historial FOREIGN KEY (id_audit) REFERENCES GestionRolesPermisos.Auditoria(id_audit)
    , CONSTRAINT FK_Historial_Usuarios FOREIGN KEY(id_usuario) REFERENCES GestionIdentidadAcad.Usuarios(id_usuario)
    , created_at DATETIME DEFAULT GETDATE()
    , updated_at DATETIME NULL DEFAULT GETDATE()
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_audithist_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_audithist_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
)
GO


--Tabla 10: Tutores
CREATE TABLE GestionTutores.Tutores (
    id_tutor INT CONSTRAINT PK_Tutores PRIMARY KEY
    , estado_tutor BIT NOT NULL DEFAULT 0
    , created_at DATETIME DEFAULT GETDATE()
    , updated_at DATETIME NULL
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_tutor_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_tutor_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
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
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_horartutor_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_horartutor_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
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
    updated_at DATETIME NULL
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_tutormat_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
    , CONSTRAINT CK_tutormat_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
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
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_tutval_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_tutval_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
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
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_acred_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
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
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_perftut_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
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
    updated_at DATETIME NULL
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_califtutor_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_califtutor_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
    , CONSTRAINT FK_CALIFICACIONES_TUTOR_TUTORES FOREIGN KEY(id_tutor) REFERENCES GestionTutores.Tutores(id_tutor),
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
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_metricapren_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_metricapren_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
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
    , created_at DATETIME DEFAULT GETDATE()
    , updated_at DATETIME NULL DEFAULT GETDATE()
    , deleted_at DATETIME NULL
    , CONSTRAINT CK_feedbackeval_updated CHECK(updated_at IS NULL OR updated_at >= created_at)
    , CONSTRAINT CK_feedbackeval_deleted CHECK(deleted_at IS NULL OR deleted_at >= created_at)
)
GO

--INSERCIONES DE BD
INSERT INTO GestionRolesPermisos.Roles(nombre, descripcion) VALUES 
    ('Administrador', 'Puede gestionar usuarios, configurar ajustes generales, acceder a datos confidenciales y modificar permisos.'),
    ('Usuario ordinario', 'Permite leer, crear y modificar su propio contenido o datos, pero tiene restricciones para alterar el sistema.'),
    ('Tutor', 'Permite gestionar sesiones de tutoría, ver alumnos inscritos y calificar participaciones.'),
    ('Auditor', 'Solo lectura de todos los datos y registros de actividad para verificaciones de seguridad.')
GO

INSERT INTO GestionRolesPermisos.DetallesPermisos(nombre, descripcion) VALUES
    ('Gestión de identidades', 'Crear, modificar o eliminar cuentas de usuario y restablecer contraseñas.'),
    ('Control de accesos', 'Otorgar o revocar permisos sobre archivos, carpetas, bases de datos y redes.'),
    ('Mantenimiento', 'Monitorizar el rendimiento del sistema, ejecutar copias de seguridad y aplicar parches críticos.'),
    ('Auditoría', 'Implementar políticas de seguridad y revisar los registros del sistema.'),
    ('Lectura y Ejecución', 'Iniciar el programa, abrirlo y leer los archivos o bases de datos a los que tiene acceso.'),
    ('Escritura', 'Generar, editar o guardar archivos nuevos únicamente en su entorno o carpeta personal.'),
    ('Gestión de Clases', 'Creación y modificación de sesiones de tutoría y registro de asistencia.')
GO

INSERT INTO GestionRolesPermisos.PermisosRoles(id_rol, id_permiso) VALUES
    (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7),
    (2, 5), (2, 6),
    (3, 5), (3, 6), (3, 7),
    (4, 4), (4, 5)
GO

INSERT INTO GestionIdentidadAcad.Usuarios(email, pass_hash, id_rol) VALUES
    ('asodelaroca@uamv.edu.ni', HASHBYTES('SHA2_256', 'papupro123'), 1),
    ('masarante@uamv.edu.ni', HASHBYTES('SHA2_256', 'lalalala362Y'), 3),
    ('laguirrev@uamv.edu.ni', HASHBYTES('SHA2_256', 'FBBRBRBG37478'), 3),
    ('caaguirre@uamv.edu.ni', HASHBYTES('SHA2_256', 'contrasenia'), 2),
    ('bryansaenz@uamv.edu.ni', HASHBYTES('SHA2_256', 'brawlstars67'), 2),
    ('cflores@uamv.edu.ni', HASHBYTES('SHA2_256', 'securepass1'), 3),
    ('pmejia@uamv.edu.ni', HASHBYTES('SHA2_256', 'securepass2'), 2),
    ('jramirez@uamv.edu.ni', HASHBYTES('SHA2_256', 'securepass3'), 4)
GO

INSERT INTO GestionIdentidadAcad.PerfilesDatos(id_usuario, nombres, apellidos, telefono, carrera) VALUES
   (1, 'Andrea Sofía', 'de la Roca Delgado', '88888888', 'Ingeniería en Sistemas'),
   (2, 'María Alejandra', 'Sarante Salinas', '66666666', 'Licenciatura en Francés'),
   (3, 'Luis Lenin', 'Aguirre Vílchez', '77777777', 'Ingeniería en Terraria'),
   (4, 'Charlotte', 'Aguirre Molina', '67676767', 'Ingeniería en SA2'),
   (5, 'Bryan Uriel', 'Saenz Vílchez', '11111111', 'Ingeniería Industrial'),
   (6, 'Carlos', 'Flores', '22222222', 'Matemáticas Puras'),
   (7, 'Paola', 'Mejía', '33333333', 'Psicología'),
   (8, 'Juan', 'Ramírez', '44444444', 'Contabilidad y Finanzas')
GO

INSERT INTO GestionIdentidadAcad.Materias(cod_materia, nombre, creditos) VALUES
    ('CNU03250', 'Base de Datos I', 3),
    ('INOP0125', 'Identidad Nacional y Orgullo Patrio', 3),
    ('FIS0111', 'Física Aplicada', 3),
    ('MAT0200', 'Cálculo II', 4),
    ('PROG0100', 'Programación Orientada a Objetos', 4)
GO

INSERT INTO GestionRolesPermisos.RegistrosAcceso(id_usuario, estado, ip) VALUES
    (1, 1, '192.168.1.10'),
    (2, 1, '192.168.1.11'),
    (3, 1, '192.168.1.12'),
    (4, 1, '192.168.1.13'),
    (5, 1, '192.168.1.14'),
    (6, 1, '192.168.1.15'),
    (7, 0, '192.168.1.16'),
    (8, 1, '192.168.1.17')
GO

INSERT INTO GestionRolesPermisos.Auditoria(tabla, columna, tupla, operacion, estado_anterior, estado_actual) VALUES
    ('Usuarios', 'email', 1, 'INSERT', NULL, 'asodelaroca@uamv.edu.ni'),
    ('Usuarios', 'email', 2, 'INSERT', NULL, 'masarante@uamv.edu.ni'),
    ('Usuarios', 'email', 3, 'INSERT', NULL, 'laguirrev@uamv.edu.ni'),
    ('Usuarios', 'email', 4, 'INSERT', NULL, 'caaguirre@uamv.edu.ni'),
    ('Usuarios', 'email', 5, 'INSERT', NULL, 'bryansaenz@uamv.edu.ni')
GO

INSERT INTO GestionRolesPermisos.AuditoriaHistorial(id_audit, id_usuario) VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (5, 1)
GO

INSERT INTO GestionTutores.Tutores(id_tutor, estado_tutor) VALUES
    (2, 1),
    (3, 1),
    (6, 1)
GO

INSERT INTO GestionTutores.HorariosTutor (id_tutor, dia_semana, hora_inicio, hora_fin) VALUES
    (2, 2, '08:00:00', '09:00:00'),
    (2, 3, '10:00:00', '12:00:00'),
    (3, 4, '14:00:00', '15:30:00'),
    (3, 3, '15:00:00', '16:00:00'),
    (6, 1, '09:00:00', '11:00:00'),
    (6, 5, '13:00:00', '15:00:00')
GO

INSERT INTO GestionTutores.TutorMateria(id_tutor, id_materia) VALUES
    (2, 1),
    (2, 2),
    (3, 1),
    (3, 3),
    (6, 4),
    (6, 5)
GO

INSERT INTO GestionTutores.TutoresValidacion(id_tutor, is_valid) VALUES
    (2, 1),
    (3, 1),
    (6, 0)
GO

INSERT INTO GestionTutores.Acreditaciones (id_tutor, archivo, file_name) VALUES
    (2, 0x255044462D312E, 'certificado_mat.pdf'),
    (2, 0xFFD8FFE000104A, 'titulo_prog.jpg'),
    (3, 0x255044462D312E, 'diploma_redes.pdf'),
    (3, 0xFFD8FFE000104A, 'certificado_bd.jpg'),
    (3, 0x255044462D312E, 'curso_excel.pdf'),
    (6, 0x255044462D312E, 'titulo_matematicas.pdf')
GO

INSERT INTO GestionTutores.PerfilTutor (id_tutor, descripcion) VALUES
    (2, 'Tutor especializado en Matemáticas y Física, experiencia universitaria.'),
    (3, 'Tutor de Programación en C# y Java, orientado a proyectos prácticos.'),
    (6, 'Apasionado por el cálculo y la lógica matemática, paciente con los nuevos.')
GO

INSERT INTO GestionTutores.CalificacionesTutor(id_tutor, puntuacion) VALUES
    (2, 4.8),
    (2, 4.5),
    (3, 4.2),
    (3, 3.8),
    (6, 5.0)
GO
    
INSERT INTO GestionTutores.MetricasAprendizaje(periodo, id_materia, estado_sesion, total_inscritos, total_asistencias, promedio_puntuacion) VALUES
    ('Primer semestre 2026', 1, 'Finalizada', 20, 18, 4.7),
    ('Primer semestre 2026', 2, 'Activa', 15, 12, 4.3),
    ('Segundo semestre 2026', 3, 'Finalizada', 25, 22, 4.6),
    ('Segundo semestre 2026', 1, 'Cancelada', 8, 0, NULL),
    ('Segundo semestre 2026', 4, 'Activa', 30, 29, 4.9)
GO

INSERT INTO GestionEventos.Sesiones(id_tutor_materia, fecha, hora_inicio, hora_fin, ubicacion, cupo_max) VALUES
    (1, '2026-06-03', '08:00:00', '09:00:00', 'C-108', 30),
    (3, '2026-05-31', '14:00:00', '15:30:00', 'B-209', 25),
    (5, '2026-07-10', '09:00:00', '11:00:00', 'A-101', 20),
    (6, '2026-07-12', '13:00:00', '15:00:00', 'Laboratorio 3', 15)
GO

INSERT INTO GestionEventos.Inscripciones(id_estudiante, id_sesion, estado) VALUES
    (4, 1, 1),
    (5, 1, 0),
    (7, 3, 1),
    (4, 3, 1),
    (5, 4, 1)
GO

INSERT INTO GestionEventos.Asistencias(id_inscripcion, estatus_asistencia, participacion) VALUES
    (1, 'Presente', 5),
    (3, 'Tarde', 3),
    (4, 'Falta justificada', 0)
GO

INSERT INTO GestionEventos.FeedbackEvaluaciones (id_inscripcion, comentario, puntuacion_tutor) VALUES
    (1, 'Muy buena, me gustó mucho', 5),
    (2, 'No pude asistir, pero la comunicación fue mala.', 1),
    (3, 'Llegué tarde pero el tutor repasó los temas principales.', 4)
GO

INSERT INTO GestionIdentidadAcad.Usuarios(email, pass_hash, id_rol) VALUES
    ('fperez@uamv.edu.ni', HASHBYTES('SHA2_256', 'pass1234'), 3),
    ('dlopez@uamv.edu.ni', HASHBYTES('SHA2_256', 'pass1234'), 2),
    ('mgarcia@uamv.edu.ni', HASHBYTES('SHA2_256', 'pass1234'), 2),
    ('rhernandez@uamv.edu.ni', HASHBYTES('SHA2_256', 'pass1234'), 3)
GO

INSERT INTO GestionIdentidadAcad.PerfilesDatos(id_usuario, nombres, apellidos, telefono, carrera) VALUES
    (9, 'Fernando', 'Pérez', '55555555', 'Ingeniería en Sistemas'),
    (10, 'Diana', 'López', '55555556', 'Marketing'),
    (11, 'Mario', 'García', '55555557', 'Diseño Gráfico'),
    (12, 'Rosa', 'Hernández', '55555558', 'Arquitectura')
GO

INSERT INTO GestionIdentidadAcad.Materias(cod_materia, nombre, creditos) VALUES
    ('RED0150', 'Redes de Computadoras', 4),
    ('DIS0200', 'Diseño Centrado en el Usuario', 3)
GO

INSERT INTO GestionRolesPermisos.RegistrosAcceso(id_usuario, estado, ip) VALUES
    (9, 1, '192.168.1.18'),
    (10, 1, '192.168.1.19'),
    (11, 1, '192.168.1.20'),
    (12, 1, '192.168.1.21')
GO

INSERT INTO GestionRolesPermisos.Auditoria(tabla, columna, tupla, operacion, estado_anterior, estado_actual) VALUES
    ('Usuarios', 'email', 9, 'INSERT', NULL, 'fperez@uamv.edu.ni'),
    ('Usuarios', 'email', 10, 'INSERT', NULL, 'dlopez@uamv.edu.ni'),
    ('Usuarios', 'email', 11, 'INSERT', NULL, 'mgarcia@uamv.edu.ni'),
    ('Usuarios', 'email', 12, 'INSERT', NULL, 'rhernandez@uamv.edu.ni')
GO

INSERT INTO GestionRolesPermisos.AuditoriaHistorial(id_audit, id_usuario) VALUES
    (6, 1),
    (7, 1),
    (8, 1),
    (9, 1)
GO

INSERT INTO GestionTutores.Tutores(id_tutor, estado_tutor) VALUES
    (9, 1),
    (12, 1)
GO

INSERT INTO GestionTutores.HorariosTutor (id_tutor, dia_semana, hora_inicio, hora_fin) VALUES
    (9, 1, '16:00:00', '18:00:00'),
    (12, 2, '09:00:00', '11:00:00')
GO

INSERT INTO GestionTutores.TutorMateria(id_tutor, id_materia) VALUES
    (9, 6),
    (12, 7)
GO

INSERT INTO GestionTutores.TutoresValidacion(id_tutor, is_valid) VALUES
    (9, 1),
    (12, 1)
GO

INSERT INTO GestionTutores.Acreditaciones (id_tutor, archivo, file_name) VALUES
    (9, 0x255044462D312E, 'cert_redes.pdf'),
    (12, 0x255044462D312E, 'cert_diseno.pdf')
GO

INSERT INTO GestionTutores.PerfilTutor (id_tutor, descripcion) VALUES
    (9, 'Especialista en infraestructura de redes y ciberseguridad.'),
    (12, 'Arquitecta y diseñadora con 5 años de experiencia en UI/UX.')
GO

INSERT INTO GestionTutores.CalificacionesTutor(id_tutor, puntuacion) VALUES
    (9, 4.9),
    (12, 4.6)
GO

INSERT INTO GestionTutores.MetricasAprendizaje(periodo, id_materia, estado_sesion, total_inscritos, total_asistencias, promedio_puntuacion) VALUES
    ('Primer semestre 2026', 6, 'Activa', 10, 9, 4.8),
    ('Primer semestre 2026', 7, 'Activa', 12, 10, 4.5)
GO

INSERT INTO GestionEventos.Sesiones(id_tutor_materia, fecha, hora_inicio, hora_fin, ubicacion, cupo_max) VALUES
    (7, '2026-08-01', '16:00:00', '18:00:00', 'Laboratorio Redes', 20),
    (8, '2026-08-05', '09:00:00', '11:00:00', 'Taller Diseño', 15)
GO

INSERT INTO GestionEventos.Inscripciones(id_estudiante, id_sesion, estado) VALUES
    (10, 5, 1),
    (11, 5, 1),
    (10, 6, 1),
    (7, 6, 1)
GO

INSERT INTO GestionEventos.Asistencias(id_inscripcion, estatus_asistencia, participacion) VALUES
    (6, 'Presente', 5),
    (7, 'Falta injustificada', 0),
    (8, 'Presente', 4)
GO

INSERT INTO GestionEventos.FeedbackEvaluaciones (id_inscripcion, comentario, puntuacion_tutor) VALUES
    (6, 'Excelente dominio del tema de enrutamiento.', 5),
    (8, 'La clase de diseño fue muy interactiva.', 4)
GO

-- Update

UPDATE GestionIdentidadAcad.Usuarios
SET email = N'feperez@uamv.edu.ni'
WHERE id_usuario = 9

UPDATE GestionIdentidadAcad.PerfilesDatos
SET telefono = '55555544'
WHERE id_usuario = 9

UPDATE GestionIdentidadAcad.Materias
SET nombre = N'Tecnologías de Redes'
WHERE cod_materia = 'RED0150'

UPDATE GestionTutores.Tutores
SET estado_tutor = 0
WHERE id_tutor = 12

UPDATE GestionTutores.HorariosTutor
SET hora_fin = '17:30:00'
WHERE id_tutor = 9

UPDATE GestionTutores.TutorMateria
SET id_tutor = 2
WHERE id_tutor = 9 AND id_materia = 6

UPDATE GestionTutores.TutoresValidacion
SET is_valid = 0
WHERE id_tutor = 2

UPDATE GestionTutores.Acreditaciones
SET file_name = 'cert_diseno1.pdf'
WHERE file_name = 'cert_diseno.pdf'

UPDATE GestionTutores.PerfilTutor
SET descripcion = 'Arquitecta y diseñadora con 6 años de experiencia en UI/UX'
WHERE id_tutor = 12

UPDATE GestionTutores.CalificacionesTutor
SET puntuacion = 5.0
WHERE id_tutor = 9

UPDATE GestionTutores.MetricasAprendizaje
SET total_inscritos = 11
WHERE id_metrica = 6

UPDATE GestionEventos.Sesiones
SET ubicacion = 'Auditorio central'
WHERE id_sesion = 6

UPDATE GestionEventos.Inscripciones
SET estado = 0
WHERE id_inscripcion = 9

UPDATE GestionEventos.Asistencias
SET estatus_asistencia = 'Falta justificada'
WHERE id_asistencia = 5

DELETE FROM GestionEventos.FeedbackEvaluaciones WHERE id_feedback = 4;
GO

DELETE FROM GestionEventos.Asistencias
WHERE id_asistencia = 4;
GO

DELETE FROM GestionEventos.Inscripciones
WHERE id_inscripcion = 6;
GO

DELETE FROM GestionTutores.Acreditaciones
WHERE file_name = 'cert_redes.pdf';
GO

-- 1. Mostrar todos los usuarios
SELECT * FROM GestionIdentidadAcad.Usuarios
GO

-- 2. Mostrar los perfiles de los usuarios
SELECT nombres, apellidos, telefono, carrera FROM GestionIdentidadAcad.PerfilesDatos
GO

-- 3. Mostrar las materias registradas
SELECT cod_materia, nombre, creditos FROM GestionIdentidadAcad.Materias
GO

-- 4. Mostrar los tutores activos
SELECT id_tutor, estado_tutor FROM GestionTutores.Tutores
WHERE estado_tutor = 1
GO

-- 5. Mostrar las sesiones disponibles
SELECT fecha, hora_inicio, hora_fin, ubicacion, cupo_max FROM GestionEventos.Sesiones
GO