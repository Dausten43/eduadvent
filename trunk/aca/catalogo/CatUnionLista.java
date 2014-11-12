 	//Clase  para la tabla CAT_ESCUELA
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatUnionLista {
	public ArrayList<CatUnion> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatUnion> list 	= new ArrayList<CatUnion>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT " +
					"UNION_ID, UNION_NOMBRE, CREDENCIAL, LETRA " +
					"FROM CAT_UNION "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatUnion union = new CatUnion();				
				union.mapeaReg(rs);
				list.add(union);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public HashMap<String,CatUnion> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatUnion> map 	= new HashMap<String,CatUnion>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		String llave					= "";
		
		try{
			comando = "SELECT" +
			" UNION_ID, UNION_NOMBRE, CREDENCIAL, LETRA" +
			" FROM CAT_UNION "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatUnion obj = new CatUnion();
				obj.mapeaReg(rs);
				llave = obj.getUnionId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnionLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapaAsociaciones(Connection conn) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT UNION_ID, COUNT(ASOCIACION_ID) AS TOTAL FROM CAT_ASOCIACION GROUP BY UNION_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("UNION_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnionLista|mapaAsociaciones|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapaEscuelas(Connection conn) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT UNION_ASOCIACION(ASOCIACION_ID) AS UNION_ID, COUNT(ESCUELA_ID) AS TOTAL FROM CAT_ESCUELA GROUP BY UNION_ASOCIACION(ASOCIACION_ID)";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("UNION_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnionLista|mapaEscuelas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapaEmpleados(Connection conn) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT UNION_ASOCIACION(ASOCIACION_ESCUELA(ESCUELA_ID)) AS UNION_ID, COUNT(CODIGO_ID) AS TOTAL" +
					" FROM EMP_PERSONAL" +
					" WHERE ESTADO = 'A'" +
					" GROUP BY UNION_ASOCIACION(ASOCIACION_ESCUELA(ESCUELA_ID))";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("UNION_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatUnionLista|mapaEmpleados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
}