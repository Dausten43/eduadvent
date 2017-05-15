package aca.kinder;

import java.util.Date;

public class Actividades {
	private Long id;
	private Long area_id;
	private Long criterio_id;
	private String ciclo_grupo_id;
	private String maestro_id;
	private String actividad;
	private String fecha;
	private Integer estado;
	private Integer evaluacion;
	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
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
	 * @return the ciclo_grupo_id
	 */
	public String getCiclo_grupo_id() {
		return ciclo_grupo_id;
	}
	/**
	 * @param ciclo_grupo_id the ciclo_grupo_id to set
	 */
	public void setCiclo_grupo_id(String ciclo_grupo_id) {
		this.ciclo_grupo_id = ciclo_grupo_id;
	}
	/**
	 * @return the maestro_id
	 */
	public String getMaestro_id() {
		return maestro_id;
	}
	/**
	 * @param maestro_id the maestro_id to set
	 */
	public void setMaestro_id(String maestro_id) {
		this.maestro_id = maestro_id;
	}
	/**
	 * @return the actividad
	 */
	public String getActividad() {
		return actividad;
	}
	/**
	 * @param actividad the actividad to set
	 */
	public void setActividad(String actividad) {
		this.actividad = actividad;
	}
	/**
	 * @return the fecha
	 */
	public String getFecha() {
		return fecha;
	}
	/**
	 * @param fecha the fecha to set
	 */
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	/**
	 * @return the estado
	 */
	public Integer getEstado() {
		return estado;
	}
	/**
	 * @param estado the estado to set
	 */
	public void setEstado(Integer estado) {
		this.estado = estado;
	}
	/**
	 * @return the evaluacion
	 */
	public Integer getEvaluacion() {
		return evaluacion;
	}
	/**
	 * @param evaluacion the evaluacion to set
	 */
	public void setEvaluacion(Integer evaluacion) {
		this.evaluacion = evaluacion;
	}
	
	
	
}
