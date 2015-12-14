package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatRegionLista {
	
	public ArrayList<CatRegion> getListAll(Connection conn, String paisId, String orden ) throws SQLException{
		ArrayList<CatRegion> list 	= new ArrayList<CatRegion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM CAT_REGION WHERE PAIS_ID = TO_NUMBER('"+paisId+"', '999') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CatRegion obj = new CatRegion();			
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
	

	public HashMap<String,CatRegion> getTotalSeccionPorPais(Connection conn) throws SQLException{
		
		HashMap<String,CatRegion> map = new HashMap<String,CatRegion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT PAIS_ID, REGION_ID, REGION_NOMBRE" +
					  " FROM CAT_REGION";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatRegion obj = new CatRegion();
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
					  " FROM CAT_REGION WHERE PAIS_ID = TO_NUMBER('"+paisId+"', '999')";
			
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
	

	public HashMap<String,CatRegion> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatRegion> map = new HashMap<String,CatRegion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT PAIS_ID, REGION_ID, RELIGION_NOMBRE FROM CAT_REGION "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatRegion obj = new CatRegion();
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