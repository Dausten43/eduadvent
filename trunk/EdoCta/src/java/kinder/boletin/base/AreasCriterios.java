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
    private String direccion;
    private String observacionA1;
    private String observacionB1;
    private String observacionA2;
    private String observacionB2;
    private String observacionA3;
    private String observacionB3;
    private String faltaA;
    private String faltaB;
    private String faltaC;
    private String tardanzaA;
    private String tardanzaB;
    private String tardanzaC;
    private String ciclo_nombre;

    private String area;
    private Collection<CalificacionesCriterios> lsCal;
    private JRDataSource Calificaciones;

    @Override
    public String toString() {
        return "AreasCriterios{" + "escuela=" + escuela + ", logo=" + logo + ", codigo_estudiante=" + codigo_estudiante + ", nombre_estudiante=" + nombre_estudiante + ", nombre_consejera=" + nombre_consejera + ", nivel=" + nivel + ", ciclo=" + ciclo + ", director=" + director + ", direccion=" + direccion + ", observacionA1=" + observacionA1 + ", observacionB1=" + observacionB1 + ", observacionA2=" + observacionA2 + ", observacionB2=" + observacionB2 + ", observacionA3=" + observacionA3 + ", observacionB3=" + observacionB3 + ", faltaA=" + faltaA + ", faltaB=" + faltaB + ", faltaC=" + faltaC + ", tardanzaA=" + tardanzaA + ", tardanzaB=" + tardanzaB + ", tardanzaC=" + tardanzaC + ", ciclo_nombre=" + ciclo_nombre + ", area=" + area + ", lsCal=" + lsCal + ", Calificaciones=" + Calificaciones + '}';
    }

    /**
     * @return the observacionA1
     */
    public String getObservacionA1() {
        return observacionA1;
    }

    /**
     * @param observacionA1 the observacionA1 to set
     */
    public void setObservacionA1(String observacionA1) {
        this.observacionA1 = observacionA1;
    }

    /**
     * @return the observacionB1
     */
    public String getObservacionB1() {
        return observacionB1;
    }

    /**
     * @param observacionB1 the observacionB1 to set
     */
    public void setObservacionB1(String observacionB1) {
        this.observacionB1 = observacionB1;
    }

    /**
     * @return the observacionA2
     */
    public String getObservacionA2() {
        return observacionA2;
    }

    /**
     * @param observacionA2 the observacionA2 to set
     */
    public void setObservacionA2(String observacionA2) {
        this.observacionA2 = observacionA2;
    }

    /**
     * @return the observacionB2
     */
    public String getObservacionB2() {
        return observacionB2;
    }

    /**
     * @param observacionB2 the observacionB2 to set
     */
    public void setObservacionB2(String observacionB2) {
        this.observacionB2 = observacionB2;
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

    public JRDataSource getCalificaciones() {
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

    /**
     * @return the direccion
     */
    public String getDireccion() {
        return direccion;
    }

    /**
     * @param direccion the direccion to set
     */
    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    /**
     * @return the observacionA3
     */
    public String getObservacionA3() {
        return observacionA3;
    }

    /**
     * @param observacionA3 the observacionA3 to set
     */
    public void setObservacionA3(String observacionA3) {
        this.observacionA3 = observacionA3;
    }

    /**
     * @return the observacionB3
     */
    public String getObservacionB3() {
        return observacionB3;
    }

    /**
     * @param observacionB3 the observacionB3 to set
     */
    public void setObservacionB3(String observacionB3) {
        this.observacionB3 = observacionB3;
    }

    /**
     * @return the faltaA
     */
    public String getFaltaA() {
        return faltaA;
    }

    /**
     * @param faltaA the faltaA to set
     */
    public void setFaltaA(String faltaA) {
        this.faltaA = faltaA;
    }

    /**
     * @return the faltaB
     */
    public String getFaltaB() {
        return faltaB;
    }

    /**
     * @param faltaB the faltaB to set
     */
    public void setFaltaB(String faltaB) {
        this.faltaB = faltaB;
    }

    /**
     * @return the faltaC
     */
    public String getFaltaC() {
        return faltaC;
    }

    /**
     * @param faltaC the faltaC to set
     */
    public void setFaltaC(String faltaC) {
        this.faltaC = faltaC;
    }

    /**
     * @return the tardanzaA
     */
    public String getTardanzaA() {
        return tardanzaA;
    }

    /**
     * @param tardanzaA the tardanzaA to set
     */
    public void setTardanzaA(String tardanzaA) {
        this.tardanzaA = tardanzaA;
    }

    /**
     * @return the tardanzaB
     */
    public String getTardanzaB() {
        return tardanzaB;
    }

    /**
     * @param tardanzaB the tardanzaB to set
     */
    public void setTardanzaB(String tardanzaB) {
        this.tardanzaB = tardanzaB;
    }

    /**
     * @return the tardanzaC
     */
    public String getTardanzaC() {
        return tardanzaC;
    }

    /**
     * @param tardanzaC the tardanzaC to set
     */
    public void setTardanzaC(String tardanzaC) {
        this.tardanzaC = tardanzaC;
    }

    /**
     * @return the ciclo_nombre
     */
    public String getCiclo_nombre() {
        return ciclo_nombre;
    }

    /**
     * @param ciclo_nombre the ciclo_nombre to set
     */
    public void setCiclo_nombre(String ciclo_nombre) {
        this.ciclo_nombre = ciclo_nombre;
    }
}
