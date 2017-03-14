package aca.preescolar;

public class CicloGrupoKinderTareas {
	private Long id_kinder_tarea;			
	private String ciclo_gpo_id;			
	private String curso_id;			
	private Long evaluacion_id;			
	private Long actividad_id;			
	private String  actividad;		
	private String observacion;
	private String ciclo_id;
	private Integer status;
	private Long promedio_id;
	
	public CicloGrupoKinderTareas(){
		
	}

	
	
	public CicloGrupoKinderTareas(Long id_kinder_tarea, String ciclo_gpo_id, String curso_id, Long evaluacion_id,
			Long actividad_id, String actividad, String observacion, String ciclo_id, Integer status, Long promedio_id) {
		super();
		this.id_kinder_tarea = id_kinder_tarea;
		this.ciclo_gpo_id = ciclo_gpo_id;
		this.curso_id = curso_id;
		this.evaluacion_id = evaluacion_id;
		this.actividad_id = actividad_id;
		this.actividad = actividad;
		this.observacion = observacion;
		this.ciclo_id = ciclo_id;
		this.status = status;
		this.promedio_id= promedio_id;
	}




	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "CicloGrupoKinderTareas [id_kinder_tarea=" + id_kinder_tarea + ", ciclo_gpo_id=" + ciclo_gpo_id
				+ ", curso_id=" + curso_id + ", evaluacion_id=" + evaluacion_id + ", actividad_id=" + actividad_id
				+ ", actividad=" + actividad + ", observacion=" + observacion + ", ciclo_id=" + ciclo_id + ", status="
				+ status + ", promedio_id=" + promedio_id + "]";
	}



	/**
	 * @return the id_kinder_tarea
	 */
	public Long getId_kinder_tarea() {
		return id_kinder_tarea;
	}
	/**
	 * @param id_kinder_tarea the id_kinder_tarea to set
	 */
	public void setId_kinder_tarea(Long id_kinder_tarea) {
		this.id_kinder_tarea = id_kinder_tarea;
	}
	/**
	 * @return the ciclo_gpo_id
	 */
	public String getCiclo_gpo_id() {
		return ciclo_gpo_id;
	}
	/**
	 * @param ciclo_gpo_id the ciclo_gpo_id to set
	 */
	public void setCiclo_gpo_id(String ciclo_gpo_id) {
		this.ciclo_gpo_id = ciclo_gpo_id;
	}
	/**
	 * @return the curso_id
	 */
	public String getCurso_id() {
		return curso_id;
	}
	/**
	 * @param curso_id the curso_id to set
	 */
	public void setCurso_id(String curso_id) {
		this.curso_id = curso_id;
	}
	/**
	 * @return the evaluacion_id
	 */
	public Long getEvaluacion_id() {
		return evaluacion_id;
	}
	/**
	 * @param evaluacion_id the evaluacion_id to set
	 */
	public void setEvaluacion_id(Long evaluacion_id) {
		this.evaluacion_id = evaluacion_id;
	}
	/**
	 * @return the actividad_id
	 */
	public Long getActividad_id() {
		return actividad_id;
	}
	/**
	 * @param actividad_id the actividad_id to set
	 */
	public void setActividad_id(Long actividad_id) {
		this.actividad_id = actividad_id;
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
	 * @return the observacion
	 */
	public String getObservacion() {
		return observacion;
	}
	/**
	 * @param observacion the observacion to set
	 */
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}




	/**
	 * @return the ciclo_id
	 */
	public String getCiclo_id() {
		return ciclo_id;
	}




	/**
	 * @param ciclo_id the ciclo_id to set
	 */
	public void setCiclo_id(String ciclo_id) {
		this.ciclo_id = ciclo_id;
	}




	/**
	 * @return the status
	 */
	public Integer getStatus() {
		return status;
	}




	/**
	 * @param status the status to set
	 */
	public void setStatus(Integer status) {
		this.status = status;
	}



	/**
	 * @return the promedio_id
	 */
	public Long getPromedio_id() {
		return promedio_id;
	}



	/**
	 * @param promedio_id the promedio_id to set
	 */
	public void setPromedio_id(Long promedio_id) {
		this.promedio_id = promedio_id;
	}
	
	
	
}
