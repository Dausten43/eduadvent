package aca.fin;

import java.math.BigDecimal;

public class FinSaldoAlumno {
	String auxiliar;
	String nombre;
	String apaterno;
	String amaterno;
	BigDecimal Saldo;
	
	
	

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "FinSaldoAlumno [auxiliar=" + auxiliar + ", nombre=" + nombre + ", apaterno=" + apaterno + ", amaterno="
				+ amaterno + ", Saldo=" + Saldo + "]";
	}
	/**
	 * @return the auxiliar
	 */
	public String getAuxiliar() {
		return auxiliar;
	}
	/**
	 * @param auxiliar the auxiliar to set
	 */
	public void setAuxiliar(String auxiliar) {
		this.auxiliar = auxiliar;
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
	 * @return the apaterno
	 */
	public String getApaterno() {
		return apaterno;
	}
	/**
	 * @param apaterno the apaterno to set
	 */
	public void setApaterno(String apaterno) {
		this.apaterno = apaterno;
	}
	/**
	 * @return the amaterno
	 */
	public String getAmaterno() {
		return amaterno;
	}
	/**
	 * @param amaterno the amaterno to set
	 */
	public void setAmaterno(String amaterno) {
		this.amaterno = amaterno;
	}
	/**
	 * @return the saldo
	 */
	public BigDecimal getSaldo() {
		return Saldo;
	}
	/**
	 * @param saldo the saldo to set
	 */
	public void setSaldo(BigDecimal saldo) {
		Saldo = saldo;
	}
	
	
	
	
}
