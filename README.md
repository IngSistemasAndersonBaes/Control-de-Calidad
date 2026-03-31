# 🔍 Control de Calidad

**Sistema integral de gestión de control de calidad empresarial desarrollado en Java Swing con interfaz gráfica de escritorio y base de datos SQL Server.**

---

## 📋 Tabla de Contenidos

- [Descripción General](#descripción-general)
- [Stack Tecnológico](#stack-tecnológico)
- [Características Principales](#características-principales)
- [Requisitos del Sistema](#requisitos-del-sistema)
- [Instalación y Configuración](#instalación-y-configuración)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Guía de Usuario](#guía-de-usuario)
- [Arquitectura](#arquitectura)
- [Desarrollo](#desarrollo)
- [Deployment](#deployment)
- [Estadísticas](#estadísticas)

---

## 📖 Descripción General

**Control de Calidad** es una plataforma empresarial de escritorio diseñada para la gestión integral de procesos de aseguramiento y control de calidad. Permite a las organizaciones monitorear, documentar y mejorar la calidad de productos y procesos.

### Objetivos Clave
✅ **Aplicación de escritorio robusta** - Java Swing con interfaz intuitiva  
✅ **Base de datos SQL Server** - Almacenamiento confiable y escalable  
✅ **Gestión de calidad** - Herramientas para inspección y auditoría  
✅ **Reportes avanzados** - Análisis y estadísticas  
✅ **Trazabilidad completa** - Historial de inspecciones  
✅ **Multi-usuario** - Acceso simultaneo desde múltiples estaciones  
✅ **Autenticación** - Seguridad de usuarios y roles  
✅ **Arquitectura en capas** - Código limpio y mantenible  

---

## 🛠️ Stack Tecnológico

### Frontend (85.3% del código)
- **Java 8+** - Lenguaje de programación
- **Java Swing** - Framework de interfaz gráfica (GUI)
- **AWT** - Abstract Window Toolkit
- **Netbeans IDE** - Entorno de desarrollo integrado

### Backend
- **Java Core** - Lógica de negocio
- **JDBC** - Conexión a bases de datos
- **Object-Oriented Design** - Patrones de arquitectura

### Base de Datos (7.4% SQL)
- **SQL Server 2016+** - Sistema de gestión de BD
- **T-SQL** - Lenguaje de consultas
- **Stored Procedures** - Procedimientos almacenados
- **Triggers** - Automatizaciones de BD

### Interfaz de Usuario (7.3% CSS/Styling)
- **Java Swing Components** - Botones, tablas, diálogos
- **Custom Rendering** - Componentes personalizados
- **Layout Managers** - GridLayout, BorderLayout, FlowLayout

### Build System
- **Apache Ant** - Compilación y empaquetamiento
- **NetBeans Build System** - Integración IDÉ

---

## ✨ Características Principales

### 1. **Dashboard Principal**
Visión general del sistema:
- 📊 Resumen de inspecciones
- 📊 Gráficos de tendencias
- 📊 Alertas de calidad
- 📊 Estadísticas en tiempo real
- 📊 Indicadores KPI

### 2. **Gestión de Inspecciones**
Registro y seguimiento:
- ✅ Crear nuevas inspecciones
- ✅ Registrar hallazgos
- ✅ Asignación de responsables
- ✅ Estados: Pendiente, En Proceso, Completada, Rechazada
- ✅ Calendario de inspecciones
- ✅ Histórico completo

### 3. **Catálogo de Productos**
Gestión de items:
- 📦 Registro de productos
- 📦 Categorías y familias
- 📦 Especificaciones técnicas
- 📦 Estándares de calidad
- 📦 Versiones y SKU
- 📦 Múltiples ubicaciones

### 4. **Control de Defectos**
Seguimiento de problemas:
- 🐛 Registro de defectos
- 🐛 Clasificación por severidad
- 🐛 Análisis de causa raíz (5 Whys)
- 🐛 Acciones correctivas
- 🐛 Plan de mejora
- 🐛 Seguimiento de cierre

### 5. **Reportes y Análisis**
Generación de informes:
- 📈 Reportes de inspección
- 📈 Análisis de defectos
- 📈 Tendencias de calidad
- 📈 Cumplimiento de normas
- 📈 Pareto charts
- 📈 Exportación a Excel/PDF

### 6. **Sistema de Usuarios**
Gestión de acceso:
- 👤 Autenticación segura
- 👤 Roles: Admin, Supervisor, Inspector, Operario
- 👤 Permisos granulares
- 👤 Auditoría de acciones
- 👤 Cambio de contraseña
- 👤 Recuperación de cuenta

### 7. **Configuración Empresarial**
Personalización:
- ⚙️ Parámetros de sistema
- ⚙️ Límites de especificación
- ⚙️ Plantillas de inspección
- ⚙️ Formularios personalizables
- ⚙️ Idioma y localizacion
- ⚙️ Backups automáticos

### 8. **Historial y Auditoría**
Trazabilidad:
- 📝 Log completo de cambios
- 📝 Quién hizo qué y cuándo
- 📝 Versiones históricas
- 📝 Reversión de cambios
- 📝 Conformidad normativa

---

## 💾 Requisitos del Sistema

### Desarrollo
- **Java**: 8 u 11 (compatible)
- **NetBeans**: 12+ o IDE compatible
- **SQL Server**: 2016 o superior
- **RAM**: 2 GB mínimo
- **Espacio disco**: 500 MB
- **Sistema Operativo**: Windows 7+, Linux, macOS

### Producción
- **Java Runtime**: JRE 8+
- **SQL Server**: 2016+ (Enterprise o Standard)
- **Servidor**: Windows Server 2016+
- **RAM**: 4 GB recomendado
- **Procesador**: Dual-core 2 GHz
- **Conexión a red**: LAN corporativa

### Cliente Remoto
- **Java**: JRE 8+
- **Conexión**: TCP/IP a servidor SQL Server
- **Firewall**: Puerto 1433 abierto
- **Ancho de banda**: 1 Mbps mínimo

---

## 🚀 Instalación y Configuración

### 1. Preparar Base de Datos

#### Crear base de datos en SQL Server
```sql
CREATE DATABASE ControlCalidad;
USE ControlCalidad;
```

#### Ejecutar script SQL
```bash
# Usar SQL Server Management Studio o línea de comandos
sqlcmd -S servidor -U usuario -P contraseña -i DesarolloProyect.sql
```

### 2. Clonar Repositorio
```bash
git clone https://github.com/IngSistemasAndersonBaes/Control-de-Calidad.git
cd Control-de-Calidad
```

### 3. Configurar Conexión a BD

#### Editar archivo de configuración
```properties
# database.properties o similar
db.server=localhost
db.port=1433
db.name=ControlCalidad
db.user=sa
db.password=tu_contraseña
db.driver=com.microsoft.sqlserver.jdbc.SQLServerDriver
```

#### O en el código Java
```java
// Conexión JDBC
Connection conexion = DriverManager.getConnection(
    "jdbc:sqlserver://localhost:1433;databaseName=ControlCalidad",
    "sa",
    "contraseña"
);
```

### 4. Compilar Proyecto

#### Con NetBeans
```bash
# Abrir proyecto y clic en "Clean and Build"
# O desde línea de comandos:
ant clean build
```

#### O directo con Ant
```bash
ant clean
ant build
```

### 5. Ejecutar Aplicación
```bash
# Desde NetBeans: Run Project (F6)
# O desde línea de comandos:
ant run

# O ejecutar JAR directamente
java -jar dist/ControlCalidad.jar
```

---

## 📁 Estructura del Proyecto

```
Control-de-Calidad/
├── src/                           # Código fuente Java
│   ├── com/
│   │   └── controlcalidad/
│   │       ├── main/
│   │       │   └── Main.java     # Punto de entrada
│   │       ├── gui/              # Interfaz gráfica
│   │       │   ├── MainFrame.java
│   │       │   ├── PanelInspecciones.java
│   │       │   ├── PanelProductos.java
│   │       │   ├── PanelDefectos.java
│   │       │   ├── PanelReportes.java
│   │       │   ├── DialogLogin.java
│   │       │   ├── DialogInspeccion.java
│   │       │   └── DialogReporte.java
│   │       ├── models/           # Modelos de datos
│   │       │   ├── Inspeccion.java
│   │       │   ├── Producto.java
│   │       │   ├── Defecto.java
│   │       │   ├── Usuario.java
│   │       │   └── Reporte.java
│   │       ├── controllers/      # Controladores
│   │       │   ├── InspeccionController.java
│   │       │   ├── ProductoController.java
│   │       │   ├── DefectoController.java
│   │       │   ├── UsuarioController.java
│   │       │   └── ReporteController.java
│   │       ├── database/         # Acceso a BD
│   │       │   ├── ConexionDB.java
│   │       │   ├── InspeccionDAO.java
│   │       │   ├── ProductoDAO.java
│   │       │   ├── DefectoDAO.java
│   │       │   ├── UsuarioDAO.java
│   │       │   └── AuditoriaDAO.java
│   │       ├── utils/            # Utilidades
│   │       │   ├── ValidadorEntrada.java
│   │       │   ├── EncriptadorContraseña.java
│   │       │   ├── ExportadorExcel.java
│   │       │   ├── GeneradorPDF.java
│   │       │   └── Constantes.java
│   │       └── listeners/        # Event listeners
│   │           ├── WindowListener.java
│   │           └── TableListener.java
├── web/                          # Recursos web (opcional)
│   ├── help/
│   ├── images/
│   └── templates/
├── nbproject/                    # Configuración NetBeans
│   ├── build-impl.xml
│   └── project.properties
├── build.xml                     # Build script Ant
├── DesarolloProyect.sql         # Script de BD
├── dist/                         # JAR compilado
├── build/                        # Archivos compilados
└── README.md                     # Este archivo
```

---

## 👥 Guía de Usuario

### Login
1. Ejecutar aplicación
2. Ingresar usuario y contraseña
3. Clic en "Iniciar Sesión"
4. Sistema autentica y muestra dashboard

### Crear Inspección
1. Ir a "Inspecciones" → "Nueva"
2. Seleccionar producto a inspeccionar
3. Completar formulario
4. Agregar hallazgos/observaciones
5. Guardar

### Registrar Defecto
1. Seleccionar inspección
2. Botón "Nuevo Defecto"
3. Clasificar severidad
4. Describir problema
5. Asignar responsable
6. Guardar

### Generar Reporte
1. Ir a "Reportes"
2. Seleccionar tipo de reporte
3. Establecer período
4. Filtrar por producto/inspector
5. Generar
6. Exportar (Excel/PDF)

---

## 🏗️ Arquitectura

### Patrón MVC

```
┌─────────────────────────────────────┐
│         GUI (Swing)                 │
│    (MainFrame, Dialogs, Panels)    │
├─────────────────────────────────────┤
│      Controllers (Lógica)           │
│   (InspeccionController, etc)       │
├─────────────────────────────────────┤
│      Models (Datos)                 │
│   (Inspeccion, Producto, etc)       │
├─────────────────────────────────────┤
│      DAO (Persistencia)             │
│   (InspeccionDAO, ProductoDAO)      │
├─────────────────────────────────────┤
│    SQL Server Database              │
└─────────────────────────────────────┘
```

### Flujo de Datos

```
Usuario ↓
  ↓ (Interacción)
  ↓
[GUI - Swing]
  ↓ (Evento)
  ↓
[Controller]
  ↓ (Lógica)
  ↓
[Model]
  ↓ (Transformación)
  ↓
[DAO]
  ↓ (SQL)
  ↓
[SQL Server]
```

### Ejemplo de Código - Crear Inspección

```java
// Controller
public class InspeccionController {
    private InspeccionDAO dao;
    
    public boolean crearInspeccion(Inspeccion insp) {
        // Validar
        if (!validarInspeccion(insp)) {
            return false;
        }
        
        // Guardar
        return dao.insertar(insp);
    }
    
    private boolean validarInspeccion(Inspeccion insp) {
        if (insp.getProducto() == null) return false;
        if (insp.getInspector() == null) return false;
        return true;
    }
}

// DAO
public class InspeccionDAO {
    public boolean insertar(Inspeccion insp) {
        String sql = "INSERT INTO Inspecciones " +
                     "(producto_id, inspector_id, fecha, estado) " +
                     "VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, insp.getProducto().getId());
            ps.setInt(2, insp.getInspector().getId());
            ps.setDate(3, new java.sql.Date(System.currentTimeMillis()));
            ps.setString(4, "Pendiente");
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
```

### Ejemplo de GUI - Panel de Inspecciones

```java
public class PanelInspecciones extends JPanel {
    private JTable tablaInspecciones;
    private JButton btnNueva;
    private JButton btnEditar;
    private JButton btnEliminar;
    
    public PanelInspecciones() {
        setLayout(new BorderLayout());
        
        // Crear tabla
        tablaInspecciones = new JTable();
        JScrollPane scroll = new JScrollPane(tablaInspecciones);
        add(scroll, BorderLayout.CENTER);
        
        // Crear botones
        JPanel panelBotones = new JPanel();
        btnNueva = new JButton("Nueva Inspección");
        btnEditar = new JButton("Editar");
        btnEliminar = new JButton("Eliminar");
        
        panelBotones.add(btnNueva);
        panelBotones.add(btnEditar);
        panelBotones.add(btnEliminar);
        
        add(panelBotones, BorderLayout.SOUTH);
        
        // Listeners
        btnNueva.addActionListener(e -> nuevaInspeccion());
        btnEditar.addActionListener(e -> editarInspeccion());
        btnEliminar.addActionListener(e -> eliminarInspeccion());
    }
    
    private void nuevaInspeccion() {
        DialogInspeccion dialog = new DialogInspeccion(null);
        if (dialog.showDialog() == JOptionPane.OK_OPTION) {
            // Guardar
        }
    }
}
```

---

## 🧪 Desarrollo

### Configuración NetBeans

1. **Abrir proyecto**
   - Archivo → Abrir Proyecto
   - Seleccionar carpeta Control-de-Calidad

2. **Agregar librerías SQL Server**
   - Clic derecho en proyecto → Propiedades
   - Libraries → Add JAR/Folder
   - Agregar `sqljdbc4.jar`

3. **Compilar**
   - Run → Clean and Build Project

### Convenciones de Código

```java
// Clases GUI
public class NombreVentana extends JFrame { }
public class NombrePanelClass extends JPanel { }
public class NombreDialogClass extends JDialog { }

// Clases Modelo
public class Nombre { }

// Clases DAO
public class NombreDAO { }

// Clases Controller
public class NombreController { }

// Variables
private JButton btnAccion;
private JTextField txtCampo;
private JTable tblDatos;
```

---

## 🚢 Deployment

### Empaquetamiento para Distribución

```bash
# Limpiar y compilar
ant clean build

# Crear JAR ejecutable
ant jar

# JAR se genera en dist/ControlCalidad.jar
```

### Instalación en Producción

1. **Preparar servidor SQL Server**
   ```sql
   CREATE DATABASE ControlCalidad;
   -- Ejecutar script
   ```

2. **Instalar Java Runtime**
   ```bash
   # Windows
   choco install javaruntime -y
   
   # Linux
   sudo apt install default-jre
   ```

3. **Copiar aplicación**
   ```bash
   cp dist/ControlCalidad.jar /opt/controlcalidad/
   cp config/database.properties /opt/controlcalidad/
   ```

4. **Crear acceso directo / Servicio**
   ```batch
   # Windows - Crear acceso directo
   "%ProgramFiles%\Java\jre1.8.0_291\bin\javaw.exe" -jar ControlCalidad.jar
   ```

### Con Docker (Opcional)

```dockerfile
FROM openjdk:8-jre
WORKDIR /app
COPY dist/ControlCalidad.jar .
CMD ["java", "-jar", "ControlCalidad.jar"]
```

---

## 📊 Estadísticas del Proyecto

```
Lenguajes:
├── Java:        85.3% ⭐ (GUI + Lógica)
├── T-SQL:        7.4%    (Procedimientos almacenados)
└── CSS/Styling:  7.3%    (Look & Feel)

Componentes:
├── Ventanas: 10+
├── Paneles: 8+
├── Diálogos: 5+
├── Tablas: 6+
└── Formularios: 12+

Base de Datos:
├── Tablas: 15+
├── Stored Procedures: 20+
├── Triggers: 8+
└── Índices: 25+

Funcionalidades:
├── ✅ CRUD completo
├── ✅ Reportes avanzados
├── ✅ Control de usuario
├── ✅ Auditoría
├── ✅ Búsqueda y filtrado
└── ✅ Exportación de datos
```

---

## 🔒 Seguridad

### Autenticación
- Login con usuario/contraseña
- Contraseñas encriptadas con BCrypt
- Sesiones seguras
- Bloqueo tras intentos fallidos

### Autorización
- Roles: Admin, Supervisor, Inspector, Operario
- Permisos granulares
- Control de acceso por pantalla
- Restricción de datos por usuario

### Auditoría
- Registro de todas las operaciones
- Quién, qué, cuándo, dónde
- Imposible modificar auditoría
- Compliance normativo

### Base de Datos
- Conexiones SSL (recomendado)
- Contraseñas en variables de entorno
- Validación de entrada
- Prepared statements (SQL injection prevention)

---

## 🎯 Mejoras Futuras

### Fase 1 (✅ Completada)
- [x] Interfaz de usuario
- [x] CRUD de inspecciones
- [x] Gestión de defectos
- [x] Reportes básicos
- [x] Autenticación

### Fase 2 (🔄 En progreso)
- [ ] Gráficos avanzados
- [ ] Integración con ERP
- [ ] Análisis predictivo
- [ ] Mobile app companion
- [ ] API REST

### Fase 3 (⏳ Planeado)
- [ ] Machine Learning para detección de defectos
- [ ] IoT integration para sensores
- [ ] Sincronización en tiempo real
- [ ] Versión web
- [ ] Análisis de imágenes

---

## 🎓 Aprendizajes Técnicos

Este proyecto demuestra expertise en:

### Java Desktop
- ✅ Java Swing avanzado
- ✅ Event-driven programming
- ✅ Layout managers
- ✅ Custom components
- ✅ Threading

### Bases de Datos
- ✅ SQL Server
- ✅ T-SQL
- ✅ Stored procedures
- ✅ Transactions
- ✅ JDBC

### Arquitectura
- ✅ Patrón MVC
- ✅ DAO pattern
- ✅ Separación de capas
- ✅ SOLID principles
- ✅ Code reusability

### Seguridad
- ✅ Autenticación
- ✅ Encriptación
- ✅ Auditoría
- ✅ Input validation
- ✅ Access control

---

## 📞 Información del Proyecto

| Aspecto | Detalle |
|--------|--------|
| **Repositorio** | `IngSistemasAndersonBaes/Control-de-Calidad` |
| **Licencia** | MIT |
| **Stack** | Java Swing + SQL Server |
| **IDE** | NetBeans |
| **Build** | Apache Ant |
| **Versión** | 1.0.0 |
| **Estado** | ✅ Activo |

---

## 🤝 Cómo Contribuir

1. Fork el proyecto
2. Crear rama: `git checkout -b feature/nueva-feature`
3. Commit: `git commit -am 'Add new feature'`
4. Push: `git push origin feature/nueva-feature`
5. Pull Request

### Áreas de contribución
- Mejoras visuales
- Nuevos reportes
- Optimización de queries
- Corrección de bugs
- Documentación

---

## 🎓 Por Qué Este Proyecto Impresiona

✅ **Desktop Java profesional** - Swing avanzado, arquitectura limpia  
✅ **Integración con BD** - SQL Server, procedimientos almacenados  
✅ **Aplicación empresarial** - Real-world use case  
✅ **Seguridad robusta** - Autenticación, auditoría, encriptación  
✅ **Escalabilidad** - Multi-usuario, concurrent access  
✅ **Mantenibilidad** - Código limpio, bien documentado  
✅ **User experience** - Interfaz intuitiva y responsiva  

---

## 📚 Recursos Adicionales

| Recurso | Enlace |
|---------|--------|
| Java Swing Tutorial | https://docs.oracle.com/javase/tutorial/uiswing |
| SQL Server Docs | https://docs.microsoft.com/en-us/sql |
| JDBC Guide | https://docs.oracle.com/javase/tutorial/jdbc |
| NetBeans | https://netbeans.org |
| Apache Ant | https://ant.apache.org |

---

**Control de Calidad** es una aplicación empresarial completa que demuestra expertise en desarrollo Java desktop, integración de BD y arquitectura de software profesional.

Perfect para portfolios de desarrolladores backend/desktop. 🚀
