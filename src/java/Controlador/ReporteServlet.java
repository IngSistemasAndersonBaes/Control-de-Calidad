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
import Modelo.Revision;
import Modelo.Usuario;
import ModeloDAO.ConfiguracionDAO; // IMPORTANTE: Nuevo DAO
import ModeloDAO.HistorialDAO;
import ModeloDAO.RevisionDAO;
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
import jakarta.servlet.http.HttpSession;
import net.sf.jasperreports.engine.JasperRunManager;

@WebServlet(name = "ReporteServlet", urlPatterns = {"/ReporteServlet"})
public class ReporteServlet extends HttpServlet {

    // Instancias de DAOs
    HistorialDAO historialDAO = new HistorialDAO();
    RevisionDAO revisionDAO = new RevisionDAO();
    ConfiguracionDAO configDao = new ConfiguracionDAO(); // Nuevo

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Configuración de caracteres para evitar problemas con tildes
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String accion = request.getParameter("accion");
        
        // ==========================================
        // ACCIÓN 1: GENERAR PDF (Descarga)
        // ==========================================
        if (accion != null && accion.equals("generarReporteFecha")) {
            generarReportePDF(request, response);
        } 
        
        // ==========================================
        // ACCIÓN 2: FILTRAR EN PANTALLA (Vista Previa)
        // ==========================================
        else if (accion != null && accion.equals("filtrarPantalla")) {
            try {
                String fInicioStr = request.getParameter("fecha_inicio");
                String fFinStr = request.getParameter("fecha_fin");
                
                if(fInicioStr != null && fFinStr != null && !fInicioStr.isEmpty() && !fFinStr.isEmpty()){
                    Date inicio = Date.valueOf(fInicioStr);
                    Date fin = Date.valueOf(fFinStr);

                    // Consultar BD
                    List<Revision> lista = revisionDAO.listarPorFechas(inicio, fin);

                    // Enviar resultados y mantener fechas en inputs
                    request.setAttribute("listaRevisiones", lista);
                    request.setAttribute("fechaInicioSelect", inicio);
                    request.setAttribute("fechaFinSelect", fin);
                    request.setAttribute("tituloTabla", "Resultados del Filtro: " + fInicioStr + " al " + fFinStr);
                }
                // Redirigir al JSP de gestión (donde está la tabla)
                request.getRequestDispatcher("Administrador/GestionInspecciones.jsp").forward(request, response);
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("RevisionServlet?accion=listar");
            }
        }
        
        // ==========================================
        // ACCIÓN 3: MOSTRAR HISTORIAL (Por defecto para 'Reportes PDF')
        // ==========================================
        else {
            List<HistorialReporte> lista = historialDAO.listar();
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
            
            if(fechaInicioStr == null || fechaFinStr == null) {
                response.getWriter().println("Error: Fechas no proporcionadas.");
                return;
            }
            
            Date fechaInicio = Date.valueOf(fechaInicioStr);
            Date fechaFin = Date.valueOf(fechaFinStr);

            // --- 1. GUARDAR EN HISTORIAL (AUDITORÍA) ---
            try {
                HttpSession session = request.getSession(false);
                if (session != null && session.getAttribute("usuario") != null) {
                    Usuario u = (Usuario) session.getAttribute("usuario");
                    // Usamos una instancia nueva para asegurar conexión limpia
                    HistorialDAO hDaoLocal = new HistorialDAO(); 
                    hDaoLocal.registrar(u.getId_usuario(), fechaInicio, fechaFin);
                }
            } catch (Exception ex) {
                System.out.println("Advertencia: No se pudo guardar el historial (" + ex.getMessage() + ")");
            }

            // --- 2. PREPARAR DATOS DE EMPRESA (MARCA BLANCA) ---
            Map<String, String> config = configDao.obtenerConfiguracion();
            
            String empresaNombre = config.getOrDefault("NOMBRE_EMPRESA", "Mi Empresa S.A.");
            String empresaDir = config.getOrDefault("DIRECCION_EMPRESA", "Dirección no configurada");
            String logoName = config.getOrDefault("LOGO_EMPRESA", "default.png");
            
            // Ruta física absoluta a la imagen del logo
            // Nota: Asegúrate de tener una imagen 'default.png' en 'Web Pages/img/logos/' para evitar errores si no hay config
            String logoPath = getServletContext().getRealPath("/img/logos/" + logoName);
            
            // Validación por si la imagen no existe físicamente
            File logoFile = new File(logoPath);
            if(!logoFile.exists()) {
                // Si no encuentra el logo personalizado, usa uno genérico o null
                // System.out.println("Logo no encontrado en: " + logoPath);
                // logoPath = null; // O ruta a imagen por defecto
            }

            // --- 3. CONFIGURAR PARÁMETROS JASPER ---
            Map<String, Object> parameters = new HashMap<>();
            
            // Parámetros de Filtro (SQL)
            parameters.put("fecha_inicio", fechaInicio); 
            parameters.put("fecha_fin", fechaFin);
            
            // Parámetros Visuales (Empresa)
            // IMPORTANTE: Estos nombres (p_empresa_nombre, etc.) deben crearse en el archivo .jrxml en Jaspersoft Studio
            parameters.put("p_empresa_nombre", empresaNombre);
            parameters.put("p_empresa_direccion", empresaDir);
            parameters.put("p_logo_path", logoPath);

            // --- 4. GENERAR PDF ---
            File reportFile = new File(getServletContext().getRealPath("reportes/ReCoCal.jasper"));
            
            if (!reportFile.exists()) {
                response.getWriter().println("Error crítico: No se encuentra el archivo ReCoCal.jasper en la carpeta reportes.");
                return;
            }

            byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parameters, con);

            // --- 5. ENVIAR AL NAVEGADOR ---
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);
            // 'inline' abre en pestaña, 'attachment' descarga directo
            response.setHeader("Content-Disposition", "inline; filename=\"Reporte_Calidad_" + fechaInicioStr + ".pdf\"");

            ServletOutputStream outputStream = response.getOutputStream();
            outputStream.write(bytes, 0, bytes.length);
            outputStream.flush();
            outputStream.close();

        } catch (Exception e) {
            e.printStackTrace();
            // En caso de error grave, intentamos mostrarlo en pantalla (si no se ha escrito la respuesta aún)
            try { response.getWriter().println("Error generando PDF: " + e.getMessage()); } catch(Exception ex){}
        } finally {
            try { if(con != null) con.close(); } catch(Exception e){}
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