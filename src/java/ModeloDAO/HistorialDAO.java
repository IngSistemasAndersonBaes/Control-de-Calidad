/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDAO;

/**
 *
 * @author MINEDUCYT
 */
import Config.Conexion;
import Modelo.HistorialReporte;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class HistorialDAO {
    
    // No usamos variables de clase para la conexión para evitar cierres inesperados
    
    // LISTAR HISTORIAL
    public List<HistorialReporte> listar() {
        List<HistorialReporte> lista = new ArrayList<>();
        String sql = "SELECT h.id_historial, u.nombre_completo, h.fecha_generacion, h.rango_inicio, h.rango_fin " +
                     "FROM HistorialReportes h " +
                     "INNER JOIN Usuarios u ON h.id_usuario = u.id_usuario " +
                     "ORDER BY h.fecha_generacion DESC";
        try {
            Conexion cn = new Conexion();
            Connection con = cn.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                HistorialReporte h = new HistorialReporte();
                h.setId_historial(rs.getInt("id_historial"));
                h.setNombre_usuario(rs.getString("nombre_completo"));
                h.setFecha_generacion(rs.getTimestamp("fecha_generacion"));
                h.setRango_inicio(rs.getDate("rango_inicio"));
                h.setRango_fin(rs.getDate("rango_fin"));
                lista.add(h);
            }
            con.close(); // Cierre explícito
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // REGISTRAR NUEVO REPORTE (IMPORTANTE)
    public void registrar(int idUsuario, java.sql.Date inicio, java.sql.Date fin) {
        String sql = "INSERT INTO HistorialReportes (id_usuario, rango_inicio, rango_fin, fecha_generacion) VALUES (?, ?, ?, GETDATE())";
        try {
            Conexion cn = new Conexion();
            Connection con = cn.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setDate(2, inicio);
            ps.setDate(3, fin);
            
            int filas = ps.executeUpdate();
            System.out.println("Historial guardado: " + filas + " filas afectadas."); // Log para depurar
            
            con.close(); // Cierre explícito
        } catch (Exception e) {
            System.err.println("Error al guardar historial: " + e.getMessage());
            e.printStackTrace();
        }
    }
}