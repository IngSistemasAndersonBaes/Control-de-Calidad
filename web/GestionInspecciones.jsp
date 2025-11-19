<%-- 
    Document   : GestionInspecciones
    Created on : 18 nov. 2025, 19:20:31
    Author     : MINEDUCYT
--%>

<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Reutilizamos la validación de la sesión del administrador
    Usuario user = (Usuario) session.getAttribute("usuario");
    if(user == null || !user.getNombre_rol().equalsIgnoreCase("Administrador")) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Inspecciones</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/estilos.css">
</head>
<body>
    <%@ include file="sidebar.jsp" %>

    <main class="main-content">
        <h1 class="header-title">Gestión de Reportes de Inspección</h1>
        
        <div class="table-container">
            <h3>Últimas Revisiones Realizadas</h3>
            
            <table class="data-table">
                <thead>
                    <tr>
                        <th># Revisión</th>
                        <th>Producto</th>
                        <th>Lote</th>
                        <th>Inspector</th>
                        <th>Fecha</th>
                        <th>Resultado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>R-00123</td>
                        <td>Motor V8</td>
                        <td>L-4567</td>
                        <td>Marco Díaz</td>
                        <td>18/11/2025</td>
                        <td class="status-aprobado">Aprobado</td>
                        <td>
                            <a href="RevisionServlet?accion=ver&id=123"><i class="fa-solid fa-magnifying-glass"></i> Detalle</a> |
                            <a href="RevisionServlet?accion=anular&id=123"><i class="fa-solid fa-ban"></i></a>
                        </td>
                    </tr>
                     <tr>
                        <td>R-00124</td>
                        <td>Caja Eléctrica</td>
                        <td>L-4568</td>
                        <td>Sofía Flores</td>
                        <td>18/11/2025</td>
                        <td class="status-rechazado">Rechazado</td>
                        <td>
                            <a href="RevisionServlet?accion=ver&id=124"><i class="fa-solid fa-magnifying-glass"></i> Detalle</a> |
                            <a href="RevisionServlet?accion=anular&id=124"><i class="fa-solid fa-ban"></i></a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
