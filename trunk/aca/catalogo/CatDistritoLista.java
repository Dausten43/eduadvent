package aca.catalogo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class CatDistritoLista {
		
	public ArrayList<CatDistrito> getListAll(Connection conn, String orden ) throws SQLException{
		
		ArrayList<CatDistrito> lis	= new ArrayList<CatDistrito>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT DISTRITO_ID, DISTRITO_NOMBRE, ASOCIACION_ID, ORG_ID FROM CAT_DISTRITO "+ orden; 
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatDistrito seccion = new CatDistrito();
				seccion.mapeaReg(rs);
				lis.add(seccion);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatDistritoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public ArrayList<CatDistrito> getListAsociacion(Connection conn, String asociacionId, String orden ) throws SQLException{
	
		ArrayList<CatDistrito> lis	= new ArrayList<CatDistrito>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT DISTRITO_ID, DISTRITO_NOMBRE, ASOCIACION_ID, ORG_ID FROM CAT_DISTRITO WHERE ASOCIACION_ID = '"+asociacionId+"' "+ orden; 
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatDistrito seccion = new CatDistrito();
				seccion.mapeaReg(rs);
				lis.add(seccion);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatDistritoLista|getListAsociacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public HashMap<String,CatDistrito> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatDistrito> map = new HashMap<String,CatDistrito>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT " +
			"DISTRITO_ID, DISTRITO_NOMBRE, ASOCIACION_ID, ORG_ID " +
			"FROM CAT_DISTRITO "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatDistrito obj = new CatDistrito();
				obj.mapeaReg(rs);
				llave = obj.getDistritoId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatDistritoLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
}