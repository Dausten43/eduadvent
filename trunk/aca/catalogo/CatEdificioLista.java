 	//Clase  para la tabla CAT_ESCUELA
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatEdificioLista {
	public ArrayList<CatEdificio> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<CatEdificio> list 	= new ArrayList<CatEdificio>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT *  " +
					"FROM CAT_EDIFICIO WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatEdificio obj = new CatEdificio();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEdificioLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public HashMap<String,CatEdificio> getMapAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		
		HashMap<String,CatEdificio> map = new HashMap<String,CatEdificio>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT *  " +
					"FROM CAT_EDIFICIO  WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatEdificio obj = new CatEdificio();
				obj.mapeaReg(rs);
				llave = obj.getEdificioId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEdificioLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
}