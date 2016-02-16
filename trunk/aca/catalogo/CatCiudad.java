/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres
 *
 */
public class CatCiudad {
	private String paisId;
	private String estadoId;
	private String ciudadId;
	private String ciudadNombre;
	
	public CatCiudad(){
		paisId			= "";
		estadoId		= "";
		ciudadId		= "";
		ciudadNombre	= "";
	}

	/**
	 * @return Returns the ciudadId.
	 */
	public String getCiudadId() {
		return ciudadId;
	}
	

	/**
	 * @param ciudadId The ciudadId to set.
	 */
	public void setCiudadId(String ciudadId) {
		this.ciudadId = ciudadId;
	}
	

	/**
	 * @return Returns the ciudadNombre.
	 */
	public String getCiudadNombre() {
		return ciudadNombre;
	}
	

	/**
	 * @param ciudadNombre The ciudadNombre to set.
	 */
	public void setCiudadNombre(String ciudadNombre) {
		this.ciudadNombre = ciudadNombre;
	}
	

	/**
	 * @return Returns the estadoId.
	 */
	public String getEstadoId() {
		return estadoId;
	}
	

	/**
	 * @param estadoId The estadoId to set.
	 */
	public void setEstadoId(String estadoId) {
		this.estadoId = estadoId;
	}
	

	/**
	 * @return Returns the paisId.
	 */
	public String getPaisId() {
		return paisId;
	}
	

	/**
	 * @param paisId The paisId to set.
	 */
	public void setPaisId(String paisId) {
		this.paisId = paisId;
	}
	
	
	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			 ps = conn.prepareStatement("INSERT INTO CAT_CIUDAD" +
					" (PAIS_ID, ESTADO_ID, CIUDAD_ID, CIUDAD_NOMBRE)" +
					" VALUES(TO_NUMBER(?, '999'),TO_NUMBER(?, '999')," +
					" TO_NUMBER(?, '999'),? )");
			
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			ps.setString(4, ciudadNombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudad|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok   		 = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_CIUDAD" +
					" SET CIUDAD_NOMBRE = ?" +
					" WHERE PAIS_ID = TO_NUMBER(?, '999')" +
					" AND ESTADO_ID = TO_NUMBER(?, '999')" +
					" AND CIUDAD_ID = TO_NUMBER(?, '999')");			
			ps.setString(1, ciudadNombre);
			ps.setString(2, paisId);
			ps.setString(3, estadoId);
			ps.setString(4, ciudadId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudad|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			 ps = conn.prepareStatement("DELETE FROM CAT_CIUDAD" +
					" WHERE PAIS_ID = TO_NUMBER(?, '999')" +
					" AND ESTADO_ID = TO_NUMBER(?, '999')" +
					" AND CIUDAD_ID = TO_NUMBER(?, '999')");
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudad|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		paisId			= rs.getString("PAIS_ID");
		estadoId		= rs.getString("ESTADO_ID");
		ciudadId		= rs.getString("CIUDAD_ID");
		ciudadNombre	= rs.getString("CIUDAD_NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String paisId, String estadoId, String ciudadId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement("SELECT PAIS_ID, ESTADO_ID, CIUDAD_ID, CIUDAD_NOMBRE" +
					" FROM CAT_CIUDAD" +
					" WHERE PAIS_ID = TO_NUMBER(?, '999')" +
					" AND ESTADO_ID = TO_NUMBER(?, '999')" +
					" AND CIUDAD_ID = TO_NUMBER(?, '999')");
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudad|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_CIUDAD" +
					" WHERE PAIS_ID = TO_NUMBER(?, '999')" +
					" AND ESTADO_ID = TO_NUMBER(?, '999')" +
					" AND CIUDAD_ID = TO_NUMBER(?, '999')");
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudad|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String paisId, String estadoId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(CIUDAD_ID)+1,'1') AS MAXIMO " +
					"FROM CAT_CIUDAD " +
					"WHERE PAIS_ID = TO_NUMBER('"+paisId+"','999') " +
					"AND ESTADO_ID= TO_NUMBER('"+estadoId+"','999')");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudad|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getCiudad(Connection conn, String paisId, String estadoId, String ciudadId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String ciudad			= "0";		
		
		try{
			ps = conn.prepareStatement("SELECT CIUDAD_NOMBRE FROM CAT_CIUDAD" +
					" WHERE PAIS_ID = TO_NUMBER(?,'999')" +
					" AND ESTADO_ID = TO_NUMBER(?,'99')" +
					" AND CIUDAD_ID = TO_NUMBER(?,'999')");
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ciudad = rs.getString("CIUDAD_NOMBRE");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getCiudad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ciudad;
	}
	
}
