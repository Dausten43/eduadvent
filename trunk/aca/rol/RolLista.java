package aca.rol;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class RolLista {
	
	public ArrayList<Rol> getListAll(Connection conn, String paisId, String orden ) throws SQLException{
		ArrayList<Rol> list 	= new ArrayList<Rol>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM CAT_REGION WHERE PAIS_ID = '"+paisId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				Rol obj = new Rol();			
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return list;
	}
	

	public HashMap<String,Rol> getTotalSeccionPorPais(Connection conn) throws SQLException{
		
		HashMap<String,Rol> map = new HashMap<String,Rol>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT PAIS_ID, REGION_ID, REGION_NOMBRE" +
					  " FROM CAT_REGION";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				Rol obj = new Rol();
				obj.mapeaReg(rs);
				llave = obj.getPaisId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegionLista|getTotalSeccionPorPais|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static String getTotalPorPais(Connection conn, String paisId) throws SQLException{
		
		String cantidad 				= "0";
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{
			comando = " SELECT COUNT(REGION_NOMBRE) TOTAL" +
					  " FROM CAT_REGION WHERE PAIS_ID = '"+paisId+"'";
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				cantidad = rs.getString("TOTAL");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegionLista|getTotalPorPais|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return cantidad;
	}
	

	public HashMap<String,Rol> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,Rol> map = new HashMap<String,Rol>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT PAIS_ID, REGION_ID, RELIGION_NOMBRE FROM CAT_REGION "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				Rol obj = new Rol();
				obj.mapeaReg(rs);
				llave = obj.getPaisId()+obj.getRegionId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegionLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapRegionesPorPais(Connection conn, String orden ) throws SQLException{
		
		HashMap<String, String> map = new HashMap<String, String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";		
		
		try{
			comando = "SELECT PAIS_ID, COUNT(REGION_ID) AS TOTAL FROM CAT_REGION "+ orden;			
			rs = st.executeQuery(comando);
			
			while (rs.next()){				
				map.put(rs.getString("PAIS_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegionLista|mapRegionesPorPais|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

}