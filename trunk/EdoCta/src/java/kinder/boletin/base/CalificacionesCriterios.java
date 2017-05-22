/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kinder.boletin.base;

/**
 *
 * @author Daniel
 */
public class CalificacionesCriterios {
    private Long area_id;
    private String area;
    private Long criterio_id;
    private String criterio;
    private String trimestre;
    private String nota;

    @Override
    public String toString() {
        return "CalificacionesCriterios{" + "area_id=" + area_id + ", area=" + area + ", criterio_id=" + criterio_id + ", criterio=" + criterio + ", trimestre=" + trimestre + ", nota=" + nota + '}';
    }

    /**
     * @return the area_id
     */
    public Long getArea_id() {
        return area_id;
    }

    /**
     * @param area_id the area_id to set
     */
    public void setArea_id(Long area_id) {
        this.area_id = area_id;
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
     * @return the criterio_id
     */
    public Long getCriterio_id() {
        return criterio_id;
    }

    /**
     * @param criterio_id the criterio_id to set
     */
    public void setCriterio_id(Long criterio_id) {
        this.criterio_id = criterio_id;
    }

    /**
     * @return the criterio
     */
    public String getCriterio() {
        return criterio;
    }

    /**
     * @param criterio the criterio to set
     */
    public void setCriterio(String criterio) {
        this.criterio = criterio;
    }

    /**
     * @return the trimestre
     */
    public String getTrimestre() {
        return trimestre;
    }

    /**
     * @param trimestre the trimestre to set
     */
    public void setTrimestre(String trimestre) {
        this.trimestre = trimestre;
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
    
    
}
