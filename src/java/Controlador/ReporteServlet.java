/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

/**
 *
 * @author MINEDUCYT
 */
import Config.Conexion;
import Modelo.HistorialReporte;
import ModeloDAO.HistorialDAO;
import ModeloDAO.RevisionDAO; // Importamos el nuevo DAO
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import net.sf.jasperreports.engine.JasperRunManager;

@WebServlet(name = "ReporteServlet", urlPatterns = {"/ReporteServlet"})
public class ReporteServlet extends HttpServlet {

    RevisionDAO revisionDAO = new RevisionDAO();
    HistorialDAO Histodao = new HistorialDAO();

// En ReporteServlet.java
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        // 1. GENERAR PDF (Viene desde GestionInspecciones.jsp)
        if (accion != null && accion.equals("generarReporteFecha")) {
            generarReportePDF(request, response);
        } 
        // 2. LISTAR HISTORIAL (Viene desde el Sidebar "Reportes PDF")
        else {
            List<HistorialReporte> lista = Histodao.listar();
            request.setAttribute("listaHistorial", lista);
            request.getRequestDispatcher("Administrador/ReportesPDF.jsp").forward(request, response);
        }
    }

    private void generarReportePDF(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection con = null;
        Conexion cn = new Conexion();
        
        try {
            con = cn.getConnection();
            
            String fechaInicioStr = request.getParameter("fecha_inicio");
            String fechaFinStr = request.getParameter("fecha_fin");
            
            Date fechaInicio = Date.valueOf(fechaInicioStr);
            Date fechaFin = Date.valueOf(fechaFinStr);

            // Buscamos el archivo .jasper
            File reportFile = new File(getServletContext().getRealPath("reportes/ReCoCal.jasper"));
            
            if (!reportFile.exists()) {
                response.getWriter().println("Error: No se encuentra el archivo ReCoCal.jasper en la carpeta 'reportes'.");
                return;
            }

            Map<String, Object> parameters = new HashMap<>();
            parameters.put("fecha_inicio", fechaInicio); 
            parameters.put("fecha_fin", fechaFin);

            byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parameters, con);

            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);
            response.setHeader("Content-Disposition", "inline; filename=\"Reporte_Calidad.pdf\"");

            ServletOutputStream outputStream = response.getOutputStream();
            outputStream.write(bytes, 0, bytes.length);
            outputStream.flush();
            outputStream.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error generando PDF: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
