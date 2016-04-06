//Clase  para la tabla CAT_ASPECTOS_CAL
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatAspectosCalLista {
	
	public ArrayList<CatAspectosCal> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<CatAspectosCal> list 	= new ArrayList<CatAspectosCal>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT ESCUELA_ID, NIVEL_ID, CAL_ID, CAL_NOMBRE, CAL_CORTO"
					+ " FROM CAT_ASPECTOS_CAL WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatAspectosCal objeto = new CatAspectosCal();				
				objeto.mapeaReg(rs);
				list.add(objeto);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosCalLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<CatAspectosCal> getListPorNivel(Connection conn, String escuelaId, String nivelId, String orden ) throws SQLException{
		ArrayList<CatAspectosCal> list 	= new ArrayList<CatAspectosCal>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT ESCUELA_ID, NIVEL_ID, CAL_ID, CAL_NOMBRE, CAL_CORTO"
					+ " FROM CAT_ASPECTOS_CAL"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND NIVEL_ID = TO_NUMBER('"+nivelId+"','99') "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatAspectosCal objeto = new CatAspectosCal();				
				objeto.mapeaReg(rs);
				list.add(objeto);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosCalLista|getListPorNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public HashMap<String,CatAspectosCal> mapEscuela(Connection conn, String escuelaId ) throws SQLException{
		
		HashMap<String,CatAspectosCal> map = new HashMap<String,CatAspectosCal>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT ESCUELA_ID, NIVEL_ID, CAL_ID, CAL_NOMBRE, CAL_CORTO"
					+ " FROM CAT_ASPECTOS_CAL"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatAspectosCal objeto = new CatAspectosCal();
				objeto.mapeaReg(rs);
				llave = objeto.getNivelId()+objeto.getCalId();
				map.put(llave, objeto);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatAspectosLista|mapEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

}