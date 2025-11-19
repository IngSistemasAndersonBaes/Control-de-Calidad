create database ControlCalidad;

use ControlCalidad;

-- =============================================
-- SISTEMA DE CONTROL DE CALIDAD - BASE DE DATOS
-- =============================================

-- Tabla de Roles
CREATE TABLE Roles (
    id_rol INT PRIMARY KEY IDENTITY(1,1),
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nombre_completo VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    id_rol INT NOT NULL,
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    ultimo_acceso DATETIME,
    intentos_fallidos INT DEFAULT 0,
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol)
);

-- Tabla de Auditoría de Accesos
CREATE TABLE AuditoriaAccesos (
    id_auditoria INT PRIMARY KEY IDENTITY(1,1),
    id_usuario INT,
    accion VARCHAR(100),
    ip_address VARCHAR(45),
    fecha_hora DATETIME DEFAULT GETDATE(),
    resultado VARCHAR(50),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

-- =============================================
-- TABLAS DEL SISTEMA DE CALIDAD
-- =============================================

-- Tabla de Productos
CREATE TABLE Producto (
    id_producto INT PRIMARY KEY IDENTITY(1,1),
    codigo_producto VARCHAR(50) NOT NULL UNIQUE,
    nombre_producto VARCHAR(150) NOT NULL,
    descripcion TEXT,
    categoria VARCHAR(100),
    unidad_medida VARCHAR(20),
    especificaciones_tecnicas TEXT,
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE(),
    creado_por INT,
    FOREIGN KEY (creado_por) REFERENCES Usuarios(id_usuario)
);

-- Tabla de Tipos de Falla
CREATE TABLE TiposDeFalla (
    id_tipo_falla INT PRIMARY KEY IDENTITY(1,1),
    codigo_falla VARCHAR(50) NOT NULL UNIQUE,
    nombre_falla VARCHAR(150) NOT NULL,
    descripcion TEXT,
    severidad VARCHAR(20) CHECK (severidad IN ('Baja', 'Media', 'Alta', 'Crítica')),
    categoria VARCHAR(100),
    accion_correctiva_sugerida TEXT,
    estado BIT DEFAULT 1,
    fecha_creacion DATETIME DEFAULT GETDATE()
);

-- Tabla de Lotes de Producción
CREATE TABLE LotesProduccion (
    id_lote INT PRIMARY KEY IDENTITY(1,1),
    numero_lote VARCHAR(50) NOT NULL UNIQUE,
    id_producto INT NOT NULL,
    fecha_produccion DATE NOT NULL,
    cantidad_producida INT NOT NULL,
    turno VARCHAR(20),
    operador_responsable VARCHAR(100),
    estado_lote VARCHAR(50) DEFAULT 'En Proceso',
    observaciones TEXT,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- Tabla Principal de Revisión
CREATE TABLE Revision (
    id_revision INT PRIMARY KEY IDENTITY(1,1),
    numero_revision VARCHAR(50) NOT NULL UNIQUE,
    id_producto INT NOT NULL,
    id_lote INT,
    fecha_revision DATETIME DEFAULT GETDATE(),
    id_inspector INT NOT NULL,
    cantidad_inspeccionada INT NOT NULL,
    cantidad_aprobada INT DEFAULT 0,
    cantidad_rechazada INT DEFAULT 0,
    porcentaje_defectos DECIMAL(5,2),
    resultado_final VARCHAR(50) CHECK (resultado_final IN ('Aprobado', 'Rechazado', 'Pendiente', 'Condicional')),
    observaciones_generales TEXT,
    estado VARCHAR(50) DEFAULT 'En Proceso',
    aprobado_por INT,
    fecha_aprobacion DATETIME,
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY (id_lote) REFERENCES LotesProduccion(id_lote),
    FOREIGN KEY (id_inspector) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (aprobado_por) REFERENCES Usuarios(id_usuario)
);

-- Tabla de Detalles de Fallas por Revisión
CREATE TABLE DetallesFalla (
    id_detalle INT PRIMARY KEY IDENTITY(1,1),
    id_revision INT NOT NULL,
    id_tipo_falla INT NOT NULL,
    cantidad_defectos INT NOT NULL,
    ubicacion_defecto VARCHAR(255),
    descripcion_detallada TEXT,
    imagen_evidencia VARCHAR(255),
    accion_correctiva TEXT,
    responsable_correccion VARCHAR(100),
    estado_correccion VARCHAR(50) DEFAULT 'Pendiente',
    fecha_registro DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_revision) REFERENCES Revision(id_revision),
    FOREIGN KEY (id_tipo_falla) REFERENCES TiposDeFalla(id_tipo_falla)
);

-- Tabla de Mediciones y Estadísticas
CREATE TABLE MedicionesCalidad (
    id_medicion INT PRIMARY KEY IDENTITY(1,1),
    id_revision INT NOT NULL,
    parametro_medido VARCHAR(100) NOT NULL,
    valor_medido DECIMAL(10,2),
    valor_minimo DECIMAL(10,2),
    valor_maximo DECIMAL(10,2),
    valor_optimo DECIMAL(10,2),
    unidad VARCHAR(20),
    cumple_especificacion BIT,
    observaciones TEXT,
    FOREIGN KEY (id_revision) REFERENCES Revision(id_revision)
);

-- Tabla de Planes de Acción Correctiva
CREATE TABLE PlanesAccionCorrectiva (
    id_plan INT PRIMARY KEY IDENTITY(1,1),
    id_revision INT NOT NULL,
    descripcion_problema TEXT NOT NULL,
    causa_raiz TEXT,
    accion_correctiva TEXT NOT NULL,
    accion_preventiva TEXT,
    responsable INT,
    fecha_inicio DATE,
    fecha_estimada_cierre DATE,
    fecha_cierre DATE,
    estado VARCHAR(50) DEFAULT 'Abierto',
    efectividad VARCHAR(50),
    costo_estimado DECIMAL(10,2),
    FOREIGN KEY (id_revision) REFERENCES Revision(id_revision),
    FOREIGN KEY (responsable) REFERENCES Usuarios(id_usuario)
);

-- Tabla de Configuración del Sistema
CREATE TABLE ConfiguracionSistema (
    id_config INT PRIMARY KEY IDENTITY(1,1),
    parametro VARCHAR(100) NOT NULL UNIQUE,
    valor VARCHAR(255) NOT NULL,
    descripcion TEXT,
    tipo_dato VARCHAR(20),
    modificado_por INT,
    fecha_modificacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (modificado_por) REFERENCES Usuarios(id_usuario)
);

-- =============================================
-- DATOS INICIALES
-- =============================================

-- Insertar Roles
INSERT INTO Roles (nombre_rol, descripcion) VALUES
('Administrador', 'Control total del sistema'),
('Jefe de Calidad', 'Supervisión y aprobación de revisiones'),
('Inspector', 'Realización de inspecciones y registro de datos');

-- Insertar Usuario Administrador por defecto (password: admin123)
INSERT INTO Usuarios (username, password_hash, nombre_completo, email, id_rol) VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', 'Administrador del Sistema', 'admin@empresa.com', 1);

-- Insertar Tipos de Falla Comunes
INSERT INTO TiposDeFalla (codigo_falla, nombre_falla, descripcion, severidad, categoria) VALUES
('D001', 'Dimensiones fuera de especificación', 'Producto no cumple con las dimensiones establecidas', 'Alta', 'Dimensional'),
('D002', 'Defecto superficial', 'Rayones, abolladuras o imperfecciones en la superficie', 'Media', 'Estético'),
('D003', 'Falla funcional', 'El producto no funciona según lo especificado', 'Crítica', 'Funcional'),
('D004', 'Color incorrecto', 'Color no coincide con la especificación', 'Media', 'Estético'),
('D005', 'Contaminación', 'Presencia de materiales extraños', 'Alta', 'Contaminación'),
('D006', 'Ensamble incorrecto', 'Componentes mal ensamblados', 'Alta', 'Ensamble'),
('D007', 'Empaque defectuoso', 'Empaque dañado o incorrecto', 'Baja', 'Empaque');

-- Insertar Productos de Ejemplo
INSERT INTO Producto (codigo_producto, nombre_producto, descripcion, categoria, unidad_medida, creado_por) VALUES
('PROD001', 'Componente Electrónico A', 'Circuito integrado para aplicaciones industriales', 'Electrónica', 'Unidades', 1),
('PROD002', 'Pieza Mecánica B', 'Engranaje de alta precisión', 'Mecánica', 'Unidades', 1),
('PROD003', 'Producto Químico C', 'Compuesto químico para limpieza', 'Química', 'Litros', 1);

-- Configuración del Sistema
INSERT INTO ConfiguracionSistema (parametro, valor, descripcion, tipo_dato) VALUES
('porcentaje_defectos_maximo', '5.0', 'Porcentaje máximo de defectos permitido', 'decimal'),
('dias_retencion_auditorias', '365', 'Días de retención de auditorías', 'int'),
('email_notificaciones', 'calidad@empresa.com', 'Email para notificaciones', 'string'),
('nivel_severidad_alerta', 'Alta', 'Nivel de severidad que genera alerta', 'string');

-- =============================================
-- VISTAS PARA REPORTES
-- =============================================

-- Vista de Resumen de Revisiones
GO
CREATE VIEW vw_ResumenRevisiones AS
SELECT 
    r.id_revision,
    r.numero_revision,
    r.fecha_revision,
    p.codigo_producto,
    p.nombre_producto,
    l.numero_lote,
    u.nombre_completo AS inspector,
    r.cantidad_inspeccionada,
    r.cantidad_aprobada,
    r.cantidad_rechazada,
    r.porcentaje_defectos,
    r.resultado_final,
    r.estado,
    jc.nombre_completo AS aprobado_por,
    r.fecha_aprobacion
FROM Revision r
INNER JOIN Producto p ON r.id_producto = p.id_producto
LEFT JOIN LotesProduccion l ON r.id_lote = l.id_lote
INNER JOIN Usuarios u ON r.id_inspector = u.id_usuario
LEFT JOIN Usuarios jc ON r.aprobado_por = jc.id_usuario;
GO

-- Vista de Defectos por Producto
CREATE VIEW vw_DefectosPorProducto AS
SELECT 
    p.codigo_producto,
    p.nombre_producto,
    tf.nombre_falla,
    tf.severidad,
    SUM(df.cantidad_defectos) AS total_defectos,
    COUNT(DISTINCT r.id_revision) AS revisiones_afectadas
FROM DetallesFalla df
INNER JOIN Revision r ON df.id_revision = r.id_revision
INNER JOIN Producto p ON r.id_producto = p.id_producto
INNER JOIN TiposDeFalla tf ON df.id_tipo_falla = tf.id_tipo_falla
GROUP BY p.codigo_producto, p.nombre_producto, tf.nombre_falla, tf.severidad;
GO

-- Vista de Performance de Inspectores
CREATE VIEW vw_PerformanceInspectores AS
SELECT 
    u.id_usuario,
    u.nombre_completo,
    COUNT(r.id_revision) AS total_revisiones,
    SUM(r.cantidad_inspeccionada) AS total_inspeccionado,
    AVG(r.porcentaje_defectos) AS promedio_defectos,
    SUM(CASE WHEN r.resultado_final = 'Aprobado' THEN 1 ELSE 0 END) AS revisiones_aprobadas,
    SUM(CASE WHEN r.resultado_final = 'Rechazado' THEN 1 ELSE 0 END) AS revisiones_rechazadas
FROM Usuarios u
LEFT JOIN Revision r ON u.id_usuario = r.id_inspector
WHERE u.id_rol = 3
GROUP BY u.id_usuario, u.nombre_completo;
GO

-- =============================================
-- PROCEDIMIENTOS ALMACENADOS
-- =============================================

-- SP para calcular porcentaje de defectos
CREATE PROCEDURE sp_CalcularPorcentajeDefectos
    @id_revision INT
AS
BEGIN
    DECLARE @total_defectos INT;
    DECLARE @cantidad_inspeccionada INT;
    DECLARE @porcentaje DECIMAL(5,2);
    
    SELECT @total_defectos = SUM(cantidad_defectos)
    FROM DetallesFalla
    WHERE id_revision = @id_revision;
    
    SELECT @cantidad_inspeccionada = cantidad_inspeccionada
    FROM Revision
    WHERE id_revision = @id_revision;
    
    IF @cantidad_inspeccionada > 0
    BEGIN
        SET @porcentaje = (@total_defectos * 100.0) / @cantidad_inspeccionada;
        
        UPDATE Revision
        SET porcentaje_defectos = @porcentaje,
            cantidad_rechazada = @total_defectos,
            cantidad_aprobada = @cantidad_inspeccionada - @total_defectos
        WHERE id_revision = @id_revision;
    END
END;
GO

-- SP para aprobar revisión
CREATE PROCEDURE sp_AprobarRevision
    @id_revision INT,
    @id_jefe INT
AS
BEGIN
    UPDATE Revision
    SET estado = 'Finalizado',
        aprobado_por = @id_jefe,
        fecha_aprobacion = GETDATE()
    WHERE id_revision = @id_revision;
END;
GO

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================

CREATE INDEX idx_revision_fecha ON Revision(fecha_revision);
CREATE INDEX idx_revision_producto ON Revision(id_producto);
CREATE INDEX idx_revision_inspector ON Revision(id_inspector);
CREATE INDEX idx_detalles_revision ON DetallesFalla(id_revision);
CREATE INDEX idx_usuarios_rol ON Usuarios(id_rol);
CREATE INDEX idx_auditoria_fecha ON AuditoriaAccesos(fecha_hora);

PRINT 'Base de datos creada exitosamente';
GO