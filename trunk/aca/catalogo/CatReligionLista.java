//Clase  para la tabla CAT_RELIGION
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatReligionLista {
	public ArrayList<CatReligion> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatReligion> lisCatReligion 	= new ArrayList<CatReligion>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT RELIGION_ID, RELIGION_NOMBRE FROM CAT_RELIGION "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				CatReligion religion = new CatReligion();				
				religion.mapeaReg(rs);
				lisCatReligion.add(religion);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligionLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatReligion;
	}
	
	public HashMap<String,CatReligion> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatReligion> map = new HashMap<String,CatReligion>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT RELIGION_ID, RELIGION_NOMBRE FROM CAT_RELIGION "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatReligion obj = new CatReligion();
				obj.mapeaReg(rs);
				llave = obj.getReligionId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatReligionLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<CatReligion> getArrayList(Connection conn, String religionId, String orden) throws SQLException{
		
		ArrayList<CatReligion> lisReligion = new ArrayList<CatReligion>();
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando	= "";
		
		try{
			comando = "SELECT RELIGION_ID, RELIGION_NOMBRE FROM CAT_RELIGION "+
				" WHERE RELIGION_ID = TO_NUMBER('"+religionId+"','99')"+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatReligion religion = new CatReligion();
				religion.mapeaReg(rs);
				lisReligion.add(religion);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatCiudadLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisReligion;
	}
}