//Clase  para la tabla CICLO
package aca.ciclo;

import java.sql.*;
import java.util.ArrayList;
import java.util.TreeMap;
import java.util.HashMap;


public class CicloGrupoCursoLista {
	
	public ArrayList<CicloGrupoCurso> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CicloGrupoCurso> lisCicloGrupoCurso 	= new ArrayList<CicloGrupoCurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID, HORARIO, SALON_ID, ESTADO " +
					"FROM CICLO_GRUPO_CURSO "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloGrupoCurso ciclo = new CicloGrupoCurso();	
				ciclo.mapeaReg(rs);
				lisCicloGrupoCurso.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}			
		
		return lisCicloGrupoCurso;
	}
	
	public ArrayList<CicloGrupoCurso> getListMateriasGrupo(Connection conn, String cicloId, String nivel, String grado, String grupo, String orden ) throws SQLException{
		ArrayList<CicloGrupoCurso> lisCicloGrupoCurso 	= new ArrayList<CicloGrupoCurso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID, HORARIO, SALON_ID, ESTADO " +
					"FROM CICLO_GRUPO_CURSO " +
					"WHERE CICLO_GRUPO_ID = " +
					"	(SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO " +
					"	WHERE CICLO_ID = '"+cicloId+"' AND NIVEL_ID = "+nivel+" " +
					"	AND GRADO = "+grado+" AND GRUPO = '"+grupo+"') "+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CicloGrupoCurso ciclo = new CicloGrupoCurso();				
				ciclo.mapeaReg(rs);
				lisCicloGrupoCurso.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|getListMateriasGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCicloGrupoCurso;
	}
	
	public ArrayList<CicloGrupoCurso> getListMateriasGrupo(Connection conn, String cicloGrupoId, String orden ) throws SQLException{
		ArrayList<CicloGrupoCurso> lisCicloGrupoCurso 	= new ArrayList<CicloGrupoCurso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID, HORARIO, SALON_ID, ESTADO " +
					"FROM CICLO_GRUPO_CURSO " +					
					"WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+orden;
			rs = st.executeQuery(comando);
			
			while (rs.next()){				
				CicloGrupoCurso ciclo = new CicloGrupoCurso();				
				ciclo.mapeaReg(rs);
				lisCicloGrupoCurso.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|getListMateriasGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCicloGrupoCurso;
	}
	
	public ArrayList<CicloGrupoCurso> getListMateriasGrupo(Connection conn, String codigoId, String cicloGrupoId, String orden ) throws SQLException{
		ArrayList<CicloGrupoCurso> lisCicloGrupoCurso 	= new ArrayList<CicloGrupoCurso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID, HORARIO, SALON_ID, ESTADO" +
					" FROM CICLO_GRUPO_CURSO" +					
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND CICLO_GRUPO_ID||CURSO_ID IN " +
					"	(SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"') "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){				
				CicloGrupoCurso ciclo = new CicloGrupoCurso();				
				ciclo.mapeaReg(rs);
				lisCicloGrupoCurso.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|getListMateriasGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCicloGrupoCurso;
	}
	
	public TreeMap<String, CicloGrupoCurso> getTreeMateriasPlan(Connection conn, String cicloId, String planId, String orden ) throws SQLException{
		
		TreeMap<String,CicloGrupoCurso> treeGrupoCurso 	= new TreeMap<String,CicloGrupoCurso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		String llave		= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID, HORARIO, SALON_ID, ESTADO" +
					" FROM CICLO_GRUPO_CURSO" +
					" WHERE CICLO_GRUPO_ID IN " +
					"	(SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO" +
					"	WHERE CICLO_ID = '"+cicloId+"'" +
					"	AND PLAN_ID = '"+planId+"') "+orden;
			rs = st.executeQuery(comando);
			
			while (rs.next()){				
				CicloGrupoCurso curso = new CicloGrupoCurso();
				curso.mapeaReg(rs);
				llave = curso.getCicloGrupoId()+curso.getCursoId();
				treeGrupoCurso.put(llave,curso);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|getTreeMateriasGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return treeGrupoCurso;
	}
	
	public ArrayList<CicloGrupoCurso> getListMateriasEmpleado(Connection conn, String cicloId, String empleadoId, String orden ) throws SQLException{
		ArrayList<CicloGrupoCurso> lisCicloGrupoCurso 	= new ArrayList<CicloGrupoCurso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID, HORARIO, SALON_ID, ESTADO " +
					" FROM CICLO_GRUPO_CURSO " +
					" WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = '"+cicloId+"' " +
					" AND EMPLEADO_ID = '"+empleadoId+"' "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoCurso ciclo = new CicloGrupoCurso();				
				ciclo.mapeaReg(rs);
				lisCicloGrupoCurso.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|getListMateriasEmpleado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return lisCicloGrupoCurso;
	}
	
	public ArrayList<CicloGrupoCurso> getAlumCursosAsignados(Connection conn, String cicloGrupoId, String codigoId, String orden ) throws SQLException{
		ArrayList<CicloGrupoCurso> lisGrupoCurso 	= new ArrayList<CicloGrupoCurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID, HORARIO, SALON_ID, ESTADO"+
			" FROM CICLO_GRUPO_CURSO" +			
			" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
			" AND CICLO_GRUPO_ID||CURSO_ID IN" +
			"	(SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_CURSO_ACT" +
			"	WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
			"	AND CODIGO_ID = '"+codigoId+"') "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloGrupoCurso ciclo = new CicloGrupoCurso();				
				ciclo.mapeaReg(rs);
				lisGrupoCurso.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|getAlumCursosAsignados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();	
		}
		
		return lisGrupoCurso;
	}
	
	public ArrayList<CicloGrupoCurso> getAlumCursosDisponibles(Connection conn, String cicloGrupoId, String codigoId, String orden ) throws SQLException{
		ArrayList<CicloGrupoCurso> lisGrupoCurso 	= new ArrayList<CicloGrupoCurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID, HORARIO, SALON_ID, ESTADO"+
			" FROM CICLO_GRUPO_CURSO" +			
			" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
			" AND CICLO_GRUPO_ID||CURSO_ID NOT IN" +
			"	(SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_CURSO_ACT" +
			"	WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
			"	AND CODIGO_ID = '"+codigoId+"') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloGrupoCurso ciclo = new CicloGrupoCurso();				
				ciclo.mapeaReg(rs);
				lisGrupoCurso.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|getAlumCursosDisponibles|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();	
		}
		
		return lisGrupoCurso;
	}
	
	public ArrayList<CicloGrupoCurso> getListMateriasEmpleadoxNivel(Connection conn, String cicloId, String empleadoId,String nivelId, String orden ) throws SQLException{
		ArrayList<CicloGrupoCurso> lisCicloGrupoCurso 	= new ArrayList<CicloGrupoCurso>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID, HORARIO, SALON_ID, ESTADO " +
					" FROM CICLO_GRUPO_CURSO " +
					" WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = '"+cicloId+"' " +
					" AND EMPLEADO_ID = '"+empleadoId+"' " +
				    " AND CICLO_GRUPO_ID IN " +
				    "  (SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO WHERE NIVEL_ID = '"+nivelId+"')" +orden;
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoCurso ciclo = new CicloGrupoCurso();				
				ciclo.mapeaReg(rs);
				lisCicloGrupoCurso.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCursoLista|getListMateriasEmpleado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
	
		return lisCicloGrupoCurso;
	}
	
	public ArrayList<CicloGrupoCurso> getReprobonesPorMaterias(Connection conn, String cicloId, String bloqueId, String orden ) throws SQLException{
		
		ArrayList<CicloGrupoCurso> map 	= new ArrayList<CicloGrupoCurso>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{// EL NUMERO DE REPROBADOS SE PONDRA EN LA COLUMNA 'HORARIO'
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EMPLEADO_ID," +
					" SALON_ID, ESTADO, " +
					" (SELECT COUNT(CURSO_ID) FROM KRDX_ALUM_EVAL WHERE CURSO_ID = CICLO_GRUPO_CURSO.CURSO_ID AND CICLO_GRUPO_ID = CICLO_GRUPO_CURSO.CICLO_GRUPO_ID AND EVALUACION_ID = "+bloqueId+" AND NOTA < (SELECT NOTA_AC FROM PLAN_CURSO WHERE CURSO_ID = KRDX_ALUM_EVAL.CURSO_ID)) AS HORARIO" +
					" FROM CICLO_GRUPO_CURSO " +
					" WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = '"+cicloId+"' "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				CicloGrupoCurso obj = new CicloGrupoCurso();
				obj.mapeaReg(rs);
				map.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloGrupoCursoLista|getReprobonesPorMaterias|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String, String> mapMaestrosPorNivel(Connection conn) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";		
		
		try{
			comando = "SELECT CG.NIVEL_ID AS NIVEL, COUNT(DISTINCT(CGC.EMPLEADO_ID)) AS TOTAL" +
					" FROM CICLO_GRUPO AS CG, CICLO_GRUPO_CURSO AS CGC" +					
					" WHERE CG.CICLO_GRUPO_ID = CGC.CICLO_GRUPO_ID" +
					" GROUP BY CG.NIVEL_ID";						
					
			rs = st.executeQuery(comando);
			
			while (rs.next()){				
				map.put(rs.getString("NIVEL"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|mapMaestrosPorNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return map;
	}
	
	public static HashMap<String, String> mapTotMatPorMaestro(Connection conn, String cicloId, String nivelId) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";		
		
		try{
			comando = "SELECT"+
				" EMPLEADO_ID, COALESCE(COUNT(DISTINCT(CICLO_GRUPO_ID||CURSO_ID)),0) AS TOTAL"+ 
				" FROM CICLO_GRUPO_CURSO"+
				" WHERE CICLO_GRUPO_ID IN (SELECT CICLO_GRUPO_ID FROM CICLO_GRUPO WHERE CICLO_ID = '"+cicloId+"' AND NIVEL_ID = "+nivelId+")" +	
				" GROUP BY EMPLEADO_ID";
					
			rs = st.executeQuery(comando);
			
			while (rs.next()){				
				map.put(rs.getString("EMPLEADO_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|mapTotMatPorMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}				
		
		return map;
	}
	
	
	public ArrayList<CicloGrupoCurso> getListGruposDelCiclo(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloGrupoCurso> lis 	= new ArrayList<CicloGrupoCurso>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM CICLO_GRUPO_CURSO"
					+ " WHERE CICLO_GRUPO_ID LIKE '"+cicloId+"%' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloGrupoCurso obj = new CicloGrupoCurso();			
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoCursoLista|getListGruposDelCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lis;
	}
	
}