<%-- 
    Document   : inspector_form_sampling
    Created on : 22 nov. 2025, 08:28:50
    Author     : MINEDUCYT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- SECCIÓN 2: MUESTREO -->
<div class="section-title"><span class="section-number">2</span> Resultados del Muestreo</div>

<div class="grid-2">
    <div class="input-group">
        <label>Total Inspeccionado</label>
        <input type="number" name="txtCantidad" id="txtTotal" class="form-control" placeholder="0" min="1" required oninput="calcular()">
    </div>
    <div class="input-group">
        <label>Total Rechazados</label>
        <input type="number" name="txtRechazados" id="txtRechazados" class="form-control" placeholder="0" min="0" required oninput="calcular()">
    </div>
</div>

<!-- Calculadora Visual -->
<div class="summary-box">
    <div>
        <span class="sum-val" id="lblAprobadas" style="color: #10b981;">0</span>
        <span class="sum-lbl">Aprobadas</span>
    </div>
    <div>
        <span class="sum-val" id="lblPorcentaje" style="color: #f59e0b;">0%</span>
        <span class="sum-lbl">% Defecto</span>
    </div>
    <div>
        <span class="sum-val" id="lblStatus" style="color: #64748b;">--</span>
        <span class="sum-lbl">Decisión</span>
    </div>
</div>

<!-- Input oculto que guarda la decisión final (Aprobado/Rechazado) -->
<input type="hidden" name="txtResultado" id="inputResultado">