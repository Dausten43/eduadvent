// Clase para la tabla de Alum_Plan
package aca.alumno;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class AlumCicloLista{
	
	/*
	 *
	 * */
	public ArrayList<AlumCiclo> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<AlumCiclo> lisAlumCiclo	= new ArrayList<AlumCiclo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT * FROM ALUM_CICLO WHERE SUBSTR(CODIGO_ID,1,3)='"+escuelaId+"' "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumCiclo alumCiclo = new AlumCiclo();
				alumCiclo.mapeaReg(rs);
				lisAlumCiclo.add(alumCiclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCicloLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisAlumCiclo;
	}
	
	
	/*
	 * LISTA DE PERIODOS EN LOS QUE HA PARTICIPADO EN EL PROCESO DE MATRICULA
	 * */
	public ArrayList<AlumCiclo> getArrayList(Connection conn, String codigoId, String orden ) throws SQLException{

		
		ArrayList<AlumCiclo> lisAlumCiclo	= new ArrayList<AlumCiclo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
	
		
		try{
			comando = "SELECT * " +
				"FROM ALUM_CICLO "+
				"WHERE CODIGO_ID = '"+codigoId+"' "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				AlumCiclo alumCiclo = new AlumCiclo();
				alumCiclo.mapeaReg(rs);
				lisAlumCiclo.add(alumCiclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCicloLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisAlumCiclo;
		
	}
	
	public ArrayList<AlumCiclo> getArrayListInscritos(Connection conn, String cicloId, String orden ) throws SQLException{
		
		ArrayList<AlumCiclo> lisAlumCiclo	= new ArrayList<AlumCiclo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
	
		
		try{
			comando = "SELECT * FROM ALUM_CICLO"+
				" WHERE CICLO_ID = '"+cicloId+"'" +
				" AND ESTADO = 'I' "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumCiclo alumCiclo = new AlumCiclo();
				alumCiclo.mapeaReg(rs);
				lisAlumCiclo.add(alumCiclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCicloLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisAlumCiclo;		
	}
	
	public ArrayList<AlumCiclo> listCiclosConMaterias(Connection conn, String codigoId, String planId, String tipos, String orden ) throws SQLException{

		
		ArrayList<AlumCiclo> lisAlumCiclo	= new ArrayList<AlumCiclo>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";	
		
		try{
			comando = "SELECT * FROM ALUM_CICLO"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " AND PLAN_ID = '"+planId+"'"
					+ " AND CICLO_ID IN "
					+ "		(SELECT SUBSTR(CICLO_GRUPO_ID,1,8) FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' AND TIPOCAL_ID IN ("+tipos+")) "
					+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumCiclo alumCiclo = new AlumCiclo();
				alumCiclo.mapeaReg(rs);
				lisAlumCiclo.add(alumCiclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumCicloLista|listCiclosConMaterias|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisAlumCiclo;		
	}
	
	public static HashMap<String,AlumCiclo> getMapHistoria(Connection conn, String orden ) throws SQLException{
		
		HashMap<String,AlumCiclo> mapPais = new HashMap<String,AlumCiclo>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_ID, ESTADO, PERIODO_ID, " +
					" CLASFIN_ID, PLAN_ID, FECHA, NIVEL, GRADO, GRUPO FROM ALUM_CICLO" +
					" WHERE ESTADO = 'I'  "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				AlumCiclo ciclo = new AlumCiclo();
				ciclo.mapeaReg(rs);
				llave = ciclo.getCodigoId()+ciclo.getCicloId()+ciclo.getPeriodoId();
				mapPais.put(llave, ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.AlumCiclo|getMapAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapPais;
	}
	
	public static HashMap<String,String> mapCuentaInscritos(Connection conn, String cicloId ) throws SQLException{
		
		HashMap<String,String> mapa = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT NIVEL, GRADO, GRUPO, COALESCE(COUNT(CODIGO_ID),0) AS TOTAL FROM ALUM_CICLO"
					+ " WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND ESTADO = 'I'"
					+ " GROUP BY NIVEL, GRADO, GRUPO ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				llave = rs.getString("NIVEL")+rs.getString("GRADO")+rs.getString("GRUPO");
				mapa.put(llave, rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.AlumCiclo|mapCuentaInscritos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapa;
	}
	
	public static HashMap<String,String> mapCuentaGenero(Connection conn, String cicloId ) throws SQLException{
		
		HashMap<String,String> mapa = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT NIVEL, GRADO, GRUPO, ALUM_GENERO(CODIGO_ID) AS GENERO, COALESCE(COUNT(CODIGO_ID),0) AS TOTAL FROM ALUM_CICLO"
					+ " WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND ESTADO = 'I'"
					+ " GROUP BY NIVEL, GRADO, GRUPO, ALUM_GENERO(CODIGO_ID)";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				llave = rs.getString("NIVEL")+rs.getString("GRADO")+rs.getString("GRUPO")+rs.getString("GENERO");
				mapa.put(llave, rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.AlumCiclo|mapCuentaGenero|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapa;
	}
	
	public static HashMap<String,String> mapCuentaClasificacion(Connection conn, String cicloId ) throws SQLException{
		
		HashMap<String,String> mapa = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT NIVEL, GRADO, GRUPO, CLASFIN_ID, COALESCE(COUNT(CODIGO_ID),0) AS TOTAL FROM ALUM_CICLO"
					+ " WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND ESTADO = 'I'"
					+ " GROUP BY NIVEL, GRADO, GRUPO, CLASFIN_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				llave = rs.getString("NIVEL")+rs.getString("GRADO")+rs.getString("GRUPO")+rs.getString("CLASFIN_ID");
				mapa.put(llave, rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.AlumCiclo|mapCuentaClasificacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapa;
	}
	
	public static HashMap<String,String> mapInscritos(Connection conn, String cicloId, String periodoId) throws SQLException{
			
			HashMap<String,String> mapa = new HashMap<String,String>();
			Statement st 				= conn.createStatement();
			ResultSet rs 				= null;
			String comando				= "";
			String llave				= "";
			
			try{
				comando = "SELECT *" 
							+" FROM ALUM_CICLO"
							+" WHERE CICLO_ID = '"+cicloId+"'"
							+" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')";
					
				rs = st.executeQuery(comando);
				while (rs.next()){				
					llave = rs.getString("CODIGO_ID");
					mapa.put(llave, rs.getString("ESTADO"));
				}
				
			}catch(Exception ex){
				System.out.println("Error - aca.ciclo.AlumCiclo|mapCuentaClasificacion|:"+ex);
			}finally{
				if (rs!=null) rs.close();
				if (st!=null) st.close();
			}
			
			return mapa;
		}
	
}

