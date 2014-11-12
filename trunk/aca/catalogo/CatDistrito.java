package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatDistrito {
	private String distritoId;
	private String distritoNombre;
	private String asociacionId;
	private String orgId;
		
	public CatDistrito(){
		distritoId			= "";
		distritoNombre		= "";
		asociacionId		= "";
		orgId				= "";
	}
	
	public String getDistritoId() {
		return distritoId;
	}

	public void setDistritoId(String distritoId) {
		this.distritoId = distritoId;
	}

	public String getDistritoNombre() {
		return distritoNombre;
	}

	public void setDistritoNombre(String distritoNombre) {
		this.distritoNombre = distritoNombre;
	}

	public String getAsociacionId() {
		return asociacionId;
	}

	public void setAsociacionId(String asociacionId) {
		this.asociacionId = asociacionId;
	}

	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public boolean insertReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO "+
				"CAT_DISTRITO(DISTRITO_ID, DISTRITO_NOMBRE, ASOCIACION_ID, ORG_ID) "+
				"VALUES(TO_NUMBER(?, '9999'), ?,TO_NUMBER(?, '999'), ?) ");
			ps.setString(1, distritoId);
			ps.setString(2, distritoNombre);
			ps.setString(3, asociacionId);
			ps.setString(4, orgId);
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatDistrito|insertReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE CAT_DISTRITO "+ 
				" SET DISTRITO_NOMBRE = ?, "+
				" ASOCIACION_ID = TO_NUMBER(?, '999')," +
				" ORG_ID = ?" +
				"WHERE DISTRITO_ID = TO_NUMBER(?, '9999') ");
			ps.setString(1, distritoNombre);
			ps.setString(2, asociacionId);
			ps.setString(3, orgId);
			ps.setString(4, distritoId);
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatDistrito|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_DISTRITO "+ 
				"WHERE DISTRITO_ID = TO_NUMBER(?, '9999') ");
			ps.setString(1, distritoId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatDistrito|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		distritoId 		= rs.getString("DISTRITO_ID");
		distritoNombre 	= rs.getString("DISTRITO_NOMBRE");
		asociacionId	= rs.getString("ASOCIACION_ID");
		orgId			= rs.getString("ORG_ID");
	}
	
	public void mapeaRegId( Connection conn, String distritoId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT DISTRITO_ID, DISTRITO_NOMBRE, ASOCIACION_ID, ORG_ID "+
				"FROM CAT_DISTRITO WHERE DISTRITO_ID = TO_NUMBER(?, '9999') "); 
			ps.setString(1,distritoId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatDistrito|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_DISTRITO WHERE DISTRITO_ID = TO_NUMBER(?, '9999')"); 
			ps.setString(1, distritoId);
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatDistrito|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
}