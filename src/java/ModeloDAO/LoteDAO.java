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
import Modelo.LoteProduccion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LoteDAO {
    
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public List<LoteProduccion> listar() {
        List<LoteProduccion> lista = new ArrayList<>();
        // Consulta para obtener solo los lotes que están activos/en proceso
        // Si quieres ver todos, quita el WHERE
        String sql = "SELECT * FROM LotesProduccion WHERE estado_lote = 'En Proceso'"; 
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                LoteProduccion l = new LoteProduccion();
                l.setId_lote(rs.getInt("id_lote"));
                l.setNumero_lote(rs.getString("numero_lote"));
                // Puedes agregar más campos si los necesitas en el futuro
                lista.add(l);
            }
        } catch (Exception e) {
            System.err.println("Error al listar lotes: " + e.getMessage());
        }
        return lista;
    }
    
     // 2. BUSCAR O CREAR (METODO MAGIA)
    // Daytoy ti usaren ti Servlet no ti inspector ket agsurat ti nagan ti lote imbes a pumili
    public int buscarOCrear(String numeroLote, int idProducto) {
        int id = 0;
        
        // Umuna, kitaen no adda daytoy a lote
        String sqlBuscar = "SELECT id_lote FROM LotesProduccion WHERE numero_lote = ?";
        
        // No awan, agpartuat ti baro
        String sqlInsertar = "INSERT INTO LotesProduccion (numero_lote, id_producto, fecha_produccion, cantidad_producida, estado_lote) VALUES (?, ?, GETDATE(), 1000, 'En Proceso')";
        
        try {
            con = cn.getConnection();
            
            // Paso A: Buscar
            ps = con.prepareStatement(sqlBuscar);
            ps.setString(1, numeroLote);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Nasarakan! Alaen ti ID
                id = rs.getInt("id_lote");
            } else {
                // Paso B: Crear (No awan)
                // Usaren ti RETURN_GENERATED_KEYS tapno makuha ti baro nga ID
                ps = con.prepareStatement(sqlInsertar, java.sql.Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, numeroLote);
                ps.setInt(2, idProducto); // Isilpo daytoy a lote iti produkto a napili/napartuat
                ps.executeUpdate();
                
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    id = rs.getInt(1);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return id;
    }
}
