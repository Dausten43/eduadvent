//Clase  para la tabla CAT_PAIS
package aca.plan;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class PlanLista {
	public ArrayList<Plan> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<Plan> lisPlan 	= new ArrayList<Plan>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, PLAN_NOMBRE, NIVEL_ID, ESCUELA_ID, ESTADO, VALIDA_HORARIO, TITULO FROM PLAN" +
					" WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Plan plan = new Plan();	
				plan.mapeaReg(rs);
				lisPlan.add(plan);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisPlan;
	}
	
	public ArrayList<Plan> getListEscuela(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<Plan> lisPlan 	= new ArrayList<Plan>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, PLAN_NOMBRE, NIVEL_ID, ESCUELA_ID, ESTADO, VALIDA_HORARIO, TITULO FROM PLAN " +
					"WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Plan plan = new Plan();	
				plan.mapeaReg(rs);
				lisPlan.add(plan);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisPlan;
	}
	
	public ArrayList<Plan> getListPlanPermiso(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<Plan> lisPlan 	= new ArrayList<Plan>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		String escuelaId = cicloId.substring(0, 3);
		
		try{
			comando = "SELECT * FROM PLAN WHERE ESCUELA_ID = '"+escuelaId+"' " +
					"AND NIVEL_ID IN (SELECT NIVEL_ID FROM CICLO_PERMISO WHERE CICLO_ID = '"+cicloId+"');";			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Plan plan = new Plan();	
				plan.mapeaReg(rs);
				lisPlan.add(plan);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisPlan;
	}
	
	public ArrayList<Plan> getListNivel(Connection conn, String nivelId, String orden ) throws SQLException{
		ArrayList<Plan> lisPlan 	= new ArrayList<Plan>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, PLAN_NOMBRE, NIVEL_ID, ESCUELA_ID, ESTADO, VALIDA_HORARIO, TITULO FROM PLAN WHERE NIVEL_ID = TO_NUMBER('"+nivelId+"', '99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				Plan plan = new Plan();			
				plan.mapeaReg(rs);
				lisPlan.add(plan);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanLista|getListNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisPlan;
	}
	
	public HashMap<String, Plan> mapPlanesEscuela(Connection conn, String escuelaId) throws SQLException{
		HashMap<String, Plan> map 	= new HashMap<String, Plan>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = "SELECT PLAN_ID, PLAN_NOMBRE, NIVEL_ID, ESCUELA_ID, ESTADO, VALIDA_HORARIO, TITULO FROM PLAN WHERE ESCUELA_ID = '"+escuelaId+"'";			
			rs = st.executeQuery(comando);
			
			while (rs.next()){
				Plan plan = new Plan();
				plan.mapeaReg(rs);
				map.put(plan.getPlanId(), plan);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanLista|mapPlanesEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return map;
	}
	
}