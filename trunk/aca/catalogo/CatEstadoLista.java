//Clase  para la tabla CAT_ESTADO
package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CatEstadoLista {
	public ArrayList<CatEstado> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatEstado> lisCatEstado 	= new ArrayList<CatEstado>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PAIS_ID, ESTADO_ID, ESTADO_NOMBRE, CLAVE FROM CAT_ESTADO "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatEstado state = new CatEstado();				
				state.mapeaReg(rs);
				lisCatEstado.add(state);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEstadoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCatEstado;
	}
	
	public HashMap<String,CatEstado> getMapAll(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,CatEstado> map = new HashMap<String,CatEstado>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT PAIS_ID, ESTADO_ID, ESTADO_NOMBRE, CLAVE FROM CAT_ESTADO "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CatEstado obj = new CatEstado();
				obj.mapeaReg(rs);
				llave = obj.getPaisId()+obj.getEstadoId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEstadoLista|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<CatEstado> getArrayList(Connection conn, String paisId, String orden ) throws SQLException{
		
		ArrayList<CatEstado> lisEstado	= new ArrayList<CatEstado>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT PAIS_ID, ESTADO_ID, ESTADO_NOMBRE, CLAVE "
					+ "FROM CAT_ESTADO "
					+ "WHERE PAIS_ID = TO_NUMBER('"+paisId+"','999') "+ orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatEstado estado = new CatEstado();
				estado.mapeaReg(rs);
				lisEstado.add(estado);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.EstadoLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisEstado;
	}
	
	public ArrayList<CatEstado> getEscEstadoPais(Connection conn, String paisId, String orden ) throws SQLException{
		
		ArrayList<CatEstado> lisEstado	= new ArrayList<CatEstado>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = " SELECT PAIS_ID, ESTADO_ID, ESTADO_NOMBRE, CLAVE FROM CAT_ESTADO" +
					  " WHERE PAIS_ID = TO_NUMBER('"+paisId+"', '999') AND ESTADO_ID IN (SELECT ESTADO_ID FROM " +
					  " CAT_ESCUELA WHERE PAIS_ID = TO_NUMBER('"+paisId+"', '999'))"+ orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CatEstado estado = new CatEstado();
				estado.mapeaReg(rs);
				lisEstado.add(estado);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.EstadoLista|getEscEstadoPais|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisEstado;
	}
	
public HashMap<String,String> getMapEstTotEsc(Connection conn, String paisId) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT ESTADO_ID, COUNT(ESCUELA_ID) AS TOTAL FROM CAT_ESCUELA WHERE PAIS_ID = TO_NUMBER('"+paisId+"', '999') GROUP BY ESTADO_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("ESTADO_ID"), rs.getString("TOTAL"));
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