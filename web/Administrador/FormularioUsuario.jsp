<%-- 
    Document   : FormularioUsuario
    Created on : 21 nov. 2025, 16:11:37
    Author     : MINEDUCYT
--%>

<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario uEdit = (Usuario) request.getAttribute("usuarioEditar");
    boolean esEdicion = (uEdit != null);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= esEdicion ? "Editar Usuario" : "Nuevo Usuario" %></title>
    
    <!-- Estilos Generales (opcional si quieres mantener fuentes, etc.) -->
    <link rel="stylesheet" href="CSS/estilos.css">
    <!-- Iconos -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* --- ESTILOS EXCLUSIVOS PARA CENTRAR ESTE FORMULARIO --- */
        
        /* 1. Configuración del Body para Centrado Total */
        body {
            margin: 0;
            padding: 0;
            width: 100%;
            min-height: 100vh;      /* Ocupa toda la altura de la ventana */
            display: flex;          /* Activa Flexbox */
            justify-content: center;/* Centra horizontalmente */
            align-items: center;    /* Centra verticalmente */
            background-color: #f0f2f5; /* Color de fondo suave */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* 2. Tarjeta del Formulario */
        .form-card { 
            background: white; 
            padding: 40px; 
            border-radius: 15px; 
            width: 100%; 
            max-width: 450px;       /* Ancho máximo para que se vea elegante */
            box-shadow: 0 10px 25px rgba(0,0,0,0.1); /* Sombra suave */
            border: 1px solid #e1e4e8;
        }

        /* --- Estilos Internos del Formulario --- */
        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .form-header h2 {
            margin: 0;
            color: #1e293b;
            font-size: 1.8rem;
        }
        
        .form-header p {
            color: #64748b;
            font-size: 0.9rem;
            margin-top: 5px;
        }

        .form-group { margin-bottom: 20px; }
        
        .form-group label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #334155; 
            font-size: 0.9rem;
        }
        
        .form-control { 
            width: 100%; 
            padding: 12px 15px; 
            border: 2px solid #e2e8f0; 
            border-radius: 8px; 
            font-size: 1rem; 
            color: #1e293b;
            transition: all 0.3s ease;
            box-sizing: border-box; 
            outline: none;
        }

        .form-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }
        
        /* Botón Principal */
        .btn-submit { 
            width: 100%; 
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%); 
            color: white; 
            padding: 14px; 
            border: none; 
            border-radius: 8px; 
            font-size: 1.1rem; 
            font-weight: 600;
            cursor: pointer; 
            margin-top: 10px; 
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .btn-submit:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(37, 99, 235, 0.3); 
        }

        /* Enlace Cancelar */
        .link-cancel { 
            display: block; 
            text-align: center; 
            margin-top: 25px; 
            color: #64748b; 
            text-decoration: none; 
            font-weight: 500;
            font-size: 0.95rem;
            transition: color 0.2s;
        }
        .link-cancel:hover { color: #ef4444; }
        
        /* Estilo para el icono del select */
        .select-wrapper { position: relative; }
        .select-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            pointer-events: none;
        }
        select.form-control { appearance: none; cursor: pointer; }
    </style>
</head>
<body>
    
    <div class="form-card">
        <div class="form-header">
            <% if(esEdicion) { %>
                <h2><i class="fa-solid fa-user-pen" style="color: #3b82f6;"></i> Editar Perfil</h2>
                <p>Modifica los datos del usuario seleccionado</p>
            <% } else { %>
                <h2><i class="fa-solid fa-user-plus" style="color: #3b82f6;"></i> Nuevo Usuario</h2>
                <p>Registra un nuevo miembro en el sistema</p>
            <% } %>
        </div>
        
        <form action="UsuarioServlet" method="POST">
            <input type="hidden" name="accion" value="<%= esEdicion ? "ActualizarUsuario" : "GuardarUsuario" %>">
            
            <% if(esEdicion) { %>
                <input type="hidden" name="txtId" value="<%= uEdit.getId_usuario() %>">
            <% } %>

            <div class="form-group">
                <label>Nombre Completo</label>
                <input type="text" name="txtNombre" class="form-control" placeholder="Ej. María González" required 
                       value="<%= esEdicion ? uEdit.getNombre_completo() : "" %>">
            </div>
            
            <div class="form-group">
                <label>Usuario (Login)</label>
                <input type="text" name="txtUser" class="form-control" placeholder="Ej. mgonzalez" required
                       value="<%= esEdicion ? uEdit.getUsername() : "" %>">
            </div>
            
            <div class="form-group">
                <label>Correo Electrónico</label>
                <input type="email" name="txtEmail" class="form-control" placeholder="juan@empresa.com" 
                       value="<%= esEdicion ? (uEdit.getEmail() != null ? uEdit.getEmail() : "") : "" %>">
            </div>
            
            <div class="form-group">
                <label>Contraseña</label>
                <input type="password" name="txtPass" class="form-control" placeholder="••••••••" required
                       value="<%= esEdicion ? uEdit.getPassword() : "" %>">
            </div>
            
            <div class="form-group">
                <label>Rol Asignado</label>
                <div class="select-wrapper">
                    <select name="txtRol" class="form-control">
                        <option value="1" <%= (esEdicion && uEdit.getId_rol() == 1) ? "selected" : "" %>>Administrador</option>
                        <option value="2" <%= (esEdicion && uEdit.getId_rol() == 2) ? "selected" : "" %>>Jefe de Calidad</option>
                        <option value="3" <%= (esEdicion && uEdit.getId_rol() == 3) ? "selected" : "" %>>Inspector</option>
                    </select>
                    <i class="fa-solid fa-chevron-down select-icon"></i>
                </div>
            </div>
            
            <button type="submit" class="btn-submit">
                <%= esEdicion ? "Guardar Cambios" : "Crear Cuenta" %>
            </button>
            
            <a href="UsuarioServlet?accion=listarUsuarios" class="link-cancel">Cancelar operación</a>
        </form>
    </div>

</body>
</html>