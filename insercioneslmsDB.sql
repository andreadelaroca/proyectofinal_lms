USE lmsDB
GO

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
    ('laguirrev@uamv.edu.ni', HASHBYTES('SHA2_256', 'FBBRBRBG37478hf_h__'), 1),
    ('caaguirre@uamv.edu.ni', HASHBYTES('SHA2_256', 'contrasenia'), 2)
GO

INSERT INTO GestionIdentidadAcad.PerfilesDatos(id_usuario, nombres, apellidos, telefono, carrera) VALUES
   (1, 'Andrea Sofía', 'de la Roca Delgado', '88888888', 'Ingeniería en Gastronomía'),
   (2, 'María Alejandra', 'Sarante Salinas', '66666666', 'Licenciatura en Francés'),
   (3, 'Luis Lenin', 'Aguirre Vílchez', '77777777', 'Ingeniería en Terraria'),
   (4, 'Charlotte', 'Aguirre Molina', '67676767', 'Ingeniería en SA2')
GO

INSERT INTO GestionIdentidadAcad.Materias(cod_materia, nombre, creditos) VALUES
    ('CNU03250', 'Base de Datos I', 3),
    ('INOP0125', 'Identidad Nacional y Orgullo Patrio', 3),
    ('FIS0111', 'Física Aplicada', 3)
GO

INSERT INTO 

INSERT INTO GestionTutores.HorariosTutor (id_tutor,  dia_semana, hora_inicio, hora_fin) VALUES
    (1,2,'08:00:00','09:00:00'),
    (1,3,'10:00:00','12:00:00'),
    (2,4,'14:00:00','15:30:00'),
    (3,3,'15:00:00','16:00:00')
GO

-- Inserciones Tabla 3.2 TUTOR_MATERIA
INSERT INTO TUTOR_MATERIA (id_tutor,id_mat,created_at,updated_at)
VALUES
(1,1,'2026-06-01 08:15:00',NULL),
(1,2,'2026-06-01 08:20:00',NULL),
(2,1,'2026-06-02 09:00:00','2026-06-02 09:20:00'),
(3,3,'2026-06-03 11:00:00',NULL)
GO

INSERT INTO TUTORES_VALIDACION (id_tutor,is_valid,created_at,updated_at)
VALUES
(1,1,'2026-06-01 09:00:00',NULL),
(2,1,'2026-06-02 09:30:00','2026-06-02 10:00:00'),
(3,0,'2026-06-03 10:00:00',NULL)
GO

INSERT INTO ACREDITACIONES (id_tutor,archivo,created_at,updated_at)
VALUES
(1,0x123456,'2026-06-01 10:00:00',NULL),
(2,0x789ABC,'2026-06-02 10:30:00','2026-06-02 11:00:00'),
(3,0x456DEF,'2026-06-03 12:00:00',NULL)
GO

INSERT INTO PERFIL_TUTOR (id_tutor,descripcion)
VALUES
(1,'Tutor con conocimientos en Bases de Datos I, SQL Server, consultas SELECT, creación de tablas, llaves primarias y llaves foráneas','2026-06-01 11:00:00',NULL),
(2,'Tutor con dominio en programación estructurada, lógica de programación, algoritmos, ciclos y condicionales','2026-06-02 11:30:00','2026-06-02 12:00:00'),
(3,'Tutor en proceso de validación académica, con experiencia básica en apoyo estudiantil','2026-06-03 12:30:00',NULL)
GO

INSERT INTO CALIFICACIONES_TUTOR (id_tutor,puntuacion,created_at,updated_at)
VALUES
(1,4.8,'2026-06-05 14:00:00',NULL),
(1,4.5,'2026-06-06 15:00:00','2026-06-06 15:10:00'),
(2,4.2,'2026-06-07 16:00:00',NULL),
(3,3.8,'2026-06-08 17:00:00',NULL)
GO
    
INSERT INTO METRICAS_APRENDIZAJE (periodo,id_mat,estado_sesion,total_inscritos,total_asistencias,promedio_puntuacion,created_at,updated_at) VALUES
('Primer semestre 2026',1,'Finalizada',20,18,4.7,'2026-06-10 08:00:00',NULL),
('Primer semestre 2026',2,'Activa',15,12,4.3,'2026-06-11 09:00:00','2026-06-11 09:30:00'),
('Segundo semestre 2026',3,'Finalizada',25,22,4.6,'2026-06-12 10:00:00',NULL),
('Segundo semestre 2026',1,'Cancelada',8,0,NULL,'2026-06-13 11:00:00',NULL)
GO

--Inserciones de la tabla Horarios del tutor
INSERT INTO GestionTutores.HorariosTutor (id_tutor, dia_semana, hora_inicio, hora_fin) VALUES
    (1, 1, '08:00', '12:00'),
    (1, 3, '14:00', '18:00'),
    (2, 2, '09:00', '11:00'),
    (2, 5, '10:00', '13:00'),
    (3, 4, '15:00', '19:00');
GO

--Inserciones de la tabla que vincula al tutor con la materia
INSERT INTO GestionTutores.TutorMateria (id_tutor, id_materia) VALUES
    (1, 101),
    (1, 102),
    (2, 103),
    (3, 104),
    (3, 105);
GO

--Inserciones de la tabla de si un tutor esta convalidado o no
INSERT INTO GestionTutores.TutoresValidacion (id_tutor, is_valid) VALUES
    (1, 1),
    (2, 0),
    (3, 1),
    (4, 0),
    (5, 1);
GO

--Inserciones de la tabla donde se guardan las acreditaciones academicas de los tutores
INSERT INTO GestionTutores.Acreditaciones (id_tutor, archivo, file_name) VALUES
    (1, 0x255044462D312E, 'certificado_mat.pdf'),
    (2, 0xFFD8FFE000104A, 'titulo_prog.jpg'),
    (3, 0x255044462D312E, 'diploma_redes.pdf'),
    (4, 0xFFD8FFE000104A, 'certificado_bd.jpg'),
    (5, 0x255044462D312E, 'curso_excel.pdf');
GO

--Inserciones de la tabla que contiene el perfil de los tutores
INSERT INTO GestionTutores.PerfilTutor (id_tutor, descripcion) VALUES
    (1, 'Tutor especializado en Matemáticas y Física, experiencia universitaria.'),
    (2, 'Tutor de Programación en C# y Java, orientado a proyectos prácticos.'),
    (3, 'Tutor en Redes Cisco, con certificación CCNA.'),
    (4, 'Tutor en Bases de Datos SQL Server y Oracle.'),
    (5, 'Tutor en Ofimática avanzada, Excel y Power BI.');
GO

