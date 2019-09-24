package aca.reporte;

import java.util.Collection;
import java.util.LinkedHashMap;

public class ReporteGrado {

	private int grado;
	private String cicloId;
	private String nombreGrado;
	private String cicloGrupoId;
	private String observaciones;
	private String nombrePlan;
	private String fechaInicial;
	private String fechaFinal;
	private String nivelEval;
	private LinkedHashMap <String, ReporteMateria> mapaMaterias;
	private LinkedHashMap <Integer, ReporteAspecto> mapaAspectos;
	
	
	private int escalaEval;
	private String redondeo;
	private String decimales;
	
	/**
	 * @return the grado
	 */
	public int getGrado() {
		return grado;
	}
	/**
	 * @param grado the grado to set
	 */
	public void setGrado(int grado) {
		this.grado = grado;
	}
	/**
	 * @return the grado
	 */
	public String getCicloId() {
		return cicloId;
	}
	/**
	 * @param cicloId the cicloId to set
	 */
	public void setCicloId(String cicloId) {
		this.cicloId = cicloId;
	}
	/**
	 * @return the nombreGrado
	 */
	public String getNombreGrado() {
		return nombreGrado;
	}
	/**
	 * @param nombreGrado the nombreGrado to set
	 */
	public void setNombreGrado(String nombreGrado) {
		this.nombreGrado = nombreGrado;
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
	 * @return the observaciones
	 */
	public String getObservaciones() {
		return observaciones;
	}
	/**
	 * @param observaciones the observaciones to set
	 */
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	/**
	 * @return the nombrePlan
	 */
	public String getNombrePlan() {
		return nombrePlan;
	}
	/**
	 * @param nombrePlan the nombrePlan to set
	 */
	public void setNombrePlan(String nombrePlan) {
		this.nombrePlan = nombrePlan;
	}
	/**
	 * @return the fechaInicial
	 */
	public String getFechaInicial() {
		return fechaInicial;
	}
	/**
	 * @param fechaInicial the fechaInicial to set
	 */
	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}
	/**
	 * @return the fechaFinal
	 */
	public String getFechaFinal() {
		return fechaFinal;
	}
	/**
	 * @param fechaFinal the fechaFinal to set
	 */
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	/**
	 * @return A Collection of materias from MapaMaterias
	 */
	public Collection<ReporteMateria> getMaterias() {
		return mapaMaterias.values();
	}
	/**
	 * @return the mapaMaterias
	 */
	public LinkedHashMap<String, ReporteMateria> getMapaMaterias() {
		return mapaMaterias;
	}
	/**
	 * @param mapaMaterias the mapaMaterias to set
	 */
	public void setMapaMaterias(LinkedHashMap<String, ReporteMateria> mapaMaterias) {
		this.mapaMaterias = mapaMaterias;
	}
	/**
	 * @return the escalaEval
	 */
	public int getEscalaEval() {
		return escalaEval;
	}
	/**
	 * @param escalaEval the escalaEval to set
	 */
	public void setEscalaEval(int escalaEval) {
		this.escalaEval = escalaEval;
	}
	/**
	 * @return the redondeoCiclo
	 */
	public String getRedondeo() {
		return redondeo;
	}
	/**
	 * @param redondeoCiclo the redondeoCiclo to set
	 */
	public void setRedondeo(String redondeo) {
		this.redondeo = redondeo;
	}
	/**
	 * @return the numDecimales
	 */
	public String getDecimales() {
		return decimales;
	}
	/**
	 * @param numDecimales the numDecimales to set
	 */
	public void setDecimales(String decimales) {
		this.decimales = decimales;
	}

	/**
	 * @return the mapaAspectos
	 */
	public LinkedHashMap<Integer, ReporteAspecto> getMapaAspectos() {
		return mapaAspectos;
	}

	/**
	 * @param mapaAspectos the mapaAspectos to set
	 */
	public void setMapaAspectos(LinkedHashMap<Integer, ReporteAspecto> mapaAspectos) {
		this.mapaAspectos = mapaAspectos;
	}

	/**
	 * @return the nivelEval
	 */
	public String getNivelEval() {
		return nivelEval;
	}

	/**
	 * @param nivelEval the nivelEval to set
	 */
	public void setNivelEval(String nivelEval) {
		this.nivelEval = nivelEval;
	}
}
