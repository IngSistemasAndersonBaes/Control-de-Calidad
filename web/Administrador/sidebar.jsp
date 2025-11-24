<%-- 
    Document   : sidebar
    Created on : 18 nov. 2025, 19:20:46
    Author     : MINEDUCYT
--%>

<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Recuperar usuario de forma segura (puede ser null si la sesión expiró)
    Usuario userSidebar = (Usuario) session.getAttribute("usuario");
    
    // 2. Validar para evitar NullPointerException
    String nombreUser = (userSidebar != null) ? userSidebar.getNombre_completo() : "Invitado";
    String rolUser = (userSidebar != null) ? userSidebar.getNombre_rol() : "";
    
    // 3. Obtener la URL actual para resaltar el menú activo
    String currentURL = request.getRequestURI(); 
%>

<nav class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fa-solid fa-check-double"></i> CALIDAD</h3>
    </div>
    
    <div class="user-info">
        <small style="color: #94a3b8; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 1px;">
            <%= rolUser %>
        </small>
        <span style="font-size: 1rem; margin-top: 2px; display: block; font-weight: 500;">
            <%= nombreUser %>
        </span>
    </div>

    <ul class="menu">
        <!-- ENLACES CON RUTAS ABSOLUTAS (${pageContext.request.contextPath}) -->
        
        <!-- 1. Dashboard -->
        <li>
            <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=cargarDashboard" 
               class="<%= currentURL.contains("AdministradorDashboard.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-chart-line"></i> Dashboard
            </a>
        </li>
        
        <!-- 2. Gestión de Usuarios -->
        <li>
            <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=listarUsuarios"
               class="<%= currentURL.contains("GestionUsuarios.jsp") || currentURL.contains("FormularioUsuario.jsp") ? "active" : "" %>"> 
                <i class="fa-solid fa-users-gear"></i> Gestión Usuarios
            </a>
        </li>
        
        <!-- 3. Gestión de Inspecciones (Ahora incluye Reportes/Filtros) -->
        <li>
            <a href="${pageContext.request.contextPath}/RevisionServlet?accion=listar"
               class="<%= currentURL.contains("GestionInspecciones.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-clipboard-check"></i> Inspecciones
            </a>
        </li>

        <!-- 4. Historial de Reportes PDF -->
        <li>
            <a href="${pageContext.request.contextPath}/ReporteServlet"
               class="<%= currentURL.contains("ReportesPDF.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-file-pdf"></i> Historial PDF
            </a>
        </li>
        
        <!-- 5. Panel de configuracion -->
        <li>
            <a href="${pageContext.request.contextPath}/ConfiguracionServlet"
               class="<%= currentURL.contains("Configuracion.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-gear"></i> Configuracion
            </a>
        </li>

        <!-- 6. Cerrar Sesión -->
        <li class="logout-item">
            <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=Salir">
                <i class="fa-solid fa-power-off"></i> Cerrar Sesión
            </a>
        </li>
    </ul>
</nav>