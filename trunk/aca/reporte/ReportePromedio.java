package aca.reporte;

import java.util.Collection;
import java.util.HashMap;

public class ReportePromedio{
	private String nombreCorto;
	private String nota;
	private String valor;
	private HashMap<Integer, ReporteEvaluacion> mapaEvaluaciones = new HashMap<Integer, ReporteEvaluacion>();
	
	public ReportePromedio(String nombreCorto, String valor) {
		this.setNombreCorto(nombreCorto);
		this.setValor(valor);
	}

	/**
	 * @return the nota
	 */
	public String getNota() {
		return nota;
	}

	/**
	 * @param nota the nota to set
	 */
	public void setNota(String nota) {
		this.nota = nota;
	}

	/**
	 * @return the mapaEvaluaciones
	 */
	public HashMap<Integer, ReporteEvaluacion> getMapaEvaluaciones() {
		return mapaEvaluaciones;
	}

	/**
	 * @param mapaEvaluaciones the mapaEvaluaciones to set
	 */
	public void setMapaEvaluaciones(HashMap<Integer, ReporteEvaluacion> mapaEvaluaciones) {
		this.mapaEvaluaciones = mapaEvaluaciones;
	}
	/**
	 * @param eval_id the id of the evaluacion
	 * @param evaluacion the evaluacion of course jaja saludos
	 */
	public void addEvaluacion(int eval_id, ReporteEvaluacion evaluacion) {
		this.mapaEvaluaciones.put(eval_id, evaluacion);
	}
	/**
	 * @return A Collection of evaluaciones from MapaEvaluaciones
	 */
	public Collection<ReporteEvaluacion> getEvaluaciones(){
		return this.mapaEvaluaciones.values();
	}
	/**
	 * @return the valor
	 */
	public String getValor() {
		return valor;
	}

	/**
	 * @param valor the valor to set
	 */
	public void setValor(String valor) {
		this.valor = valor;
	}

	/**
	 * @return the nombreCorto
	 */
	public String getNombreCorto() {
		return nombreCorto;
	}

	/**
	 * @param nombreCorto the nombreCorto to set
	 */
	public void setNombreCorto(String nombreCorto) {
		this.nombreCorto = nombreCorto;
	}
}