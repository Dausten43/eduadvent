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
	
	
	public ArrayList<KrdxAlumEval> getListHija(Connection conn, String cursoBase, String decimal, String redTrunc ) throws SQLException{
		ArrayList<KrdxAlumEval> lisEval 	= new ArrayList<KrdxAlumEval>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		
		
		try{
			
			if(redTrunc.equals("T")){
				comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, '"+cursoBase+"' AS CURSO_ID, EVALUACION_ID,  TRUNC(AVG(NOTA),"+decimal+") NOTA, "
						+ " TRUNC(AVG(FALTA), "+decimal+")  FALTA,  TRUNC(AVG(CONDUCTA),"+decimal+") CONDUCTA, PROMEDIO_ID"
						+ " FROM krdx_alum_eval WHERE CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE CURSO_BASE = '"+cursoBase+"')"
						+ " GROUP BY CODIGO_ID, CICLO_GRUPO_ID, EVALUACION_ID, PROMEDIO_ID ORDER BY CODIGO_ID";
			}else{
				comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, '"+cursoBase+"' AS CURSO_ID, EVALUACION_ID,  CAST(AVG(NOTA) AS DECIMAL(10,"+decimal+")) NOTA, "
						+ " CAST(AVG(FALTA) AS DECIMAL(10,"+decimal+"))  FALTA,  CAST(AVG(CONDUCTA) AS DECIMAL(10,"+decimal+")) CONDUCTA, PROMEDIO_ID"
						+ " FROM krdx_alum_eval WHERE CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE CURSO_BASE = '"+cursoBase+"')"
						+ " GROUP BY CODIGO_ID, CICLO_GRUPO_ID, EVALUACION_ID, PROMEDIO_ID ORDER BY CODIGO_ID";
				
			}
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
	
	
	public static HashMap<String, KrdxAlumEval> mapEvalAlumno(Connection conn, String codigoId) throws SQLException{
		HashMap<String,KrdxAlumEval> map 			= new HashMap<String, KrdxAlumEval>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, NOTA, FALTA, CONDUCTA, PROMEDIO_ID"
					+ " FROM KRDX_ALUM_EVAL"
					+ " WHERE CODIGO_ID = '"+codigoId+"'";
			rs = st.executeQuery(comando);			
			while (rs.next()){
				KrdxAlumEval kae = new KrdxAlumEval();		
				kae.mapeaReg(rs);
				map.put(rs.getString("CODIGO_ID")+rs.getString("CICLO_GRUPO_ID")+rs.getString("CURSO_ID")+rs.getString("EVALUACION_ID"), kae);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|mapEvalAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
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
					" AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99') " +
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
					"   AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99')) AS PROM " +
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
					" AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99') " +
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
					"		FROM KRDX_ALUM_EVAL WHERE CICLO_GRUPO_ID = CGC.CICLO_GRUPO_ID AND CURSO_ID = CGC.CURSO_ID AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99')) AS PROMEDIO" +
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
					" AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99') " +
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
					+ " AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99') "
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
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|mapAlumnosEvaluadosCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}	
	
	public static HashMap<String, String> mapEvalSumaNotas(Connection conn, String codigoId) throws SQLException{
		HashMap<String,String> map 			= new HashMap<String, String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, TIPO_CURSO_ID(CURSO_ID) AS TIPO, EVALUACION_ID, COALESCE(SUM(NOTA),0) AS SUMA FROM KRDX_ALUM_EVAL"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " GROUP BY CICLO_GRUPO_ID, TIPO_CURSO_ID(CURSO_ID), EVALUACION_ID";
			rs = st.executeQuery(comando);			
			while (rs.next()){				 				
				map.put(rs.getString("CICLO_GRUPO_ID")+rs.getString("TIPO")+rs.getString("EVALUACION_ID"), rs.getString("SUMA"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|mapEvalSumaNotas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String, String> mapEvalCuentaNotas(Connection conn, String codigoId) throws SQLException{
		HashMap<String,String> map 			= new HashMap<String, String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, TIPO_CURSO_ID(CURSO_ID) AS TIPO, EVALUACION_ID, COALESCE(COUNT(NOTA),0) AS TOTAL FROM KRDX_ALUM_EVAL"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " GROUP BY CICLO_GRUPO_ID, TIPO_CURSO_ID(CURSO_ID), EVALUACION_ID";
			rs = st.executeQuery(comando);			
			while (rs.next()){				 				
				map.put(rs.getString("CICLO_GRUPO_ID")+rs.getString("TIPO")+rs.getString("EVALUACION_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|mapEvalSumaNotas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String, String> mapEvalSumaNotasTot(Connection conn, String codigoId) throws SQLException{
		HashMap<String,String> map 			= new HashMap<String, String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, EVALUACION_ID, COALESCE(SUM(NOTA),0) AS SUMA FROM KRDX_ALUM_EVAL"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " GROUP BY CICLO_GRUPO_ID, EVALUACION_ID";
			rs = st.executeQuery(comando);			
			while (rs.next()){				 				
				map.put(rs.getString("CICLO_GRUPO_ID")+rs.getString("EVALUACION_ID"), rs.getString("SUMA"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|mapEvalSumaNotasTot|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String, String> mapEvalCuentaNotasTot(Connection conn, String codigoId) throws SQLException{
		HashMap<String,String> map 			= new HashMap<String, String>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT CICLO_GRUPO_ID, EVALUACION_ID, COALESCE(COUNT(NOTA),0) AS TOTAL FROM KRDX_ALUM_EVAL"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " GROUP BY CICLO_GRUPO_ID, EVALUACION_ID";
			rs = st.executeQuery(comando);			
			while (rs.next()){				 				
				map.put(rs.getString("CICLO_GRUPO_ID")+rs.getString("EVALUACION_ID"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|mapEvalSumaNotasTot|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	
	public HashMap<String, KrdxAlumEval> mapEvalHija(Connection conn, String cursoBase, String decimal) throws SQLException{
		HashMap<String,KrdxAlumEval> map 	= new HashMap<String, KrdxAlumEval>();
		Statement st 						= conn.createStatement();
		ResultSet rs 						= null;
		String comando						= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, '"+cursoBase+"' AS CURSO_ID, EVALUACION_ID,  CAST(AVG(NOTA) AS DECIMAL(10,"+decimal+")) NOTA, "
					+ " CAST(AVG(FALTA) AS DECIMAL(10,"+decimal+"))  FALTA,  CAST(AVG(CONDUCTA) AS DECIMAL(10,"+decimal+")) CONDUCTA, PROMEDIO_ID"
					+ " FROM krdx_alum_eval WHERE CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE CURSO_BASE = '"+cursoBase+"')"
					+ " GROUP BY CODIGO_ID, CICLO_GRUPO_ID, EVALUACION_ID, PROMEDIO_ID ORDER BY CODIGO_ID";
						
			rs = st.executeQuery(comando);			
			while (rs.next()){
				KrdxAlumEval eval = new KrdxAlumEval();
				eval.setCodigoId(rs.getString("CODIGO_ID"));
				eval.setCicloGrupoId(rs.getString("CICLO_GRUPO_ID"));
				eval.setCursoId(rs.getString("CURSO_ID"));
				eval.setEvaluacionId(rs.getString("EVALUACION_ID"));
				eval.setNota(rs.getString("EVALUACION_ID"));
				
				map.put(rs.getString("CODIGO_ID")+rs.getString("CICLO_GRUPO_ID")+rs.getString("CURSO_ID")+rs.getString("EVALUACION_ID"), eval);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|mapEvalSumaNotasTot|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	
	
	
	
	
	
	public boolean checkMateriasHijas(Connection conn, String cicloGrupoId, String curosBase, String promedioId, String estado, String tipo, String evaluacionId ) throws SQLException{
		
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		boolean existe	= false;	
		try{ 
			
			if (tipo.equals("P")){
			comando = "SELECT CASE WHEN EXISTS ( SELECT * FROM CICLO_GRUPO_EVAL "
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE CURSO_BASE = '"+curosBase+"')"
					+ " AND PROMEDIO_ID='"+promedioId+"' AND ESTADO = '"+estado+"')"
					+ " THEN CAST(1 AS BIT)"
					+ " ELSE CAST(0 AS BIT) END";
			
			}else{
				
				comando = "SELECT CASE WHEN EXISTS ( SELECT * FROM CICLO_GRUPO_EVAL "
						+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' AND CURSO_ID IN (SELECT CURSO_ID FROM PLAN_CURSO WHERE CURSO_BASE = '"+curosBase+"')"
						+ " AND PROMEDIO_ID='"+promedioId+"' AND EVALUACION_ID ='"+evaluacionId+"' AND ESTADO = '"+estado+"')"
						+ " THEN CAST(1 AS BIT)"
						+ " ELSE CAST(0 AS BIT) END";
				
			}
			
			rs = st.executeQuery(comando);			
			//System.out.println(rs.getBoolean("CASE"));
			if (rs.next()){				 				
				existe = rs.getBoolean("CASE");
			}
			
			
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumEvalLista|mapEvalSumaNotasTot|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		
		return existe;
		
		
	}
	
	
	
}
