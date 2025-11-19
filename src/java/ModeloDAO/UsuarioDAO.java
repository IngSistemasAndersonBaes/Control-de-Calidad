/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;

import Config.Conexion;
import Modelo.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
/**
 *
 * @author MINEDUCYT
 */
public class UsuarioDAO {
// Variables para uso interno
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    Conexion cn = new Conexion(); // Instanciamos tu clase Conexion

    // ==========================================
    // 1. METODO VALIDAR (LOGIN)
    // ==========================================
    public Usuario validar(String user, String pass) {
        Usuario u = new Usuario();
        // Hacemos JOIN con Roles para obtener el nombre del rol (Admin/Inspector)
        String sql = "SELECT u.id_usuario, u.username, u.nombre_completo, u.id_rol, r.nombre_rol " +
                     "FROM Usuarios u " +
                     "INNER JOIN Roles r ON u.id_rol = r.id_rol " +
                     "WHERE u.username = ? AND u.password_hash = ?";
        try {
            con = cn.getConnection(); // Obtenemos la conexión de tu objeto
            ps = con.prepareStatement(sql);
            ps.setString(1, user);
            ps.setString(2, pass); 
            rs = ps.executeQuery();
            
            if (rs.next()) {
                u.setId_usuario(rs.getInt("id_usuario"));
                u.setUsername(rs.getString("username"));
                u.setNombre_completo(rs.getString("nombre_completo"));
                u.setId_rol(rs.getInt("id_rol"));
                u.setNombre_rol(rs.getString("nombre_rol")); // Importante para la redirección en el Servlet
                
                // Registramos el acceso en la tabla Auditoria
                registrarAuditoria(u.getId_usuario(), "LOGIN_EXITOSO");
            } else {
                // Opcional: Registrar intento fallido si tienes el usuario pero mal pass
            }
        } catch (SQLException e) {
            System.err.println("Error al validar usuario: " + e.getMessage());
        }
        return u;
    }

    // ==========================================
    // 2. METODO REGISTRAR (NUEVOS INSPECTORES)
    // ==========================================
    public boolean registrar(Usuario u) {
        // Por defecto asignamos el rol 'Inspector' buscando su ID en la subconsulta
        String sql = "INSERT INTO Usuarios (username, password_hash, nombre_completo, email, id_rol) " +
                     "VALUES (?, ?, ?, ?, (SELECT id_rol FROM Roles WHERE nombre_rol = 'Inspector'))";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getNombre_completo());
            ps.setString(4, u.getUsername() + "@ejemplo.com"); // Generamos un email temporal o pídelo en el form
            
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar: " + e.getMessage());
            return false;
        }
    }

    // ==========================================
    // 3. ESTADÍSTICAS PARA EL DASHBOARD (ADMIN)
    // ==========================================
    public Map<String, Integer> obtenerEstadisticasAccesos() {
        Map<String, Integer> stats = new HashMap<>();
        // Cuenta cuántas veces han entrado Jefes e Inspectores basándose en la auditoría
        String sql = "SELECT r.nombre_rol, COUNT(a.id_auditoria) as total " +
                     "FROM AuditoriaAccesos a " +
                     "JOIN Usuarios u ON a.id_usuario = u.id_usuario " +
                     "JOIN Roles r ON u.id_rol = r.id_rol " +
                     "WHERE r.nombre_rol IN ('Jefe de Calidad', 'Inspector') " +
                     "GROUP BY r.nombre_rol";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                stats.put(rs.getString("nombre_rol"), rs.getInt("total"));
            }
        } catch (SQLException e) {
            System.err.println("Error obteniendo estadísticas: " + e.getMessage());
        }
        return stats;
    }

    // ==========================================
    // METODO AUXILIAR: AUDITORIA
    // ==========================================
    private void registrarAuditoria(int idUser, String accion) {
        String sql = "INSERT INTO AuditoriaAccesos (id_usuario, accion, resultado, ip_address) VALUES (?, ?, 'OK', '127.0.0.1')";
        try {
            // Nota: Podrías necesitar una nueva conexión si el ResultSet anterior sigue abierto
            PreparedStatement psAudit = con.prepareStatement(sql);
            psAudit.setInt(1, idUser);
            psAudit.setString(2, accion);
            psAudit.executeUpdate();
            psAudit.close();
        } catch (SQLException e) {
            System.err.println("Error en auditoría: " + e.getMessage());
        }
    }
}
