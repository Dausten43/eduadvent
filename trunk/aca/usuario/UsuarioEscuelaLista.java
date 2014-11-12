/**
 * 
 */
package aca.usuario;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * @author elifo
 *
 */
public class UsuarioEscuelaLista {
	public ArrayList<UsuarioEscuela> getListUsuario(Connection Conn, String codigoId, String orden) throws SQLException{
		
		ArrayList<UsuarioEscuela> lisUsuarioEscuela 	= new ArrayList<UsuarioEscuela>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, PREDETERMINADA FROM USUARIO_ESCUELA" +
					" WHERE CODIGO_ID = '"+codigoId+"' "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				UsuarioEscuela usuarioEscuela = new UsuarioEscuela();
				usuarioEscuela.mapeaReg(rs);
				lisUsuarioEscuela.add(usuarioEscuela);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioEscuelaLista|getListUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisUsuarioEscuela;
	}
}
