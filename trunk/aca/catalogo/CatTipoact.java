package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatTipoact {
	
	private String unionId;
	private String tipoactId;
	private String tipoactNombre;
		
	public CatTipoact(){
		tipoactId		= "";
		tipoactNombre	= "";	
	}
	
	public String getUnionId() {
		return unionId;
	}

	public void setUnionId(String unionId) {
		this.unionId = unionId;
	}

	public String getTipoactId() {
		return tipoactId;
	}

	public void setTipoactId(String tipoactId) {
		this.tipoactId = tipoactId;
	}

	public String getTipoactNombre() {
		return tipoactNombre;
	}

	public void setTipoactNombre(String tipoactNombre) {
		this.tipoactNombre = tipoactNombre;
	}

	public boolean insertReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO "+
				"CAT_TIPOACT(UNION_ID, TIPOACT_ID, TIPOACT_NOMBRE) "+
				"VALUES( TO_NUMBER(?,'99'), TO_NUMBER(?,'99'), ? ) ");
			ps.setString(1, unionId);
			ps.setString(2, tipoactId);
			ps.setString(3, tipoactNombre);	
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoact|insertReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE CAT_TIPOACT "+ 
				"SET TIPOACT_NOMBRE = ? "+
				"WHERE UNION_ID = TO_NUMBER(?,'99') AND TIPOACT_ID = TO_NUMBER(?,'99')");
			ps.setString(1, tipoactNombre);
			ps.setString(2, unionId);
			ps.setString(3, tipoactId);
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoact|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_TIPOACT "+ 
				"WHERE UNION_ID = TO_NUMBER(?,'99') AND TIPOACT_ID = TO_NUMBER(?,'99')");
			ps.setString(1, unionId);
			ps.setString(2, tipoactId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoact|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		unionId 		= rs.getString("UNION_ID");
		tipoactId 		= rs.getString("TIPOACT_ID");
		tipoactNombre 	= rs.getString("TIPOACT_NOMBRE");		
	}
	
	public void mapeaRegId( Connection conn, String tipoactId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT UNION_ID, TIPOACT_ID, TIPOACT_NOMBRE"
					+ " FROM CAT_TIPOACT WHERE TIPOACT_ID = TO_NUMBER(?,'99')"); 
			ps.setString(1,tipoactId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoact|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean 		ok 	= false;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_TIPOACT WHERE UNION_ID = TO_NUMBER(?,'99') AND TIPOACT_ID = TO_NUMBER(?,'99')"); 
			ps.setString(1,tipoactId);
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoact|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String maximoReg(Connection conn) throws SQLException{
		String maximo 			= "1";
		ResultSet rs			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT MAX(TIPOACT_ID)+1 MAXIMO FROM CAT_TIPOACT WHERE UNION_ID = TO_NUMBER(?,'99')");
			ps.setString(1, unionId);
			
			rs = ps.executeQuery();
			if (rs.next())
				maximo = rs.getString("MAXIMO");
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoact|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return maximo;
	}
	
	public static String getTipoactNombre(Connection conn, String tipoactId) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String nombre			= "X";
		
		try{
			ps = conn.prepareStatement("SELECT TIPOACT_NOMBRE FROM CAT_TIPOACT WHERE "
			//		+ "--UNION_ID = TO_NUMBER(?,'99') AND "
					+ " AND TIPOACT_ID = TO_NUMBER(?, '99')"); 
			ps.setString(1, tipoactId);			
			rs = ps.executeQuery();
			if (rs.next())
				nombre = rs.getString("TIPOACT_NOMBRE");
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatTipoact|getTipoactNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombre;
	}
}