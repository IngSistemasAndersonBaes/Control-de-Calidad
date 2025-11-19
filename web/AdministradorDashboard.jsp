<%-- 
    Document   : AdministradorDashboar
    Created on : 17 nov. 2025, 17:04:24
    Author     : MINEDUCYT
--%>

<%@page import="java.util.Map"%>
<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Validación de sesión y rol
    Usuario user = (Usuario) session.getAttribute("usuario");
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    
    if(user == null || !user.getNombre_rol().equalsIgnoreCase("Administrador")) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
    
Map<String, Integer> revisionStats = (Map<String, Integer>) request.getAttribute("revisionStats");
    
    // Asignamos 0 si el mapa es nulo (para evitar NPE)
    int aprobadas = (revisionStats != null && revisionStats.containsKey("Aprobado")) ? revisionStats.get("Aprobado") : 0;
    int rechazadas = (revisionStats != null && revisionStats.containsKey("Rechazado")) ? revisionStats.get("Rechazado") : 0;
    int pendientes = (revisionStats != null && revisionStats.containsKey("Pendiente")) ? revisionStats.get("Pendiente") : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Control Calidad</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="CSS/estilos.css">
</head>
<body>

    <%@ include file="sidebar.jsp" %>

    <main class="main-content">
        <h1 class="header-title">Panel General</h1>

        <div class="stats-grid">
            <div class="card card-jefes">
                <i class="fa-solid fa-user-tie icon-bg"></i>
                <h3>Accesos Jefes</h3>
                <div class="number">
                    <%= (stats != null && stats.containsKey("Jefe de Calidad")) ? stats.get("Jefe de Calidad") : 0 %>
                </div>
                <small>Ingresos registrados</small>
            </div>

            <div class="card card-inspectores">
                <i class="fa-solid fa-helmet-safety icon-bg"></i>
                <h3>Accesos Inspectores</h3>
                <div class="number">
                    <%= (stats != null && stats.containsKey("Inspector")) ? stats.get("Inspector") : 0 %>
                </div>
                <small>Ingresos registrados</small>
            </div>

            <div class="card card-reportes">
                <i class="fa-solid fa-file-contract icon-bg"></i>
                <h3>Reportes Generados</h3>
                <div class="number">0</div> <small>Documentos emitidos</small>
            </div>
        </div>

        <div style="margin-top: 40px;">
            <h2>Acciones Rápidas</h2>
            <div style="background: white; padding: 20px; border-radius: 8px; margin-top: 15px;">
                <p>Seleccione una opción del menú lateral para comenzar a administrar el sistema.</p>
            </div>
        </div>

        <h2 style="margin-top: 40px; color: #1e293b;">Estado de Reportes de Calidad</h2>

        <div class="stats-grid">
            <div class="card" style="grid-column: span 3; border-left: none;">
                <canvas id="revisionChart" height="100%"></canvas>
            </div>
        </div>
    </main>

    <script>
        // Datos extraídos del servidor (JSP)
        const aprobadas = <%= aprobadas %>;
        const rechazadas = <%= rechazadas %>;
        const pendientes = <%= pendientes %>;
        
        const ctx = document.getElementById('revisionChart');
        
        new Chart(ctx, {
            type: 'bar', // Tipo de gráfica (puedes cambiar a 'doughnut' o 'pie')
            data: {
                labels: ['Aprobadas', 'Rechazadas', 'Pendientes'],
                datasets: [{
                    label: 'Cantidad de Revisiones',
                    data: [aprobadas, rechazadas, pendientes],
                    backgroundColor: [
                        '#10b981', // Verde para Aprobadas
                        '#ef4444', // Rojo para Rechazadas
                        '#f59e0b'  // Naranja para Pendientes
                    ],
                    borderColor: [
                        '#047857',
                        '#b91c1c',
                        '#b45309'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    title: {
                        display: true,
                        text: 'Total de Revisiones por Estado',
                        font: { size: 16 }
                    }
                }
            }
        });
    </script>            
</body>
</html>