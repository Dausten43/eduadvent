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
			comando = "SELECT " +
					"ASPECTOS_ID, NOMBRE, ORDEN, NIVEL, AREA " +
					"FROM CAT_ASPECTOS "+orden;		
			
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
	
	public ArrayList<CatAspectos> getListAspectos(Connection conn, String aspectosId, String orden ) throws SQLException{
		ArrayList<CatAspectos> list 	= new ArrayList<CatAspectos>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ASPECTO_ID, NOMBRE, ORDEN, NIVEL, AREA" +
					" FROM CAT_ASPECTOS" +
					" WHERE ASPECTO_ID = TO_NUMBER('"+aspectosId+"', '99') "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatAspectos obj = new CatAspectos();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosLista|getListUnion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public HashMap<String,CatAspectos> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatAspectos> map = new HashMap<String,CatAspectos>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT " +
			"ASPECTOS_ID, NOMBRE, ORDEN, NIVEL, AREA " +
			"FROM CAT_ASPECTOS "+orden;
			
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