package aca.kinder;

public class Criterios {
	
	private Long id;
	private Long area_id;
	private String ciclo_id;
	private String criterio;
	private Integer estado;
	
	
	
	
	@Override
	public String toString() {
		return "Criterios [id=" + id + ", area_id=" + area_id + ", ciclo_id=" + ciclo_id + ", criterio=" + criterio
				+ ", estado=" + estado + "]";
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
	
	
	

}
