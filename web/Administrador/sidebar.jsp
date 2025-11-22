<%-- 
    Document   : sidebar
    Created on : 18 nov. 2025, 19:20:46
    Author     : MINEDUCYT
--%>

<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // BORRADA LA LÍNEA: Usuario user = (Usuario) session.getAttribute("usuario");
    // Ya no la necesitamos aquí porque la página "padre" (Dashboard) ya nos la presta.
    
    String currentURL = request.getRequestURI(); 
%>

<nav class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fa-solid fa-check-double"></i> CALIDAD</h3>
    </div>
    
    <div class="user-info">
        Administrador
        <span><%= user.getNombre_completo() %></span>
    </div>

    <ul class="menu">
        <li>
            <a href="UsuarioServlet?accion=cargarDashboard" 
               class="<%= currentURL.contains("AdministradorDashboard.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-chart-line"></i> Dashboard
            </a>
        </li>
        
        <li>
            <a href="UsuarioServlet?accion=listarUsuarios"
               class="<%= currentURL.contains("GestionUsuarios.jsp") ? "active" : "" %>"> 
                <i class="fa-solid fa-users-gear"></i> Gestión Usuarios
            </a>
        </li>
        
        <li>
            <a href="RevisionServlet?accion=listar"
               class="<%= currentURL.contains("RevisionServlet") || currentURL.contains("GestionInspecciones.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-clipboard-check"></i> Inspecciones
            </a>
        </li>

        <li>
            <a href="ReporteServlet"
               class="<%= currentURL.contains("ReporteServlet") || currentURL.contains("ReportesPDF.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-file-pdf"></i> Reportes PDF
            </a>
        </li>
        
        <li class="logout-item">
            <a href="UsuarioServlet?accion=Salir">
                <i class="fa-solid fa-power-off"></i> Cerrar Sesión
            </a>
        </li>
    </ul>
</nav>