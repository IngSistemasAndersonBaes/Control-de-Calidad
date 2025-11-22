<%-- 
    Document   : inspector_form_context
    Created on : 22 nov. 2025, 08:26:34
    Author     : MINEDUCYT
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Modelo.Producto"%>
<%@page import="Modelo.LoteProduccion"%>
<%
    // Recuperamos las listas que envió el JSP Maestro para usarlas en las sugerencias
    List<Producto> prodList = (List<Producto>) request.getAttribute("listaProductos");
    List<LoteProduccion> loteList = (List<LoteProduccion>) request.getAttribute("listaLotes");
%>

<div class="section-title"><span class="section-number">1</span> Datos del Producto</div>

<div class="grid-2">
    <!-- CAMPO PRODUCTO CON SUGERENCIAS -->
    <div class="input-group">
        <label>Nombre del Producto</label>
        
        <!-- El atributo 'list' conecta el input con el datalist de abajo -->
        <input type="text" name="txtProductoNombre" class="form-control" 
               placeholder="Escribe o selecciona..." required autocomplete="off" 
               list="listado-productos">
        
        <!-- Lista invisible de sugerencias -->
        <datalist id="listado-productos">
            <% if(prodList != null) { for(Producto p : prodList) { %>
                <option value="<%= p.getNombre_producto() %>">
            <% }} %>
        </datalist>
        
        <small style="color: #64748b; font-size: 0.8rem;">
            <i class="fa-solid fa-circle-info"></i> Si es nuevo, escríbelo completo.
        </small>
    </div>
    
    <!-- CAMPO LOTE CON SUGERENCIAS -->
    <div class="input-group">
        <label>Lote de Producción</label>
        
        <input type="text" name="txtLoteNombre" class="form-control" 
               placeholder="Código de lote..." required autocomplete="off"
               list="listado-lotes">
               
        <datalist id="listado-lotes">
            <% if(loteList != null) { for(LoteProduccion l : loteList) { %>
                <option value="<%= l.getNumero_lote() %>">
            <% }} %>
        </datalist>
    </div>
</div>