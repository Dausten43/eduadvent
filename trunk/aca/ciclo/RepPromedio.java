package aca.ciclo;

import java.math.BigDecimal;

public class RepPromedio {
	public String ciclo_gpo_id;
	public String ciclo_nombre;
	public String codigo_id;
	public String nombre_alumno;
	public String evaluacion_id;
	public String curso_id;
	public String nombre_materia;
	public BigDecimal suma;
	public Integer numMaterias;
	public BigDecimal promedio;
	
	
	
	@Override
	public String toString() {
		return "RepPromedio [ciclo_gpo_id=" + ciclo_gpo_id + ", codigo_id=" + codigo_id + ", evaluacion_id="
				+ evaluacion_id + ", curso_id=" + curso_id + ", suma=" + suma + ", numMaterias=" + numMaterias
				+ ", promedio=" + promedio + "]";
	}
	
	
	/**
	 * @return the ciclo_nombre
	 */
	public String getCiclo_nombre() {
		return ciclo_nombre;
	}


	/**
	 * @param ciclo_nombre the ciclo_nombre to set
	 */
	public void setCiclo_nombre(String ciclo_nombre) {
		this.ciclo_nombre = ciclo_nombre;
	}


	public String getNombre_alumno() {
		return nombre_alumno;
	}


	public void setNombre_alumno(String nombre_alumno) {
		this.nombre_alumno = nombre_alumno;
	}


	public String getNombre_materia() {
		return nombre_materia;
	}


	public void setNombre_materia(String nombre_materia) {
		this.nombre_materia = nombre_materia;
	}


	public String getCiclo_gpo_id() {
		return ciclo_gpo_id;
	}
	public void setCiclo_gpo_id(String ciclo_gpo_id) {
		this.ciclo_gpo_id = ciclo_gpo_id;
	}
	public String getCodigo_id() {
		return codigo_id;
	}
	public void setCodigo_id(String codigo_id) {
		this.codigo_id = codigo_id;
	}
	public String getEvaluacion_id() {
		return evaluacion_id;
	}
	public void setEvaluacion_id(String evaluacion_id) {
		this.evaluacion_id = evaluacion_id;
	}
	public String getCurso_id() {
		return curso_id;
	}
	public void setCurso_id(String curso_id) {
		this.curso_id = curso_id;
	}
	public BigDecimal getSuma() {
		return suma;
	}
	public void setSuma(BigDecimal suma) {
		this.suma = suma;
	}
	public Integer getNumMaterias() {
		return numMaterias;
	}
	public void setNumMaterias(Integer numMaterias) {
		this.numMaterias = numMaterias;
	}
	public BigDecimal getPromedio() {
		return promedio;
	}
	public void setPromedio(BigDecimal promedio) {
		this.promedio = promedio;
	}
	
	
}
