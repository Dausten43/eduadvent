package aca.fin;

import java.math.BigDecimal;
import java.util.Date;

public class FinTopeNivelEscuela {
	
	private Long finTopeId;

	private String escuelaId;
	
	private Integer nivelSistema;
	
	private BigDecimal importeTope;
	
	private Date fechaCreado;
	
	private Date fechaActualizado;
	
	
	public FinTopeNivelEscuela() {
		
	}
	
	
	public FinTopeNivelEscuela(Long finTopeId, String escuelaId, Integer nivelSistema, BigDecimal importeTope,
			Date fechaCreado, Date fechaActualizado) {
		super();
		this.finTopeId = finTopeId;
		this.escuelaId = escuelaId;
		this.nivelSistema = nivelSistema;
		this.importeTope = importeTope;
		this.fechaCreado = fechaCreado;
		this.fechaActualizado = fechaActualizado;
	}

	@Override
	public String toString() {
		return "FinTopeNivelEscuela [finTopeId=" + finTopeId + ", escuelaId=" + escuelaId + ", nivelSistema="
				+ nivelSistema + ", importeTope=" + importeTope + ", fechaCreado=" + fechaCreado + ", fechActualizado = " + fechaActualizado + " ]";
	}

	public Long getFinTopeId() {
		return finTopeId;
	}

	public void setFinTopeId(Long finTopeId) {
		this.finTopeId = finTopeId;
	}

	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public Integer getNivelSistema() {
		return nivelSistema;
	}

	public void setNivelSistema(Integer nivelSistema) {
		this.nivelSistema = nivelSistema;
	}

	public BigDecimal getImporteTope() {
		return importeTope;
	}

	public void setImporteTope(BigDecimal importeTope) {
		this.importeTope = importeTope;
	}

	public Date getFechaCreado() {
		return fechaCreado;
	}

	public void setFechaCreado(Date fechaCreado) {
		this.fechaCreado = fechaCreado;
	}


	public Date getFechaActualizado() {
		return fechaActualizado;
	}


	public void setFechaActualizado(Date fechaActualizado) {
		this.fechaActualizado = fechaActualizado;
	}
	

}
