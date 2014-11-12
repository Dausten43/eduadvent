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
			comando = "SELECT * " +
				"FROM ALUM_CICLO "+
				"WHERE CICLO_ID = '"+cicloId+"' " +
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
	
}

