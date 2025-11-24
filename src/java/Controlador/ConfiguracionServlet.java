/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

/**
 *
 * @author MINEDUCYT
 */
import ModeloDAO.ConfiguracionDAO;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet(name = "ConfiguracionServlet", urlPatterns = {"/ConfiguracionServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ConfiguracionServlet extends HttpServlet {

    ConfiguracionDAO dao = new ConfiguracionDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        if (accion == null || accion.equals("ver")) {
            Map<String, String> config = dao.obtenerConfiguracion();
            request.setAttribute("config", config);
            request.getRequestDispatcher("Administrador/Configuracion.jsp").forward(request, response);
        }
        
        else if (accion.equals("guardar")) {
            try {
                // 1. Guardar Textos
                String nombre = request.getParameter("txtNombre");
                String direccion = request.getParameter("txtDireccion");
                
                dao.actualizarParametro("NOMBRE_EMPRESA", nombre);
                dao.actualizarParametro("DIRECCION_EMPRESA", direccion);
                
                // 2. Guardar Logo (Si se subió uno nuevo)
                Part filePart = request.getPart("fileLogo");
                
                if (filePart != null && filePart.getSize() > 0) {
                    // Nombre del archivo: logo_timestamp.png para evitar caché
                    String fileName = "logo_" + System.currentTimeMillis() + ".png";
                    
                    // Carpeta donde se guardará (Dentro de Web Pages/img/logos)
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "img" + File.separator + "logos";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    
                    // Guardar archivo físico
                    try (InputStream input = filePart.getInputStream()) {
                        File file = new File(uploadPath, fileName);
                        Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        
                        // Actualizar BD con el nuevo nombre
                        dao.actualizarParametro("LOGO_EMPRESA", fileName);
                    }
                }
                
                request.setAttribute("mensaje", "Configuración actualizada correctamente");
                
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error al guardar configuración: " + e.getMessage());
            }
            
            // Recargar datos y volver
            Map<String, String> config = dao.obtenerConfiguracion();
            request.setAttribute("config", config);
            request.getRequestDispatcher("Administrador/Configuracion.jsp").forward(request, response);
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
