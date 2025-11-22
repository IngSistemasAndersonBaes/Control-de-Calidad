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
import java.sql.Timestamp;

public class HistorialReporte {
    private int id_historial;
    private String nombre_usuario; // Para mostrar quién lo hizo
    private Timestamp fecha_generacion;
    private Date rango_inicio;
    private Date rango_fin;

    public HistorialReporte() {
    }

    public int getId_historial() {
        return id_historial;
    }

    public void setId_historial(int id_historial) {
        this.id_historial = id_historial;
    }

    public String getNombre_usuario() {
        return nombre_usuario;
    }

    public void setNombre_usuario(String nombre_usuario) {
        this.nombre_usuario = nombre_usuario;
    }

    public Timestamp getFecha_generacion() {
        return fecha_generacion;
    }

    public void setFecha_generacion(Timestamp fecha_generacion) {
        this.fecha_generacion = fecha_generacion;
    }

    public Date getRango_inicio() {
        return rango_inicio;
    }

    public void setRango_inicio(Date rango_inicio) {
        this.rango_inicio = rango_inicio;
    }

    public Date getRango_fin() {
        return rango_fin;
    }

    public void setRango_fin(Date rango_fin) {
        this.rango_fin = rango_fin;
    }
    
    
    
}
