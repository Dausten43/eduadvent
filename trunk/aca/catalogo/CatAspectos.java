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
	private String aspectosId;
	private String nombre;
	private String orden;
	private String nivel;
	private String area;
	
	public CatAspectos(){
		aspectosId	= "";
		nombre		= "";
		orden 		= "";
		nivel 		= "";
		area 		= "";
		
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


	public String getNivel() {
		return nivel;
	}


	public void setNivel(String nivel) {
		this.nivel = nivel;
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
					" (ASPECTOS_ID, NOMBRE, ORDEN, NIVEL, AREA_ID)" +
					" VALUES(TO_NUMBER(?, '99'), ?, TO_NUMBER(?,'99'), TO_NUMBER(?,'99'),TO_NUMBER(?,'99'))");
							
			ps.setString(1, aspectosId);
			ps.setString(2, nombre);			
			ps.setString(3, orden);
			ps.setString(4, nivel);
			ps.setString(5, area);
						
			if ( ps.executeUpdate()== 1){
				ok = true;
				conn.commit();
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
			ps = conn.prepareStatement("UPDATE CAT_ASPECTOS" +
					" SET NOMBRE = ?, ORDER = TO_NUMBER(?, '99'), NIVEL = TO_NUMBER(?, '99'), AREA_ID = TO_NUMBER(?, '99') " +
					" WHERE ASPECTOS_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, nombre);
			ps.setString(2, orden);
			ps.setString(3, nivel);	
			ps.setString(4, area);
			ps.setString(5, aspectosId);
				
			if ( ps.executeUpdate()== 1){
				ok = true;
				conn.commit();
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
			ps = conn.prepareStatement("DELETE FROM CAT_ASPECTOS" +
					" WHERE ASPECTOS_ID = TO_NUMBER(?, '99')");
			ps.setString(1, aspectosId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
				conn.commit();
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
		aspectosId	= rs.getString("ASPECTOS_ID");
		nombre	 	= rs.getString("NOMBRE");
		orden		= rs.getString("ORDEN");	
		nivel		= rs.getString("NIVEL");
		area 		= rs.getString("AREA_ID");
	}
	
	public void mapeaRegId(Connection con) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT ASPECTOS_ID, NOMBRE, ORDEN, NIVEL, AREA_ID " +
					" FROM CAT_ASPECTOS WHERE ASPECTOS_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, aspectosId);
			
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
			ps = conn.prepareStatement("SELECT * FROM CAT_ASPECTOS WHERE ASPECTOS_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, aspectosId);
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
	
	public String maximoReg(Connection conn) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(ASPECTOS_ID)+1,'1') AS MAXIMO FROM CAT_ASPECTOS");
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
