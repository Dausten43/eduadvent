/**
 * 
 */
package aca.catalogo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class CatHorarioCiclo {
	
	private String escuelaId;
	private String folio;
	private String ciclos;
	
	public CatHorarioCiclo(){
		escuelaId		= "";
		folio			= "";
		ciclos 			= "";
	}

	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getCiclos() {
		return ciclos;
	}

	public void setCiclos(String ciclos) {
		this.ciclos = ciclos;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_HORARIO_CICLO" +
					"( ESCUELA_ID,  FOLIO, CICLOS )" +
					" VALUES( ?, TO_NUMBER(?, '999'), ? )");
			
			ps.setString(1, escuelaId);
			ps.setString(2, folio);
			ps.setString(3, ciclos);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioCiclo|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_HORARIO_CICLO" +
					" SET CICLOS = ? " +
					" WHERE ESCUELA_ID = ?"
					+ " AND FOLIO = TO_NUMBER(?, '999') ");			
			
			ps.setString(1, ciclos);
			ps.setString(2, escuelaId);
			ps.setString(3, folio);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioCiclo|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_HORARIO_CICLO" +
					" WHERE ESCUELA_ID = ? AND FOLIO = TO_NUMBER(?, '999') ");
			
			ps.setString(1, escuelaId);
			ps.setString(2, folio);
			
			if ( ps.executeUpdate() == 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioCiclo|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId		= rs.getString("ESCUELA_ID");
		folio 			= rs.getString("FOLIO");
		ciclos			= rs.getString("CICLOS");
	}
	
	public void mapeaRegId(Connection con, String escuelaId, String folio) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;		
		try{
			ps = con.prepareStatement("SELECT ESCUELA_ID, FOLIO," +
					" CICLOS " +
					" FROM CAT_HORARIO_CICLO" +
					" WHERE ESCUELA_ID = ? AND FOLIO = TO_NUMBER(?, '999') ");
			
			ps.setString(1, escuelaId);
			ps.setString(2, folio);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioCiclo|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_HORARIO_CICLO" +
					" WHERE ESCUELA_ID = ? AND FOLIO = TO_NUMBER(?,'999') " );
			
			ps.setString(1, escuelaId);
			ps.setString(1, folio);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioCiclo|existeReg|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public boolean existeCiclo(Connection conn,String escuelaId, String folio) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM CAT_HORARIO_CICLO" +
					" WHERE ESCUELA_ID = '"+escuelaId+"' AND FOLIO = TO_NUMBER('"+folio+"', '999') " );
			
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatHorarioCiclo|existeCiclo|:"+ex);
		}
		if (rs!=null) rs.close();
		if (ps!=null) ps.close();
		
		return ok;
	}
	
	public String maximoReg(Connection conn, String escuelaId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(FOLIO)+1,1) AS MAXIMO FROM CAT_HORARIO_CICLO WHERE ESCUELA_ID = '"+escuelaId+"' ");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.cat.CatHorarioCiclo|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
}
