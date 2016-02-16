package aca.archivo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ArchDocAlum {
	private String codigoId;
	private String escuelaId;	
	private String documentoId;	
	private String fecha;	
	private String usuario;	
	private String comentario;	
	
	public ArchDocAlum(){
		codigoId		= "";
		escuelaId		= "";
		documentoId		= "";
		fecha			= "";
		usuario			= "";
		comentario		= "";
			
	}
	
	/**
	 * @return the codigoId
	 */
	public String getCodigoId() {
		return codigoId;
	}

	/**
	 * @param codigoId the codigoId to set
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}

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
	 * @return the documentoId
	 */
	public String getDocumentoId() {
		return documentoId;
	}

	/**
	 * @param documentoId the documentoId to set
	 */
	public void setDocumentoId(String documentoId) {
		this.documentoId = documentoId;
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
	 * @return the usuario
	 */
	public String getUsuario() {
		return usuario;
	}

	/**
	 * @param usuario the usuario to set
	 */
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	/**
	 * @return the comentario
	 */
	public String getComentario() {
		return comentario;
	}

	/**
	 * @param comentario the comentario to set
	 */
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO ARCH_DOCALUM " +
					"(CODIGO_ID, ESCUELA_ID, DOCUMENTO_ID, FECHA, USUARIO, COMENTARIO ) VALUES(?, ?, TO_NUMBER(?, '99'), TO_DATE(?,'DD/MM/YYYY'), ?,?)");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);	
			ps.setString(4, fecha);
			ps.setString(5, usuario);
			ps.setString(6, comentario);
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.archDocAlum|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ARCH_DOCALUM" +
					" SET FECHA = TO_DATE(?,'DD/MM/YYYY')," +
					" ESCUELA_ID = ?, " +
					" USUARIO = ?, COMENTARIO = ? " +									
					" WHERE CODIGO_ID = ?  AND DOCUMENTO_ID = TO_NUMBER(?, '99') ");			
			ps.setString(1, fecha);
			ps.setString(2, escuelaId);	
			ps.setString(3, usuario);	
			ps.setString(4, comentario);						
			ps.setString(5, codigoId);
			ps.setString(6, documentoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocAlum|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM ARCH_DOCALUM" +
					" WHERE CODIGO_ID = ?  AND ESCUELA_ID = ? AND DOCUMENTO_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocAlum|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId			= rs.getString("CODIGO_ID");
		escuelaId			= rs.getString("ESCUELA_ID");	
		documentoId			= rs.getString("DOCUMENTO_ID");
		fecha			    = rs.getString("FECHA");
		usuario			    = rs.getString("USUARIO");	
		comentario			= rs.getString("COMENTARIO");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String escuelaId, String documentoId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, ESCUELA_ID, DOCUMENTO_ID, FECHA, USUARIO, COMENTARIO " +
					" FROM ARCH_DOCALUM WHERE CODIGO_ID = ?  AND ESCUELA_ID = ? AND DOCUMENTO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocAlum|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}	
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM ARCH_DOCALUM WHERE CODIGO_ID = ? AND ESCUELA_ID = ? AND DOCUMENTO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);

			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocAlum|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
/*	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(CODIGO_ID)+1,'1') AS MAXIMO FROM ARCH_DOCALUM");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocAlum|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
*/	
}
