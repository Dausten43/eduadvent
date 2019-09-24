package aca.reporte;

import java.util.Collection;
import java.util.HashMap;

public class ReporteMateria {
	
	private String cursoId;
	private String nombre;
	private String horas;
	private String calificacion;
	private String convalidacion;
	private String cursoBase;//Si es madre o hija
	private String boleta;//"S":sí aparece en boleta, "N": no aparece
	private String empleado;
	private String cicloGrupoId;
	private HashMap<Integer, ReportePromedio> mapaPromedios = new HashMap<Integer, ReportePromedio>();	
	
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
	 * @return the horas
	 */
	public String getHoras() {
		return horas;
	}
	/**
	 * @param horas the horas to set
	 */
	public void setHoras(String horas) {
		this.horas = horas;
	}
	/**
	 * @return the calificacion
	 */
	public String getCalificacion() {
		return calificacion;
	}
	/**
	 * @param calificacion the calificacion to set
	 */
	public void setCalificacion(String calificacion) {
		this.calificacion = calificacion;
	}
	/**
	 * @return the convalidacion
	 */
	public String getConvalidacion() {
		return convalidacion;
	}
	/**
	 * @param convalidacion the convalidacion to set
	 */
	public void setConvalidacion(String convalidacion) {
		this.convalidacion = convalidacion;
	}
	/**
	 * @return the cursoBase
	 */
	public String getCursoBase() {
		return cursoBase;
	}
	/**
	 * @param cursoBase the cursoBase to set
	 */
	public void setCursoBase(String cursoBase) {
		this.cursoBase = cursoBase;
	}
	/**
	 * @return the boleta
	 */
	public String getBoleta() {
		return boleta;
	}
	/**
	 * @param boleta the boleta to set
	 */
	public void setBoleta(String boleta) {
		this.boleta = boleta;
	}
	/**
	 * @return the empleado
	 */
	public String getEmpleado() {
		return empleado;
	}
	/**
	 * @param empleado the empleado to set
	 */
	public void setEmpleado(String empleado) {
		this.empleado = empleado;
	}
	/**
	 * @return the empleado
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
	 * @return the mapaPromedios
	 */
	public HashMap<Integer, ReportePromedio> getMapaPromedios() {
		return mapaPromedios;
	}
	/**
	 * @param mapaPromedios the mapaPromedios to set
	 */
	public void setMapaPromedios(HashMap<Integer, ReportePromedio> mapaPromedios) {
		this.mapaPromedios = mapaPromedios;
	}
	/**
	 * @return A Collection of Promedios from MapaPromedios
	 */
	public Collection<ReportePromedio> getPromedios() {
		return mapaPromedios.values();
	}
}
