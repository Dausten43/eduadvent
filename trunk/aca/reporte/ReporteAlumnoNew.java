package aca.reporte;

import java.util.Map;

public class ReporteAlumnoNew {

	private String codigoId;
	private String nombreAlumno;
	private String cip;
	private Map<Integer, ReporteGrado> mapaGrados;

	public String getCodigoId() {
		return codigoId;
	}

	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

	/**
	 * @return the nombreAlumno
	 */
	public String getNombreAlumno() {
		return nombreAlumno;
	}

	/**
	 * @param nombreAlumno the nombreAlumno to set
	 */
	public void setNombreAlumno(String nombreAlumno) {
		this.nombreAlumno = nombreAlumno;
	}

	/**
	 * @return the cip
	 */
	public String getCip() {
		return cip;
	}

	/**
	 * @param cip the cip to set
	 */
	public void setCip(String cip) {
		this.cip = cip;
	}

	/**
	 * @return the mapGrados
	 */
	public Map<Integer, ReporteGrado> getMapaGrados() {
		return mapaGrados;
	}

	/**
	 * @param mapGrados the mapGrados to set
	 */
	public void setMapaGrados(Map<Integer, ReporteGrado> mapGrados) {
		this.mapaGrados = mapGrados;
	}
	
}
