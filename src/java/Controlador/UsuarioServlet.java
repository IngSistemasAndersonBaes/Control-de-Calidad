/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.Usuario;
import ModeloDAO.UsuarioDAO;
import java.io.IOException;
import java.util.List; // <--- ¡IMPORTANTE! No olvides importar List
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/UsuarioServlet"})
public class UsuarioServlet extends HttpServlet {

    UsuarioDAO dao = new UsuarioDAO();
    Usuario u = new Usuario();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        // =========================================================
        // SECCIÓN 1: LOGIN, DASHBOARD Y SALIR (Lógica Existente)
        // =========================================================
        
        if (accion.equalsIgnoreCase("Ingresar")) {
            String user = request.getParameter("txtUser");
            String pass = request.getParameter("txtPass");
            u = dao.validar(user, pass);
            
            if (u.getUsername() != null) {
                // Guardar sesión
                HttpSession session = request.getSession();
                session.setAttribute("usuario", u);
                
                // Redirección por roles
                if (u.getNombre_rol().equalsIgnoreCase("Administrador")) {
                    response.sendRedirect("UsuarioServlet?accion=cargarDashboard");
                } else {
                    request.getRequestDispatcher("Inspector/ControlCalidadUsuario.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Credenciales Incorrectas");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        }
        
        else if (accion.equalsIgnoreCase("cargarDashboard")) {
            HttpSession session = request.getSession();
            Usuario usuarioLogueado = (Usuario) session.getAttribute("usuario");
            
            if (usuarioLogueado != null && usuarioLogueado.getNombre_rol().equalsIgnoreCase("Administrador")) {
                
                // 1. Estadísticas de Tarjetas
                request.setAttribute("stats", dao.obtenerEstadisticasAccesos());
                // 2. Gráfica de Barras
                request.setAttribute("revisionStats", dao.obtenerEstadisticasRevisiones());
                // 3. Gráfica de Línea (Tendencia)
                request.setAttribute("tendenciaStats", dao.obtenerTendenciaRevisiones());
                // 4. Gráfica de Dona (Top Defectos)
                request.setAttribute("topDefectosStats", dao.obtenerTopProductosDefectuosos());
                
                request.getRequestDispatcher("Administrador/AdministradorDashboard.jsp").forward(request, response);
            } else {
                response.sendRedirect("index.jsp");
            }
        }
        
        else if (accion.equalsIgnoreCase("Salir")) {
            request.getSession().invalidate();
            response.sendRedirect("index.jsp");
        }

        // =========================================================
        // SECCIÓN 2: CRUD DE USUARIOS (AQUÍ VA LA PARTE NUEVA)
        // =========================================================
        
        else if (accion.equalsIgnoreCase("listarUsuarios")) {
            List<Usuario> lista = dao.listar();
            request.setAttribute("listaUsuarios", lista);
            request.getRequestDispatcher("Administrador/GestionUsuarios.jsp").forward(request, response);
        }
        
        else if (accion.equalsIgnoreCase("agregarForm")) {
            request.getRequestDispatcher("Administrador/FormularioUsuario.jsp").forward(request, response);
        }
        
        else if (accion.equalsIgnoreCase("GuardarUsuario")) {
            Usuario nuevo = new Usuario();
            nuevo.setNombre_completo(request.getParameter("txtNombre"));
            nuevo.setUsername(request.getParameter("txtUser"));
            nuevo.setPassword(request.getParameter("txtPass"));
            nuevo.setId_rol(Integer.parseInt(request.getParameter("txtRol")));
            
            dao.agregar(nuevo);
            response.sendRedirect("UsuarioServlet?accion=listarUsuarios");
        }
        
        else if (accion.equalsIgnoreCase("editar")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario userEdit = dao.listarId(id);
            request.setAttribute("usuarioEditar", userEdit);
            request.getRequestDispatcher("Administrador/FormularioUsuario.jsp").forward(request, response);
        }
        
        else if (accion.equalsIgnoreCase("ActualizarUsuario")) {
            Usuario editado = new Usuario();
            editado.setId_usuario(Integer.parseInt(request.getParameter("txtId")));
            editado.setNombre_completo(request.getParameter("txtNombre"));
            editado.setUsername(request.getParameter("txtUser"));
            editado.setPassword(request.getParameter("txtPass"));
            editado.setId_rol(Integer.parseInt(request.getParameter("txtRol")));
            
            dao.actualizar(editado);
            response.sendRedirect("UsuarioServlet?accion=listarUsuarios");
        }
        
        else if (accion.equalsIgnoreCase("eliminar")) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.eliminar(id);
            response.sendRedirect("UsuarioServlet?accion=listarUsuarios");
        }
        
        // 3. Registro simple desde el Login (Opcional, si lo usas)
        else if (accion.equalsIgnoreCase("Registrar")) {
            String user = request.getParameter("txtUserNew");
            String pass = request.getParameter("txtPassNew");
            String nom = request.getParameter("txtNombreNew");
            Usuario nuevo = new Usuario();
            nuevo.setUsername(user);
            nuevo.setPassword(pass);
            nuevo.setNombre_completo(nom);
            
            dao.registrar(nuevo); // Esto registra como Inspector por defecto en tu DAO
            request.setAttribute("mensaje", "Registro Exitoso. Inicie Sesión.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
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