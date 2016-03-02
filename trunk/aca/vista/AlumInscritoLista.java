package aca.vista;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;


public class AlumInscritoLista {
	
	public ArrayList<AlumInscrito> getListaInscritos(Connection conn,  String cicloId, String periodoId, String orden) throws SQLException{
		ArrayList<AlumInscrito> lisInscritos 	= new ArrayList<AlumInscrito>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM ALUMNO_INSCRITO WHERE CICLO_ID = '"+cicloId+"' AND PERIODO_ID = TO_NUMBER('"+periodoId+"','99') "+orden;			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){				
				AlumInscrito inscrito = new AlumInscrito();				
				inscrito.mapeaReg(rs);
				lisInscritos.add(inscrito);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumInscritosLista|getListaInscritos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisInscritos;
	}
	
	public ArrayList<AlumInscrito> getListaInscritos(Connection conn,  String escuelaId, String orden) throws SQLException{
		ArrayList<AlumInscrito> lisInscritos 	= new ArrayList<AlumInscrito>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM ALUMNO_INSCRITO WHERE SUBSTR(CODIGO_ID,1,3) = '"+escuelaId+"' "+orden;			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){				
				AlumInscrito inscrito = new AlumInscrito();				
				inscrito.mapeaReg(rs);
				lisInscritos.add(inscrito);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumInscritosLista|getListaInscritos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisInscritos;
	}
	
	public static HashMap<String, String> mapInscritosPorNivel(Connection conn) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";		
		
		try{
			comando = "SELECT NIVEL, COALESCE(COUNT(*)) AS TOTAL FROM ALUMNO_INSCRITO GROUP BY NIVEL";	
			rs = st.executeQuery(comando);			
			while (rs.next()){				
				map.put(rs.getString("NIVEL"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumInscritoLista|mapInscritosPorNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return map;
	}
	
	public HashMap<String,String> mapaAlumnosPorEscuela(Connection conn, String asociacion) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = " SELECT SUBSTR(CODIGO_ID,1,3) AS ESCUELA_ID, COUNT(CODIGO_ID) AS TOTAL FROM ALUMNO_INSCRITO WHERE ASOCIACION_ESCUELA(SUBSTR(CODIGO_ID,1,3)) = "+asociacion+
					  " GROUP BY ESCUELA_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("ESCUELA_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumInscritoLista|mapaAlumnosPorEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
}