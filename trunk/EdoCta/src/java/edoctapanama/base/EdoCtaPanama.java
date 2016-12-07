/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edoctapanama.base;

import java.util.ArrayList;
import java.util.Collection;
import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

/**
 *
 * @author Daniel
 */
public class EdoCtaPanama {
    
    private String codigoid;
    private String nombre;
    private String escuela;
    private String logo;
    private String nota;
    private String finicial;
    private String ffinal;
    private String nivelgradogrupo;
    private Collection<Movimientos> movimientos;
    private JRDataSource dsMovimientos;

    /**
     * @return the codigoid
     */
    public String getCodigoid() {
        return codigoid;
    }

    /**
     * @param codigoid the codigoid to set
     */
    public void setCodigoid(String codigoid) {
        this.codigoid = codigoid;
    }

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
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
     * @return the nota
     */
    public String getNota() {
        return nota;
    }

    /**
     * @param nota the nota to set
     */
    public void setNota(String nota) {
        this.nota = nota;
    }

    /**
     * @return the finicial
     */
    public String getFinicial() {
        return finicial;
    }

    /**
     * @param finicial the finicial to set
     */
    public void setFinicial(String finicial) {
        this.finicial = finicial;
    }

    /**
     * @return the ffinal
     */
    public String getFfinal() {
        return ffinal;
    }

    /**
     * @param ffinal the ffinal to set
     */
    public void setFfinal(String ffinal) {
        this.ffinal = ffinal;
    }

    /**
     * @return the movimientos
     */
        public Collection<Movimientos> getMovimientos() {
            return movimientos;
        }

        /**
         * @param movimientos the movimientos to set
         */
        public void setMovimientos(Collection<Movimientos> movimientos) {
            this.movimientos = movimientos;
        }

    /**
     * @return the dsMovimientos
     */
    public JRDataSource getDsMovimientos() {
        return new JRBeanCollectionDataSource(movimientos);
    }

    /**
     * @return the nivelgradogrupo
     */
    public String getNivelgradogrupo() {
        return nivelgradogrupo;
    }

    /**
     * @param nivelgradogrupo the nivelgradogrupo to set
     */
    public void setNivelgradogrupo(String nivelgradogrupo) {
        this.nivelgradogrupo = nivelgradogrupo;
    }

    
}
