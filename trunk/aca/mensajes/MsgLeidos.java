package aca.mensajes;

public class MsgLeidos {

	
		private Long id;
		private String destinatario;
		private Long mensajeId;
		private String fecha;
		
		
		
		public MsgLeidos() {
			
		}
		public MsgLeidos(Long id, String destinatario, Long mensajeId, String fecha) {
			super();
			this.id = id;
			this.destinatario = destinatario;
			this.mensajeId = mensajeId;
			this.fecha = fecha;
		}
		@Override
		public String toString() {
			return "MsgLeidos [id=" + id + ", destinatario=" + destinatario + ", mensajeId=" + mensajeId + ", fecha="
					+ fecha + "]";
		}
		public Long getId() {
			return id;
		}
		public void setId(Long id) {
			this.id = id;
		}
		public String getDestinatario() {
			return destinatario;
		}
		public void setDestinatario(String destinatario) {
			this.destinatario = destinatario;
		}
		public Long getMensajeId() {
			return mensajeId;
		}
		public void setMensajeId(Long mensajeId) {
			this.mensajeId = mensajeId;
		}
		public String getFecha() {
			return fecha;
		}
		public void setFecha(String fecha) {
			this.fecha = fecha;
		}
		
		
}
