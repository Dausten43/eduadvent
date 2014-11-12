//Clase  para la tabla CAT_NIVEL
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatNivelLista {
	
	public ArrayList<CatNivel> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatNivel> lisCatNivel 	= new ArrayList<CatNivel>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT NIVEL_ID, NIVEL_NOMBRE, GRADO_INI, GRADO_FIN, METODO, TITULO, NOTAMINIMA, NOMBRE_CORTO FROM CAT_NIVEL "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatNivel nivel = new CatNivel();				
				nivel.mapeaReg(rs);
				lisCatNivel.add(nivel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatNivel;
	}
	
	public HashMap<String,CatNivel> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatNivel> map = new HashMap<String,CatNivel>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT NIVEL_ID, NIVEL_NOMBRE, GRADO_INI, GRADO_FIN, METODO, TITULO, NOTAMINIMA, NOMBRE_CORTO FROM CAT_NIVEL "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatNivel obj = new CatNivel();
				obj.mapeaReg(rs);
				llave = obj.getNivelId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<CatNivel> getListEscuela(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<CatNivel> lisCatNivel 	= new ArrayList<CatNivel>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT NIVEL_ID, NIVEL_NOMBRE, GRADO_INI, GRADO_FIN, METODO, TITULO, NOTAMINIMA, NOMBRE_CORTO FROM CAT_NIVEL" +
					" WHERE NIVEL_ID IN (SELECT NIVEL_ID FROM PLAN WHERE ESCUELA_ID = '"+escuelaId+"' ) "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatNivel nivel = new CatNivel();				
				nivel.mapeaReg(rs);
				lisCatNivel.add(nivel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatNivel;
	}
	
	public ArrayList<CatNivel> getListNivelesPermitidos(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CatNivel> lisCatNivel 	= new ArrayList<CatNivel>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT NIVEL_ID, NIVEL_NOMBRE, GRADO_INI, GRADO_FIN, METODO, TITULO, NOTAMINIMA, NOMBRE_CORTO FROM CAT_NIVEL" +
					" WHERE NIVEL_ID IN (SELECT NIVEL_ID FROM CICLO_PERMISO WHERE CICLO_ID = '"+cicloId+"') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatNivel nivel = new CatNivel();				
				nivel.mapeaReg(rs);
				lisCatNivel.add(nivel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatNivel;
	}
	
	public ArrayList<CatNivel> getListNivelesCarga(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CatNivel> lisCatNivel 	= new ArrayList<CatNivel>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT NIVEL_ID, NIVEL_NOMBRE, GRADO_INI, GRADO_FIN, METODO, TITULO, NOTAMINIMA, NOMBRE_CORTO FROM CAT_NIVEL" +
					" WHERE NIVEL_ID IN (SELECT NIVEL FROM ALUM_CICLO WHERE CICLO_ID = '"+cicloId+"' AND ESTADO = 'I' ) "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatNivel nivel = new CatNivel();				
				nivel.mapeaReg(rs);
				lisCatNivel.add(nivel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelLista|getListNivelesCarga|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatNivel;
	}
	
}