<%-- 
    Document   : GestionInspecciones
    Created on : 18 nov. 2025, 19:20:31
    Author     : MINEDUCYT
--%>

<%@page import="java.util.List"%>
<%@page import="Modelo.Revision"%>
<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%
    // Validación de sesión
    Usuario user = (Usuario) session.getAttribute("usuario");
    if(user == null || !user.getNombre_rol().equalsIgnoreCase("Administrador")) { 
        response.sendRedirect(request.getContextPath() + "/index.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Inspecciones | Control Calidad</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Ruta absoluta al CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/estilos.css">
</head>
<body>
    <jsp:include page="sidebar.jsp" />

    <main class="main-content">
        <h1 class="header-title">Gestión y Reportes de Inspecciones</h1>
        
        <!-- TARJETA DE FILTROS -->
        <div class="report-filter-card">
            <h3><i class="fa-solid fa-filter"></i> Buscar y Exportar</h3>
            
            <form method="GET" class="filter-form" id="formReportes">
                
                <div class="input-group">
                    <label>Fecha de Inicio:</label>
                    <!-- Agregamos ID para validar -->
                    <input type="date" name="fecha_inicio" id="fechaInicio" class="input-date" 
                           value="<%= request.getAttribute("fechaInicioSelect") != null ? request.getAttribute("fechaInicioSelect") : "" %>">
                </div>
                
                <div class="input-group">
                    <label>Fecha de Fin:</label>
                    <!-- Agregamos ID para validar -->
                    <input type="date" name="fecha_fin" id="fechaFin" class="input-date" 
                           value="<%= request.getAttribute("fechaFinSelect") != null ? request.getAttribute("fechaFinSelect") : "" %>">
                </div>
                
                <!-- BOTÓN 1: BUSCAR (Permitimos buscar sin fechas para ver todo, o puedes restringirlo también) -->
                <button type="submit" formaction="${pageContext.request.contextPath}/RevisionServlet" name="accion" value="filtrar" class="btn-generate" style="background: #475569;">
                    <i class="fa-solid fa-magnifying-glass"></i> Filtrar Tabla
                </button>

                <!-- BOTÓN 2: PDF (VALIDADO) -->
                <!-- El onclick ejecuta la validación antes de enviar -->
                <button type="submit" formaction="${pageContext.request.contextPath}/ReporteServlet" name="accion" value="generarReporteFecha" class="btn-generate" onclick="return validarFechas()">
                    <i class="fa-solid fa-file-pdf"></i> Generar PDF
                </button>
                
                <!-- BOTÓN 3: RESET -->
                <a href="${pageContext.request.contextPath}/RevisionServlet?accion=listar" class="btn-generate" style="background: #94a3b8; text-decoration: none; height: 48px; padding: 0 20px; display: inline-flex; align-items: center;">
                    <i class="fa-solid fa-rotate-right"></i> Ver Todo
                </a>
            </form>
        </div>

        <!-- TABLA DE RESULTADOS -->
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
                            <!-- La visualización de acentos aquí ya debería arreglarse con el cambio en el Servlet y el Header del JSP -->
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
                                <a href="${pageContext.request.contextPath}/RevisionServlet?accion=ver&id=<%= r.getId_revision() %>" title="Ver Detalle" style="color: #38bdf8; font-size: 1.2rem; margin-right: 10px;">
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
        // Función para confirmar anulación (Ya existía)
        function confirmarAnulacion(id) {
            if(confirm("¿Desea anular este registro?")) {
                window.location.href = "${pageContext.request.contextPath}/RevisionServlet?accion=anular&id=" + id;
            }
        }

        // NUEVA: Función para validar fechas antes de generar PDF
        function validarFechas() {
            var inicio = document.getElementById("fechaInicio").value;
            var fin = document.getElementById("fechaFin").value;

            if (inicio === "" || fin === "") {
                alert("⚠️ Atención:\n\nPara generar el reporte PDF, debe ingresar un rango de fechas (Inicio y Fin).");
                return false; // Esto cancela el envío del formulario
            }
            return true; // Esto permite que continúe hacia el Servlet
        }
    </script>
</body>
</html>