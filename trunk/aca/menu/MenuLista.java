package aca.menu;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class MenuLista{
		
	public ArrayList<Menu> getListAll(Connection Conn, String orden) throws SQLException{
		
		ArrayList<Menu> lisMenu			= new ArrayList<Menu>();
		Statement st 					= Conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{
			comando = "SELECT * FROM MENU "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				Menu menu = new Menu();
				menu.mapeaReg(rs);
				lisMenu.add(menu);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.MenuLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisMenu;
	}
	
	public ArrayList<Menu> getListUser(Connection Conn, String  codigoId ) throws SQLException{
		
		ArrayList<Menu> lisMenu 	= new ArrayList<Menu>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT MENU_ID, MENU_NOMBRE " +
					" FROM MENU WHERE MENU_ID IN " +
					"  (SELECT DISTINCT(MENU_ID) FROM MODULO WHERE MODULO_ID " +
					"      IN (SELECT DISTINCT(MODULO_ID) FROM MODULO_OPCION A, USUARIO_MENU B " +
					"           WHERE B.OPCION_ID = A.OPCION_ID " +
					"             AND B.CODIGO_ID = '"+codigoId+"' AND A.ESTADO = 'A' )) ORDER BY 1" ;
			//System.out.println(comando);
			rs = st.executeQuery(comando);
			while (rs.next()){				
				Menu menu = new Menu();
				menu.mapeaReg(rs);
				lisMenu.add(menu);							
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloLista|getListUser|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisMenu;
	}
}

