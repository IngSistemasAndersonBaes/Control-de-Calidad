<%-- 
    Document   : AdministradorDashboar
    Created on : 17 nov. 2025, 17:04:24
    Author     : MINEDUCYT
--%>

<%@page import="java.util.Map"%>
<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. SEGURIDAD
    Usuario user = (Usuario) session.getAttribute("usuario");
    if(user == null || !user.getNombre_rol().equalsIgnoreCase("Administrador")) { 
        response.sendRedirect(request.getContextPath() + "/index.jsp"); 
        return; 
    }

    // 2. DATOS
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    Map<String, Integer> rStats = (Map<String, Integer>) request.getAttribute("revisionStats");
    Map<String, Integer> tStats = (Map<String, Integer>) request.getAttribute("tendenciaStats");
    Map<String, Integer> dStats = (Map<String, Integer>) request.getAttribute("topDefectosStats");

    // 3. PROCESAMIENTO
    int aprobadas = (rStats != null && rStats.containsKey("Aprobado")) ? rStats.get("Aprobado") : 0;
    int rechazadas = (rStats != null && rStats.containsKey("Rechazado")) ? rStats.get("Rechazado") : 0;
    int pendientes = (rStats != null && rStats.containsKey("Pendiente")) ? rStats.get("Pendiente") : 0;
    
    int totalRev = 0;
    if(rStats != null) { for(int val : rStats.values()) totalRev += val; }

    String tLabels = ""; String tData = "";
    if(tStats != null) {
        for(Map.Entry<String, Integer> entry : tStats.entrySet()) {
            tLabels += "'" + entry.getKey() + "',";
            tData += entry.getValue() + ",";
        }
    }

    String dLabels = ""; String dData = "";
    if(dStats != null) {
        for(Map.Entry<String, Integer> entry : dStats.entrySet()) {
            dLabels += "'" + entry.getKey() + "',";
            dData += entry.getValue() + ",";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Control Calidad</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/estilos.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>

    <!-- CAMBIO CLAVE: Usamos jsp:include (Dinámico) en lugar de @include -->
    <jsp:include page="sidebar.jsp" />

    <main class="main-content">
        <h1 class="header-title">Panel de Control Ejecutivo</h1>

        <div class="stats-grid">
            <div class="card card-jefes">
                <i class="fa-solid fa-user-tie icon-bg"></i>
                <h3>Accesos Jefes</h3>
                <div class="number">
                    <%= (stats != null && stats.containsKey("Jefe de Calidad")) ? stats.get("Jefe de Calidad") : 0 %>
                </div>
            </div>

            <div class="card card-inspectores">
                <i class="fa-solid fa-helmet-safety icon-bg"></i>
                <h3>Accesos Inspectores</h3>
                <div class="number">
                    <%= (stats != null && stats.containsKey("Inspector")) ? stats.get("Inspector") : 0 %>
                </div>
            </div>

            <div class="card card-reportes">
                <i class="fa-solid fa-file-contract icon-bg"></i>
                <h3>Total Revisiones</h3>
                <div class="number"><%= totalRev %></div>
            </div>
        </div>

        <h2 style="margin: 30px 0 20px 0; color: #1e293b; border-left: 5px solid #38bdf8; padding-left: 15px;">
            Análisis de Operaciones
        </h2>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 25px;">
            <div class="card">
                <h3 style="border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px;">
                    <i class="fa-solid fa-bars-progress"></i> Estatus
                </h3>
                <canvas id="statusChart"></canvas>
            </div>
            <div class="card">
                <h3 style="border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px;">
                    <i class="fa-solid fa-arrow-trend-up"></i> Ritmo (7 Días)
                </h3>
                <canvas id="trendChart"></canvas>
            </div>
            <div class="card" style="grid-column: 1 / -1;">
                 <h3 style="border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 15px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> Top Rechazos
                </h3>
                <div style="height: 300px; width: 100%; display: flex; justify-content: center;">
                    <canvas id="doughnutChart"></canvas>
                </div>
            </div>
        </div>
    </main>

    <script>
        Chart.defaults.font.family = "'Segoe UI', sans-serif";
        Chart.defaults.color = '#64748b';

        new Chart(document.getElementById('statusChart'), {
            type: 'bar',
            data: {
                labels: ['Aprobadas', 'Rechazadas', 'Pendientes'],
                datasets: [{
                    label: 'Cantidad',
                    data: [<%= aprobadas %>, <%= rechazadas %>, <%= pendientes %>],
                    backgroundColor: ['#10b981', '#ef4444', '#f59e0b'],
                    borderRadius: 6
                }]
            },
            options: { responsive: true, plugins: { legend: { display: false } } }
        });

        new Chart(document.getElementById('trendChart'), {
            type: 'line',
            data: {
                labels: [<%= tLabels %>],
                datasets: [{
                    label: 'Inspecciones',
                    data: [<%= tData %>],
                    borderColor: '#38bdf8',
                    backgroundColor: 'rgba(56, 189, 248, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: { responsive: true, scales: { y: { beginAtZero: true } } }
        });

        new Chart(document.getElementById('doughnutChart'), {
            type: 'doughnut',
            data: {
                labels: [<%= dLabels %>],
                datasets: [{
                    data: [<%= dData %>],
                    backgroundColor: ['#6366f1', '#ec4899', '#f43f5e', '#8b5cf6', '#06b6d4'],
                    borderWidth: 0
                }]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });
    </script>
</body>
</html>