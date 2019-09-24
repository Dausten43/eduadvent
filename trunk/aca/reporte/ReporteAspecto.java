package aca.reporte;

import java.util.HashMap;

public class ReporteAspecto {
	
	private String aspectoNombre;
	private HashMap<String, String> notas = new HashMap<String, String>();	
	
	/**
	 * @return the aspectoNombre
	 */
	public String getAspectoNombre() {
		return aspectoNombre;
	}
	/**
	 * @param aspectoNombre the aspectoNombre to set
	 */
	public void setAspectoNombre(String aspectoNombre) {
		this.aspectoNombre = aspectoNombre;
	}
	/**
	 * @return the mapaPromedios
	 */
	public HashMap<String, String> getMapaPromedios() {
		return notas;
	}
	/**
	 * @param mapaPromedios the mapaPromedios to set
	 */
	public void setMapaPromedios(HashMap<String, String> mapaPromedios) {
		this.notas = mapaPromedios;
	}
	
	public void setNota(String prom_eval, String nota) {
		notas.put(prom_eval, nota);
	}
	
	public String getNota(String prom_eval) {
		return notas.get(prom_eval);
	}
}
