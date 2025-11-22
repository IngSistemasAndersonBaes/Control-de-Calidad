<%-- 
    Document   : inspector_header
    Created on : 22 nov. 2025, 08:25:20
    Author     : MINEDUCYT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Usuario"%>
<%
    Usuario userHeader = (Usuario) session.getAttribute("usuario");
%>
<div class="header-banner">
    <div>
        <h2 style="margin: 0 0 5px 0; font-size: 1.5rem;">
            <i class="fa-solid fa-clipboard-list"></i> Nueva Inspección
        </h2>
        <div style="font-size: 0.9rem; opacity: 0.9;">
            <span class="kpi-badge"><i class="fa-solid fa-user-check"></i> <%= (userHeader!=null)?userHeader.getNombre_completo():"" %></span>
            <span class="kpi-badge"><i class="fa-solid fa-id-card"></i> <%= (userHeader!=null)?userHeader.getNombre_rol():"" %></span>
        </div>
    </div>
    <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=Salir" 
       style="color: #fca5a5; text-decoration: none; font-weight: 600; font-size: 0.9rem; border: 1px solid #fca5a5; padding: 8px 15px; border-radius: 6px;">
        <i class="fa-solid fa-right-from-bracket"></i> Salir
    </a>
</div>