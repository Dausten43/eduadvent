package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatSeccion {
	private String seccionId;
	private String seccionNombre;
	private String tipo;
	private String unionId;
		
	public CatSeccion(){
		seccionId		= "";
		seccionNombre	= "";
		tipo			= "";
		unionId			= "";
	}
	
	public String getSeccionId() {
		return seccionId;
	}

	public void setSeccionId(String seccionId) {
		this.seccionId = seccionId;
	}

	public String getSeccionNombre() {
		return seccionNombre;
	}

	public void setSeccionNombre(String seccionNombre) {
		this.seccionNombre = seccionNombre;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	
	public String getUnionId() {
		return unionId;
	}

	public void setUnionId(String unionId) {
		this.unionId = unionId;
	}

	public boolean insertReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO "+
				"CAT_SECCION(SECCION_ID, SECCION_NOMBRE, TIPO, UNION_ID) "+
				"VALUES(?, ?, ?, TO_NUMBER(?, '99')) ");
			ps.setString(1, seccionId);
			ps.setString(2, seccionNombre);
			ps.setString(3, tipo);
			ps.setString(4, unionId);
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeccion|insertReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE CAT_SECCION "+ 
				"SET SECCION_NOMBRE = ?, "+
				" TIPO = ?" +
				"WHERE SECCION_ID = ? AND UNION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, seccionNombre);
			ps.setString(2, tipo);
			ps.setString(3, seccionId);
			ps.setString(4, unionId);
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeccion|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_SECCION "+ 
				"WHERE SECCION_ID = ? AND UNION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, seccionId);
			ps.setString(2, unionId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeccion|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		seccionId 		= rs.getString("SECCION_ID");
		seccionNombre 	= rs.getString("SECCION_NOMBRE");
		tipo			= rs.getString("TIPO");
		unionId			= rs.getString("UNION_ID");
	}
	
	public void mapeaRegId( Connection conn, String seccionId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT SECCION_ID, SECCION_NOMBRE, TIPO "+
				"FROM CAT_SECCION WHERE SECCION_ID = ? AND UNION_ID = TO_NUMBER(?, '99') "); 
			ps.setString(1,seccionId);
			ps.setString(2,unionId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeccion|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_SECCION WHERE SECCION_ID = ? AND UNION_ID = TO_NUMBER(?, '99')"); 
			ps.setString(1, seccionId);
			ps.setString(2, unionId);
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeccion|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
}