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
import java.util.ArrayList;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.HashMap;

public class UsuarioDAO {
    
    // Variables globales para uso interno
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // 1. LOGIN
    public Usuario validar(String user, String pass) {
        Usuario u = new Usuario();
        String sql = "SELECT u.*, r.nombre_rol FROM Usuarios u INNER JOIN Roles r ON u.id_rol = r.id_rol WHERE u.username = ? AND u.password_hash = ?";
        try {
            // Instanciamos la conexión DENTRO del método para evitar desconexiones
            Conexion cn = new Conexion(); 
            con = cn.getConnection(); // Asegúrate que en Conexion.java se llame así
            
            ps = con.prepareStatement(sql);
            ps.setString(1, user);
            ps.setString(2, pass);
            rs = ps.executeQuery();
            if (rs.next()) {
                u.setId_usuario(rs.getInt("id_usuario"));
                u.setUsername(rs.getString("username"));
                u.setNombre_completo(rs.getString("nombre_completo"));
                u.setId_rol(rs.getInt("id_rol"));
                u.setNombre_rol(rs.getString("nombre_rol"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return u;
    }

    // 2. LISTAR TODOS
    public List<Usuario> listar() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT u.id_usuario, u.nombre_completo, u.username, u.email, r.nombre_rol, u.estado " +
                     "FROM Usuarios u INNER JOIN Roles r ON u.id_rol = r.id_rol";
        try {
            Conexion cn = new Conexion();
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setId_usuario(rs.getInt("id_usuario"));
                u.setNombre_completo(rs.getString("nombre_completo"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email")); // Recuperamos email
                u.setNombre_rol(rs.getString("nombre_rol"));
                lista.add(u);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // 3. AGREGAR USUARIO
    public boolean agregar(Usuario u) {
        String sql = "INSERT INTO Usuarios(nombre_completo, username, password_hash, email, id_rol, estado) VALUES(?, ?, ?, ?, ?, 1)";
        try {
            Conexion cn = new Conexion();
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, u.getNombre_completo());
            ps.setString(2, u.getUsername());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getEmail()); // Email
            ps.setInt(5, u.getId_rol());
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 4. OBTENER POR ID (PARA EDITAR) - ¡AQUÍ FALTABA EL EMAIL!
    public Usuario listarId(int id) {
        Usuario u = new Usuario();
        String sql = "SELECT * FROM Usuarios WHERE id_usuario=" + id;
        try {
            Conexion cn = new Conexion();
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                u.setId_usuario(rs.getInt("id_usuario"));
                u.setNombre_completo(rs.getString("nombre_completo"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password_hash"));
                u.setEmail(rs.getString("email")); // <-- ¡ESTO FALTABA!
                u.setId_rol(rs.getInt("id_rol"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return u;
    }

    // 5. ACTUALIZAR
    public boolean actualizar(Usuario u) {
        String sql = "UPDATE Usuarios SET nombre_completo=?, username=?, password_hash=?, email=?, id_rol=? WHERE id_usuario=?";
        try {
            Conexion cn = new Conexion();
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, u.getNombre_completo());
            ps.setString(2, u.getUsername());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getEmail());
            ps.setInt(5, u.getId_rol());
            ps.setInt(6, u.getId_usuario());
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 6. ELIMINAR
    public void eliminar(int id) {
        String sql = "DELETE FROM Usuarios WHERE id_usuario=" + id;
        try {
            Conexion cn = new Conexion();
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    // 7. REGISTRAR (Login)
    public boolean registrar(Usuario u) {
        u.setId_rol(3); 
        return agregar(u);
    }
    
    // Métodos de Gráficas (Sin cambios, solo asegurando conexión fresca)
    public Map<String, Integer> obtenerTendenciaRevisiones() {
        Map<String, Integer> datos = new LinkedHashMap<>();
        String sql = "SELECT FORMAT(fecha_revision, 'dd/MM') as fecha, COUNT(*) as total FROM Revision WHERE fecha_revision >= DATEADD(day, -7, GETDATE()) GROUP BY FORMAT(fecha_revision, 'dd/MM'), CAST(fecha_revision AS DATE) ORDER BY CAST(fecha_revision AS DATE) ASC";
        try {
            Conexion cn = new Conexion();
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) { datos.put(rs.getString("fecha"), rs.getInt("total")); }
        } catch (Exception e) { e.printStackTrace(); }
        return datos;
    }

    public Map<String, Integer> obtenerTopProductosDefectuosos() {
        Map<String, Integer> datos = new HashMap<>();
        String sql = "SELECT TOP 5 p.nombre_producto, COUNT(*) as total_rechazos FROM Revision r INNER JOIN Producto p ON r.id_producto = p.id_producto WHERE r.resultado_final = 'Rechazado' GROUP BY p.nombre_producto ORDER BY total_rechazos DESC";
        try {
            Conexion cn = new Conexion();
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) { datos.put(rs.getString("nombre_producto"), rs.getInt("total_rechazos")); }
        } catch (Exception e) { e.printStackTrace(); }
        return datos;
    }
    
    public Map<String, Integer> obtenerEstadisticasAccesos() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT r.nombre_rol, COUNT(a.id_auditoria) as total FROM AuditoriaAccesos a JOIN Usuarios u ON a.id_usuario = u.id_usuario JOIN Roles r ON u.id_rol = r.id_rol WHERE r.nombre_rol IN ('Jefe de Calidad', 'Inspector') GROUP BY r.nombre_rol";
        try {
            Conexion cn = new Conexion();
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) { stats.put(rs.getString("nombre_rol"), rs.getInt("total")); }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    public Map<String, Integer> obtenerEstadisticasRevisiones() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("Aprobado", 0); stats.put("Rechazado", 0); stats.put("Pendiente", 0);
        String sql = "SELECT resultado_final, COUNT(*) as total FROM Revision GROUP BY resultado_final";
        try {
            Conexion cn = new Conexion();
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                String estado = rs.getString("resultado_final");
                if(estado != null) { stats.put(estado, rs.getInt("total")); }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }
}