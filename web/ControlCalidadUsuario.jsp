<%-- 
    Document   : ControlCalidadUsuario
    Created on : 17 nov. 2025, 17:03:51
    Author     : MINEDUCYT
--%>

<%@page import="Modelo.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuario");
    if(user == null) { response.sendRedirect("index.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Formulario de Inspección</title>
    <style>
        body { 
            font-family: sans-serif; 
            background: #eef2f3; 
            padding: 20px; 
        }
        .container { 
            max-width: 800px; 
            margin: 0 auto; 
            background: white; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); 
        }
        .header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            border-bottom: 2px solid #007bff; 
            padding-bottom: 10px; 
            margin-bottom: 20px; 
        }
        .role-badge { 
            background: #ffc107; 
            padding: 5px 10px; 
            border-radius: 20px; 
            font-size: 0.8rem; 
            font-weight: bold; 
        }
        .form-grid { 
            display: grid;
            grid-template-columns: 1fr 1fr; 
            gap: 20px; 
        }
        input, select, textarea { 
            width: 100%; 
            padding: 8px; 
            margin-top: 5px; 
            border: 1px solid #ddd;
            border-radius: 4px; 
        }
        .full-width { 
            grid-column: span 2; 
        }
        .btn-submit { 
            background: #28a745; 
            color: white; 
            padding: 12px;
            border: none;
            width: 100%;
            cursor: pointer; 
            font-size: 16px; 
            margin-top: 20px; 
        }
        .btn-report {
            background: #17a2b8; 
            color: white; 
            padding: 10px 20px; 
            text-decoration: none; 
            border-radius: 4px; 
        }
        .logout { 
            color: #dc3545; 
            text-decoration: none; 
            font-weight: bold; 
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>Registro de Inspección</h1>
                <p>Bienvenido, <%= user.getNombre_completo() %> <span class="role-badge"><%= user.getNombre_rol() %></span></p>
            </div>
            <a href="UsuarioServlet?accion=Salir" class="logout">Cerrar Sesión</a>
        </div>

        <% if(user.getNombre_rol().equalsIgnoreCase("Jefe de Calidad")) { %>
            <div style="background: #d1ecf1; padding: 15px; margin-bottom: 20px; border-left: 5px solid #17a2b8;">
                <h3>Panel de Gestión</h3>
                <p>Como Jefe de Calidad, puedes generar reportes detallados.</p>
                <a href="ReporteServlet?tipo=mensual" class="btn-report">🖨️ Generar Reporte PDF (JasperSoft)</a>
            </div>
        <% } %>

        <form action="RevisionServlet" method="POST">
            <div class="form-grid">
                <div>
                    <label>Número de Lote</label>
                    <input type="text" name="lote" placeholder="Lote Escaneado" required>
                </div>
                <div>
                    <label>Producto</label>
                    <select name="id_producto">
                        <option value="1">Producto A</option>
                        <option value="2">Producto B</option>
                        </select>
                </div>
                <div>
                    <label>Cantidad Inspeccionada</label>
                    <input type="number" name="cant_insp" required>
                </div>
                <div>
                    <label>Cantidad Rechazada</label>
                    <input type="number" name="cant_rech" required>
                </div>
                <div class="full-width">
                    <label>Observaciones</label>
                    <textarea name="obs" rows="3"></textarea>
                </div>
                <div class="full-width">
                    <label>Resultado Final</label>
                    <select name="resultado">
                        <option value="Aprobado">Aprobado</option>
                        <option value="Rechazado">Rechazado</option>
                        <option value="Condicional">Condicional</option>
                    </select>
                </div>
            </div>
            <input type="submit" name="accion" value="Guardar Revisión" class="btn-submit">
        </form>
    </div>
</body>
</html>
