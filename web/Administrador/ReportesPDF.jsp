<%-- 
    Document   : ReportesPDF
    Created on : 19 nov. 2025, 08:04:31
    Author     : MINEDUCYT
--%>
<%@page import="java.util.List"%>
<%@page import="Modelo.HistorialReporte"%>
<%@page import="java.text.SimpleDateFormat"%>
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
    <meta charset="UTF-8">
    <title>Historial de Descargas | Control Calidad</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/estilos.css">
</head>
<body>
    <%@ include file="sidebar.jsp" %>

    <main class="main-content">
        <h1 class="header-title">Historial de Descargas</h1>
        
        <div class="table-container">
            <h3 style="margin-bottom: 15px; color: #1e293b;">Registro de Reportes Generados</h3>
            <p style="color: #64748b; margin-bottom: 20px;">Aquí puedes consultar y volver a descargar los reportes emitidos anteriormente.</p>
            
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Generado Por</th>
                        <th>Rango Solicitado</th>
                        <th>Fecha Generación</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<HistorialReporte> historial = (List<HistorialReporte>) request.getAttribute("listaHistorial");
                        if (historial != null && !historial.isEmpty()) {
                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                            SimpleDateFormat sdfFecha = new SimpleDateFormat("dd/MM/yyyy");
                            
                            for (HistorialReporte h : historial) {
                    %>
                        <tr>
                            <td>#REP-<%= h.getId_historial() %></td>
                            <td><%= h.getNombre_usuario() %></td>
                            <td><%= sdfFecha.format(h.getRango_inicio()) %> al <%= sdfFecha.format(h.getRango_fin()) %></td>
                            <td><%= sdf.format(h.getFecha_generacion()) %></td>
                            <td>
                                <a href="ReporteServlet?accion=generarReporteFecha&fecha_inicio=<%= h.getRango_inicio() %>&fecha_fin=<%= h.getRango_fin() %>" target="_blank" class="btn-download">
                                    <i class="fa-solid fa-download"></i> Descargar Copia
                                </a>
                            </td>
                        </tr>
                    <% 
                            } 
                        } else { 
                    %>
                        <tr><td colspan="5" style="text-align: center; padding: 20px;">El historial está vacío.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>