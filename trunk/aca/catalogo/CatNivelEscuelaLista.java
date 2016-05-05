package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatNivelEscuelaLista {
	public ArrayList<CatNivelEscuela> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatNivelEscuela> list 	= new ArrayList<CatNivelEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * " +
					"FROM CAT_NIVEL_ESCUELA "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatNivelEscuela obj = new CatNivelEscuela();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuelaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<CatNivelEscuela> getListEscuela(Connection conn, String escuelaId, String orden) throws SQLException{
		ArrayList<CatNivelEscuela> list 	= new ArrayList<CatNivelEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT *  " +
					"FROM CAT_NIVEL_ESCUELA WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatNivelEscuela obj = new CatNivelEscuela();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuelaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public HashMap<String,String> mapaNiveles(Connection conn) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = " SELECT NIVEL_ID, COUNT(ESCUELA_ID) AS TOTAL FROM CAT_NIVEL_ESCUELA AS CNE " +
					  " WHERE ESCUELA_ID IN (SELECT ESCUELA_ID FROM PLAN WHERE ESCUELA_ID = " +
					  " CNE.ESCUELA_ID AND NIVEL_ID = CNE.NIVEL_ID AND ESTADO = 'A')" +
					  " GROUP BY NIVEL_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("NIVEL_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuelaLista|mapaNiveles|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<CatNivelEscuela> getListNivelesCarga(Connection conn, String escuelaId, String cicloId, String orden ) throws SQLException{
		ArrayList<CatNivelEscuela> lis 	= new ArrayList<CatNivelEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM CAT_NIVEL_ESCUELA" +
					" WHERE ESCUELA_ID = '"+escuelaId+"' AND NIVEL_ID IN (SELECT NIVEL FROM ALUM_CICLO WHERE CICLO_ID = '"+cicloId+"' AND ESTADO = 'I' ) "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatNivelEscuela nivel = new CatNivelEscuela();				
				nivel.mapeaReg(rs);
				lis.add(nivel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuelaLista|getListNivelesCarga|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lis;
	}
	
	
	public HashMap<String, CatNivelEscuela> mapNivelesEscuela(Connection conn, String escuelaId ) throws SQLException{
		HashMap<String, CatNivelEscuela> map 	= new HashMap<String, CatNivelEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM CAT_NIVEL_ESCUELA" +
					" WHERE ESCUELA_ID = '"+escuelaId+"' ";
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatNivelEscuela obj = new CatNivelEscuela();
				obj.mapeaReg(rs);
				map.put(obj.getNivelId(), obj );
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuelaLista|getListNivelesCarga|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return map;
	}
	public ArrayList<CatNivelEscuela> getListNivelesPermitidos(Connection conn, String escuelaId, String cicloId, String orden ) throws SQLException{
		ArrayList<CatNivelEscuela> lis 	= new ArrayList<CatNivelEscuela>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM CAT_NIVEL_ESCUELA" +
					" WHERE ESCUELA_ID = '"+escuelaId+"' AND NIVEL_ID IN (SELECT NIVEL_ID FROM CICLO_PERMISO WHERE CICLO_ID = '"+cicloId+"') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatNivelEscuela nivel = new CatNivelEscuela();				
				nivel.mapeaReg(rs);
				lis.add(nivel);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuelaLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lis;
	}
	
	public HashMap<String,CatNivelEscuela> mapNivelEscuela(Connection conn, String asociaciones) throws SQLException{
		
		HashMap<String,CatNivelEscuela> map 	= new HashMap<String,CatNivelEscuela>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";		
		
		try{
			comando = " SELECT * FROM"
					+ " CAT_NIVEL_ESCUELA"
					+ " WHERE ASOCIACION_ESCUELA(ESCUELA_ID) IN ("+asociaciones+") ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){		
				CatNivelEscuela obj = new CatNivelEscuela();				
				obj.mapeaReg(rs);
				map.put(obj.getEscuelaId()+"@@"+obj.getNivelId(), obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuelaLista|mapNivelEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,CatNivelEscuela> mapNiveles(Connection conn) throws SQLException{
		
		HashMap<String,CatNivelEscuela> map 	= new HashMap<String,CatNivelEscuela>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";		
		
		try{
			comando = " SELECT * FROM CAT_NIVEL_ESCUELA";
			
			rs = st.executeQuery(comando);
			while (rs.next()){		
				CatNivelEscuela obj = new CatNivelEscuela();				
				obj.mapeaReg(rs);
				map.put(obj.getEscuelaId()+obj.getNivelId(), obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatNivelEscuelaLista|mapNiveles|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

}