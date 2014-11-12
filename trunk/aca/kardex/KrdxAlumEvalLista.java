/**
 * 
 */
package aca.kardex;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.TreeMap;

/**
 * @author Jose Torres
 *
 */
public class KrdxAlumEvalLista {
	public ArrayList<KrdxAlumEval> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<KrdxAlumEval> lisEval 	= new ArrayList<KrdxAlumEval>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " EVALUACION_ID, NOTA " +
                " FROM KRDX_ALUM_EVAL "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumEval kae = new KrdxAlumEval();				
				kae.mapeaReg(rs);
				lisEval.add(kae);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisEval;
	}
	
	public ArrayList<KrdxAlumEval> getListAlumMat(Connection conn, String codigoId, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		ArrayList<KrdxAlumEval> lisEval 	= new ArrayList<KrdxAlumEval>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " EVALUACION_ID, NOTA " +
                " FROM KRDX_ALUM_EVAL" +
                " WHERE CODIGO_ID = '"+codigoId+"'" +
                " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"' "+ orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumEval kae = new KrdxAlumEval();		
				kae.mapeaReg(rs);
				lisEval.add(kae);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|getListAlumMat|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisEval;
	}
	
	public TreeMap<String,KrdxAlumEval> getTreeAlumMat(Connection conn, String codigoId, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		TreeMap<String,KrdxAlumEval> treeEval 	= new TreeMap<String, KrdxAlumEval>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " EVALUACION_ID, NOTA " +
                " FROM KRDX_ALUM_EVAL" +
                " WHERE CODIGO_ID = '"+codigoId+"'" +
                " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"' "+ orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumEval kae = new KrdxAlumEval();		
				kae.mapeaReg(rs);
				treeEval.put(kae.getCodigoId()+kae.getCicloGrupoId()+kae.getCursoId()+kae.getEvaluacionId(), kae);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|getTreeAlumMat|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return treeEval;
	}
	
	public TreeMap<String,KrdxAlumEval> getTreeMateria( Connection conn, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		TreeMap<String,KrdxAlumEval> treeEval 	= new TreeMap<String, KrdxAlumEval>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " EVALUACION_ID, NOTA " +
                " FROM KRDX_ALUM_EVAL" +
                " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"' "+ orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumEval kae = new KrdxAlumEval();		
				kae.mapeaReg(rs);
				treeEval.put(kae.getCicloGrupoId()+kae.getCursoId()+kae.getEvaluacionId()+kae.getCodigoId(), kae);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|getTreeMateria|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return treeEval;
	}
	
	public TreeMap<String,KrdxAlumEval> getTreeMateria( Connection conn, String cicloGrupoId, String orden ) throws SQLException{
		TreeMap<String,KrdxAlumEval> treeEval 	= new TreeMap<String, KrdxAlumEval>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " EVALUACION_ID, NOTA " +
                " FROM KRDX_ALUM_EVAL" +
                " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+ orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumEval kae = new KrdxAlumEval();		
				kae.mapeaReg(rs);
				treeEval.put(kae.getCicloGrupoId()+kae.getCursoId()+kae.getEvaluacionId()+kae.getCodigoId(), kae);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|getTreeMateria|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return treeEval;
	}
	
	public static HashMap<String,String> getMapPromBim(Connection conn, String cicloId, String evaluacionId, String orden ) throws SQLException{
		
		HashMap<String,String> mapPais = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, " +
					" (SUM(NOTA)/COUNT(NOTA)) AS PROMEDIO " +
					" FROM KRDX_ALUM_EVAL WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = '"+cicloId+"' " +
					" AND EVALUACION_ID = '"+evaluacionId+"' " +
					" GROUP BY CICLO_GRUPO_ID  "+ orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				llave = rs.getString("CICLO_GRUPO_ID");
				mapPais.put(llave, rs.getString("PROMEDIO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|getMapPromBim|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapPais;
	}
	
	public ArrayList<String> getListaPromTopAlum(Connection conn, String cicloGrupoId, String evaluacionId ) throws SQLException{
		
		ArrayList<String> lisTopAlumnos = new ArrayList<String>();
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando	= "";
		
		try{
			comando = "SELECT DISTINCT(CODIGO_ID) AS CODIGO_ID," +
					" ALUM_APELLIDO(CODIGO_ID) AS NOMBRE ," +
					" (SELECT (SUM(NOTA)/COUNT(NOTA)) " +
					"   FROM KRDX_ALUM_EVAL WHERE CICLO_GRUPO_ID = KRDX_CURSO_ACT.CICLO_GRUPO_ID " +
					"   AND CODIGO_ID = KRDX_CURSO_ACT.CODIGO_ID " +
					"   AND EVALUACION_ID = '"+evaluacionId+"') AS PROM " +
					" FROM KRDX_CURSO_ACT WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' ORDER BY 3 DESC ";
			
			rs = st.executeQuery(comando);
			
				while (rs.next()){
					lisTopAlumnos.add(rs.getString("CODIGO_ID")+"@"+rs.getString("NOMBRE")+"@"+rs.getString("PROM"));
				}
		
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|getListaPromTopAlum|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisTopAlumnos;
	}
	
	public static HashMap<String,String> getMapPromMaestro(Connection conn, String cicloId, String evaluacionId, String orden ) throws SQLException{
		
		HashMap<String,String> mapPais = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT CODIGO_ID," +
					" ( " +
					" SELECT" +
					" ( COALESCE(SUM(NOTA),1) / ( CASE COUNT(NOTA) WHEN 0 THEN 1 ELSE COUNT(NOTA) END) )" +
					" FROM KRDX_ALUM_EVAL  " +
					" WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = '"+cicloId+"'" +
					" AND EVALUACION_ID = '"+evaluacionId+"' " +
					" AND CICLO_GRUPO_ID || CURSO_ID IN (SELECT CICLO_GRUPO_ID||CURSO_ID " +
					"   FROM CICLO_GRUPO_CURSO WHERE EMPLEADO_ID = EMP_PERSONAL.CODIGO_ID)) AS PROMEDIO" +
					" FROM EMP_PERSONAL " +
					" WHERE EXISTS (SELECT EMPLEADO_ID FROM CICLO_GRUPO_CURSO " +
					"   WHERE EMPLEADO_ID = EMP_PERSONAL.CODIGO_ID AND SUBSTR(CICLO_GRUPO_ID,1,8) = '"+cicloId+"') " + orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				llave = rs.getString("CODIGO_ID");
				mapPais.put(llave, rs.getString("PROMEDIO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|getMapPromMaestro|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapPais;
	}
	
	public static HashMap<String,String> getMapPromMaestroMateria(Connection conn, String cicloId, String evaluacionId, String orden ) throws SQLException{
		
		HashMap<String,String> mapPais = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT EMPLEADO_ID, CICLO_GRUPO_ID, CURSO_ID, " +
					"   (SELECT (COALESCE(SUM(NOTA),1) / ( CASE COUNT(NOTA) WHEN 0 THEN 1 ELSE COUNT(NOTA) END) ) " +
					"		FROM KRDX_ALUM_EVAL WHERE CICLO_GRUPO_ID = CGC.CICLO_GRUPO_ID AND CURSO_ID = CGC.CURSO_ID AND EVALUACION_ID = '"+evaluacionId+"') AS PROMEDIO" +
					" 	FROM CICLO_GRUPO_CURSO AS CGC " +
					" 	WHERE SUBSTR(CICLO_GRUPO_ID,1,8) = '"+cicloId+"' " + orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				llave = rs.getString("EMPLEADO_ID")+rs.getString("CICLO_GRUPO_ID")+rs.getString("CURSO_ID");
				mapPais.put(llave, rs.getString("PROMEDIO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|getMapPromMaestroMateria|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return mapPais;
	}
	
	public ArrayList<KrdxAlumEval> getReprobones(Connection conn, String cursoId, String cicloGrupoId, String evaluacionId, String orden ) throws SQLException{
		ArrayList<KrdxAlumEval> lisEval 	= new ArrayList<KrdxAlumEval>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * " +
					" FROM KRDX_ALUM_EVAL " +
					" WHERE CURSO_ID = '"+cursoId+"'" +
					" AND CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND EVALUACION_ID = "+evaluacionId+" " +
					" AND NOTA < (SELECT NOTA_AC FROM PLAN_CURSO WHERE CURSO_ID = KRDX_ALUM_EVAL.CURSO_ID) "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumEval kae = new KrdxAlumEval();				
				kae.mapeaReg(rs);
				lisEval.add(kae);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|getReprobones|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisEval;
	}
	
	public static HashMap<String, String> mapAlumnosReprobonesCicloGrupoId(Connection conn, String cicloId, String evaluacionId) throws SQLException{
		HashMap<String,String> map 			= new HashMap<String, String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, COUNT( DISTINCT(CODIGO_ID) ) AS CANTIDAD"
					+ " FROM KRDX_ALUM_EVAL"
					+ " WHERE CICLO_GRUPO_ID LIKE '"+cicloId+"%'"
					+ " AND EVALUACION_ID = "+evaluacionId+" "
					+ " AND NOTA < (SELECT NOTA_AC FROM PLAN_CURSO WHERE CURSO_ID = KRDX_ALUM_EVAL.CURSO_ID)"
					+ " GROUP BY CICLO_GRUPO_ID ";
			rs = st.executeQuery(comando);			
			while (rs.next()){				 				
				map.put(rs.getString("CICLO_GRUPO_ID"), rs.getString("CANTIDAD"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|mapAlumnosReprobonesCicloGrupoId|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}	
	
	
	public static HashMap<String, String> mapAlumnosEvaluadosCiclo(Connection conn, String cicloId) throws SQLException{
		HashMap<String,String> map 			= new HashMap<String, String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT EVALUACION_ID, COUNT(CODIGO_ID) AS CANTIDAD FROM KRDX_ALUM_EVAL"
					+ " WHERE SUBSTR(CICLO_GRUPO_ID, 0, 9) = '"+cicloId+"'"
					+ " GROUP BY EVALUACION_ID ";
			rs = st.executeQuery(comando);			
			while (rs.next()){				 				
				map.put(rs.getString("EVALUACION_ID"), rs.getString("CANTIDAD"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxCursoActLista|mapAlumnosEvaluadosCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}	
	
}
