package aca.reporte;

import java.util.HashMap;

public class Reporte {

	private String escuelaId;
	private String nombreEscuela;
	private String telefono;//ciudad,estado,direccion,telefono. -- numero Personal
	private String ciudad;
	private String estado;
	private String nombrePais;
	private String nombreDirector;
	private String nombreSecretaria; // Secretaría de registro
	private String logo;
	private HashMap<String, ReporteAlumnoNew> mapaReportes;

	/**
	 * @return the escuelaId
	 */
	public String getEscuelaId() {
		return escuelaId;
	}
	/**
	 * @param escuelaId the escuelaId to set
	 */
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}
	/**
	 * @return the nombreEscuela
	 */
	public String getNombreEscuela() {
		return nombreEscuela;
	}
	/**
	 * @param nombreEscuela the nombreEscuela to set
	 */
	public void setNombreEscuela(String nombreEscuela) {
		this.nombreEscuela = nombreEscuela;
	}
	/**
	 * @return the telefono
	 */
	public String getTelefono() {
		return telefono;
	}
	/**
	 * @param telefono the telefono to set
	 */
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	/**
	 * @return the ciudad
	 */
	public String getCiudad() {
		return ciudad;
	}
	/**
	 * @param ciudad the ciudad to set
	 */
	public void setCiudad(String ciudad) {
		this.ciudad = ciudad;
	}
	/**
	 * @return the estado
	 */
	public String getEstado() {
		return estado;
	}
	/**
	 * @param estado the estado to set
	 */
	public void setEstado(String estado) {
		this.estado = estado;
	}
	/**
	 * @return the nombreDirector
	 */
	public String getNombreDirector() {
		return nombreDirector;
	}
	/**
	 * @param nombreDirector the nombreDirector to set
	 */
	public void setNombreDirector(String nombreDirector) {
		this.nombreDirector = nombreDirector;
	}
	/**
	 * @return the nombreSecretaria
	 */
	public String getNombreSecretaria() {
		return nombreSecretaria;
	}
	/**
	 * @param nombreSecretaria the nombreSecretaria to set
	 */
	public void setNombreSecretaria(String nombreSecretaria) {
		this.nombreSecretaria = nombreSecretaria;
	}
	/**
	 * @return the logo
	 */
	public String getLogo() {
		return logo;
	}
	/**
	 * @param logo the logo to set
	 */
	public void setLogo(String logo) {
		this.logo = "https://eduadvent.um.edu.mx/escuela/imagenes/logos/" + logo;
	}
	/**
	 * @return the nombrePais
	 */
	public String getNombrePais() {
		return nombrePais;
	}
	/**
	 * @param nombrePais the nombrePais to set
	 */
	public void setNombrePais(String nombrePais) {
		this.nombrePais = nombrePais;
	}
	/**
	 * @return the mapaReportes
	 */
	public HashMap<String, ReporteAlumnoNew> getMapaReportes() {
		return mapaReportes;
	}
	/**
	 * @param mapaReportes the mapaReportes to set
	 */
	public void setMapaReportes(HashMap<String, ReporteAlumnoNew> mapaReportes) {
		this.mapaReportes = mapaReportes;
	}
	
}
