package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatModalidad {
	private String modalidadId;
	private String modalidadNombre;
	
	public CatModalidad(){
		modalidadId		= "";
		modalidadNombre	= "";
	}
	
	

	/**
	 * @return the modalidadId
	 */
	public String getModalidadId() {
		return modalidadId;
	}



	/**
	 * @param modalidadId the modalidadId to set
	 */
	public void setModalidadId(String modalidadId) {
		this.modalidadId = modalidadId;
	}



	/**
	 * @return the modalidadNombre
	 */
	public String getModalidadNombre() {
		return modalidadNombre;
	}



	/**
	 * @param modalidadNombre the modalidadNombre to set
	 */
	public void setModalidadNombre(String modalidadNombre) {
		this.modalidadNombre = modalidadNombre;
	}


	
	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_MODALIDAD" +
					" (MODALIDAD_ID, MODALIDAD_NOMBRE)" +
					" VALUES(TO_NUMBER(?, '99'),?)");
			
			ps.setString(1, modalidadId);
			ps.setString(2, modalidadNombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatModalidad|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{			
			ps = conn.prepareStatement("UPDATE CAT_MODALIDAD" +
					" SET MODALIDAD_NOMBRE = ? WHERE MODALIDAD_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, modalidadNombre);			
			ps.setString(2, modalidadId);						
			if ( ps.executeUpdate()== 1){			
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatModalidad|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{			
			ps = conn.prepareStatement("DELETE FROM CAT_MODALIDAD" +
					" WHERE MODALIDAD_ID = TO_NUMBER(?, '99')");			
			ps.setString(1,modalidadId);					
			if ( ps.executeUpdate()== 1){			
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatModalidad|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		modalidadId			= rs.getString("MODALIDAD_ID");
		modalidadNombre		= rs.getString("MODALIDAD_NOMBRE");		
	}
	
	public void mapeaRegId(Connection con, String modalidadId) throws SQLException{
		PreparedStatement ps =null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT MODALIDAD_ID, MODALIDAD_NOMBRE FROM CAT_MODALIDAD" +
					" WHERE MODALIDAD_ID = TO_NUMBER(?, '99')");
			ps.setString(1, modalidadId);			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatModalidad|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_MODALIDAD" +
					" WHERE MODALIDAD_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, modalidadId);			
			rs= ps.executeQuery();					
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatModalidad|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(MODALIDAD_ID)+1,'1') AS MAXIMO " +
					"FROM CAT_MODALIDAD");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatModalidad|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}

}
