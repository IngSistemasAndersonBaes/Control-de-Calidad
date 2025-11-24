/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

/**
 *
 * @author MINEDUCYT
 */
import Modelo.Revision;
import Modelo.Usuario;
import ModeloDAO.ProductoDAO;
import ModeloDAO.LoteDAO;
import ModeloDAO.RevisionDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;

@WebServlet(name = "RevisionServlet", urlPatterns = {"/RevisionServlet"})
public class RevisionServlet extends HttpServlet {

    RevisionDAO dao = new RevisionDAO();
    ProductoDAO prodDao = new ProductoDAO(); // <--- NECESARIO
    LoteDAO loteDao = new LoteDAO();         // <--- NECESARIO

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // --- CORRECCIÓN DE CARACTERES ESPECIALES ---
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        // -------------------------------------------
        
        String accion = request.getParameter("accion");
        
        // ACCIÓN 1: LISTAR TODO (Por defecto)
        if (accion == null || accion.equals("listar")) {
            List<Revision> lista = dao.listarUltimas();
            request.setAttribute("listaInspecciones", lista);
            request.setAttribute("tituloTabla", "Últimas 50 Revisiones Realizadas");
            request.getRequestDispatcher("Administrador/GestionInspecciones.jsp").forward(request, response);
        }
        
        // --- ACCIÓN DEL INSPECTOR: GUARDAR ---
        else if (accion.equalsIgnoreCase("GuardarRevision")) {
            try {
                Revision rev = new Revision();
                
                // 1. MAGIA: RECIBIR TEXTO Y OBTENER ID (Buscar o Crear)
                String nombreProd = request.getParameter("txtProductoNombre");
                String nombreLote = request.getParameter("txtLoteNombre");
                
                // Buscamos el ID del producto. Si no existe, el DAO lo crea.
                int idProd = prodDao.buscarOCrear(nombreProd);
                
                // Buscamos el ID del lote asociado a ese producto. Si no existe, el DAO lo crea.
                int idLote = loteDao.buscarOCrear(nombreLote, idProd); 
                
                rev.setId_producto(idProd);
                rev.setId_lote(idLote);
                
                // 2. DATOS DE SESIÓN (Inspector)
                HttpSession session = request.getSession();
                Usuario user = (Usuario) session.getAttribute("usuario");
                if(user != null) {
                    rev.setId_inspector(user.getId_usuario());
                } else {
                    // Si se perdió la sesión, redirigir al login
                    response.sendRedirect("index.jsp");
                    return;
                }
                
                // 3. DATOS DE MUESTREO Y CÁLCULOS
                int total = Integer.parseInt(request.getParameter("txtCantidad"));
                int rechazos = Integer.parseInt(request.getParameter("txtRechazados"));
                int aprobados = total - rechazos;
                
                // Cálculo del porcentaje
                double porcentaje = (total > 0) ? ((double)rechazos / total) * 100 : 0;
                
                rev.setCantidad_inspeccionada(total);
                rev.setCantidad_rechazada(rechazos);
                rev.setCantidad_aprobada(aprobados);
                rev.setPorcentaje_defectos(porcentaje);
                
                // Lógica de Resultado Final (Puede venir del JS o calcularse aquí)
                // Nota: El JS ya sugiere "Aprobado" o "Rechazado" en el input hidden txtResultado
                String resultadoFinal = request.getParameter("txtResultado");
                rev.setResultado_final(resultadoFinal); 
                
                rev.setObservaciones_generales(request.getParameter("txtObservaciones"));
                
                // 4. PROCESAR DETALLES (Arrays de Fallas)
                String[] fallasIds = request.getParameterValues("idTipoFalla[]");
                String[] fallasCants = request.getParameterValues("cantFalla[]");
                
                // 5. GUARDAR TODO (Transacción)
                if(dao.registrarCompleto(rev, fallasIds, fallasCants)){
                    request.setAttribute("mensaje", "¡Inspección registrada exitosamente!");
                } else {
                    request.setAttribute("error", "Error al guardar en base de datos.");
                }
                
                // 6. REDIRIGIR A LA VISTA DEL INSPECTOR
                request.getRequestDispatcher("Inspector/ControlCalidadUsuario.jsp").forward(request, response);
                
            } catch(Exception e) {
                e.printStackTrace(); // Imprimir error en consola del servidor para depurar
                request.setAttribute("error", "Error crítico: " + e.getMessage());
                request.getRequestDispatcher("Inspector/ControlCalidadUsuario.jsp").forward(request, response);
            }
        }
        
        // ACCIÓN 2: FILTRAR POR FECHAS (Nuevo)
        else if (accion.equals("filtrar")) {
            String fInicio = request.getParameter("fecha_inicio");
            String fFin = request.getParameter("fecha_fin");
            
            if (fInicio != null && fFin != null && !fInicio.isEmpty() && !fFin.isEmpty()) {
                Date inicio = Date.valueOf(fInicio);
                Date fin = Date.valueOf(fFin);
                
                List<Revision> lista = dao.listarPorFechas(inicio, fin);
                
                request.setAttribute("listaInspecciones", lista);
                request.setAttribute("tituloTabla", "Resultados del Filtro: " + fInicio + " al " + fFin);
                request.setAttribute("fechaInicioSelect", fInicio); // Mantener input
                request.setAttribute("fechaFinSelect", fFin);       // Mantener input
            } else {
                // Si no puso fechas, recargamos todo y avisamos (opcional)
                response.sendRedirect("RevisionServlet?accion=listar");
                return;
            }
            request.getRequestDispatcher("Administrador/GestionInspecciones.jsp").forward(request, response);
        }
        
        // 2. VER DETALLE
        else if (accion.equals("ver")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Revision r = dao.obtenerPorId(id);
            request.setAttribute("revision", r);
            request.getRequestDispatcher("Administrador/VerDetalle.jsp").forward(request, response);
        }
        
        // 3. ANULAR REGISTRO
        else if (accion.equals("anular")) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.anular(id);
            // Redirigimos de vuelta a listar para ver el cambio
            response.sendRedirect("RevisionServlet?accion=listar");
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
