/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kinder.boletin.base;

import java.util.Collection;
import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

/**
 *
 * @author Daniel
 */
public class AreasCriterios {
    
    private String escuela;
    private String logo;
    private String codigo_estudiante;
    private String nombre_estudiante;
    private String nombre_consejera;
    private String nivel;
    private String ciclo;
    private String director;
    
    
    private String area;
    private Collection<CalificacionesCriterios> lsCal;
     private JRDataSource Calificaciones;

    @Override
    public String toString() {
        return "AreasCriterios{" + "escuela=" + escuela + ", logo=" + logo + ", codigo_estudiante=" + codigo_estudiante + ", nombre_estudiante=" + nombre_estudiante + ", nombre_consejera=" + nombre_consejera + ", nivel=" + nivel + ", ciclo=" + ciclo + ", director=" + director + ", area=" + area + ", lsCal=" + lsCal + ", Calificaciones=" + Calificaciones + '}';
    }



    /**
     * @return the area
     */
    public String getArea() {
        return area;
    }

    /**
     * @param area the area to set
     */
    public void setArea(String area) {
        this.area = area;
    }

    /**
     * @return the lsCal
     */
    public Collection<CalificacionesCriterios> getLsCal() {
        return lsCal;
    }

    /**
     * @param lsCal the lsCal to set
     */
    public void setLsCal(Collection<CalificacionesCriterios> lsCal) {
        this.lsCal = lsCal;
    }
    
    public JRDataSource getCalificaciones(){
        return new JRBeanCollectionDataSource(lsCal);
    }

    /**
     * @return the escuela
     */
    public String getEscuela() {
        return escuela;
    }

    /**
     * @param escuela the escuela to set
     */
    public void setEscuela(String escuela) {
        this.escuela = escuela;
    }

    /**
     * @return the logo
     */
    public String getLogo() {
        return logo;
    }

    /**
     * @param logo the logo to set
     */
    public void setLogo(String logo) {
        this.logo = logo;
    }

    /**
     * @return the codigo_estudiante
     */
    public String getCodigo_estudiante() {
        return codigo_estudiante;
    }

    /**
     * @param codigo_estudiante the codigo_estudiante to set
     */
    public void setCodigo_estudiante(String codigo_estudiante) {
        this.codigo_estudiante = codigo_estudiante;
    }

    /**
     * @return the nombre_estudiante
     */
    public String getNombre_estudiante() {
        return nombre_estudiante;
    }

    /**
     * @param nombre_estudiante the nombre_estudiante to set
     */
    public void setNombre_estudiante(String nombre_estudiante) {
        this.nombre_estudiante = nombre_estudiante;
    }

    /**
     * @return the nombre_consejera
     */
    public String getNombre_consejera() {
        return nombre_consejera;
    }

    /**
     * @param nombre_consejera the nombre_consejera to set
     */
    public void setNombre_consejera(String nombre_consejera) {
        this.nombre_consejera = nombre_consejera;
    }

    /**
     * @return the nivel
     */
    public String getNivel() {
        return nivel;
    }

    /**
     * @param nivel the nivel to set
     */
    public void setNivel(String nivel) {
        this.nivel = nivel;
    }

    /**
     * @return the ciclo
     */
    public String getCiclo() {
        return ciclo;
    }

    /**
     * @param ciclo the ciclo to set
     */
    public void setCiclo(String ciclo) {
        this.ciclo = ciclo;
    }

    /**
     * @return the director
     */
    public String getDirector() {
        return director;
    }

    /**
     * @param director the director to set
     */
    public void setDirector(String director) {
        this.director = director;
    }
}
