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
public class CatClasFin {
	private String clasfinId;
	private String clasfinNombre;
	private String escuelaId;
	private String estado;
	
	public CatClasFin(){
		clasfinId			= "";
		clasfinNombre		= "";					
		escuelaId			= "";
		estado 				= "";		
	}

	/**
	 * @return the clasfinId
	 */
	public String getClasfinId() {
		return clasfinId;
	}

	/**
	 * @param clasfinId the clasfinId to set
	 */
	public void setClasfinId(String clasfinId) {
		this.clasfinId = clasfinId;
	}

	/**
	 * @return the clasfinNombre
	 */
	public String getClasfinNombre() {
		return clasfinNombre;
	}

	/**
	 * @param clasfinNombre the clasfinNombre to set
	 */
	public void setClasfinNombre(String clasfinNombre) {
		this.clasfinNombre = clasfinNombre;
	}	

	/**
	 * @return the escuelaId
	 */
	public String getEscuelaId() {
		return escuelaId;
	}

	/**
	 * @param escuelaId the escuelaId to set
	 */
	public void setEscuelaId(String escuelaId) {
		this.escuelaId = escuelaId;
	}

	/**
	 * @return the estado
	 */
	public String getEstado() {
		return estado;
	}

	/**
	 * @param estado the estado to set
	 */
	public void setEstado(String estado) {
		this.estado = estado;
	}

	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO CAT_CLASFIN " +
					"(CLASFIN_ID, CLASFIN_NOMBRE, ESCUELA_ID, ESTADO ) VALUES(TO_NUMBER(?,'99'), ?, ?, ?)");
			
			ps.setString(1, clasfinId);			
			ps.setString(2, clasfinNombre);		
			ps.setString(3, escuelaId);			
			ps.setString(4, estado);	
			
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatClasfin|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("UPDATE CAT_CLASFIN" +
					" SET CLASFIN_NOMBRE = ?, ESTADO = ? " +
					" WHERE ESCUELA_ID = ? AND CLASFIN_ID = TO_NUMBER(?,'99')");
			ps.setString(1, clasfinNombre);
			ps.setString(2, estado);
			ps.setString(3, escuelaId);
			ps.setString(4, clasfinId);		
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatClasfin|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("DELETE FROM CAT_CLASFIN" +
					" WHERE ESCUELA_ID =? AND CLASFIN_ID = TO_NUMBER(?,'99')");
			
			ps.setString(1, escuelaId);
			ps.setString(2, clasfinId);			
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatClasfin|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		clasfinId				= rs.getString("CLASFIN_ID");
		clasfinNombre			= rs.getString("CLASFIN_NOMBRE");
		escuelaId				= rs.getString("ESCUELA_ID");
		estado					= rs.getString("ESTADO");		
	}
	
	public void mapeaRegId(Connection con, String escuelaId, String clasificacionId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps = con.prepareStatement("SELECT CLASFIN_ID, CLASFIN_NOMBRE, ESCUELA_ID, ESTADO FROM CAT_CLASFIN " +
					" WHERE ESCUELA_ID = ? AND CLASFIN_ID = TO_NUMBER(?,'99')");
			
			ps.setString(1, escuelaId);
			ps.setString(2, clasificacionId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatClasFin|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM CAT_CLASFIN WHERE ESCUELA_ID = ? AND CLASFIN_ID = TO_NUMBER(?, '99') ");
			ps.setString(1, escuelaId);
			ps.setString(2, clasfinId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatClasfin|existeReg|:"+ex);
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
			ps = conn.prepareStatement("SELECT COALESCE(MAX(CLASFIN_ID)+1,'1') AS MAXIMO FROM CAT_CLASFIN WHERE ESCUELA_ID = '"+escuelaId+"' ");			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatClasfin|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}
	
	public static String getClasFinNombre(Connection conn, String escuelaId, String clasFinId ) throws SQLException{
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String nombre			= "";
		
		try{
			ps = conn.prepareStatement("SELECT CLASFIN_NOMBRE FROM CAT_CLASFIN WHERE ESCUELA_ID = ? AND CLASFIN_ID = TO_NUMBER(?, '99') ");			
			ps.setString(1, escuelaId);
			ps.setString(2, clasFinId);
						
			rs= ps.executeQuery();
			if(rs.next()){
				nombre = rs.getString("CLASFIN_NOMBRE");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatClasfin|getClasFinNombre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return nombre;
	}
	
}
