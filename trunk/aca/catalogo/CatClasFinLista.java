//Clase  para la tabla CAT_CIUDAD
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatClasFinLista {

	public ArrayList<CatClasFin> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatClasFin> lisCatClas 	= new ArrayList<CatClasFin>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CLASFIN_ID, CLASFIN_NOMBRE, ESCUELA_ID, ESTADO FROM CAT_CLASFIN "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatClasFin clas = new CatClasFin();				
				clas.mapeaReg(rs);
				lisCatClas.add(clas);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatClasFinLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatClas;
	}

			
	public HashMap<String,CatClasFin> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatClasFin> map = new HashMap<String,CatClasFin>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT CLASFIN_ID,CLASFIN_NOMBRE, ESCUELA_ID, ESTADO FROM CAT_CLASFIN "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatClasFin obj = new CatClasFin();
				obj.mapeaReg(rs);
				llave = obj.getClasfinId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatClasFinLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<CatClasFin> getListEscuela(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<CatClasFin> lisCatClas 	= new ArrayList<CatClasFin>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CLASFIN_ID,CLASFIN_NOMBRE, ESCUELA_ID, ESTADO FROM CAT_CLASFIN WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatClasFin clas = new CatClasFin();				
				clas.mapeaReg(rs);
				lisCatClas.add(clas);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatClasFinLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatClas;
	}
	
	public ArrayList<String> getListClas(Connection Conn, String escuelaId) throws SQLException{
		
		ArrayList<String> lisModulo 	= new ArrayList<String>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT CLASFIN_ID  FROM CAT_CLASFIN WHERE ESCUELA_ID = '"+escuelaId+"' "+
					" ORDER BY CLASFIN_ID";
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				lisModulo.add(rs.getString("CLASFIN_ID"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPersonalLista|getListClas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisModulo;
	}
	
	
}