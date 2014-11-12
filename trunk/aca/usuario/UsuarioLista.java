/**
 * 
 */
package aca.usuario;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class UsuarioLista {
	
	public ArrayList<Usuario> getListAll(Connection Conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<Usuario> lisUsuario 	= new ArrayList<Usuario>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, TIPO_ID, CUENTA, CLAVE, ADMINISTRADOR, ESCUELA, PLAN, COTEJADOR, CONTABLE, NIVEL, ASOCIACION, DIVISION, IDIOMA" +
					" FROM USUARIO" +
					" WHERE ESCUELA = '"+escuelaId+"' "+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				Usuario usuario = new Usuario();
				usuario.mapeaReg(rs);
				lisUsuario.add(usuario);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisUsuario;
	}
	
	public ArrayList<Usuario> getListTipo(Connection Conn, String escuelaId, int tipoId, String orden ) throws SQLException{
		
		ArrayList<Usuario> lisUsuario 	= new ArrayList<Usuario>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, TIPO_ID, CUENTA, CLAVE, ADMINISTRADOR, ESCUELA, PLAN, COTEJADOR, CONTABLE, NIVEL, ASOCIACION, DIVISION, IDIOMA" +
					" FROM USUARIO" +
					" WHERE ESCUELA = '"+escuelaId+"'" +
					" AND TIPO_ID = TO_NUMBER('"+tipoId+"','99') "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				Usuario usuario = new Usuario();
				usuario.mapeaReg(rs);
				lisUsuario.add(usuario);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioLista|getListTipo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisUsuario;
	}
	
	public ArrayList<Usuario> getListContable(Connection Conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<Usuario> lisUsuario 	= new ArrayList<Usuario>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, TIPO_ID, CUENTA, CLAVE, ADMINISTRADOR, ESCUELA, PLAN, COTEJADOR, CONTABLE, NIVEL, ASOCIACION, DIVISION, IDIOMA" +
					" FROM USUARIO" +
					" WHERE ESCUELA = '"+escuelaId+"'" +
					" AND CONTABLE = 'S' "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				Usuario usuario = new Usuario();
				usuario.mapeaReg(rs);
				lisUsuario.add(usuario);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.usuario.UsuarioLista|getListContable|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisUsuario;
	}
	
}
