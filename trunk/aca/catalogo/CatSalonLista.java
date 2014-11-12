//Clase  para la tabla CAT_SALON
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatSalonLista {
	public ArrayList<CatSalon> getListAll(Connection conn, String edificioId, String orden ) throws SQLException{
		ArrayList<CatSalon> lisCatSalon 	= new ArrayList<CatSalon>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "Select * from cat_salon where edificio_id = "+edificioId+" "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatSalon salon = new CatSalon();				
				salon.mapeaReg(rs);
				lisCatSalon.add(salon);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSalonLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCatSalon;
	}
	
	public HashMap<String,CatSalon> getMapAll(Connection conn, String edificioId, String orden ) throws SQLException{
		
		HashMap<String,CatSalon> map = new HashMap<String,CatSalon>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SSelect * from cat_salon where edficio_id = "+edificioId+" "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatSalon obj = new CatSalon();
				obj.mapeaReg(rs);
				llave = obj.getSalonId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatSalonLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
}