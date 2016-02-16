/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Jose Torres
 *
 */
public class CatPais {
	private String paisId;
	private String paisNombre;
	
	public CatPais(){
		paisId		= "";
		paisNombre	= "";
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
	 * @return Returns the paisNombre.
	 */
	public String getPaisNombre() {
		return paisNombre;
	}
	

	/**
	 * @param paisNombre The paisNombre to set.
	 */
	public void setPaisNombre(String paisNombre) {
		this.paisNombre = paisNombre;
	}
	
	
	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_PAIS" +
					" (PAIS_ID, PAIS_NOMBRE)" +
					" VALUES(TO_NUMBER(?, '999'), ?)");
			
			ps.setString(1, paisId);
			ps.setString(2, paisNombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatPais|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_PAIS" +
					" SET PAIS_NOMBRE = ?" +
					" WHERE PAIS_ID = TO_NUMBER(?, '999')");			
			ps.setString(1, paisNombre);
			ps.setString(2, paisId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatPais|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_PAIS" +
					" WHERE PAIS_ID = TO_NUMBER(?, '999')");
			ps.setString(1, paisId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatPais|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		paisId			= rs.getString("PAIS_ID");
		paisNombre		= rs.getString("PAIS_NOMBRE");
	}
	
	public void mapeaRegId(Connection con, String paisId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT PAIS_ID, PAIS_NOMBRE" +
					" FROM CAT_PAIS" +
					" WHERE PAIS_ID = TO_NUMBER(?, '999')");
			ps.setString(1, paisId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatPais|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_PAIS" +
					" WHERE PAIS_ID = TO_NUMBER(?, '999')");
			ps.setString(1, paisId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatPais|existeReg|:"+ex);
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
			ps = conn.prepareStatement("SELECT COALESCE(MAX(PAIS_ID)+1,'1') AS MAXIMO FROM CAT_PAIS");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatPais|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getPais(Connection Conn, String paisId) throws SQLException{
		
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String nombre		= "No encontro";	
		
		try{
			comando = "SELECT COALESCE(PAIS_NOMBRE,'vacio') FROM CAT_PAIS WHERE PAIS_ID = TO_NUMBER('"+paisId+"','999')";
			rs = st.executeQuery(comando);
			if (rs.next()){
				nombre = rs.getString(1);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatPais|getPais|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		return nombre;
	}
}
