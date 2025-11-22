<%-- 
    Document   : VerDetalle
    Created on : 21 nov. 2025, 09:46:36
    Author     : MINEDUCYT
--%>

<%@page import="Modelo.Revision"%>
<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if(user == null || !user.getNombre_rol().equalsIgnoreCase("Administrador")) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
    Revision r = (Revision) request.getAttribute("revision");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalle de Inspección</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/estilos.css">
</head>
<body>
    <%@ include file="sidebar.jsp" %>

    <main class="main-content">
        <h1 class="header-title">Detalle del Registro</h1>
        
        <div class="detail-card">
            <% if (r != null) { %>
                <div class="detail-header">
                    <div>
                        <h2>Expediente: <%= (r.getNumero_revision() != null) ? r.getNumero_revision() : "#" + r.getId_revision() %></h2>
                        <p style="color: #64748b;">Realizado el: <%= r.getFecha_revision() %></p>
                    </div>
                    <div>
                        <% if("Aprobado".equalsIgnoreCase(r.getResultado_final())) { %>
                            <span class="status-badge bg-green">APROBADO</span>
                        <% } else if("Cancelado".equalsIgnoreCase(r.getResultado_final())) { %>
                             <span class="status-badge bg-gray">ANULADO</span>
                        <% } else { %>
                            <span class="status-badge bg-red">RECHAZADO</span>
                        <% } %>
                    </div>
                </div>

                <div class="detail-grid">
                    <div class="detail-item">
                        <label>Producto</label>
                        <span><%= r.getNombre_producto() %></span>
                    </div>
                    <div class="detail-item">
                        <label>Lote de Producción</label>
                        <span><%= r.getNumero_lote() %></span>
                    </div>
                    <div class="detail-item">
                        <label>Inspector Responsable</label>
                        <span><%= r.getNombre_inspector() %></span>
                    </div>
                    <div class="detail-item">
                        <label>Estado del Registro</label>
                        <span><%= r.getEstado() %></span>
                    </div>

                    <div class="detail-item" style="border-top: 1px solid #eee; padding-top: 20px;">
                        <label>Total Inspeccionado</label>
                        <span><%= r.getCantidad_inspeccionada() %> Uds.</span>
                    </div>
                    <div class="detail-item" style="border-top: 1px solid #eee; padding-top: 20px;">
                        <label>Unidades Defectuosas</label>
                        <span style="color: #ef4444;"><%= r.getCantidad_rechazada() %> Uds.</span>
                    </div>

                    <div class="detail-item obs-box">
                        <label>Observaciones Generales</label>
                        <p><%= (r.getObservaciones_generales() != null) ? r.getObservaciones_generales() : "Sin observaciones registradas." %></p>
                    </div>
                </div>
            <% } else { %>
                <p>No se encontró la información solicitada.</p>
            <% } %>

            <a href="RevisionServlet?accion=listar" class="btn-back"><i class="fa-solid fa-arrow-left"></i> Volver al listado</a>
        </div>
    </main>
</body>
</html>
