package aca.mensajes;

public class Mensajeria {

	private Long id;			
	private String usr_envia;			
	private String tipo_destino;			
	private String destino;			
	private String fecha;			
	private Integer es_respuesta;			
	private Long id_mensaje_original;			
	private String asunto;
	private String mensaje;			
	private Integer estado;
	
	public Mensajeria(){
		
	}
	
	
	public Mensajeria(Long id, String usr_envia, String tipo_destino, String destino, String fecha,
			Integer es_respuesta, Long id_mensaje_original, String asunto, String mensaje, Integer estado) {
		super();
		this.id = id;
		this.usr_envia = usr_envia;
		this.tipo_destino = tipo_destino;
		this.destino = destino;
		this.fecha = fecha;
		this.es_respuesta = es_respuesta;
		this.id_mensaje_original = id_mensaje_original;
		this.asunto = asunto;
		this.mensaje = mensaje;
		this.estado = estado;
	}


	
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "Mensajeria [id=" + id + ", usr_envia=" + usr_envia + ", tipo_destino=" + tipo_destino + ", destino="
				+ destino + ", fecha=" + fecha + ", es_respuesta=" + es_respuesta + ", id_mensaje_original="
				+ id_mensaje_original + ", asunto=" + asunto + ", mensaje=" + mensaje + ", estado=" + estado + "]";
	}




	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return the usr_envia
	 */
	public String getUsr_envia() {
		return usr_envia;
	}
	/**
	 * @param usr_envia the usr_envia to set
	 */
	public void setUsr_envia(String usr_envia) {
		this.usr_envia = usr_envia;
	}
	/**
	 * @return the tipo_destino
	 */
	public String getTipo_destino() {
		return tipo_destino;
	}
	/**
	 * @param tipo_destino the tipo_destino to set
	 */
	public void setTipo_destino(String tipo_destino) {
		this.tipo_destino = tipo_destino;
	}
	/**
	 * @return the destino
	 */
	public String getDestino() {
		return destino;
	}
	/**
	 * @param destino the destino to set
	 */
	public void setDestino(String destino) {
		this.destino = destino;
	}
	/**
	 * @return the fecha
	 */
	public String getFecha() {
		return fecha;
	}
	/**
	 * @param fecha the fecha to set
	 */
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	/**
	 * @return the es_respuesta
	 */
	public Integer getEs_respuesta() {
		return es_respuesta;
	}
	/**
	 * @param es_respuesta the es_respuesta to set
	 */
	public void setEs_respuesta(Integer es_respuesta) {
		this.es_respuesta = es_respuesta;
	}
	/**
	 * @return the id_mensaje_original
	 */
	public Long getId_mensaje_original() {
		return id_mensaje_original;
	}
	/**
	 * @param id_mensaje_original the id_mensaje_original to set
	 */
	public void setId_mensaje_original(Long id_mensaje_original) {
		this.id_mensaje_original = id_mensaje_original;
	}
	/**
	 * @return the mensaje
	 */
	public String getMensaje() {
		return mensaje;
	}
	/**
	 * @param mensaje the mensaje to set
	 */
	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}
	/**
	 * @return the estado
	 */
	public Integer getEstado() {
		return estado;
	}
	/**
	 * @param estado the estado to set
	 */
	public void setEstado(Integer estado) {
		this.estado = estado;
	}


	/**
	 * @return the asunto
	 */
	public String getAsunto() {
		return asunto;
	}


	/**
	 * @param asunto the asunto to set
	 */
	public void setAsunto(String asunto) {
		this.asunto = asunto;
	}
	
	
	
	
	
}
