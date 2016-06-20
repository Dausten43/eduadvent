//Clase  para la tabla CICLO
package aca.ciclo;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class CicloGrupoEvalLista {
	
	public ArrayList<CicloGrupoEval> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		
		ArrayList<CicloGrupoEval> lisGrupoEval = new ArrayList<CicloGrupoEval>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT "+
				" CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, EVALUACION_NOMBRE,"+
				" TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, VALOR, TIPO, ESTADO, CALCULO, ORDEN, PROMEDIO_ID"+
				" FROM CICLO_GRUPO_EVAL" +
				" WHERE SUBSTR(CICLO_GRUPO_ID,1,3) = '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoEval evaluacion = new CicloGrupoEval();				
				evaluacion.mapeaReg(rs);
				lisGrupoEval.add(evaluacion);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoEvalLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisGrupoEval;
	}
	
	public ArrayList<CicloGrupoEval> getArrayList(Connection conn, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		ArrayList<CicloGrupoEval> lisGrupoEval = new ArrayList<CicloGrupoEval>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT "+
				" CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, EVALUACION_NOMBRE,"+
				" TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, VALOR, TIPO, ESTADO, CALCULO, ORDEN, PROMEDIO_ID"+
				" FROM CICLO_GRUPO_EVAL"+
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+
				" AND CURSO_ID = '"+cursoId+"' "+orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				CicloGrupoEval evaluacion = new CicloGrupoEval();				
				evaluacion.mapeaReg(rs);
				lisGrupoEval.add(evaluacion);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoLista|getArrayList|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisGrupoEval;
	}
	
	public ArrayList<CicloGrupoEval> getArrayListPorPromedio(Connection conn, String cicloGrupoId, String cursoId, String promedioId, String orden ) throws SQLException{
		ArrayList<CicloGrupoEval> lisGrupoEval = new ArrayList<CicloGrupoEval>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT "+
				" CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, EVALUACION_NOMBRE,"+
				" TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, VALOR, TIPO, ESTADO, CALCULO, ORDEN, PROMEDIO_ID"+
				" FROM CICLO_GRUPO_EVAL"+
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+
				" AND CURSO_ID = '"+cursoId+"' AND PROMEDIO_ID = TO_NUMBER('"+promedioId+"', '99') "+orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				CicloGrupoEval evaluacion = new CicloGrupoEval();				
				evaluacion.mapeaReg(rs);
				lisGrupoEval.add(evaluacion);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoLista|getArrayListPorPromedio|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisGrupoEval;
	}
	
	public ArrayList<CicloGrupoEval> getEvalGrupo(Connection conn, String cicloGrupoId, String orden ) throws SQLException{
		ArrayList<CicloGrupoEval> lisGrupoEval = new ArrayList<CicloGrupoEval>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT "+
				" CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, EVALUACION_NOMBRE,"+
				" TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, VALOR, TIPO, ESTADO, CALCULO, ORDEN, PROMEDIO_ID"+
				" FROM CICLO_GRUPO_EVAL"+
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				CicloGrupoEval evaluacion = new CicloGrupoEval();
				evaluacion.mapeaReg(rs);
				lisGrupoEval.add(evaluacion);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoLista|getEvalGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisGrupoEval;
	}
	
	public static HashMap<String,CicloGrupoEval> getMapConducta(Connection conn, String cicloGrupoId, String cursoId, String planId ) throws SQLException{
		
		HashMap<String,CicloGrupoEval> map 	= new HashMap<String,CicloGrupoEval>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		String llave						= "";
		
		try{
			comando = " SELECT * FROM CICLO_GRUPO_EVAL " +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' " +
					" AND CURSO_ID = (" +
					" SELECT CURSO_ID FROM PLAN_CURSO " +
					" WHERE CURSO_ID = '"+cursoId+"' " +
					" AND PLAN_ID = '"+planId+"'" +
					" AND CONDUCTA = 'S' ) ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoEval cicloGrupo = new CicloGrupoEval();
				cicloGrupo.mapeaReg(rs);
				llave = cicloGrupo.getEvaluacionId();
				map.put(llave, cicloGrupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEvalLista|getMapConducta|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String,String> mapMateriasPorBloque(Connection conn, String cicloId, String nivelId, String tipo ) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = "SELECT EVALUACION_ID, COALESCE(COUNT(*),0) AS TOTAL " +
					" FROM CICLO_GRUPO_EVAL" +
					" WHERE CICLO_GRUPO_ID IN (SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO WHERE CICLO_ID = '"+cicloId+"' AND NIVEL_ID = "+nivelId+")" +
					" AND ESTADO IN("+tipo+")" +
					" GROUP BY EVALUACION_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("EVALUACION_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEvalLista|mapNumMaterias|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String,String> mapEvalPorMaestro(Connection conn, String cicloId, String nivelId, String tipo ) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";		
		
		try{
			comando = " SELECT GRUPOCURSO_EMPLEADO(CICLO_GRUPO_ID, CURSO_ID) AS EMPLEADO, COALESCE(COUNT(EVALUACION_ID),0) AS TOTAL" +
					" FROM CICLO_GRUPO_EVAL" +
					" WHERE CICLO_GRUPO_ID IN (SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO WHERE CICLO_ID = '"+cicloId+"' AND NIVEL_ID = "+nivelId+")" +
					" AND ESTADO = '"+tipo+"'" +
					" GROUP BY GRUPOCURSO_EMPLEADO(CICLO_GRUPO_ID, CURSO_ID)";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("EMPLEADO"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEvalLista|mapEvalPorMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String,String> mapEvalPorBloque(Connection conn, String cicloId, String nivelId, String tipo ) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		String llave						= "";
		
		try{
			comando = " SELECT GRUPOCURSO_EMPLEADO(CICLO_GRUPO_ID, CURSO_ID) AS EMPLEADO, EVALUACION_ID, COALESCE(COUNT(EVALUACION_ID),0) AS TOTAL" +
					" FROM CICLO_GRUPO_EVAL" +
					" WHERE CICLO_GRUPO_ID IN (SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO WHERE CICLO_ID = '"+cicloId+"' AND NIVEL_ID = "+nivelId+")" +
					" AND ESTADO = '"+tipo+"'" +
					" GROUP BY GRUPOCURSO_EMPLEADO(CICLO_GRUPO_ID, CURSO_ID), EVALUACION_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				llave = rs.getString("EMPLEADO")+rs.getString("EVALUACION_ID");
				map.put(llave, rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEvalLista|mapEvalPorBloque|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String,String> mapTotMatBloque(Connection conn, String cicloId, String nivelId, String tipo ) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";	
		
		try{
			comando = "SELECT EVALUACION_ID, COALESCE(COUNT(*),0) AS TOTAL" +
					" FROM CICLO_GRUPO_EVAL" +
					" WHERE CICLO_GRUPO_ID IN (SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO WHERE CICLO_ID = '"+cicloId+"' AND NIVEL_ID = "+nivelId+")" +					
					" AND ESTADO IN ("+tipo+")" +
					" GROUP BY EVALUACION_ID";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("EVALUACION_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEvalLista|mapTotMatBloque|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String,CicloGrupoEval> mapEvalAlumno(Connection conn, String codigoId ) throws SQLException{
		
		HashMap<String,CicloGrupoEval> map 	= new HashMap<String,CicloGrupoEval>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		String llave						= "";
		
		try{
			comando = " SELECT * FROM CICLO_GRUPO_EVAL"
					+ " WHERE CICLO_GRUPO_ID IN"
					+ "		(SELECT CICLO_GRUPO_ID FROM KRDX_ALUM_EVAL WHERE CODIGO_ID = '"+codigoId+"')";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoEval cicloGrupo = new CicloGrupoEval();
				cicloGrupo.mapeaReg(rs);
				llave = cicloGrupo.getCicloGrupoId()+cicloGrupo.getCursoId()+cicloGrupo.getEvaluacionId();
				map.put(llave, cicloGrupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEvalLista|mapEvalAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String,CicloGrupoEval> mapEvalCurso(Connection conn, String cicloGrupoId, String cursoId ) throws SQLException{
		
		HashMap<String,CicloGrupoEval> map 	= new HashMap<String,CicloGrupoEval>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		String llave						= "";
		
		try{
			comando = " SELECT * FROM CICLO_GRUPO_EVAL"
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'"
					+ " AND CURSO_ID = '"+cursoId+"'";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoEval cicloGrupo = new CicloGrupoEval();
				cicloGrupo.mapeaReg(rs);
				llave = cicloGrupo.getCicloGrupoId()+cicloGrupo.getCursoId()+cicloGrupo.getEvaluacionId();
				map.put(llave, cicloGrupo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoEvalLista|mapEvalCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	// SELECT * FROM CICLO_GRUPO_EVAL WHERE CICLO_GRUPO_ID IN (SELECT CICLO_GRUPO_ID FROM KRDX_ALUM_EVAL WHERE CODIGO_ID = 'A1106057');
	
}