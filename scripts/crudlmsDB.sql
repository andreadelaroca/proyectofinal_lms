USE lmsDB
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
