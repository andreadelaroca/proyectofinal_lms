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