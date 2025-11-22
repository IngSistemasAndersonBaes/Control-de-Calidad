/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author MINEDUCYT
 */
import java.sql.Date;

public class Revision {
    // Atributos originales de la tabla
    private int id_revision;
    private int id_producto;
    private int id_lote;
    private int id_inspector;
    private Date fecha_revision;
    private int cantidad_inspeccionada;
    private int cantidad_aprobada;
    private int cantidad_rechazada;
    private double porcentaje_defectos;
    private String resultado_final;
    private String observaciones_generales;
    private String estado;
    private String Numero_revision;

    // --- NUEVOS ATRIBUTOS AUXILIARES (Para mostrar Nombres en lugar de IDs) ---
    private String nombre_producto;
    private String numero_lote;
    private String nombre_inspector;

    public Revision() {
    }

    public int getId_revision() {
        return id_revision;
    }

    public void setId_revision(int id_revision) {
        this.id_revision = id_revision;
    }

    public int getId_producto() {
        return id_producto;
    }

    public void setId_producto(int id_producto) {
        this.id_producto = id_producto;
    }

    public int getId_lote() {
        return id_lote;
    }

    public void setId_lote(int id_lote) {
        this.id_lote = id_lote;
    }

    public int getId_inspector() {
        return id_inspector;
    }

    public void setId_inspector(int id_inspector) {
        this.id_inspector = id_inspector;
    }

    public Date getFecha_revision() {
        return fecha_revision;
    }

    public void setFecha_revision(Date fecha_revision) {
        this.fecha_revision = fecha_revision;
    }

    public int getCantidad_inspeccionada() {
        return cantidad_inspeccionada;
    }

    public void setCantidad_inspeccionada(int cantidad_inspeccionada) {
        this.cantidad_inspeccionada = cantidad_inspeccionada;
    }

    public int getCantidad_aprobada() {
        return cantidad_aprobada;
    }

    public void setCantidad_aprobada(int cantidad_aprobada) {
        this.cantidad_aprobada = cantidad_aprobada;
    }

    public int getCantidad_rechazada() {
        return cantidad_rechazada;
    }

    public void setCantidad_rechazada(int cantidad_rechazada) {
        this.cantidad_rechazada = cantidad_rechazada;
    }

    public double getPorcentaje_defectos() {
        return porcentaje_defectos;
    }

    public void setPorcentaje_defectos(double porcentaje_defectos) {
        this.porcentaje_defectos = porcentaje_defectos;
    }

    public String getResultado_final() {
        return resultado_final;
    }

    public void setResultado_final(String resultado_final) {
        this.resultado_final = resultado_final;
    }

    public String getObservaciones_generales() {
        return observaciones_generales;
    }

    public void setObservaciones_generales(String observaciones_generales) {
        this.observaciones_generales = observaciones_generales;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getNombre_producto() {
        return nombre_producto;
    }

    public void setNombre_producto(String nombre_producto) {
        this.nombre_producto = nombre_producto;
    }

    public String getNumero_lote() {
        return numero_lote;
    }

    public void setNumero_lote(String numero_lote) {
        this.numero_lote = numero_lote;
    }

    public String getNombre_inspector() {
        return nombre_inspector;
    }

    public void setNombre_inspector(String nombre_inspector) {
        this.nombre_inspector = nombre_inspector;
    }

    public String getNumero_revision() {
        return Numero_revision;
    }

    public void setNumero_revision(String Numero_revision) {
        this.Numero_revision = Numero_revision;
    }
    
    
}
