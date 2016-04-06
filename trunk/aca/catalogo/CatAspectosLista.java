 	//Clase  para la tabla CAT_ESCUELA
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatAspectosLista {
	
	public ArrayList<CatAspectos> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatAspectos> list 	= new ArrayList<CatAspectos>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT ESCUELA_ID, ASPECTOS_ID, NOMBRE, ORDEN, NIVEL_ID, AREA_ID"
					+ " FROM CAT_ASPECTOS "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatAspectos asoc = new CatAspectos();				
				asoc.mapeaReg(rs);
				list.add(asoc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<CatAspectos> getListAspectos(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<CatAspectos> list 	= new ArrayList<CatAspectos>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT ESCUELA_ID, ASPECTOS_ID, NOMBRE, ORDEN, NIVEL_ID, AREA_ID"
					+ " FROM CAT_ASPECTOS"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatAspectos obj = new CatAspectos();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosLista|getListAspectos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<CatAspectos> getListAspectos(Connection conn, String escuelaId, String nivelId, String orden ) throws SQLException{
		ArrayList<CatAspectos> list 	= new ArrayList<CatAspectos>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT ESCUELA_ID, ASPECTOS_ID, NOMBRE, ORDEN, NIVEL_ID, AREA_ID"
					+ " FROM CAT_ASPECTOS"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND NIVEL_ID = TO_NUMBER('"+nivelId+"','99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatAspectos obj = new CatAspectos();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosLista|getListAspectos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public HashMap<String,CatAspectos> getMapAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		
		HashMap<String,CatAspectos> map = new HashMap<String,CatAspectos>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT ESCUELA_ID, ASPECTOS_ID, NOMBRE, ORDEN, NIVEL_ID, AREA_ID"
					+ " FROM CAT_ASPECTOS"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatAspectos obj = new CatAspectos();
				obj.mapeaReg(rs);
				llave = obj.getAspectosId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

}