//Clase  para la tabla CAT_CIUDAD
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatCiudadLista {
	public ArrayList<CatCiudad> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatCiudad> lisCatCiudad 	= new ArrayList<CatCiudad>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PAIS_ID, ESTADO_ID, CIUDAD_ID, CIUDAD_NOMBRE FROM CAT_CIUDAD "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatCiudad city = new CatCiudad();				
				city.mapeaReg(rs);
				lisCatCiudad.add(city);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudadLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatCiudad;
	}
	
	public HashMap<String,CatCiudad> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatCiudad> map = new HashMap<String,CatCiudad>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT PAIS_ID, ESTADO_ID, CIUDAD_ID, CIUDAD_NOMBRE FROM CAT_CIUDAD "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatCiudad obj = new CatCiudad();
				obj.mapeaReg(rs);
				llave = obj.getPaisId()+obj.getEstadoId()+obj.getCiudadId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudadLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<CatCiudad> getArrayList(Connection conn, String paisId, String estadoId, String orden ) throws SQLException{
		
		ArrayList<CatCiudad> lisCiudad = new ArrayList<CatCiudad>();
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando	= "";
		
		try{
			comando = "SELECT PAIS_ID,ESTADO_ID,CIUDAD_ID, CIUDAD_NOMBRE FROM CAT_CIUDAD "
					+ "WHERE PAIS_ID = TO_NUMBER('"+paisId+"','999')"
					+ "AND ESTADO_ID = TO_NUMBER('"+estadoId+"','999')  "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatCiudad ciudad = new CatCiudad();
				ciudad.mapeaReg(rs);
				lisCiudad.add(ciudad);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudadLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCiudad;
	}
}