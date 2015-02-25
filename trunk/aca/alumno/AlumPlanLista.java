// Clase para la tabla de Alum_Plan
package aca.alumno;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class AlumPlanLista{
		
	public ArrayList<AlumPlan> getArrayList(Connection conn, String codigoId, String orden ) throws SQLException{
		
		ArrayList<AlumPlan> lisPlan	= new ArrayList<AlumPlan>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando		= "";
		
		try{
			comando = "SELECT CODIGO_ID, PLAN_ID, " +
					  "TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO, " +
					  "TO_CHAR(F_GRADUACION,'DD/MM/YYYY') AS F_GRADUACION, " +
					  "ESTADO, GRADO, GRUPO FROM ALUM_PLAN WHERE CODIGO_ID = '"+codigoId+"' "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				AlumPlan plan = new AlumPlan();
				plan.mapeaReg(rs);
				lisPlan.add(plan);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlanLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisPlan;
	}
	
	public ArrayList<AlumPlan> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<AlumPlan> lisPlan	= new ArrayList<AlumPlan>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CODIGO_ID, PLAN_ID, " +
					  "TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO, " +
					  "TO_CHAR(F_GRADUACION,'DD/MM/YYYY') AS F_GRADUACION, " +
					  "ESTADO, GRADO, GRUPO "+ 
					"FROM ALUM_PLAN " +
					"WHERE SUBSTR(CODIGO_ID,1,3) = '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				AlumPlan plan = new AlumPlan();
				plan.mapeaReg(rs);
				lisPlan.add(plan);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlanLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisPlan;
	}
	
	public HashMap<String, AlumPlan> mapPlanActivo(Connection conn, String escuelaId) throws SQLException{
		HashMap<String, AlumPlan> map 	= new HashMap<String, AlumPlan>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = "SELECT CODIGO_ID, PLAN_ID,"
					+ " TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO,"
					+ " TO_CHAR(F_GRADUACION,'DD/MM/YYYY') AS F_GRADUACION,"
					+ " ESTADO, GRADO, GRUPO"
					+ " FROM ALUM_PLAN"
					+ " WHERE SUBSTR(CODIGO_ID,1,3) = '"+escuelaId+"'"
					+ " AND ESTADO = '1'";		
			rs = st.executeQuery(comando);
			
			while (rs.next()){
				AlumPlan plan = new AlumPlan();
				plan.mapeaReg(rs);
				map.put(plan.getCodigoId(), plan);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.alumno.AlumPlanLista|mapPlanActivo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return map;
	}
	
}

