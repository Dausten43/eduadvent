package aca.kinder;

public class Areas {
	
	private Long id;
	private String ciclo_id;
	private String area;
    private Integer estado;
    
    
    
    
	@Override
	public String toString() {
		return "Areas [id=" + id + ", ciclo_id=" + ciclo_id + ", area=" + area + ", estado=" + estado + "]";
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
