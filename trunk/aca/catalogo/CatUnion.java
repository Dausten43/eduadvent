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
public class CatUnion {
	private String unionId;
	private String unionNombre;
	private String credencial;
	private String letra;
	
	public CatUnion(){
		unionId				= "";
		unionNombre			= "";
		credencial 			= ""; 
		letra 	 			= ""; 
	}

	public String getUnionId() {
		return unionId;
	}


	public void setUnionId(String unionId) {
		this.unionId = unionId;
	}


	public String getUnionNombre() {
		return unionNombre;
	}


	public void setUnionNombre(String unionNombre) {
		this.unionNombre = unionNombre;
	}


	public String getCredencial() {
		return credencial;
	}

	public void setCredencial(String credencial) {
		this.credencial = credencial;
	}

	

	public String getLetra() {
		return letra;
	}

	public void setLetra(String letra) {
		this.letra = letra;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_UNION" +
					" (UNION_ID, UNION_NOMBRE, CREDENCIAL, LETRA)" +
					" VALUES(TO_NUMBER(?, '99'), ?, ?)");
			
			ps.setString(1, unionId);
			ps.setString(2, unionNombre);
			ps.setString(3, credencial);
			ps.setString(4, letra);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnion|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_UNION" +
					" SET UNION_NOMBRE = ?, CREDENCIAL = ?, LETRA = ?" +
					" WHERE UNION_ID = TO_NUMBER(?, '99') ");			
			ps.setString(1, unionNombre);
			ps.setString(2, credencial);
			ps.setString(3, letra);
			ps.setString(4, unionId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.Union|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_UNION" +
					" WHERE UNION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, unionId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnion|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		unionId				= rs.getString("UNION_ID");
		unionNombre			= rs.getString("UNION_NOMBRE");
		credencial			= rs.getString("CREDENCIAL");	
		letra				= rs.getString("LETRA");	
	}
	
	public void mapeaRegId(Connection con, String unionId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT UNION_ID, UNION_NOMBRE, CREDENCIAL, LETRA " +
					" FROM CAT_UNION WHERE UNION_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, unionId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnion|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 				= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_UNION WHERE UNION_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, unionId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnion|existeReg|:"+ex);
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
			ps = conn.prepareStatement("SELECT COALESCE(MAX(UNION_ID)+1,'1') AS MAXIMO FROM CAT_UNION");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnion|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getNombre(Connection conn, String unionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "X";		
		
		try{
			ps = conn.prepareStatement("SELECT UNION_NOMBRE FROM CAT_UNION WHERE UNION_ID = TO_NUMBER(?,'99') ");
			ps.setString(1, unionId);
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("UNION_NOMBRE");
			}			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnion|getNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return nombre;
	}	
	
}
