package aca.archivo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ArchDocumento {
	private String escuelaId;
	private String documentoId;	
	private String documentoNombre;
	
	public ArchDocumento(){
		escuelaId			= "";
		documentoId			= "";
		documentoNombre		= "";
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
	 * @return the documentoNombre
	 */
	public String getDocumentoNombre() {
		return documentoNombre;
	}

	/**
	 * @param documentoNombre the documentoNombre to set
	 */
	public void setDocumentoNombre(String documentoNombre) {
		this.documentoNombre = documentoNombre;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO ARCH_DOCUMENTO " +
					"(ESCUELA_ID, DOCUMENTO_ID, DOCUMENTO_NOMBRE) " +
					"VALUES(?,TO_NUMBER(?,'99'), ? )");
			
			ps.setString(1, escuelaId);
			ps.setString(2, documentoId);
			ps.setString(3, documentoNombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.archDocumento|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE ARCH_DOCUMENTO" +
				" SET DOCUMENTO_NOMBRE = ? " +									
				" WHERE ESCUELA_ID = ?" +
				" AND DOCUMENTO_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, documentoNombre);
			ps.setString(2, escuelaId);
			ps.setString(3, documentoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocumento|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM ARCH_DOCUMENTO" +
					" WHERE ESCUELA_ID = ? AND DOCUMENTO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, escuelaId);
			ps.setString(2, documentoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocumento|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId			= rs.getString("ESCUELA_ID");
		documentoId			= rs.getString("DOCUMENTO_ID");	
		documentoNombre		= rs.getString("DOCUMENTO_NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String escuelaId, String documentoId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT ESCUELA_ID, DOCUMENTO_ID, DOCUMENTO_NOMBRE " +
					" FROM ARCH_DOCUMENTO" +
					" WHERE ESCUELA_ID = ? AND DOCUMENTO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, escuelaId);
			ps.setString(2, documentoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocumento|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM ARCH_DOCUMENTO WHERE ESCUELA_ID = ? AND DOCUMENTO_ID = TO_NUMBER(?, '99')");
			ps.setString(1, escuelaId);
			ps.setString(2, documentoId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocumento|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn, String escuelaId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(DOCUMENTO_ID)+1,'1') AS MAXIMO FROM ARCH_DOCUMENTO WHERE ESCUELA_ID = '"+escuelaId+"' ");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocumento|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	public static String getNombreDoc(Connection conn, String documentoId, String escuelaId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "X";		
		
		try{
			ps = conn.prepareStatement("SELECT DOCUMENTO_NOMBRE FROM ARCH_DOCUMENTO WHERE DOCUMENTO_ID = TO_NUMBER(?, '99') AND ESCUELA_ID = ? ");
			ps.setString(1, documentoId);
			ps.setString(2, escuelaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("DOCUMENTO_NOMBRE");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.archivo.ArchDocumento|getNombreDoc|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}
}
