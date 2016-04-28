package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CatSeguro {
	
	private String escuelaId;
	private String year;
	private String poliza;
	
	public CatSeguro(){
		escuelaId	= "";
		year		= "";
		poliza		= "";
	}
	
		
	public String getEcuelaId() {
		return escuelaId;
	}

	public void setEscuela(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getPoliza() {
		return poliza;
	}

	public void setPoliza(String poliza) {
		this.poliza = poliza;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_SEGURO" +
					" (ESCUELA_ID, YEAR, POLIZA)" +
					" VALUES(?, TO_NUMBER(?, '9999'), ?)");
							
			ps.setString(1, escuelaId);
			ps.setString(2, year);
			ps.setString(3, poliza);			
						
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeguro|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_SEGURO" +
					" SET POLIZA = ? " +
					" WHERE ESCUELA_ID = ? AND YEAR = TO_NUMBER(?, '9999')");
			
			ps.setString(1, poliza);
			ps.setString(2, escuelaId);					
			ps.setString(3, year);
				
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeguro|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_SEGURO" +
					" WHERE ESCUELA_ID = ? AND YEAR = TO_NUMBER(?, '9999')");
			
			ps.setString(1, escuelaId);
			ps.setString(2, year);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeguro|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId	= rs.getString("ESCUELA_ID");
		year		= rs.getString("YEAR");
		poliza		= rs.getString("POLIZA");
	}
	
	public void mapeaRegId(Connection con) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT * " +
					" FROM CAT_SEGURO WHERE ESCUELA_ID = ?" +
					" AND YEAR = TO_NUMBER(?, '9999')");
			ps.setString(1, escuelaId);
			ps.setString(2, year);
			
			rs = ps.executeQuery();			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeguro|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_SEGURO WHERE ESCUELA_ID = ? AND YEAR = TO_NUMBER(?, '9999' )");
			ps.setString(1, escuelaId);
			ps.setString(2, year);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeguro|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static String getPoliza(Connection conn, String escuelaId, String year) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre 			= "X";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(POLIZA,'X') AS POLIZA FROM CAT_SEGURO"
					+ " WHERE ESCUELA_ID = ? AND YEAR = TO_NUMBER(?, '9999') ");
			ps.setString(1, escuelaId);
			ps.setString(2, year);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				nombre = rs.getString("POLIZA");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSeguro|getPoliza|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return nombre;
	}
	
	
}
