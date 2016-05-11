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
public class CatAspectos {
	
	private String escuelaId;
	private String aspectosId;
	private String nombre;
	private String orden;
	private String nivelId;
	private String area;
	
	public CatAspectos(){
		escuelaId	= "";
		aspectosId	= "";
		nombre		= "";
		orden 		= "";
		nivelId 	= "";
		area 		= "";
		
	}
	
	
	
	public String getEscuelaId() {
		return escuelaId;
	}



	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}



	public String getAspectosId() {
		return aspectosId;
	}


	public void setAspectosId(String aspectosId) {
		this.aspectosId = aspectosId;
	}


	public String getNombre() {
		return nombre;
	}


	public void setNombre(String nombre) {
		this.nombre = nombre;
	}


	public String getOrden() {
		return orden;
	}


	public void setOrden(String orden) {
		this.orden = orden;
	}


	public String getNivelId() {
		return nivelId;
	}


	public void setNivelId(String nivelId) {
		this.nivelId = nivelId;
	}


	public String getArea() {
		return area;
	}


	public void setArea(String area) {
		this.area = area;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_ASPECTOS" +
					" (ESCUELA_ID, ASPECTOS_ID, NOMBRE, ORDEN, NIVEL_ID, AREA_ID)" +
					" VALUES(?,TO_NUMBER(?, '999'), ?, TO_NUMBER(?,'99'), TO_NUMBER(?,'99'),TO_NUMBER(?,'99'))");
							
			ps.setString(1, escuelaId);
			ps.setString(2, aspectosId);
			ps.setString(3, nombre);			
			ps.setString(4, orden);
			ps.setString(5, nivelId);
			ps.setString(6, area);
						
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectos|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_ASPECTOS"
					+ " SET NOMBRE = ?, ORDEN = TO_NUMBER(?, '99'), NIVEL_ID = TO_NUMBER(?, '99'), AREA_ID = TO_NUMBER(?, '99')"
					+ " WHERE ESCUELA_ID = ?"
					+ " AND ASPECTOS_ID = TO_NUMBER(?, '999')");
			
			ps.setString(1, nombre);
			ps.setString(2, orden);
			ps.setString(3, nivelId);	
			ps.setString(4, area);
			ps.setString(5, escuelaId);
			ps.setString(6, aspectosId);
				
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectos|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_ASPECTOS"
					+ " WHERE ESCUELA_ID = ?"
					+ " AND ASPECTOS_ID = TO_NUMBER(?, '999')");
			ps.setString(1, escuelaId);
			ps.setString(2, aspectosId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectos|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId	= rs.getString("ESCUELA_ID");
		aspectosId	= rs.getString("ASPECTOS_ID");
		nombre	 	= rs.getString("NOMBRE");
		orden		= rs.getString("ORDEN");	
		nivelId		= rs.getString("NIVEL_ID");
		area 		= rs.getString("AREA_ID");
	}
	
	public void mapeaRegId(Connection con) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT ASPECTOS_ID, NOMBRE, ORDEN, NIVEL_ID, AREA_ID, ESCUELA_ID"
					+ " FROM CAT_ASPECTOS"
					+ " WHERE ESCUELA_ID = ?"
					+ " AND ASPECTOS_ID = TO_NUMBER(?, '999') ");
			ps.setString(1, escuelaId);
			ps.setString(2, aspectosId);
			
			rs = ps.executeQuery();			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectos|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_ASPECTOS"
					+ " WHERE ESCUELA_ID = ?"
					+ " AND ASPECTOS_ID = TO_NUMBER(?, '999')");
			ps.setString(1, escuelaId);
			ps.setString(2, aspectosId);
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectos|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn, String escuelaId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ASPECTOS_ID)+1,'1') AS MAXIMO"
					+ " FROM CAT_ASPECTOS"
					+ " WHERE ESCUELA_ID = ?");
			ps.setString(1, escuelaId);
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectos|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
}
