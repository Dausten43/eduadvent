// Clase para la tabla de Modulo
package aca.menu;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class ModuloLista{
		
	public ArrayList<Modulo> getListAll(Connection Conn, String orden ) throws SQLException{
		
		ArrayList<Modulo> lisModulo 	= new ArrayList<Modulo>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT MODULO_ID, NOMBRE_MODULO, URL, ICONO, MENU_ID FROM MODULO "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				Modulo modulo = new Modulo();
				modulo.mapeaReg(rs);
				lisModulo.add(modulo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisModulo;
	}
	
	public ArrayList<Modulo> getListUser(Connection Conn, String  codigoId ) throws SQLException{
		
		ArrayList<Modulo> lisModulo 	= new ArrayList<Modulo>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT MODULO_ID, NOMBRE_MODULO, URL, MENU_ID FROM MODULO "+
					"WHERE MODULO_ID IN "+
						"(SELECT DISTINCT(A.MODULO_ID) " +
						"FROM MODULO_OPCION A, USUARIO_MENU B " +
						"WHERE B.OPCION_ID = A.OPCION_ID " +
						"AND B.CODIGO_ID = '"+codigoId+"' " +
						" AND A.ESTADO = 'A' )"+
					" ORDER BY 2";
			//System.out.println(comando);
			rs = st.executeQuery(comando);
			while (rs.next()){				
				Modulo modulo = new Modulo();
				modulo.mapeaReg(rs);
				lisModulo.add(modulo);							
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloLista|getListUser|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisModulo;
	}
	
	public ArrayList<Modulo> getListUserSuper(Connection Conn, String  codigoId ) throws SQLException{
		
		ArrayList<Modulo> lisModulo 	= new ArrayList<Modulo>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT MODULO_ID, NOMBRE_MODULO, URL, MENU_ID FROM MODULO "+
					"WHERE MODULO_ID IN "+
						"(SELECT DISTINCT(A.MODULO_ID) " +
						"FROM MODULO_OPCION A, USUARIO_MENU B " +
						"WHERE B.OPCION_ID = A.OPCION_ID " +
						"AND B.CODIGO_ID = '"+codigoId+"') " +
					" ORDER BY 2";
			//System.out.println(comando);
			rs = st.executeQuery(comando);
			while (rs.next()){				
				Modulo modulo = new Modulo();
				modulo.mapeaReg(rs);
				lisModulo.add(modulo);							
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloLista|getListUser|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisModulo;
	}
	
	public HashMap<String,Modulo> getMapAll(Connection conn) throws SQLException{
		
		HashMap<String,Modulo> map = new HashMap<String, Modulo>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT MODULO_ID, NOMBRE_MODULO, URL, ICONO, MENU_ID FROM MODULO";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				Modulo obj = new Modulo();
				obj.mapeaReg(rs);
				llave = obj.getModuloId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
		
}

