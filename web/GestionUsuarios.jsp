<%-- 
    Document   : GestionUsuarios
    Created on : 18 nov. 2025, 19:19:37
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
    <title>Gestión de Usuarios</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/estilos.css">
</head>
<body>
    <%@ include file="sidebar.jsp" %>
    
    <main class="main-content">
        <h1 class="header-title">Gestión de Usuarios</h1>
        
        <div class="table-container">
            <a href="UsuarioServlet?accion=agregarForm" class="btn-new"><i class="fa-solid fa-user-plus"></i> Nuevo Usuario</a>
            
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre Completo</th>
                        <th>Usuario</th>
                        <th>Rol</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>Juan Pérez (Admin)</td>
                        <td>admin</td>
                        <td>Administrador</td>
                        <td>Activo</td>
                        <td>
                            <a href="UsuarioServlet?accion=editar&id=1"><i class="fa-solid fa-pen-to-square"></i></a> |
                            <a href="UsuarioServlet?accion=eliminar&id=1"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>María López</td>
                        <td>mlopez</td>
                        <td>Jefe de Calidad</td>
                        <td>Activo</td>
                        <td>
                            <a href="UsuarioServlet?accion=editar&id=2"><i class="fa-solid fa-pen-to-square"></i></a> |
                            <a href="UsuarioServlet?accion=eliminar&id=2"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
