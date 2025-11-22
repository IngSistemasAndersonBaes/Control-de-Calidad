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
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // Método para listar el historial
    public List<HistorialReporte> listar() {
        List<HistorialReporte> lista = new ArrayList<>();
        String sql = "SELECT h.id_historial, u.nombre_completo, h.fecha_generacion, h.rango_inicio, h.rango_fin " +
                     "FROM HistorialReportes h " +
                     "INNER JOIN Usuarios u ON h.id_usuario = u.id_usuario " +
                     "ORDER BY h.fecha_generacion DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                HistorialReporte h = new HistorialReporte();
                h.setId_historial(rs.getInt("id_historial"));
                h.setNombre_usuario(rs.getString("nombre_completo"));
                h.setFecha_generacion(rs.getTimestamp("fecha_generacion"));
                h.setRango_inicio(rs.getDate("rango_inicio"));
                h.setRango_fin(rs.getDate("rango_fin"));
                lista.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Método para registrar un nuevo reporte generado
    public void registrar(int idUsuario, java.sql.Date inicio, java.sql.Date fin) {
        String sql = "INSERT INTO HistorialReportes (id_usuario, rango_inicio, rango_fin) VALUES (?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ps.setDate(2, inicio);
            ps.setDate(3, fin);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }  
}
