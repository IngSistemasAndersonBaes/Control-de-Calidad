<%-- 
    Document   : Configuracion
    Created on : 24 nov. 2025, 10:40:31
    Author     : MINEDUCYT
--%>

<%@page import="java.util.Map"%>
<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // SEGURIDAD
    Usuario user = (Usuario) session.getAttribute("usuario");
    if(user == null || !user.getNombre_rol().equalsIgnoreCase("Administrador")) { 
        response.sendRedirect(request.getContextPath() + "/index.jsp"); 
        return; 
    }

    // --- CORRECCIÓN DEL ERROR ---
    // Cambiamos el nombre de variable 'config' a 'dataConfig' porque 'config' es reservada en JSP
    Map<String, String> dataConfig = (Map<String, String>) request.getAttribute("config");
    
    // Usamos la nueva variable 'dataConfig' para leer
    String nombreEmpresa = (dataConfig != null) ? dataConfig.get("NOMBRE_EMPRESA") : "";
    String dirEmpresa = (dataConfig != null) ? dataConfig.get("DIRECCION_EMPRESA") : "";
    String logoEmpresa = (dataConfig != null) ? dataConfig.get("LOGO_EMPRESA") : "default.png";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Configuración de Empresa</title>
    <!-- Rutas absolutas -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <jsp:include page="sidebar.jsp" />

    <main class="main-content">
        <h1 class="header-title">Configuración General</h1>
        
        <div class="form-card" style="max-width: 700px;">
            <div class="form-title">Identidad Corporativa</div>
            
            <!-- Mensajes de Feedback -->
            <% if(request.getAttribute("mensaje") != null) { %>
                <div class="alert alert-success" style="margin-bottom: 20px; text-align: center; background: #dcfce7; color: #166534; padding: 10px; border-radius: 8px;">
                    <i class="fa-solid fa-check-circle"></i> <%= request.getAttribute("mensaje") %>
                </div>
            <% } %>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-error" style="margin-bottom: 20px; text-align: center; background: #fee2e2; color: #991b1b; padding: 10px; border-radius: 8px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/ConfiguracionServlet" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="accion" value="guardar">
                
                <div style="display: flex; gap: 30px; align-items: flex-start; flex-wrap: wrap;">
                    
                    <!-- Lado Izquierdo: Logo -->
                    <div style="flex: 1; text-align: center; min-width: 200px;">
                        <label style="display: block; margin-bottom: 10px; font-weight: bold; color: #64748b;">Logo Actual</label>
                        
                        <div style="border: 2px dashed #cbd5e1; padding: 20px; border-radius: 8px; margin-bottom: 10px; background: #f8fafc;">
                            <!-- Usamos pageContext para encontrar la imagen correctamente -->
                            <img src="${pageContext.request.contextPath}/img/logos/<%= logoEmpresa %>" 
                                 style="max-width: 100%; max-height: 150px; object-fit: contain;" 
                                 alt="Logo Empresa"
                                 onerror="this.src='${pageContext.request.contextPath}/img/logos/default.png';"> 
                        </div>
                        
                        <input type="file" name="fileLogo" accept="image/*" class="form-control" style="font-size: 0.8rem;">
                        <small style="color: #94a3b8; display: block; margin-top: 5px;">Formato: PNG o JPG (Máx 10MB)</small>
                    </div>
                    
                    <!-- Lado Derecho: Datos -->
                    <div style="flex: 2; min-width: 250px;">
                        <div class="input-group" style="margin-bottom: 20px;">
                            <label>Nombre de la Empresa</label>
                            <input type="text" name="txtNombre" class="form-control" required value="<%= nombreEmpresa %>" placeholder="Ej. Industrias ACME S.A.">
                        </div>
                        
                        <div class="input-group" style="margin-bottom: 20px;">
                            <label>Dirección / Slogan</label>
                            <input type="text" name="txtDireccion" class="form-control" value="<%= dirEmpresa %>" placeholder="Ej. Av. Central #123, Ciudad">
                        </div>
                        
                        <button type="submit" class="btn-save">
                            <i class="fa-solid fa-floppy-disk"></i> Guardar Cambios
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </main>
</body>
</html>