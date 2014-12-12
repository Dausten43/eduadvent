//Clase  para la tabla CAT_PAIS
package aca.plan;

import java.sql.*;
import java.util.ArrayList;

public class PlanGradoLista {
	
	public ArrayList<PlanGrado> getListAll(Connection conn,  String orden ) throws SQLException{
		ArrayList<PlanGrado> lisCurso = new ArrayList<PlanGrado>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, GRADO, NOMBRE FROM PLAN_GRADO  "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				PlanGrado curso = new PlanGrado();			
				curso.mapeaReg(rs);
				lisCurso.add(curso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanGradoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCurso;
	}
	
	public ArrayList<PlanGrado> getListPlan(Connection conn, String plan, String orden ) throws SQLException{
		ArrayList<PlanGrado> lisCurso = new ArrayList<PlanGrado>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, GRADO, NOMBRE FROM PLAN_GRADO WHERE PLAN_ID = '"+plan+"' "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				PlanGrado curso = new PlanGrado();			
				curso.mapeaReg(rs);
				lisCurso.add(curso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanGradoLista|getListPlan|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCurso;
	}
	
}