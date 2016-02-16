/**
 * 
 */
package aca.usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author elifo
 *
 */
public class UsuarioEscuela {
	private String codigoId;
	private String escuelaId;
	private String predeterminada;
	
	public UsuarioEscuela(){
		codigoId			= "";
		escuelaId		= "";
		predeterminada	= "";
	}
	
	/**
	 * @return the usuarioId
	 */
	public String getCodigoId() {
		return codigoId;
	}
	/**
	 * @param usuarioId the usuarioId to set
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
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
	 * @return the predeterminada
	 */
	public String getPredeterminada() {
		return predeterminada;
	}
	/**
	 * @param predeterminada the predeterminada to set
	 */
	public void setPredeterminada(String predeterminada) {
		this.predeterminada = predeterminada;
	}
	
	public boolean insertReg(Connection conn) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO USUARIO_ESCUELA" +
					"(CODIGO_ID, ESCUELA_ID, PREDETERMINADA)" +
					" VALUES(?,TO_NUMBER(?, '999'),?)");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			ps.setString(3, predeterminada);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioEscuela|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean updateReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE USUARIO_ESCUELA" +
					" SET PREDETERMINADA = ?" +
					" WHERE CODIGO_ID = ? " +
					" AND ESCUELA_ID = TO_NUMBER(?, '999')");			
			ps.setString(1, predeterminada);
			ps.setString(2, codigoId);
			ps.setString(3, escuelaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioEscuela|updateReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM USUARIO_ESCUELA" +
					" WHERE CODIGO_ID = ?" +
					" AND ESCUELA_ID = TO_NUMBER(?,'999')");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioEscuela|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		escuelaId		= rs.getString("ESCUELA_ID");
		predeterminada	= rs.getString("PREDETERMINADA");
	}
	
	public void mapeaRegId(Connection con, String codigoId, String escuelaId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, ESCUELA_ID, PREDETERMINADA" +
					" FROM USUARIO_ESCUELA" +
					" WHERE CODIGO_ID = ?" +
					" AND ESCUELA_ID = TO_NUMBER(?,'999')");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioEscuela|mapeaRegId|:"+ex);
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
			ps = conn.prepareStatement("SELECT * FROM USUARIO_ESCUELA" +
					" WHERE CODIGO_ID = ?" +
					" AND ESCUELA_ID = TO_NUMBER(?,'999')");
			
			ps.setString(1, codigoId);
			ps.setString(2, escuelaId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioEscuela|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public boolean cancelaPredeterminado(Connection conn, String codigoId) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("UPDATE USUARIO_ESCUELA" +
					" SET PREDETERMINADA = ?" +
					" WHERE CODIGO_ID = ?");
			
			ps.setString(1, "N");
			ps.setString(2, codigoId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioEscuela|cancelaPredeterminado|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public static String getUsuarioEscuela(Connection conn, String codigoId) throws SQLException{
	 		
 		PreparedStatement ps	= null;
 		ResultSet 		rs		= null;
 		String escuela	 		= "0";
 		
 		try{
 			ps = conn.prepareStatement("SELECT ESCUELA_ID FROM USUARIO_ESCUELA WHERE CODIGO_ID = '"+codigoId+"' AND PREDETERMINADA='S'");
 			
 		 	rs = ps.executeQuery(); 
 		 	if (rs.next()){ 			 
 				escuela = rs.getString("ESCUELA_ID");
 			}
 		}catch(Exception ex){
 			System.out.println("Error - aca.usuario.UsuarioEscuela|getUsuarioEscuela|:"+ex);
 		}finally{
 			if (rs!=null) rs.close();
 			if (ps!=null) ps.close();
 		}	
 		return escuela;
 	}
}
