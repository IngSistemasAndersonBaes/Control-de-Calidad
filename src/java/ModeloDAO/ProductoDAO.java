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
import Modelo.Producto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {
    
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // MÉTODO PARA LISTAR PRODUCTOS ACTIVOS (Para llenar Combobox)
    public List<Producto> listar() {
        List<Producto> lista = new ArrayList<>();
        // Filtramos por estado=1 para mostrar solo productos activos
        // Ajusta el nombre de la columna 'estado' según tu BD real
        String sql = "SELECT * FROM Producto WHERE estado = 1"; 
        
        try {
            // Instancia local para asegurar conexión fresca
            Conexion cnLocal = new Conexion();
            con = cnLocal.getConnection();
            
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Producto p = new Producto();
                p.setId_producto(rs.getInt("id_producto"));
                p.setCodigo_producto(rs.getString("codigo_producto"));
                p.setNombre_producto(rs.getString("nombre_producto"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setCategoria(rs.getString("categoria"));
                p.setUnidad_medida(rs.getString("unidad_medida"));
                
                // Puedes agregar más campos si tu modelo los tiene
                // p.setEspecificaciones(rs.getString("especificaciones_tecnicas"));
                
                lista.add(p);
            }
        } catch (Exception e) {
            System.err.println("Error al listar productos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Es buena práctica cerrar recursos, aunque en este patrón simple a veces se omite
            try { if(rs!=null) rs.close(); if(ps!=null) ps.close(); if(con!=null) con.close(); } catch(Exception e){}
        }
        return lista;
    }
    
    // MÉTODO AUXILIAR: Obtener nombre por ID (Útil para reportes si no haces JOIN)
    public Producto obtenerPorId(int id) {
        Producto p = new Producto();
        String sql = "SELECT * FROM Producto WHERE id_producto = ?";
        try {
            Conexion cnLocal = new Conexion();
            con = cnLocal.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if(rs.next()) {
                p.setId_producto(rs.getInt("id_producto"));
                p.setCodigo_producto(rs.getString("codigo_producto"));
                p.setNombre_producto(rs.getString("nombre_producto"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }
    
    // MÉTODO MAGIA: Busca el ID por nombre, si no existe lo crea
    public int buscarOCrear(String nombre) {
        int id = 0;
        String sqlBuscar = "SELECT id_producto FROM Producto WHERE nombre_producto = ?";
        String sqlInsertar = "INSERT INTO Producto (codigo_producto, nombre_producto, estado) VALUES (?, ?, 1)";
        
        try {
            // 1. Intentar buscar
            Conexion cn = new Conexion();
            Connection con = cn.getConnection();
            PreparedStatement ps = con.prepareStatement(sqlBuscar);
            ps.setString(1, nombre);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                id = rs.getInt("id_producto");
            } else {
                // 2. Si no existe, crear
                // Generamos un código aleatorio para el SKU requerido
                String sku = "PROD-" + System.currentTimeMillis(); 
                
                ps = con.prepareStatement(sqlInsertar, java.sql.Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, sku);
                ps.setString(2, nombre);
                ps.executeUpdate();
                
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    id = rs.getInt(1);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return id;
    }
}
