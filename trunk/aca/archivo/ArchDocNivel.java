package aca.archivo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ArchDocNivel {
	private String escuelaId;
	private String nivelId;	
	private String documentoId;	
	
	public ArchDocNivel(){
		escuelaId			= "";
		nivelId				= "";
		documentoId			= "";
		
			
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
	 * @return the nivelId
	 */
	public String getNivelId() {
		return nivelId;
	}

	/**
	 * @param nivelId the nivelId to set
	 */
	public void setNivelId(String nivelId) {
		this.nivelId = nivelId;
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


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO ARCH_DOCNIVEL " +
					"(ESCUELA_ID, NIVEL_ID, DOCUMENTO_ID ) VALUES(?,TO_NUMBER(?,'99'), TO_NUMBER(?,'99'))");
			
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, documentoId);	
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.archDocNivel|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM ARCH_DOCNIVEL" +
					" WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') AND DOCUMENTO_ID = TO_NUMBER(?,'99')");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, documentoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocNivel|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId		= rs.getString("ESCUELA_ID");
		nivelId			= rs.getString("NIVEL_ID");	
		documentoId		= rs.getString("DOCUMENTO_ID");
	}
	
	public void mapeaRegId(Connection con, String escuelaId, String nivelId, String documentoId) throws SQLException{
		
		ResultSet rs = null;
		PreparedStatement ps = null;
		try{
			ps = con.prepareStatement("SELECT ESCUELA_ID, NIVEL_ID, DOCUMENTO_ID" +
					" FROM ARCH_DOCNIVEL WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') AND DOCUMENTO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, documentoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.AlumDocNivel|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM ARCH_DOCNIVEL WHERE ESCUELA_ID = ? AND NIVEL_ID = TO_NUMBER(?, '99') AND DOCUMENTO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, documentoId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocNivel|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ESCUELA_ID)+1,'1') AS MAXIMO FROM ARCH_DOCNIVEL");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocNivel|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
}