<%-- 
    Document   : GestionUsuarios
    Created on : 18 nov. 2025, 19:19:37
    Author     : MINEDUCYT
--%>

<%@page import="java.util.List"%>
<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if(user == null || !user.getNombre_rol().equalsIgnoreCase("Administrador")) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gestión de Usuarios</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/estilos.css">
</head>
<body>
    <%@ include file="sidebar.jsp" %>
    
    <main class="main-content">
        <h1 class="header-title">Gestión de Usuarios del Sistema</h1>
        
        <div class="table-container">
            <a href="UsuarioServlet?accion=agregarForm" class="btn-new"><i class="fa-solid fa-user-plus"></i> Nuevo Usuario</a>
            
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre Completo</th>
                        <th>Usuario</th>
                        <th>Rol</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Usuario> lista = (List<Usuario>) request.getAttribute("listaUsuarios");
                        if(lista != null) {
                            for(Usuario usu : lista) {
                    %>
                    <tr>
                        <td><%= usu.getId_usuario() %></td>
                        <td><%= usu.getNombre_completo() %></td>
                        <td><%= usu.getUsername() %></td>
                        <td>
                            <% if(usu.getNombre_rol().equals("Administrador")) { %>
                                <span style="background: #e0e7ff; color: #3730a3; padding: 4px 8px; border-radius: 4px; font-size: 0.8rem; font-weight: bold;">Admin</span>
                            <% } else { %>
                                <span style="background: #dcfce7; color: #166534; padding: 4px 8px; border-radius: 4px; font-size: 0.8rem;"><%= usu.getNombre_rol() %></span>
                            <% } %>
                        </td>
                        <td>
                            <a href="UsuarioServlet?accion=editar&id=<%= usu.getId_usuario() %>" title="Editar"><i class="fa-solid fa-pen-to-square" style="color: #3b82f6;"></i></a>
                            <a href="#" onclick="confirmarEliminar(<%= usu.getId_usuario() %>)" title="Eliminar"><i class="fa-solid fa-trash" style="color: #ef4444;"></i></a>
                        </td>
                    </tr>
                    <%      } 
                        } else { %>
                        <tr><td colspan="6">No hay usuarios cargados.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
    
    <script>
        function confirmarEliminar(id) {
            if(confirm("¿Estás seguro de ELIMINAR este usuario?")) {
                window.location.href = "UsuarioServlet?accion=eliminar&id=" + id;
            }
        }
    </script>
</body>
</html>