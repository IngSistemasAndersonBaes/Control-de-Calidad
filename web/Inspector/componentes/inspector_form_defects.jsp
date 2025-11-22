<%-- 
    Document   : inspector_form_defects
    Created on : 22 nov. 2025, 08:36:02
    Author     : MINEDUCYT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Modelo.TiposFalla"%>
<%
    List<TiposFalla> fallasList = (List<TiposFalla>) request.getAttribute("listaFallas");
%>
<!-- SECCIÓN 3: DESGLOSE DE DEFECTOS (DINÁMICO) -->
<div id="seccion-defectos" style="display: none;">
    <div class="section-title" style="color: #ef4444; border-color: #fecaca; margin-top: 40px;">
        <span class="section-number" style="background: #ef4444;">3</span> Desglose de Defectos
    </div>
    
    <div style="background: #fff1f2; padding: 15px; border-radius: 8px; border: 1px solid #fecaca; margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
        <i class="fa-solid fa-circle-info" style="color: #ef4444;"></i>
        <p style="margin: 0; font-size: 0.9rem; color: #991b1b;">
            Debes clasificar las <strong><span id="lblRechazadosTarget">0</span></strong> unidades rechazadas según el tipo de falla.
        </p>
    </div>
    
    <!-- Contenedor de filas dinámicas -->
    <div id="lista-defectos">
        <!-- Las filas se crean con JS -->
    </div>
    
    <button type="button" class="btn-add" onclick="agregarFilaDefecto()">
        <i class="fa-solid fa-plus"></i> Agregar Otro Defecto
    </button>
</div>

<!-- Script auxiliar para pasar la lista de fallas a JS -->
<script>
    const opcionesFallas = `
        <option value="">-- Seleccionar Falla --</option>
        <% if(fallasList != null) { for(TiposFalla t : fallasList) { %>
            <option value="<%= t.getId_tipo_falla() %>"><%= t.getCodigo_falla() %> - <%= t.getNombre_falla() %></option>
        <% }} %>
    `;
</script>
