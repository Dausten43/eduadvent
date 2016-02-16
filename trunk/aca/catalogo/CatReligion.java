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
public class CatReligion {
	private String religionId;
	private String religionNombre;	
	
	public CatReligion(){
		religionId		= "";
		religionNombre	= "";		
	}

	public String getReligionId() {
		return religionId;
	}



	public void setReligionId(String religionId) {
		this.religionId = religionId;
	}



	public String getReligionNombre() {
		return religionNombre;
	}



	public void setReligionNombre(String religionNombre) {
		this.religionNombre = religionNombre;
	}



	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_RELIGION" +
					" (RELIGION_ID, RELIGION_NOMBRE)" +
					" VALUES(TO_NUMBER(?, '99'),?)");
			
			ps.setString(1, religionId);
			ps.setString(2, religionNombre);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{			
			ps = conn.prepareStatement("UPDATE CAT_RELIGION" +
					" SET RELIGION_NOMBRE = ? WHERE RELIGION_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, religionNombre);			
			ps.setString(2, religionId);						
			if ( ps.executeUpdate()== 1){			
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{			
			ps = conn.prepareStatement("DELETE FROM CAT_RELIGION" +
					" WHERE RELIGION_ID = TO_NUMBER(?, '99')");			
			ps.setString(1,religionId);					
			if ( ps.executeUpdate()== 1){			
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		religionId			= rs.getString("RELIGION_ID");
		religionNombre		= rs.getString("RELIGION_NOMBRE");		
	}
	
	public void mapeaRegId(Connection con, String religionId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT RELIGION_ID, RELIGION_NOMBRE FROM CAT_RELIGION" +
					" WHERE RELIGION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, religionId);			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_RELIGION" +
					" WHERE RELIGION_ID = TO_NUMBER(?, '99')");			
			ps.setString(1, religionId);			
			rs= ps.executeQuery();					
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|existeReg|:"+ex);
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
			ps = conn.prepareStatement("SELECT COALESCE(MAX(RELIGION_ID)+1,'1') AS MAXIMO " +
					"FROM CAT_RELIGION");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	
	public static String getReligionNombre(Connection conn, String religionId) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "x";
		
		try{
			ps = conn.prepareStatement("SELECT RELIGION_NOMBRE FROM CAT_RELIGION " +
					"WHERE RELIGION_ID = TO_NUMBER(?, '99')");
			ps.setString(1, religionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("RELIGION_NOMBRE");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligion|getReligionNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return nombre;
	}
}
