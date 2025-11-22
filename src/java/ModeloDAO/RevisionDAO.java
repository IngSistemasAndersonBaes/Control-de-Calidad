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
import Modelo.Revision;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class RevisionDAO {
    
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    // ==========================================
    // MÉTODOS PARA EL ADMINISTRADOR (LECTURA)
    // ==========================================

    // 1. LISTAR ÚLTIMAS 50 REVISIONES (Para la carga inicial)
    public List<Revision> listarUltimas() {
        List<Revision> lista = new ArrayList<>();
        String sql = "SELECT TOP 50 r.id_revision, r.numero_revision, r.fecha_revision, " +
                     "p.nombre_producto, l.numero_lote, u.nombre_completo, " +
                     "r.resultado_final, r.estado " +
                     "FROM Revision r " +
                     "INNER JOIN Producto p ON r.id_producto = p.id_producto " +
                     "INNER JOIN LotesProduccion l ON r.id_lote = l.id_lote " +
                     "INNER JOIN Usuarios u ON r.id_inspector = u.id_usuario " +
                     "ORDER BY r.fecha_revision DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Revision r = new Revision();
                r.setId_revision(rs.getInt("id_revision"));
                r.setNumero_revision(rs.getString("numero_revision"));
                r.setFecha_revision(rs.getDate("fecha_revision"));
                // Datos auxiliares (Nombres)
                r.setNombre_producto(rs.getString("nombre_producto"));
                r.setNumero_lote(rs.getString("numero_lote"));
                r.setNombre_inspector(rs.getString("nombre_completo"));
                
                r.setResultado_final(rs.getString("resultado_final"));
                r.setEstado(rs.getString("estado"));
                lista.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // 2. LISTAR FILTRADO POR FECHAS
    public List<Revision> listarPorFechas(Date inicio, Date fin) {
        List<Revision> lista = new ArrayList<>();
        String sql = "SELECT r.id_revision, r.numero_revision, r.fecha_revision, " +
                     "p.nombre_producto, l.numero_lote, u.nombre_completo, " +
                     "r.cantidad_inspeccionada, r.cantidad_rechazada, r.resultado_final, r.estado " +
                     "FROM Revision r " +
                     "INNER JOIN Producto p ON r.id_producto = p.id_producto " +
                     "INNER JOIN LotesProduccion l ON r.id_lote = l.id_lote " +
                     "INNER JOIN Usuarios u ON r.id_inspector = u.id_usuario " +
                     "WHERE CAST(r.fecha_revision AS DATE) BETWEEN ? AND ? " +
                     "ORDER BY r.fecha_revision DESC";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setDate(1, inicio);
            ps.setDate(2, fin);
            rs = ps.executeQuery();
            while (rs.next()) {
                Revision r = new Revision();
                r.setId_revision(rs.getInt("id_revision"));
                r.setNumero_revision(rs.getString("numero_revision"));
                r.setFecha_revision(rs.getDate("fecha_revision"));
                r.setNombre_producto(rs.getString("nombre_producto"));
                r.setNumero_lote(rs.getString("numero_lote"));
                r.setNombre_inspector(rs.getString("nombre_completo"));
                r.setCantidad_inspeccionada(rs.getInt("cantidad_inspeccionada"));
                r.setCantidad_rechazada(rs.getInt("cantidad_rechazada"));
                r.setResultado_final(rs.getString("resultado_final"));
                r.setEstado(rs.getString("estado"));
                lista.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }

    // 3. OBTENER DETALLE COMPLETO DE UNA REVISIÓN
    public Revision obtenerPorId(int id) {
        Revision r = null;
        String sql = "SELECT r.*, p.nombre_producto, l.numero_lote, u.nombre_completo " +
                     "FROM Revision r " +
                     "INNER JOIN Producto p ON r.id_producto = p.id_producto " +
                     "INNER JOIN LotesProduccion l ON r.id_lote = l.id_lote " +
                     "INNER JOIN Usuarios u ON r.id_inspector = u.id_usuario " +
                     "WHERE r.id_revision = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                r = new Revision();
                r.setId_revision(rs.getInt("id_revision"));
                r.setNumero_revision(rs.getString("numero_revision"));
                r.setFecha_revision(rs.getDate("fecha_revision"));
                r.setNombre_producto(rs.getString("nombre_producto"));
                r.setNumero_lote(rs.getString("numero_lote"));
                r.setNombre_inspector(rs.getString("nombre_completo"));
                r.setCantidad_inspeccionada(rs.getInt("cantidad_inspeccionada"));
                r.setCantidad_aprobada(rs.getInt("cantidad_aprobada"));
                r.setCantidad_rechazada(rs.getInt("cantidad_rechazada"));
                r.setPorcentaje_defectos(rs.getDouble("porcentaje_defectos"));
                r.setResultado_final(rs.getString("resultado_final"));
                r.setObservaciones_generales(rs.getString("observaciones_generales"));
                r.setEstado(rs.getString("estado"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return r;
    }

    // 4. ANULAR REVISIÓN
    public boolean anular(int id) {
        String sql = "UPDATE Revision SET estado = 'Anulado', resultado_final = 'Cancelado' WHERE id_revision = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // ==========================================
    // MÉTODOS PARA EL INSPECTOR (ESCRITURA)
    // ==========================================

    // 5. REGISTRAR REVISIÓN Y SUS DETALLES (TRANSACCIONAL)
    public boolean registrarCompleto(Revision rev, String[] fallasIds, String[] fallasCants) {
        
        String sqlRev = "INSERT INTO Revision (numero_revision, id_producto, id_lote, id_inspector, " +
                        "cantidad_inspeccionada, cantidad_aprobada, cantidad_rechazada, " +
                        "porcentaje_defectos, resultado_final, observaciones_generales, estado, fecha_revision) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Finalizado', GETDATE())";
                        
        String sqlDet = "INSERT INTO DetallesFalla (id_revision, id_tipo_falla, cantidad_defectos) VALUES (?, ?, ?)";
        
        try {
            con = cn.getConnection();
            con.setAutoCommit(false); // Iniciar Transacción
            
            // A) INSERTAR REVISIÓN
            ps = con.prepareStatement(sqlRev, Statement.RETURN_GENERATED_KEYS);
            
            // Generar código único (REV-TIMESTAMP)
            String numRev = "REV-" + System.currentTimeMillis();
            
            ps.setString(1, numRev);
            ps.setInt(2, rev.getId_producto());
            ps.setInt(3, rev.getId_lote());
            ps.setInt(4, rev.getId_inspector());
            ps.setInt(5, rev.getCantidad_inspeccionada());
            ps.setInt(6, rev.getCantidad_aprobada());
            ps.setInt(7, rev.getCantidad_rechazada());
            ps.setDouble(8, rev.getPorcentaje_defectos());
            ps.setString(9, rev.getResultado_final());
            ps.setString(10, rev.getObservaciones_generales());
            
            int filas = ps.executeUpdate();
            
            if(filas == 0) throw new Exception("No se guardó la cabecera.");

            // B) OBTENER ID GENERADO
            int idGenerado = 0;
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                idGenerado = rs.getInt(1);
            }

            // C) INSERTAR DETALLES (Si existen)
            if (fallasIds != null && idGenerado > 0) {
                PreparedStatement psDet = con.prepareStatement(sqlDet);
                for (int i = 0; i < fallasIds.length; i++) {
                    if(fallasIds[i] != null && !fallasIds[i].isEmpty()) {
                        int idFalla = Integer.parseInt(fallasIds[i]);
                        int cant = Integer.parseInt(fallasCants[i]);
                        
                        if(cant > 0) {
                            psDet.setInt(1, idGenerado);
                            psDet.setInt(2, idFalla);
                            psDet.setInt(3, cant);
                            psDet.addBatch();
                        }
                    }
                }
                psDet.executeBatch();
            }
            
            con.commit(); // Confirmar todo
            return true;
            
        } catch (Exception e) {
            try { if(con != null) con.rollback(); } catch(Exception ex){}
            e.printStackTrace();
            return false;
        } finally {
            try { if(con != null) con.setAutoCommit(true); } catch(Exception ex){}
        }
    }
    
        // MÉTODO NUEVO: Historial personal del Inspector (Últimas 10)
    public List<Revision> listarPorInspector(int idInspector) {
        List<Revision> lista = new ArrayList<>();
        String sql = "SELECT TOP 10 r.id_revision, r.numero_revision, r.fecha_revision, " +
                     "p.nombre_producto, l.numero_lote, r.resultado_final, r.estado " +
                     "FROM Revision r " +
                     "INNER JOIN Producto p ON r.id_producto = p.id_producto " +
                     "INNER JOIN LotesProduccion l ON r.id_lote = l.id_lote " +
                     "WHERE r.id_inspector = ? " +
                     "ORDER BY r.fecha_revision DESC";
        try {
            // Aseguramos una nueva conexión
            Conexion cnLocal = new Conexion();
            con = cnLocal.getConnection();
            
            ps = con.prepareStatement(sql);
            ps.setInt(1, idInspector);
            rs = ps.executeQuery();
            while (rs.next()) {
                Revision r = new Revision();
                r.setId_revision(rs.getInt("id_revision"));
                r.setNumero_revision(rs.getString("numero_revision"));
                r.setFecha_revision(rs.getDate("fecha_revision"));
                r.setNombre_producto(rs.getString("nombre_producto"));
                r.setNumero_lote(rs.getString("numero_lote"));
                r.setResultado_final(rs.getString("resultado_final"));
                r.setEstado(rs.getString("estado"));
                lista.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return lista;
    }
}