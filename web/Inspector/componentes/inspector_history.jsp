<%-- 
    Document   : inspector_history
    Created on : 22 nov. 2025, 16:44:38
    Author     : MINEDUCYT
--%>

<%@page import="java.util.List"%>
<%@page import="Modelo.Revision"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Revision> miHistorial = (List<Revision>) request.getAttribute("miHistorial");
%>
<div class="history-section" style="margin-top: 50px;">
    <div class="section-title">
        <i class="fa-solid fa-clock-rotate-left" style="color: #64748b;"></i> 
        Mis Inspecciones Recientes
    </div>
    
    <div style="overflow-x: auto; background: white; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); border: 1px solid #e2e8f0;">
        <table style="width: 100%; border-collapse: collapse; font-size: 0.9rem;">
            <thead style="background: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                <tr>
                    <th style="padding: 15px; text-align: left; color: #475569;"># Rev</th>
                    <th style="padding: 15px; text-align: left; color: #475569;">Producto</th>
                    <th style="padding: 15px; text-align: left; color: #475569;">Lote</th>
                    <th style="padding: 15px; text-align: center; color: #475569;">Resultado</th>
                    <th style="padding: 15px; text-align: center; color: #475569;">Estado</th>
                </tr>
            </thead>
            <tbody>
                <% if(miHistorial != null && !miHistorial.isEmpty()) { 
                    for(Revision r : miHistorial) { %>
                    <tr style="border-bottom: 1px solid #f1f5f9;">
                        <td style="padding: 12px 15px; font-weight: 600; color: #64748b;">
                            <%= (r.getNumero_revision()!=null)?r.getNumero_revision():"#"+r.getId_revision() %>
                        </td>
                        <td style="padding: 12px 15px;"><%= r.getNombre_producto() %></td>
                        <td style="padding: 12px 15px;"><%= r.getNumero_lote() %></td>
                        <td style="padding: 12px 15px; text-align: center;">
                            <% if("Aprobado".equalsIgnoreCase(r.getResultado_final())) { %>
                                <span style="background: #dcfce7; color: #166534; padding: 4px 10px; border-radius: 15px; font-size: 0.8rem; font-weight: 700;">OK</span>
                            <% } else { %>
                                <span style="background: #fee2e2; color: #991b1b; padding: 4px 10px; border-radius: 15px; font-size: 0.8rem; font-weight: 700;">RECHAZADO</span>
                            <% } %>
                        </td>
                        <td style="padding: 12px 15px; text-align: center; color: #64748b;">
                            <%= r.getEstado() %>
                        </td>
                    </tr>
                <% }} else { %>
                    <tr>
                        <td colspan="5" style="padding: 20px; text-align: center; color: #94a3b8;">
                            No has realizado inspecciones hoy.
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
