<%-- 
    Document   : GestionInspecciones
    Created on : 18 nov. 2025, 19:20:31
    Author     : MINEDUCYT
--%>

<%@page import="java.util.List"%>
<%@page import="Modelo.Revision"%>
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
    <title>Gestión de Inspecciones | Control Calidad</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/estilos.css">
</head>
<body>
    <%@ include file="sidebar.jsp" %>

    <main class="main-content">
        <h1 class="header-title">Gestión y Reportes de Inspecciones</h1>
        
        <div class="report-filter-card">
            <h3><i class="fa-solid fa-filter"></i> Buscar y Exportar</h3>
            
            <form method="GET" class="filter-form">
                
                <div class="input-group">
                    <label>Fecha de Inicio:</label>
                    <input type="date" name="fecha_inicio" class="input-date" 
                           value="<%= request.getAttribute("fechaInicioSelect") != null ? request.getAttribute("fechaInicioSelect") : "" %>">
                </div>
                
                <div class="input-group">
                    <label>Fecha de Fin:</label>
                    <input type="date" name="fecha_fin" class="input-date" 
                           value="<%= request.getAttribute("fechaFinSelect") != null ? request.getAttribute("fechaFinSelect") : "" %>">
                </div>
                
                <button type="submit" formaction="RevisionServlet" name="accion" value="filtrar" class="btn-generate" style="background: #475569;">
                    <i class="fa-solid fa-magnifying-glass"></i> Filtrar Tabla
                </button>

                <button type="submit" formaction="ReporteServlet" name="accion" value="generarReporteFecha" class="btn-generate">
                    <i class="fa-solid fa-file-pdf"></i> Generar PDF
                </button>
                
                <a href="RevisionServlet?accion=listar" class="btn-generate" style="background: #94a3b8; text-decoration: none; height: auto; padding: 12px 20px;">
                    <i class="fa-solid fa-rotate-right"></i> Ver Todo
                </a>
            </form>
        </div>

        <div class="table-container">
            <h3 style="margin-bottom: 15px; color: #1e293b;">
                <%= request.getAttribute("tituloTabla") != null ? request.getAttribute("tituloTabla") : "Últimas Revisiones Registradas" %>
            </h3>
            
            <table class="data-table">
                <thead>
                    <tr>
                        <th># Rev</th>
                        <th>Producto</th>
                        <th>Lote</th>
                        <th>Inspector</th>
                        <th>Fecha</th>
                        <th>Resultado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Revision> lista = (List<Revision>) request.getAttribute("listaInspecciones");
                        if (lista != null && !lista.isEmpty()) {
                            for (Revision r : lista) {
                    %>
                        <tr>
                            <td style="font-weight: bold; color: #64748b;">
                                <%= (r.getNumero_revision() != null) ? r.getNumero_revision() : "#" + r.getId_revision() %>
                            </td>
                            <td><%= r.getNombre_producto() %></td>
                            <td><%= r.getNumero_lote() %></td>
                            <td><%= r.getNombre_inspector() %></td>
                            <td><%= r.getFecha_revision() %></td>
                            <td>
                                <% if("Aprobado".equalsIgnoreCase(r.getResultado_final())) { %>
                                    <span class="status-aprobado"><i class="fa-solid fa-check"></i> Aprobado</span>
                                <% } else if("Rechazado".equalsIgnoreCase(r.getResultado_final())) { %>
                                    <span class="status-rechazado"><i class="fa-solid fa-xmark"></i> Rechazado</span>
                                <% } else { %>
                                    <span style="color: #94a3b8;">Anulado</span>
                                <% } %>
                            </td>
                            <td>
                                <a href="RevisionServlet?accion=ver&id=<%= r.getId_revision() %>" title="Ver Detalle" style="color: #38bdf8; font-size: 1.2rem; margin-right: 10px;">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                </a>
                                <% if(!"Anulado".equalsIgnoreCase(r.getEstado())) { %>
                                    <a href="#" onclick="confirmarAnulacion(<%= r.getId_revision() %>)" title="Anular" style="color: #ef4444; font-size: 1.2rem;">
                                        <i class="fa-solid fa-ban"></i>
                                    </a>
                                <% } %>
                            </td>
                        </tr>
                    <% 
                            }
                        } else { 
                    %>
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 30px;">
                                No se encontraron inspecciones con los criterios seleccionados.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>
    
    <script>
        function confirmarAnulacion(id) {
            if(confirm("¿Desea anular este registro?")) {
                window.location.href = "RevisionServlet?accion=anular&id=" + id;
            }
        }
    </script>
</body>
</html>