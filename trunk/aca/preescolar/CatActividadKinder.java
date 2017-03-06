package aca.preescolar;

public class CatActividadKinder {
	
	Long id;
	
	String nivel;			
	String actividad;			
	String descripcion;
	Integer activa;
	
	public CatActividadKinder(){
		
	}
	
	
	public CatActividadKinder(Long id, String nivel, String actividad, String descripcion, Integer activa) {
		super();
		this.id = id;
		this.nivel = nivel;
		this.actividad = actividad;
		this.descripcion = descripcion;
		this.activa = activa;
	}
	
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "CatActividadKinder [id=" + id + ", nivel=" + nivel + ", actividad=" + actividad + ", descripcion="
				+ descripcion + ", activa=" + activa + "]";
	}

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
	 * @return the descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}
	/**
	 * @param descripcion the descripcion to set
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	/**
	 * @return the activa
	 */
	public Integer getActiva() {
		return activa;
	}
	/**
	 * @param activa the activa to set
	 */
	public void setActiva(Integer activa) {
		this.activa = activa;
	}
	
	
	

}
