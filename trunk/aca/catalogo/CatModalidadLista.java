package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatModalidadLista {
	public ArrayList<CatModalidad> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatModalidad> lisCatModalidad 	= new ArrayList<CatModalidad>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT MODALIDAD_ID, MODALIDAD_NOMBRE FROM CAT_MODALIDAD "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				CatModalidad modalidad = new CatModalidad();				
				modalidad.mapeaReg(rs);
				lisCatModalidad.add(modalidad);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatModalidadLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatModalidad;
	}
	
	public HashMap<String,CatModalidad> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatModalidad> map = new HashMap<String,CatModalidad>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT MODALIDAD_ID, MODALIDAD_NOMBRE FROM CAT_MODALIDAD "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatModalidad obj = new CatModalidad();
				obj.mapeaReg(rs);
				llave = obj.getModalidadId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatModalidadLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<CatModalidad> getArrayList(Connection conn, String modalidadId, String orden) throws SQLException{
		
		ArrayList<CatModalidad> lisModalidad = new ArrayList<CatModalidad>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = "SELECT MODALIDAD_ID, MODALIDAD_NOMBRE FROM CAT_MODALIDAD "+
				" WHERE MODALIDAD_ID = TO_NUMBER('"+modalidadId+"','99')"+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatModalidad modalidad = new CatModalidad();
				modalidad.mapeaReg(rs);
				lisModalidad.add(modalidad);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatModalidadLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisModalidad;
	}

}
