package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatRegion {
	private String paisId;
	private String regionId;
	private String regionNombre;
		
	public CatRegion(){
		paisId			= "";
		regionId 		= "";
		regionNombre	= "";
	}

	public String getPaisId() {
		return paisId;
	}

	public void setPaisId(String paisId) {
		this.paisId = paisId;
	}

	public String getRegionId() {
		return regionId;
	}

	public void setRegionId(String regionId) {
		this.regionId = regionId;
	}

	public String getRegionNombre() {
		return regionNombre;
	}

	public void setRegionNombre(String regionNombre) {
		this.regionNombre = regionNombre;
	}


	public boolean insertReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO "+
				"CAT_REGION(PAIS_ID, REGION_ID, REGION_NOMBRE) "+
				"VALUES(TO_NUMBER(?, '999'), TO_NUMBER(?, '99'), ?) ");
			ps.setString(1, paisId);
			ps.setString(2, regionId);
			ps.setString(3, regionNombre);
			
			if (ps.executeUpdate()== 1)
				ok = true;				
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegion|insertReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}	
	
	public boolean updateReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE CAT_REGION "+ 
				" SET REGION_NOMBRE = ? "+
				"WHERE PAIS_ID = TO_NUMBER(?, '999') AND REGION_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, regionNombre);
			ps.setString(2, paisId);
			ps.setString(3, regionId);
			
			
			if (ps.executeUpdate()== 1)
				ok = true;	
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegion|updateReg|:"+ex);		
		}finally{
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	
	public boolean deleteReg(Connection conn ) throws Exception{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_REGION "+ 
				"WHERE PAIS_ID = TO_NUMBER(?, '999') AND REGION_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, paisId);
			ps.setString(2, regionId);
			
			if (ps.executeUpdate()== 1)
				ok = true;
			else
				ok = false;
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegion|deleteReg|:"+ex);			
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		paisId 			= rs.getString("PAIS_ID");
		regionId 		= rs.getString("REGION_ID");
		regionNombre	= rs.getString("REGION_NOMBRE");
	}
	
	public void mapeaRegId( Connection conn, String distritoId) throws SQLException{
		ResultSet rs = null;
		PreparedStatement ps = null; 
		try{
			ps = conn.prepareStatement("SELECT PAIS_ID, REGION_ID, REGION_NOMBRE  "+
				"FROM CAT_REGION WHERE PAIS_ID = TO_NUMBER(?, '999') AND REGION_ID = TO_NUMBER(?, '99') "); 
			ps.setString(1,paisId);
			ps.setString(2,regionId);
			
			rs = ps.executeQuery();
			if (rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegion|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_REGION WHERE PAIS_ID = TO_NUMBER(?, '999') AND REGION_ID = TO_NUMBER(?, '99')"); 
			ps.setString(1,paisId);
			ps.setString(2,regionId);
			
			rs = ps.executeQuery();
			if (rs.next())
				ok = true;
			else
				ok = false;
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegion|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String paisId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(REGION_ID)+1,'1') AS MAXIMO " +
					"FROM CAT_REGION WHERE PAIS_ID = TO_NUMBER('"+paisId+"','999')");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegion|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
}