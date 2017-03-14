package aca.preescolar;

public class CicloActividadEvaluacionPromedio {
	
	private String cicloGrupoId;
	private String cursoId;
	private Integer promedioId;
	private String nombrePromedio;
	private Integer evaluacionId;
	private String nombreEvaluacion;
	private int actividadId;
	private String nombreActividad;
	
	
	
	public CicloActividadEvaluacionPromedio() {
		
	}



	public CicloActividadEvaluacionPromedio(String cicloGrupoId, String cursoId, Integer promedioId,
			String nombrePromedio, Integer evaluacionId, String nombreEvaluacion, int actividadId,
			String nombreActividad) {
		super();
		this.cicloGrupoId = cicloGrupoId;
		this.cursoId = cursoId;
		this.promedioId = promedioId;
		this.nombrePromedio = nombrePromedio;
		this.evaluacionId = evaluacionId;
		this.nombreEvaluacion = nombreEvaluacion;
		this.actividadId = actividadId;
		this.nombreActividad = nombreActividad;
	}



	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "CicloActividadEvaluacionPromedio [cicloGrupoId=" + cicloGrupoId + ", cursoId=" + cursoId
				+ ", promedioId=" + promedioId + ", nombrePromedio=" + nombrePromedio + ", evaluacionId=" + evaluacionId
				+ ", nombreEvaluacion=" + nombreEvaluacion + ", actividadId=" + actividadId + ", nombreActividad="
				+ nombreActividad + "]";
	}



	/**
	 * @return the cicloGrupoId
	 */
	public String getCicloGrupoId() {
		return cicloGrupoId;
	}



	/**
	 * @param cicloGrupoId the cicloGrupoId to set
	 */
	public void setCicloGrupoId(String cicloGrupoId) {
		this.cicloGrupoId = cicloGrupoId;
	}



	/**
	 * @return the cursoId
	 */
	public String getCursoId() {
		return cursoId;
	}



	/**
	 * @param cursoId the cursoId to set
	 */
	public void setCursoId(String cursoId) {
		this.cursoId = cursoId;
	}



	/**
	 * @return the promedioId
	 */
	public Integer getPromedioId() {
		return promedioId;
	}



	/**
	 * @param promedioId the promedioId to set
	 */
	public void setPromedioId(Integer promedioId) {
		this.promedioId = promedioId;
	}



	/**
	 * @return the nombrePromedio
	 */
	public String getNombrePromedio() {
		return nombrePromedio;
	}



	/**
	 * @param nombrePromedio the nombrePromedio to set
	 */
	public void setNombrePromedio(String nombrePromedio) {
		this.nombrePromedio = nombrePromedio;
	}



	/**
	 * @return the evaluacionId
	 */
	public Integer getEvaluacionId() {
		return evaluacionId;
	}



	/**
	 * @param evaluacionId the evaluacionId to set
	 */
	public void setEvaluacionId(Integer evaluacionId) {
		this.evaluacionId = evaluacionId;
	}



	/**
	 * @return the nombreEvaluacion
	 */
	public String getNombreEvaluacion() {
		return nombreEvaluacion;
	}



	/**
	 * @param nombreEvaluacion the nombreEvaluacion to set
	 */
	public void setNombreEvaluacion(String nombreEvaluacion) {
		this.nombreEvaluacion = nombreEvaluacion;
	}



	/**
	 * @return the actividadId
	 */
	public int getActividadId() {
		return actividadId;
	}



	/**
	 * @param actividadId the actividadId to set
	 */
	public void setActividadId(int actividadId) {
		this.actividadId = actividadId;
	}



	/**
	 * @return the nombreActividad
	 */
	public String getNombreActividad() {
		return nombreActividad;
	}



	/**
	 * @param nombreActividad the nombreActividad to set
	 */
	public void setNombreActividad(String nombreActividad) {
		this.nombreActividad = nombreActividad;
	}
	
	
	
	
}
