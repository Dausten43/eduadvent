//Clase  para la tabla CAT_CIUDAD
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatBarrioLista {
	
	public ArrayList<CatBarrio> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatBarrio> lista 	= new ArrayList<CatBarrio>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PAIS_ID, ESTADO_ID, CIUDAD_ID, BARRIO_ID, BARRIO_NOMBRE FROM CAT_BARRIO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatBarrio barrio = new CatBarrio();
				barrio.mapeaReg(rs);
				lista.add(barrio);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatBarrioLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lista;
	}
	
	public ArrayList<CatBarrio> getArrayList(Connection conn, String paisId, String estadoId, String ciudadId, String orden ) throws SQLException{
		
		ArrayList<CatBarrio> lisCiudad = new ArrayList<CatBarrio>();
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando	= "";
		
		try{
			comando = " SELECT PAIS_ID,ESTADO_ID,CIUDAD_ID, BARRIO_ID, BARRIO_NOMBRE FROM CAT_BARRIO"
					+ " WHERE PAIS_ID = TO_NUMBER('"+paisId+"','999')"
					+ " AND ESTADO_ID = TO_NUMBER('"+estadoId+"','999')"
					+ " AND CIUDAD_ID = TO_NUMBER('"+ciudadId+"','999') "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatBarrio ciudad = new CatBarrio();
				ciudad.mapeaReg(rs);
				lisCiudad.add(ciudad);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatBarrioLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCiudad;
	}

	/* Map de todos los barrios de un pais */
	public HashMap<String,CatBarrio> getMapAll(Connection conn, String paisId, String orden ) throws SQLException{
		
		HashMap<String,CatBarrio> map = new HashMap<String,CatBarrio>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT PAIS_ID, ESTADO_ID, CIUDAD_ID, BARRIO_ID, BARRIO_NOMBRE FROM CAT_BARRIO WHERE PAIS_ID = '"+paisId+"' "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatBarrio obj = new CatBarrio();
				obj.mapeaReg(rs);
				llave = obj.getPaisId()+obj.getEstadoId()+obj.getCiudadId()+obj.getBarrioId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatBarrioLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	
}