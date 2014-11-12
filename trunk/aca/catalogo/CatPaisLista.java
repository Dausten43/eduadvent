//Clase  para la tabla CAT_PAIS
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatPaisLista {
	
	public ArrayList<CatPais> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatPais> lisCatPais 	= new ArrayList<CatPais>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PAIS_ID, PAIS_NOMBRE FROM CAT_PAIS "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatPais pais = new CatPais();			
				pais.mapeaReg(rs);
				lisCatPais.add(pais);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatPaisLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCatPais;
	}
	
	public HashMap<String,CatPais> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatPais> map = new HashMap<String,CatPais>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT PAIS_ID, PAIS_NOMBRE FROM CAT_PAIS "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatPais obj = new CatPais();
				obj.mapeaReg(rs);
				llave = obj.getPaisId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatPaisLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> getMapPaisTotEsc(Connection conn) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT PAIS_ID, COALESCE(COUNT(ESCUELA_ID),0) AS TOTAL FROM CAT_ESCUELA GROUP BY PAIS_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("PAIS_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatPaisLista|getMapPaisTotEsc|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
}