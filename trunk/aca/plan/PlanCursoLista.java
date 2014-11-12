//Clase  para la tabla CAT_PAIS
package aca.plan;

import java.sql.*;
import java.util.ArrayList;

public class PlanCursoLista {
	
	public ArrayList<PlanCurso> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<PlanCurso> lisCurso = new ArrayList<PlanCurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, CURSO_ID, CURSO_NOMBRE, CURSO_CORTO, GRADO, NOTA_AC, " +
					" TIPOCURSO_ID, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION" +
					" FROM PLAN_CURSO " +
					" WHERE PLAN_ID IN (SELECT PLAN_ID FROM PLAN WHERE ESCUELA_ID = '"+escuelaId+"' ) "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				PlanCurso curso = new PlanCurso();			
				curso.mapeaReg(rs);
				lisCurso.add(curso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCursoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCurso;
	}
	
	
	public ArrayList<PlanCurso> getListCurso(Connection conn, String planId, String orden ) throws SQLException{
		ArrayList<PlanCurso> lisCurso = new ArrayList<PlanCurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, CURSO_ID, CURSO_NOMBRE, CURSO_CORTO, GRADO, TIPOCURSO_ID," +
					" NOTA_AC, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION" +
					" FROM PLAN_CURSO WHERE PLAN_ID = '"+planId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				PlanCurso curso = new PlanCurso();			
				curso.mapeaReg(rs);
				lisCurso.add(curso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCursoLista|getListCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCurso;
	}
	
	public ArrayList<PlanCurso> getListCursoActivo(Connection conn, String planId, String orden ) throws SQLException{
		ArrayList<PlanCurso> lisCurso = new ArrayList<PlanCurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, CURSO_ID, CURSO_NOMBRE, CURSO_CORTO, GRADO, TIPOCURSO_ID," +
					" NOTA_AC, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION" +
					" FROM PLAN_CURSO WHERE ESTADO = 'A' AND PLAN_ID = '"+planId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				PlanCurso curso = new PlanCurso();			
				curso.mapeaReg(rs);
				lisCurso.add(curso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCursoLista|getListCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCurso;
	}
	
	public ArrayList<PlanCurso> getListCursoGrado(Connection conn, String planId, String grado, String orden ) throws SQLException{
		ArrayList<PlanCurso> lisCurso = new ArrayList<PlanCurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, CURSO_ID, CURSO_NOMBRE, CURSO_CORTO," +
					" GRADO, TIPOCURSO_ID, NOTA_AC, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION" +
					" FROM PLAN_CURSO WHERE PLAN_ID = '"+planId+"' AND GRADO = TO_NUMBER('"+grado+"','99')  " +
					"AND CURSO_ID IN (SELECT CURSO_ID FROM CICLO_GRUPO_CURSO WHERE CURSO_ID = PLAN_CURSO.CURSO_ID)" + orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				PlanCurso curso = new PlanCurso();			
				curso.mapeaReg(rs);
				lisCurso.add(curso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCursoLista|getListCursoGrado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCurso;
	}
	
	
}