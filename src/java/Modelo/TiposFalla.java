/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Modelo;

/**
 *
 * @author MINEDUCYT
 */
public class TiposFalla {
    private int id_tipo_falla;
    private String codigo_falla;
    private String nombre_falla;
    private String severidad;

    public TiposFalla() {
    }

    public int getId_tipo_falla() {
        return id_tipo_falla;
    }

    public void setId_tipo_falla(int id_tipo_falla) {
        this.id_tipo_falla = id_tipo_falla;
    }

    public String getCodigo_falla() {
        return codigo_falla;
    }

    public void setCodigo_falla(String codigo_falla) {
        this.codigo_falla = codigo_falla;
    }

    public String getNombre_falla() {
        return nombre_falla;
    }

    public void setNombre_falla(String nombre_falla) {
        this.nombre_falla = nombre_falla;
    }

    public String getSeveridad() {
        return severidad;
    }

    public void setSeveridad(String severidad) {
        this.severidad = severidad;
    }
    
}
