package aca.reporte;

public class MateriaReporte {
	private String cursoId;
	private String nombre;
	private Double horas;
	private String calificacion;
	private String convalidacion;
	
	public MateriaReporte(){
		cursoId = "";
		nombre = "";
		horas = 0.0;
		calificacion = "0.0";
		convalidacion = "";
	}
	
	public MateriaReporte(String cursoId, String nombre, Double horas, String convalidacion){
		setCursoId(cursoId);
		setNombre(nombre);
		setHoras(horas);
		setConvalidacion(convalidacion);
	}
	
	public String getCursoId() {
		return cursoId;
	}
	
	public void setCursoId(String codigo) {
		this.cursoId = codigo;
	}
	
	public String getNombre() {
		return nombre;
	}
	
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	public Double getHoras() {
		return horas;
	}
	
	public void setHoras(Double horas) {
		this.horas = horas;
	}
	
	public String getCalificacion() {
		return calificacion;
	}
	
	public void setCalificacion(String calificacion) {
		this.calificacion = calificacion;
	}
	
	public String getConvalidacion() {
		return convalidacion;
	}
	
	public void setConvalidacion(String convalidacion) {
		this.convalidacion = convalidacion;
	}
}
