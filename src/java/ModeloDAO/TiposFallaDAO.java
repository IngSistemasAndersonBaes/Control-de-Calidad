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
import Modelo.TiposFalla;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TiposFallaDAO {
    public List<TiposFalla> listar() {
        List<TiposFalla> lista = new ArrayList<>();
        String sql = "SELECT * FROM TiposDeFalla WHERE estado = 1";
        try {
            Conexion cn = new Conexion();
            Connection con = cn.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TiposFalla t = new TiposFalla();
                t.setId_tipo_falla(rs.getInt("id_tipo_falla"));
                t.setCodigo_falla(rs.getString("codigo_falla"));
                t.setNombre_falla(rs.getString("nombre_falla"));
                t.setSeveridad(rs.getString("severidad"));
                lista.add(t);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }
}
