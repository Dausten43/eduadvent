/**
 * 
 */
package aca.cond;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Elifo
 *
 */
public class CondTipoReporte {
	private String tipoId;
	private String tipoNombre;
	private String comentario;
	private String escuelaId;
	
	public CondTipoReporte(){
		tipoId		= "";
		tipoNombre	= "";
		comentario	= "";
		escuelaId	= "";
	}


	/**
	 * @return the tipoId
	 */
	public String getTipoId() {
		return tipoId;
	}


	/**
	 * @param tipoId the tipoId to set
	 */
	public void setTipoId(String tipoId) {
		this.tipoId = tipoId;
	}


	/**
	 * @return the tipoNombre
	 */
	public String getTipoNombre() {
		return tipoNombre;
	}


	/**
	 * @param tipoNombre the tipoNombre to set
	 */
	public void setTipoNombre(String tipoNombre) {
		this.tipoNombre = tipoNombre;
	}


	/**
	 * @return the comentario
	 */
	public String getComentario() {
		return comentario;
	}


	/**
	 * @param comentario the comentario to set
	 */
	public void setComentario(String comentario) {
		this.comentario = comentario;
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


	public boolean insertReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			ps = conn.prepareStatement("INSERT INTO COND_TIPOREPORTE" +
					" (TIPO_ID, TIPO_NOMBRE, COMENTARIO, ESCUELA_ID)" +
					" VALUES(TO_NUMBER(?,'9999999'),?,?,?)");
			
			ps.setString(1, tipoId);
			ps.setString(2, tipoNombre);
			ps.setString(3, comentario);
			ps.setString(4, escuelaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condTipoReporte|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{			
			ps = conn.prepareStatement("UPDATE COND_TIPOREPORTE" +
					" SET TIPO_NOMBRE = ?," +
					" COMENTARIO = ?" +
					" WHERE TIPO_ID = TO_NUMBER(?,'9999999')");
			
			ps.setString(1, tipoNombre);
			ps.setString(2, comentario);
			ps.setString(3, tipoId);
			
			if ( ps.executeUpdate()== 1){
				System.out.println("despues del execute");
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condTipoReporte|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		PreparedStatement ps = null;
		boolean ok = false;
		try{
			 ps = conn.prepareStatement("DELETE FROM COND_TIPOREPORTE" +
					" WHERE TIPO_ID = TO_NUMBER(?, '9999999')");
			ps.setString(1, tipoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}	
			
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condTipoReporte|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean existeReg(Connection conn) throws SQLException{
		boolean ok 			= false;
		ResultSet rs 			= null;
		PreparedStatement ps	= null;
		
		try{
			ps = conn.prepareStatement("SELECT * FROM COND_TIPOREPORTE" +
					" WHERE TIPO_ID = TO_NUMBER(?, '9999999')");
			ps.setString(1, tipoId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.cond.condTipoReporte|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		tipoId		= rs.getString("TIPO_ID");
		tipoNombre	= rs.getString("TIPO_NOMBRE");
		comentario	= rs.getString("COMENTARIO");
		escuelaId	= rs.getString("ESCUELA_ID");
	}
	
	public void mapeaRegId(Connection con, String tipoId) throws SQLException{
		PreparedStatement ps = null;
		ResultSet rs = null;		
		try{
			 ps = con.prepareStatement("SELECT TIPO_ID, TIPO_NOMBRE, COMENTARIO, ESCUELA_ID" +
					" FROM COND_TIPOREPORTE" +
					" WHERE TIPO_ID = TO_NUMBER(?,'9999999')");
					
			ps.setString(1, tipoId);			
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.cond.CondTipoReporte|mapeaRegId|:"+ex);
			ex.printStackTrace();
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
	}
	
public String maximoReg(Connection conn, String escuelaId) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String maximo 			= "1";
		
		try{
			ps = conn.prepareStatement("SELECT COALESCE(MAX(TIPO_ID)+1,'1') AS MAXIMO " +
					"FROM COND_TIPOREPORTE");
			rs= ps.executeQuery();		
			if(rs.next()){
				maximo = rs.getString("MAXIMO");
			}
		}catch(Exception ex){
			System.out.println("Error - aca.cond.CondTipoReporte|maximoReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		return maximo;
	}

	/*public static String getTipoReporte(Connection conn) throws SQLException {
	    
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		String tipoId			= "0";
	
	    try{
			ps = conn.prepareStatement("SELECT TIPO_ID FROM COND_TIPOREPORTE");
			
	        rs = ps.executeQuery();
	        if (rs.next()) {
				tipoId = rs.getString("TIPO_ID");
	        }
				
				
		} catch (Exception ex) {
			System.out.println("Error - aca.cond.CondTipoReporte|getTipoReporte|:" +ex);
	    }finally{
			if (rs != null) rs.close();
			if (ps != null) ps.close();
		}        
	
	    return tipoId;
	}*/
	
	public static String getTipoReporteNombre(Connection conn, String tipoId) throws SQLException {
	    
		PreparedStatement ps 	= null;
		ResultSet rs 			= null;
		String tipoNombre		= "0";
			
	    try{
			ps = conn.prepareStatement("SELECT TIPO_NOMBRE FROM COND_TIPOREPORTE WHERE TIPO_ID = TO_NUMBER('"+tipoId+"', '9999999') ");
			
	        rs = ps.executeQuery();
	        if (rs.next()) {
				tipoNombre = rs.getString("TIPO_NOMBRE");
	        }
				
				
		} catch (Exception ex) {
			System.out.println("Error - aca.cond.CondTipoReporte|getTipoReporteNombre|:" +ex);
	    }finally{
			if (rs != null) rs.close();
			if (ps != null) ps.close();
		}        
	
	    return tipoNombre;
	}
	
}
