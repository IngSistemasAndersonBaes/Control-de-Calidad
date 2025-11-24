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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class ConfiguracionDAO {
    
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // Obtener todas las configuraciones clave-valor
    public Map<String, String> obtenerConfiguracion() {
        Map<String, String> config = new HashMap<>();
        String sql = "SELECT parametro, valor FROM ConfiguracionSistema";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                config.put(rs.getString("parametro"), rs.getString("valor"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return config;
    }

    // Actualizar un parámetro específico
    public boolean actualizarParametro(String parametro, String valor) {
        String sql = "UPDATE ConfiguracionSistema SET valor = ?, fecha_modificacion = GETDATE() WHERE parametro = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, valor);
            ps.setString(2, parametro);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
