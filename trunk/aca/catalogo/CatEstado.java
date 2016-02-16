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
public class CatEstado {
	private String paisId;
	private String estadoId;
	private String estadoNombre;
	private String clave;
	
	public CatEstado(){
		paisId			= "";
		estadoId		= "";
		estadoNombre	= "";
		clave 			= "";
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
	 * @return Returns the estadoNombre.
	 */
	public String getEstadoNombre() {
		return estadoNombre;
	}
	

	/**
	 * @param estadoNombre The estadoNombre to set.
	 */
	public void setEstadoNombre(String estadoNombre) {
		this.estadoNombre = estadoNombre;
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
	
		
	/**
	 * @return Returns the clave.
	 */
	public String getClave() {
		return clave;
	}
	

	/**
	 * @param clave The clave to set.
	 */
	public void setClave(String clave) {
		this.clave = clave;
	}
	

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_ESTADO" +
					"(PAIS_ID, ESTADO_ID, ESTADO_NOMBRE, CLAVE)" +
					" VALUES(TO_NUMBER(?, '999'), TO_NUMBER(?, '999'), ?, ?)");
			
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, estadoNombre);
			ps.setString(4, clave);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEstado|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_ESTADO" +
					" SET ESTADO_NOMBRE = ?, CLAVE = ?" +
					" WHERE ESTADO_ID = TO_NUMBER(?, '999')" +
					" AND PAIS_ID = TO_NUMBER(?, '999')");			
			ps.setString(1, estadoNombre);
			ps.setString(2, clave);
			ps.setString(3, estadoId);
			ps.setString(4, paisId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEstado|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_ESTADO" +
					" WHERE ESTADO_ID = TO_NUMBER(?, '999')" +
					" AND PAIS_ID = TO_NUMBER(?, '999')");
			ps.setString(1, estadoId);
			ps.setString(2, paisId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
					
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEstado|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		paisId			= rs.getString("PAIS_ID");
		estadoId		= rs.getString("ESTADO_ID");
		estadoNombre	= rs.getString("ESTADO_NOMBRE");
		clave			= rs.getString("CLAVE");
	}
	
	public void mapeaRegId(Connection con,  String paisId, String estadoId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT PAIS_ID, ESTADO_ID, ESTADO_NOMBRE, CLAVE" +
					" FROM CAT_ESTADO" +
					" WHERE PAIS_ID = TO_NUMBER(?, '999') " +
					" AND ESTADO_ID = TO_NUMBER(?, '999')");
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEstado|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_ESTADO" +
					" WHERE ESTADO_ID = TO_NUMBER(?, '999')" +
					" AND PAIS_ID = TO_NUMBER(?, '999')");
			ps.setString(1, estadoId);
			ps.setString(2, paisId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEstado|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String paisId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ESTADO_ID)+1,'1') AS MAXIMO " +
					"FROM CAT_ESTADO WHERE PAIS_ID = TO_NUMBER('"+paisId+"','999')");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEstado|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getEstado(Connection conn, String paisId, String estadoId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String estado			= "0";		
		
		try{
			ps = conn.prepareStatement("SELECT ESTADO_NOMBRE FROM CAT_ESTADO " +
					"WHERE PAIS_ID = TO_NUMBER(?,'999') AND ESTADO_ID = TO_NUMBER(?,'999') ");
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			rs= ps.executeQuery();		
			if(rs.next()){
				estado = rs.getString("ESTADO_NOMBRE");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getEstado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return estado;
	}
	
}
