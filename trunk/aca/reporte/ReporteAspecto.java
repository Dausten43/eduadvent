package aca.reporte;

import java.util.HashMap;

public class ReporteAspecto {
	
	private String nombre;
	private HashMap<String, String> mapaNotas = new HashMap<String, String>();	
	
	/**
	 * @return the aspectoNombre
	 */
	public String getNombre() {
		return nombre;
	}
	/**
	 * @param aspectoNombre the aspectoNombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	/**
	 * @return the mapaPromedios
	 */
	public HashMap<String, String> getMapaNotas() {
		return mapaNotas;
	}
	/**
	 * @param mapaPromedios the mapaPromedios to set
	 */
	public void setMapaNotas(HashMap<String, String> mapaPromedios) {
		this.mapaNotas = mapaPromedios;
	}
	
	public void setNota(String prom_eval, String nota) {
		mapaNotas.put(prom_eval, nota);
	}
	
	public String getNota(String prom_eval) {
		return mapaNotas.get(prom_eval);
	}
}
