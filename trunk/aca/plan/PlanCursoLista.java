//Clase  para la tabla CAT_PAIS
package aca.plan;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class PlanCursoLista {
	
	public ArrayList<PlanCurso> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<PlanCurso> lisCurso = new ArrayList<PlanCurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, CURSO_ID, CURSO_NOMBRE, CURSO_CORTO, GRADO, NOTA_AC, " +
					" TIPOCURSO_ID, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION, ASPECTOS, CURSO_BASE, BOLETA" +
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
					" NOTA_AC, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION, ASPECTOS, CURSO_BASE, BOLETA" +
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
					" NOTA_AC, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION, ASPECTOS, CURSO_BASE, BOLETA" +
					" FROM PLAN_CURSO WHERE ESTADO = 'A' AND PLAN_ID = '"+planId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				PlanCurso curso = new PlanCurso();			
				curso.mapeaReg(rs);
				lisCurso.add(curso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCursoLista|getListCursoActivo|:"+ex);
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
					" GRADO, TIPOCURSO_ID, NOTA_AC, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION, ASPECTOS, CURSO_BASE, BOLETA" +
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
	
	public ArrayList<PlanCurso> getCursosPorGrado(Connection conn, String planId, String grado, String orden ) throws SQLException{
		ArrayList<PlanCurso> lisCurso = new ArrayList<PlanCurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PLAN_ID, CURSO_ID, CURSO_NOMBRE, CURSO_CORTO," +
					" GRADO, TIPOCURSO_ID, NOTA_AC, FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION, ASPECTOS, CURSO_BASE, BOLETA" +
					" FROM PLAN_CURSO WHERE PLAN_ID = '"+planId+"' AND GRADO = TO_NUMBER('"+grado+"','99')  " + orden;
					
			
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
	
	public ArrayList<PlanCurso> getMateriasHijas( Connection conn, String cursoBase) throws SQLException, Exception{
		ArrayList<PlanCurso> lisCurso = new ArrayList<PlanCurso>();
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;	
		
		try{
			ps = conn.prepareStatement("SELECT * FROM PLAN_CURSO WHERE CURSO_BASE = ?");					
			ps.setString(1, cursoBase);
			rs = ps.executeQuery();
			while (rs.next()){
				PlanCurso curso = new PlanCurso();			
				curso.mapeaReg(rs);
				lisCurso.add(curso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCursoLista|getMateriasHijas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}			
		return lisCurso;
	}

	
	public static boolean esMateriaMadre( Connection conn, String cursoId) throws SQLException, Exception{
		boolean esMateriaMadre 	= true;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;	
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS TOTAL FROM PLAN_CURSO WHERE CURSO_ID= ? AND CURSO_BASE ='-' ");					
			ps.setString(1, cursoId);
			rs = ps.executeQuery();
			while (rs.next()){
				if(rs.getString("TOTAL").equals("0")){
					esMateriaMadre=false;
				}
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCursoLista|esMateriaMadre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}			
		return esMateriaMadre;
	}
	
	public static boolean esMateriaMadreDeIngles( Connection conn, String cursoBase) throws SQLException, Exception{
		boolean esMateriaMadreDeIngles 	= true;
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;	
		
		try{
			ps = conn.prepareStatement("SELECT COUNT(*) AS TOTAL FROM PLAN_CURSO"
					+ " WHERE CURSO_BASE = ?"
					+ " AND TIPOCURSO_ID = 3");					
			ps.setString(1, cursoBase);
			rs = ps.executeQuery();
			while (rs.next()){
				if(rs.getString("TOTAL").equals("0")){
					esMateriaMadreDeIngles=false;
				}
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCursoLista|esMateriaMadreDeIngles|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}			
		return esMateriaMadreDeIngles;
	}
		
	
	public static HashMap<String,PlanCurso> mapPlanCursos(Connection conn, String planId ) throws SQLException{
		
		HashMap<String,PlanCurso> mapa = new HashMap<String,PlanCurso>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";		
		
		try{
			comando = " SELECT PLAN_ID, CURSO_ID, CURSO_NOMBRE, CURSO_CORTO, GRADO, TIPOCURSO_ID, NOTA_AC,"
					+ " FALTA, CONDUCTA, ORDEN, PUNTO, HORAS, CREDITOS, ESTADO, TIPO_EVALUACION, ASPECTOS, CURSO_BASE, BOLETA"
					+ " FROM PLAN_CURSO WHERE PLAN_ID = '"+planId+"'";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				PlanCurso curso = new PlanCurso();
				curso.mapeaReg(rs);				
				mapa.put(curso.getCursoId(), curso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.plan.PlanCursoLista|mapPlanCursos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapa;
	}
	
	
}