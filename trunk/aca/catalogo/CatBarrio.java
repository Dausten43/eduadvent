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
public class CatBarrio {
	private String paisId;
	private String estadoId;
	private String ciudadId;
	private String barrioId;
	private String barrioNombre;
	
	public CatBarrio(){
		paisId			= "";
		estadoId		= "";
		ciudadId		= "";
		barrioId		= "";
		barrioNombre	= "";
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
	
	public String getBarrioId() {
		return barrioId;
	}

	public void setBarrioId(String barrioId) {
		this.barrioId = barrioId;
	}

	public String getBarrioNombre() {
		return barrioNombre;
	}

	public void setBarrioNombre(String barrioNombre) {
		this.barrioNombre = barrioNombre;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			 ps = conn.prepareStatement("INSERT INTO CAT_BARRIO" +
					" (PAIS_ID, ESTADO_ID, CIUDAD_ID, BARRIO_ID, BARRIO_NOMBRE)" +
					" VALUES(TO_NUMBER(?, '999'),TO_NUMBER(?, '999')," +
					" TO_NUMBER(?, '999'),TO_NUMBER(?, '999'), ? )");
			
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			ps.setString(4, barrioId);
			ps.setString(5, barrioNombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatBarrio|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok   		 = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_BARRIO"
					+ " SET BARRIO_NOMBRE = ?"
					+ " WHERE PAIS_ID = TO_NUMBER(?, '999')"
					+ " AND ESTADO_ID = TO_NUMBER(?, '999')"
					+ " AND CIUDAD_ID = TO_NUMBER(?, '999')"
					+ " AND BARRIO_ID = TO_NUMBER(?, '999')");
			ps.setString(1, barrioNombre);
			ps.setString(2, paisId);
			ps.setString(3, estadoId);
			ps.setString(4, ciudadId);
			ps.setString(5, barrioId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatBarrio|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			 ps = conn.prepareStatement("DELETE FROM CAT_BARRIO"
			 		+ " WHERE PAIS_ID = TO_NUMBER(?, '999')"
			 		+ " AND ESTADO_ID = TO_NUMBER(?, '999')"
			 		+ " AND CIUDAD_ID = TO_NUMBER(?, '999')"
			 		+ " AND BARRIO_ID = TO_NUMBER(?, '999')");
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			ps.setString(4, barrioId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatBarrio|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		paisId			= rs.getString("PAIS_ID");
		estadoId		= rs.getString("ESTADO_ID");
		ciudadId		= rs.getString("CIUDAD_ID");
		barrioId		= rs.getString("BARRIO_ID");
		barrioNombre	= rs.getString("BARRIO_NOMBRE");		
	}
	
	public void mapeaRegId(Connection con, String paisId, String estadoId, String ciudadId, String barrioId ) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement("SELECT PAIS_ID, ESTADO_ID, CIUDAD_ID, BARRIO_ID, BARRIO_NOMBRE"
					+ " FROM CAT_BARRIO"
					+ " WHERE PAIS_ID = TO_NUMBER(?, '999')"
					+ " AND ESTADO_ID = TO_NUMBER(?, '999')"
					+ " AND CIUDAD_ID = TO_NUMBER(?, '999')"
					+ " AND BARRIO_ID = TO_NUMBER(?, '999')");
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			ps.setString(4, barrioId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatBarrio|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_BARRIO"
					+ " WHERE PAIS_ID = TO_NUMBER(?, '999')"
					+ " AND ESTADO_ID = TO_NUMBER(?, '999')"
					+ " AND CIUDAD_ID = TO_NUMBER(?, '999')"
					+ " AND BARRIO_ID = TO_NUMBER(?, '999')");
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			ps.setString(4, barrioId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatBarrio|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String paisId, String estadoId, String ciudadId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps	= conn.prepareStatement("SELECT COALESCE(MAX(BARRIO_ID)+1,'1') AS MAXIMO"
					+ " FROM CAT_BARRIO"
					+ " WHERE PAIS_ID = TO_NUMBER('"+paisId+"','999')"
					+ " AND ESTADO_ID = TO_NUMBER('"+estadoId+"','999')"
					+ " AND CIUDAD_ID = TO_NUMBER('"+ciudadId+"','999')");
			rs 	= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatBarrio|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getBarrio(Connection conn, String paisId, String estadoId, String ciudadId, String barrioId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String barrio			= "0";		
		
		try{
			ps = conn.prepareStatement("SELECT BARRIO_NOMBRE FROM CAT_BARRIO"
					+ " WHERE PAIS_ID = TO_NUMBER(?,'999')"
					+ " AND ESTADO_ID = TO_NUMBER(?,'99')"
					+ " AND CIUDAD_ID = TO_NUMBER(?,'999')"
					+ " AND BARRIO_ID = TO_NUMBER(?,'999')");
			ps.setString(1, paisId);
			ps.setString(2, estadoId);
			ps.setString(3, ciudadId);
			ps.setString(4, barrioId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				barrio = rs.getString("BARRIO_NOMBRE");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEscuela|getBarrio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return barrio;
	}
	
}
