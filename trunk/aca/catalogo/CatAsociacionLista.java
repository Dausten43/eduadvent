 	//Clase  para la tabla CAT_ESCUELA
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatAsociacionLista {
	
	public ArrayList<CatAsociacion> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatAsociacion> list 	= new ArrayList<CatAsociacion>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT " +
					"ASOCIACION_ID, ASOCIACION_NOMBRE, UNION_ID, FONDO_ID, ASOCIACION_CORTO " +
					"FROM CAT_ASOCIACION "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatAsociacion asoc = new CatAsociacion();				
				asoc.mapeaReg(rs);
				list.add(asoc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<CatAsociacion> getListUnion(Connection conn, String unionId, String orden ) throws SQLException{
		ArrayList<CatAsociacion> list 	= new ArrayList<CatAsociacion>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ASOCIACION_ID, ASOCIACION_NOMBRE, UNION_ID, FONDO_ID, ASOCIACION_CORTO" +
					" FROM CAT_ASOCIACION" +
					" WHERE UNION_ID = TO_NUMBER('"+unionId+"', '99') "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatAsociacion asoc = new CatAsociacion();				
				asoc.mapeaReg(rs);
				list.add(asoc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacionLista|getListUnion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public HashMap<String,CatAsociacion> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatAsociacion> map = new HashMap<String,CatAsociacion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT " +
			"ASOCIACION_ID, ASOCIACION_NOMBRE, UNION_ID, FONDO_ID, ASOCIACION_CORTO " +
			"FROM CAT_ASOCIACION "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatAsociacion obj = new CatAsociacion();
				obj.mapeaReg(rs);
				llave = obj.getAsociacionId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacionLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapaEscuelas(Connection conn, String unionId) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT ASOCIACION_ID, COUNT(ESCUELA_ID) AS TOTAL" +
					" FROM CAT_ESCUELA" +
					" WHERE UNION_ASOCIACION(ASOCIACION_ESCUELA(ESCUELA_ID)) = "+unionId+
					" GROUP BY ASOCIACION_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("ASOCIACION_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacionLista|mapaEscuelas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapaEmpleados(Connection conn, String unionId) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT ASOCIACION_ESCUELA(ESCUELA_ID) AS ASOCIACION_ID, COUNT(CODIGO_ID) AS TOTAL" +
					" FROM EMP_PERSONAL" +
					" WHERE UNION_ASOCIACION(ASOCIACION_ESCUELA(ESCUELA_ID)) = "+unionId+
					" AND ESTADO = 'A'" +
					" GROUP BY ASOCIACION_ESCUELA(ESCUELA_ID)";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("ASOCIACION_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAsociacionLista|mapaEmpleados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}


}