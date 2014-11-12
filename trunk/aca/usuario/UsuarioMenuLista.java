/**
 * 
 */
package aca.usuario;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class UsuarioMenuLista {
	
	public ArrayList<UsuarioMenu> getListAll(Connection Conn, String orden ) throws SQLException{
		
		ArrayList<UsuarioMenu> lisUsuario 	= new ArrayList<UsuarioMenu>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, OPCION_ID FROM USUARIO_MENU "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				UsuarioMenu usuario = new UsuarioMenu();
				usuario.mapeaReg(rs);
				lisUsuario.add(usuario);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioMenuLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisUsuario;
	}
	
	public ArrayList<UsuarioMenu> getListUsuario(Connection Conn, String codigoId, String orden ) throws SQLException{
		
		ArrayList<UsuarioMenu> lisUsuario 	= new ArrayList<UsuarioMenu>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			
			comando = "SELECT CODIGO_ID, OPCION_ID FROM USUARIO_MENU " +
					" WHERE CODIGO_ID = '"+codigoId+"'" +
					" AND OPCION_ID IN (SELECT OPCION_ID FROM MODULO_OPCION WHERE ESTADO = 'A') "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				UsuarioMenu usuario = new UsuarioMenu();
				usuario.mapeaReg(rs);
				lisUsuario.add(usuario);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioMenuLista|getListUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisUsuario;
	}
	
}
