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

INSERT INTO GestionIdentidadAcad.PerfilesDatos(nombres, apellidos, telefono, carrera) VALUES
   (1, 'Andrea Sofía', 'de la Roca Delgado', '88888888', 'Ingeniería en Gastronomía'),
   (2, 'María Alejandra', 'Sarante Salinas', '66666666', 'Licenciatura en Francés'),
   (3, 'Luis Lenin', 'Aguirre Vílchez', '77777777', 'Ingeniería en Terraria'),
   (4, 'Charlotte', 'Aguirre Molina', '67676767', 'Ingeniería en SA2')
GO