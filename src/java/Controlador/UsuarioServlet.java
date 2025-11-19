/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.Usuario;
import ModeloDAO.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
/**
 *
 * @author MINEDUCYT
 */
@WebServlet(name = "UsuarioServlet", urlPatterns = {"/UsuarioServlet"})
public class UsuarioServlet extends HttpServlet{
    UsuarioDAO dao = new UsuarioDAO();
    Usuario u = new Usuario();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion.equalsIgnoreCase("Ingresar")) {
            String user = request.getParameter("txtUser");
            String pass = request.getParameter("txtPass");
            u = dao.validar(user, pass);

            if (u.getUsername() != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuario", u); // Guardamos usuario en sesión

                // Lógica de Redirección por Roles
                if (u.getNombre_rol().equalsIgnoreCase("Administrador")) {
                    // El admin va al dashboard y cargamos estadísticas
                    request.setAttribute("stats", dao.obtenerEstadisticasAccesos());
                    request.getRequestDispatcher("AdministradorDashboard.jsp").forward(request, response);
                } else {
                    // Jefe e Inspector van al formulario de control
                    request.getRequestDispatcher("ControlCalidadUsuario.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Credenciales Incorrectas");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        } 
        else if (accion.equalsIgnoreCase("Registrar")) {
            String user = request.getParameter("txtUserNew");
            String pass = request.getParameter("txtPassNew");
            String nom = request.getParameter("txtNombreNew");
            Usuario nuevo = new Usuario();
            nuevo.setUsername(user);
            nuevo.setPassword(pass);
            nuevo.setNombre_completo(nom);
            
            dao.registrar(nuevo);
            request.setAttribute("mensaje", "Registro Exitoso. Inicie Sesión.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
        else if (accion.equalsIgnoreCase("Salir")) {
            request.getSession().invalidate();
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
