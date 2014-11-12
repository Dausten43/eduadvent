// Clase para la tabla de MODULO_OPCION
package aca.menu;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class ModuloOpcionLista{
	
	// Regresa una lista con todos los elementos de la tabla Modulo_opcion 
	public ArrayList<ModuloOpcion> getListAll(Connection conn, String orden ) throws SQLException{
		
		ArrayList<ModuloOpcion> lisOpcion	= new ArrayList<ModuloOpcion>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT MODULO_ID, OPCION_ID, NOMBRE_OPCION, URL, ORDEN, ACCESO, ESTADO " +
					"FROM MODULO_OPCION "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				ModuloOpcion opcion = new ModuloOpcion();
				opcion.mapeaReg(rs);
				lisOpcion.add(opcion);
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisOpcion;
	}
	
	// Regresa una lista con todos los elementos de la tabla Modulo_opcion 
	public ArrayList<ModuloOpcion> getListActivos(Connection conn, String orden ) throws SQLException{
		
		ArrayList<ModuloOpcion> lisOpcion	= new ArrayList<ModuloOpcion>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT MODULO_ID, OPCION_ID, NOMBRE_OPCION, URL, ORDEN, ACCESO, ESTADO " +
					"FROM MODULO_OPCION WHERE ESTADO='A' "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				ModuloOpcion opcion = new ModuloOpcion();
				opcion.mapeaReg(rs);
				lisOpcion.add(opcion);
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisOpcion;
	}	
	
	public ArrayList<ModuloOpcion> getListaActivosSuper(Connection conn, String orden) throws SQLException{
		
		ArrayList<ModuloOpcion> lisOpcion	= new ArrayList<ModuloOpcion>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT MODULO_ID, OPCION_ID, NOMBRE_OPCION, URL, ORDEN, ACCESO, ESTADO " +
					"FROM MODULO_OPCION WHERE ESTADO='A' AND (ACCESO='A' OR ACCESO='S')"+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				ModuloOpcion opcion = new ModuloOpcion();
				opcion.mapeaReg(rs);
				lisOpcion.add(opcion);
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisOpcion;
	}

	public ArrayList<ModuloOpcion> getListaActivosAdmin(Connection conn, String orden) throws SQLException{
		
		ArrayList<ModuloOpcion> lisOpcion	= new ArrayList<ModuloOpcion>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT MODULO_ID, OPCION_ID, NOMBRE_OPCION, URL, ORDEN, ACCESO, ESTADO " +
					"FROM MODULO_OPCION WHERE ESTADO='A' AND ACCESO='A'"+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				ModuloOpcion opcion = new ModuloOpcion();
				opcion.mapeaReg(rs);
				lisOpcion.add(opcion);
			}		
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisOpcion;
	}
	
//	 Regresa un listor del Objeto "Opcion" con las opciones a las que tiene acceso el usuario
	public ArrayList<ModuloOpcion> getListUser(Connection conn, String codigoId ) throws SQLException{
		
		ArrayList<ModuloOpcion> lisOpcion 	= new ArrayList<ModuloOpcion>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT A.MODULO_ID, A.OPCION_ID, A.NOMBRE_OPCION, A.URL, A.ORDEN, A.ACCESO, A.ESTADO " +
					"FROM MODULO_OPCION A, USUARIO_MENU B "+
					"WHERE B.OPCION_ID = A.OPCION_ID " +
					"AND B.CODIGO_ID= '"+codigoId+"'" +
					"AND A.ESTADO = 'A' "+
					"ORDER BY 1,3";
			rs = st.executeQuery(comando);
			while (rs.next()){				
				ModuloOpcion opcion = new ModuloOpcion();
				opcion.mapeaReg(rs);
				lisOpcion.add(opcion);							
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcionLista|getListUser|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisOpcion;
	}
	
	public ArrayList<ModuloOpcion> getListUserSuper(Connection conn, String codigoId ) throws SQLException{
		
		ArrayList<ModuloOpcion> lisOpcion 	= new ArrayList<ModuloOpcion>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT A.MODULO_ID, A.OPCION_ID, A.NOMBRE_OPCION, A.URL, A.ORDEN, A.ACCESO, A.ESTADO " +
					"FROM MODULO_OPCION A, USUARIO_MENU B "+
					"WHERE B.OPCION_ID = A.OPCION_ID " +
					"AND B.CODIGO_ID= '"+codigoId+"' "+
					"ORDER BY 1,3";
			rs = st.executeQuery(comando);
			while (rs.next()){				
				ModuloOpcion opcion = new ModuloOpcion();
				opcion.mapeaReg(rs);
				lisOpcion.add(opcion);							
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcionLista|getListUser|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisOpcion;
	}
	
	public HashMap<String,ModuloOpcion> getMapActivos(Connection conn) throws SQLException{
		
		HashMap<String,ModuloOpcion> map = new HashMap<String,ModuloOpcion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT MODULO_ID, OPCION_ID, NOMBRE_OPCION, URL, ORDEN, ACCESO, ESTADO"+					
					" FROM MODULO_OPCION WHERE ESTADO='A'";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				ModuloOpcion obj = new ModuloOpcion();
				obj.mapeaReg(rs);
				llave = obj.getOpcionId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.menu.ModuloOpcionLista|getMapActivos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

}

