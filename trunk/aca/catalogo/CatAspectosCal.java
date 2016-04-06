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
public class CatAspectosCal {
	
	private String escuelaId;
	private String nivelId;
	private String calId;
	private String calNombre;
	private String calCorto;
	
	public CatAspectosCal(){
		escuelaId	= "";
		nivelId		= "";
		calId		= "";
		calNombre 	= "";
		calCorto	= "";		
	}
	
	public String getEscuelaId() {
		return escuelaId;
	}

	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	public String getNivelId() {
		return nivelId;
	}

	public void setNivelId(String nivelId) {
		this.nivelId = nivelId;
	}

	public String getCalId() {
		return calId;
	}

	public void setCalId(String calId) {
		this.calId = calId;
	}

	public String getCalNombre() {
		return calNombre;
	}

	public void setCalNombre(String calNombre) {
		this.calNombre = calNombre;
	}

	public String getCalCorto() {
		return calCorto;
	}

	public void setCalCorto(String calCorto) {
		this.calCorto = calCorto;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_ASPECTOS_CAL" +
					" (ESCUELA_ID, NIVEL_ID, CAL_ID, CAL_NOMBRE, CAL_CORTO)" +
					" VALUES( ?, TO_NUMBER(?, '99'), TO_NUMBER(?, '99'), ?, ?)");
							
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, calId);
			ps.setString(4, calNombre);			
			ps.setString(5, calCorto);			
						
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosCal|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		
		try{
			ps = conn.prepareStatement("UPDATE CAT_ASPECTOS_CAL"
					+ " SET CAL_NOMBRE = ?, CAL_CORTO = ? "
					+ " WHERE ESCUELA_ID = ?"
					+ " AND NIVEL_ID = TO_NUMBER(?, '99')"
					+ " AND CAL_ID = TO_NUMBER(?, '99')");
			
			ps.setString(1, calNombre);
			ps.setString(2, calCorto);
			ps.setString(3, escuelaId);	
			ps.setString(4, nivelId);
			ps.setString(5, calId);			
				
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosCal|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_ASPECTOS_CAL"
					+ " WHERE ESCUELA_ID = ?"
					+ " AND NIVEL_ID = TO_NUMBER(?,'99')"
					+ " AND CAL_ID = TO_NUMBER(?, '99')");
			ps.setString(1, escuelaId);			
			ps.setString(2, nivelId);
			ps.setString(3, calId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosCal|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		escuelaId	= rs.getString("ESCUELA_ID");
		nivelId		= rs.getString("NIVEL_ID");
		calId		= rs.getString("CAL_ID");
		calNombre	= rs.getString("CAL_NOMBRE");
		calCorto	= rs.getString("CAL_CORTO");
		
	}
	
	public void mapeaRegId(Connection con) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT ESCUELA_ID, NIVEL_ID, CAL_ID, CAL_NOMBRE, CAL_CORTO"
					+ " FROM CAT_ASPECTOS_CAL"
					+ " WHERE ESCUELA_ID = ?"
					+ " AND NIVEL_ID = TO_NUMBER(?, '99')"
					+ " AND CAL_ID = TO_NUMBER(?,'99')");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, calId);
			
			rs = ps.executeQuery();			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosCal|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_ASPECTOS_CAL"
					+ " WHERE ESCUELA_ID = ?"
					+ " AND NIVEL_ID = TO_NUMBER(?, '99')"
					+ " AND CAL_ID = TO_NUMBER(?,'99')");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, calId);			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosCal|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public String maximoReg(Connection conn, String escuelaId, String nivelId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(CAL_ID)+1,'1') AS MAXIMO"
					+ " FROM CAT_ASPECTOS_CAL"
					+ " WHERE ESCUELA_ID = ?"
					+ " AND NIVEL_ID = TO_NUMBER(?,'99')");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosCal|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getCalCorto(Connection conn, String escuelaId, String nivelId, String calId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String corto 			= "-";
		
		try{
			ps = conn.prepareStatement("SELECT CAL_CORTO FROM CAT_ASPECTOS_CAL"
					+ " WHERE ESCUELA_ID = ?"
					+ " AND NIVEL_ID = TO_NUMBER(?,'99')"
					+ " AND CAL_ID = TO_NUMBER(?,'99')");
			ps.setString(1, escuelaId);
			ps.setString(2, nivelId);
			ps.setString(3, calId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				corto = rs.getString("CAL_CORTO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosCal|getCalCorto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return corto;
	}
}
