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
public class KrdxAlumObs {

    private Long id;
    private String ciclo_gupo_id;
    private String codigo_id;
    private Integer ubicador;
    private String observacion_1;
    private String observacion_2;

    public KrdxAlumObs() {

    }

    public KrdxAlumObs(Long id, String ciclo_gupo_id, String codigo_id, Integer ubicador, String observacion_1,
            String observacion_2) {
        super();
        this.id = id;
        this.ciclo_gupo_id = ciclo_gupo_id;
        this.codigo_id = codigo_id;
        this.ubicador = ubicador;
        this.observacion_1 = observacion_1;
        this.observacion_2 = observacion_2;
    }

    @Override
    public String toString() {
        return "KrdxAlumObs [id=" + id + ", ciclo_gupo_id=" + ciclo_gupo_id + ", codigo_id=" + codigo_id + ", ubicador="
                + ubicador + ", observacion_1=" + observacion_1 + ", observacion_2=" + observacion_2 + "]";
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCiclo_gupo_id() {
        return ciclo_gupo_id;
    }

    public void setCiclo_gupo_id(String ciclo_gupo_id) {
        this.ciclo_gupo_id = ciclo_gupo_id;
    }

    public String getCodigo_id() {
        return codigo_id;
    }

    public void setCodigo_id(String codigo_id) {
        this.codigo_id = codigo_id;
    }

    public Integer getUbicador() {
        return ubicador;
    }

    public void setUbicador(Integer ubicador) {
        this.ubicador = ubicador;
    }

    public String getObservacion_1() {
        return observacion_1;
    }

    public void setObservacion_1(String observacion_1) {
        this.observacion_1 = observacion_1;
    }

    public String getObservacion_2() {
        return observacion_2;
    }

    public void setObservacion_2(String observacion_2) {
        this.observacion_2 = observacion_2;
    }
}
