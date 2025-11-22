<%-- 
    Document   : ControlCalidadUsuario
    Created on : 17 nov. 2025, 17:03:51
    Author     : MINEDUCYT
--%>

<%@page import="java.util.List"%>
<%@page import="Modelo.Usuario"%>
<%@page import="ModeloDAO.ProductoDAO"%>
<%@page import="Modelo.Producto"%>
<%@page import="ModeloDAO.LoteDAO"%>
<%@page import="Modelo.LoteProduccion"%>
<%@page import="ModeloDAO.TiposFallaDAO"%>
<%@page import="Modelo.TiposFalla"%>
<%@page import="ModeloDAO.RevisionDAO"%>
<%@page import="Modelo.Revision"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // ==========================================
    // 1. LÓGICA DE SEGURIDAD Y CARGA DE DATOS
    // ==========================================
    
    // Verificar sesión
    Usuario user = (Usuario) session.getAttribute("usuario");
    if(user == null) { 
        // Redirigir al login si no hay usuario
        response.sendRedirect(request.getContextPath() + "/index.jsp"); 
        return; 
    }
    
    // Cargar listas para los sugerencias (autocompletado)
    ProductoDAO pDao = new ProductoDAO();
    List<Producto> productos = pDao.listar();
    
    LoteDAO lDao = new LoteDAO();
    List<LoteProduccion> lotes = lDao.listar();
    
    TiposFallaDAO tDao = new TiposFallaDAO();
    List<TiposFalla> fallas = tDao.listar();
    
    // Cargar Historial Personal
    RevisionDAO rDao = new RevisionDAO();
    List<Revision> historial = rDao.listarPorInspector(user.getId_usuario());
    
    // Enviar datos al request para que los componentes los usen
    request.setAttribute("listaProductos", productos);
    request.setAttribute("listaLotes", lotes);
    request.setAttribute("listaFallas", fallas);
    request.setAttribute("miHistorial", historial);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Panel de Inspección | Control Calidad</title>
    
    <!-- CSS y Fuentes (Rutas Absolutas) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* Estilos específicos para esta página */
        body { display: block; overflow-y: auto; background-color: #f8fafc; }
        .work-container { max-width: 900px; margin: 40px auto; padding: 0 15px 50px 15px; }
        
        /* Estilos compartidos por componentes */
        .header-banner { background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%); color: white; padding: 25px 30px; border-radius: 16px 16px 0 0; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
        .form-body { background: white; padding: 40px; border-radius: 0 0 16px 16px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); border: 1px solid #e2e8f0; border-top: none; }
        .section-title { color: #334155; font-size: 1.1rem; font-weight: 700; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px; margin: 30px 0 20px 0; display: flex; align-items: center; gap: 10px; }
        .section-number { background: #38bdf8; color: white; width: 28px; height: 28px; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-size: 0.9rem; font-weight: bold; }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 8px; text-align: center; font-weight: 500; }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        
        /* Calculadora Visual */
        .summary-box { background: #f8fafc; padding: 20px; border-radius: 12px; display: flex; justify-content: space-around; text-align: center; margin-top: 25px; border: 2px dashed #cbd5e1; }
        .sum-val { font-size: 1.8rem; font-weight: 800; color: #1e293b; display: block; }
        .sum-lbl { font-size: 0.8rem; text-transform: uppercase; color: #64748b; letter-spacing: 1px; font-weight: 600; }
        
        .kpi-badge { background: rgba(255,255,255,0.15); padding: 6px 15px; border-radius: 20px; font-size: 0.85rem; margin-right: 10px; border: 1px solid rgba(255,255,255,0.2); }
        
        /* Filas dinámicas */
        .defect-row { display: flex; gap: 15px; margin-bottom: 10px; align-items: center; background: #fff; padding: 10px; border-radius: 8px; border: 1px solid #e2e8f0; }
        .btn-add { background: #e0f2fe; color: #0284c7; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600; margin-top: 10px; transition: background 0.2s; }
        .btn-add:hover { background: #bae6fd; }
        .btn-remove { color: #ef4444; cursor: pointer; font-size: 1.2rem; transition: color 0.2s; }
        .btn-remove:hover { color: #dc2626; }
    </style>
</head>
<body>

    <div class="work-container">
        
        <!-- 1. ENCABEZADO -->
        <jsp:include page="componentes/inspector_header.jsp" />

        <div class="form-body">
            
            <!-- Mensajes de Respuesta -->
            <% if(request.getAttribute("mensaje") != null) { %>
                <div class="alert alert-success"><i class="fa-solid fa-check-circle"></i> <%= request.getAttribute("mensaje") %></div>
            <% } %>
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-error"><i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("error") %></div>
            <% } %>

            <!-- FORMULARIO DE REVISIÓN -->
            <form action="${pageContext.request.contextPath}/RevisionServlet" method="POST" id="formRevision">
                <input type="hidden" name="accion" value="GuardarRevision">
                
                <!-- 2. Datos Producto (Inputs Texto + Datalist) -->
                <jsp:include page="componentes/inspector_form_context.jsp" />

                <!-- 3. Muestreo -->
                <jsp:include page="componentes/inspector_form_sampling.jsp" />

                <!-- 4. Defectos (Dinámico) -->
                <jsp:include page="componentes/inspector_form_defects.jsp" />

                <!-- 5. Notas y Botón -->
                <jsp:include page="componentes/inspector_form_notes.jsp" />
                
            </form>
        </div>
        
        <!-- 6. HISTORIAL PERSONAL -->
        <jsp:include page="componentes/inspector_history.jsp" />
        
    </div>

    <!-- LÓGICA JAVASCRIPT -->
    <script>
        // Configuración: % máximo de defectos permitido
        const TOLERANCIA_MAXIMA = 25.0; 

        function calcular() {
            let total = parseInt(document.getElementById("txtTotal").value) || 0;
            let rech = parseInt(document.getElementById("txtRechazados").value) || 0;
            
            if(rech > total) {
                rech = total;
                document.getElementById("txtRechazados").value = total;
            }

            let aprob = total - rech;
            let porcent = (total > 0) ? ((rech / total) * 100).toFixed(2) : 0;

            // Actualizar UI
            document.getElementById("lblAprobadas").innerText = aprob;
            document.getElementById("lblPorcentaje").innerText = porcent + "%";
            
            let lblTarget = document.getElementById("lblRechazadosTarget");
            if(lblTarget) lblTarget.innerText = rech;

            // Decisión Automática
            let statusLbl = document.getElementById("lblStatus");
            let statusInput = document.getElementById("inputResultado");
            let seccionDefectos = document.getElementById("seccion-defectos");
            
            // Si supera tolerancia -> Rechazado
            if(parseFloat(porcent) > TOLERANCIA_MAXIMA) {
                statusLbl.innerText = "RECHAZADO";
                statusLbl.style.color = "#ef4444";
                statusInput.value = "Rechazado";
                
                if(rech > 0) {
                    if(seccionDefectos) seccionDefectos.style.display = "block";
                    // Si no hay filas, agrega una
                    let lista = document.getElementById("lista-defectos");
                    if(lista && lista.children.length === 0) agregarFilaDefecto();
                }
            } else {
                statusLbl.innerText = "APROBADO";
                statusLbl.style.color = "#10b981";
                statusInput.value = "Aprobado";
                
                if(seccionDefectos) seccionDefectos.style.display = "none";
            }
        }

        function agregarFilaDefecto() {
            let container = document.getElementById("lista-defectos");
            let div = document.createElement("div");
            div.className = "defect-row";
            
            // CORRECCIÓN: Usamos \ antes del $ para evitar conflicto con JSP
            let opciones = (typeof opcionesFallas !== 'undefined') ? opcionesFallas : '<option>Error</option>';
            
            div.innerHTML = `
                <div style="flex: 2;">
                    <select name="idTipoFalla[]" class="form-control" required style="cursor: pointer;">
                        ` + opciones + `
                    </select>
                </div>
                <div style="flex: 1;">
                    <input type="number" name="cantFalla[]" class="form-control" placeholder="Cant." min="1" required>
                </div>
                <div style="width: 30px; text-align: center;">
                    <i class="fa-solid fa-trash-can btn-remove" onclick="eliminarFila(this)" title="Quitar fila"></i>
                </div>
            `;
            container.appendChild(div);
        }

        function eliminarFila(btn) {
            btn.closest(".defect-row").remove();
        }
        
        // Validar suma antes de enviar
        document.getElementById("formRevision").onsubmit = function() {
            let rech = parseInt(document.getElementById("txtRechazados").value) || 0;
            let seccionVisible = document.getElementById("seccion-defectos").style.display !== 'none';
            
            if(rech > 0 && seccionVisible) {
                let inputs = document.getElementsByName("cantFalla[]");
                let suma = 0;
                for(let inp of inputs) suma += parseInt(inp.value) || 0;
                
                if(suma !== rech) {
                    alert("⚠️ La suma del desglose (" + suma + ") no coincide con los Rechazados (" + rech + ").");
                    return false;
                }
            }
            return true;
        };
    </script>

</body>
</html>