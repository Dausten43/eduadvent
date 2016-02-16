/**
 * 
 */
package aca.usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author Jose Torres
 *
 */
public class UsuarioMenu {
	
	private String codigoId;
	private String opcionId;
	
	public UsuarioMenu(){
		codigoId		= "";
		opcionId		= "";		
	}
		

	/**
	 * @return Returns the codigoId.
	 */
	public String getCodigoId() {
		return codigoId;
	}
	

	/**
	 * @param codigoId The codigoId to set.
	 */
	public void setCodigoId(String codigoId) {
		this.codigoId = codigoId;
	}
		

	/**
	 * @return Returns the opcionId.
	 */
	public String getOpcionId() {
		return opcionId;
	}
	

	/**
	 * @param opcionId The opcionId to set.
	 */
	public void setOpcionId(String opcionId) {
		this.opcionId = opcionId;
	}


	public boolean insertReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("INSERT INTO USUARIO_MENU" +
					"(CODIGO_ID, OPCION_ID)" +
					" VALUES(?,TO_NUMBER(?, '999'))");
			
			ps.setString(1, codigoId);
			ps.setString(2, opcionId);		
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioMenu|insertReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM USUARIO_MENU " +
					"WHERE CODIGO_ID = ? AND OPCION_ID = TO_NUMBER(?,'999')");
			ps.setString(1, codigoId);
			ps.setString(2, opcionId);
			
			if ( ps.executeUpdate()== 1){
				ok = true;				
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioMenu|deleteReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public boolean deleteAllReg(Connection conn ) throws SQLException{
		boolean ok = false;
		PreparedStatement ps = null;
		try{
			ps = conn.prepareStatement("DELETE FROM USUARIO_MENU " +
					"WHERE CODIGO_ID = ?");
			ps.setString(1, codigoId);
			
			if ( ps.executeUpdate()!= -1){
				ok = true;
			}else{
				ok = false;
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioMenu|deleteAllReg|:"+ex);
		}finally{
			if (ps!=null) ps.close();
		}
		return ok;
	}
	
	public void mapeaReg(ResultSet rs ) throws SQLException{
		codigoId		= rs.getString("CODIGO_ID");
		opcionId		= rs.getString("OPCION_ID");		
	}
	
	public void mapeaRegId(Connection con, String codigoId, String opcionId) throws SQLException{
		
		ResultSet rs = null;		
		PreparedStatement ps = null; 
		try{
			ps = con.prepareStatement("SELECT CODIGO_ID, OPCION_ID" +
					" FROM USUARIO_MENU WHERE CODIGO_ID = ? AND OPCION_ID = TO_NUMBER(?,'999')");
			ps.setString(1, codigoId);
			ps.setString(2, opcionId);
			
			rs = ps.executeQuery();
			
			if(rs.next()){
				mapeaReg(rs);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioMenu|mapeaRegId|:"+ex);
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
			//System.out.println("SELECT * FROM USUARIO_MENU WHERE CODIGO_ID = '"+codigoId+"' AND OPCION_ID = TO_NUMBER('"+opcionId+"','999')");
			ps = conn.prepareStatement("SELECT * FROM USUARIO_MENU WHERE CODIGO_ID = ? AND OPCION_ID = TO_NUMBER(?,'999')");
			ps.setString(1, codigoId);
			ps.setString(2, opcionId);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				ok = true;
			}else{
				ok = false;
			}
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioMenu|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return ok;
	}
	
	public static String getUsuarioOpcion(Connection conn, String codigoId) throws SQLException{
				
		PreparedStatement ps	= null;
		ResultSet rs 			= null;
		String opciones			= "";
		
		try{
			ps = conn.prepareStatement("SELECT OPCION_ID FROM USUARIO_MENU WHERE CODIGO_ID = ? AND OPCION_ID IN (SELECT OPCION_ID FROM MODULO_OPCION WHERE ESTADO = 'A' )");
			ps.setString(1, codigoId);
						
			rs= ps.executeQuery();		
			while(rs.next()){
				opciones += "-"+rs.getString("OPCION_ID");
			}
			if (opciones.length()>1) opciones += "-";
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioMenu|existeReg|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}		
		
		return opciones;
	}
	
}
