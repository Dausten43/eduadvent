/**
 * 
 */
package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author Elifo
 *
 */
public class CicloGrupoActividadLista {
	public ArrayList<CicloGrupoActividad> getListGrupo(Connection conn, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		
		ArrayList<CicloGrupoActividad> lisGrupoActividad = new ArrayList<CicloGrupoActividad>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID," +
					" ACTIVIDAD_NOMBRE, TO_CHAR(FECHA, 'DD/MM/YYYY HH:MI AM') AS FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID, MOSTRAR "+
					" FROM CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND CURSO_ID = '"+cursoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloGrupoActividad actividad = new CicloGrupoActividad();				
				actividad.mapeaReg(rs);
				lisGrupoActividad.add(actividad);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoActividadLista|getListGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisGrupoActividad;
	}
	
	public ArrayList<CicloGrupoActividad> getListEvaluacion(Connection conn, String cicloGrupoId, String evaluacionId, String orden ) throws SQLException{
		
		ArrayList<CicloGrupoActividad> lisGrupoActividad = new ArrayList<CicloGrupoActividad>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT * FROM CICLO_GRUPO_ACTIVIDAD"
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "
					+ " AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99') "
					+ " ORDER BY CURSO_ID, ACTIVIDAD_ID, ETIQUETA_ID "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloGrupoActividad actividad = new CicloGrupoActividad();				
				actividad.mapeaReg(rs);
				lisGrupoActividad.add(actividad);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoActividadLista|getListEvaluacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisGrupoActividad;
	}
	
	public ArrayList<CicloGrupoActividad> getListEvaluacion(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String orden ) throws SQLException{
		
		ArrayList<CicloGrupoActividad> lisGrupoActividad = new ArrayList<CicloGrupoActividad>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID," +
					" ACTIVIDAD_NOMBRE, TO_CHAR(FECHA, 'DD/MM/YYYY HH:MI AM') AS FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID, MOSTRAR"+
					" FROM CICLO_GRUPO_ACTIVIDAD" +
					" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
					" AND CURSO_ID = '"+cursoId+"'" +
					" AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99')" +orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloGrupoActividad actividad = new CicloGrupoActividad();				
				actividad.mapeaReg(rs);
				lisGrupoActividad.add(actividad);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoActividadLista|getListEvaluacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		

		return lisGrupoActividad;
	}
	
public ArrayList<CicloGrupoActividad> getListTareas(Connection conn, String codigoId, String fecha, String orden, String cicloId ) throws SQLException{
		
		ArrayList<CicloGrupoActividad> lisGrupoActividad = new ArrayList<CicloGrupoActividad>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			
			String[] txtSplit=fecha.split("-");
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, " +
					" ACTIVIDAD_NOMBRE, TO_CHAR(FECHA, 'DD/MM/YYYY HH:MI AM') AS FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID, MOSTRAR " +
					" FROM CICLO_GRUPO_ACTIVIDAD " +
					" WHERE CICLO_GRUPO_ID||CURSO_ID " +
					" IN (SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' AND TIPOCAL_ID != 6)" +
					" and SUBSTR(CICLO_GRUPO_ID,1,8) = (SELECT CICLO_ID FROM alum_ciclo where codigo_id='"+codigoId+"' "
						    + "and ciclo_id in (select ciclo_id from ciclo where current_timestamp BETWEEN f_inicial AND f_final) and estado='I') " +
					"  and extract(YEAR FROM fecha)=" + txtSplit[0] + " and extract(WEEK FROM fecha)=" + txtSplit[1]  + " " +
					orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloGrupoActividad actividad = new CicloGrupoActividad();				
				actividad.mapeaReg(rs);
				lisGrupoActividad.add(actividad);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoActividadLista|getListTareas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisGrupoActividad;
	}

	public ArrayList<CicloGrupoActividad> getListTareas(Connection conn, String codigoId, String fecha, String orden ) throws SQLException{
		
		ArrayList<CicloGrupoActividad> lisGrupoActividad = new ArrayList<CicloGrupoActividad>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, " +
					" ACTIVIDAD_NOMBRE, TO_CHAR(FECHA, 'DD/MM/YYYY HH:MI AM') AS FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID, MOSTRAR " +
					" FROM CICLO_GRUPO_ACTIVIDAD " +
					" WHERE TO_CHAR(FECHA,'DD/MM/YYYY') = '"+fecha+"' " +
					" AND CICLO_GRUPO_ID||CURSO_ID " +
					" IN (SELECT CICLO_GRUPO_ID||CURSO_ID FROM KRDX_CURSO_ACT WHERE CODIGO_ID = '"+codigoId+"' )" +orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloGrupoActividad actividad = new CicloGrupoActividad();				
				actividad.mapeaReg(rs);
				lisGrupoActividad.add(actividad);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoActividadLista|getListTareas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisGrupoActividad;
	}
	
	
	public static HashMap<String,String> getMapActividadesPorEvaluacion(Connection conn, String cicloGrupoId, String cursoId ) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT EVALUACION_ID, ACTIVIDAD_ID FROM CICLO_GRUPO_ACTIVIDAD"
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'"
					+ " AND CURSO_ID = '"+cursoId+"' ORDER BY EVALUACION_ID, ACTIVIDAD_ID ";
			
			rs = st.executeQuery(comando);
			
			String evaluacionTmp 	= "";
			String actividades 		= "";
			while (rs.next()){				
				String evaluacion = rs.getString("EVALUACION_ID");
				String actividad  = rs.getString("ACTIVIDAD_ID");
				
				if(evaluacionTmp.equals("")){
					evaluacionTmp = evaluacion;
				}
				
				if(!evaluacion.equals(evaluacionTmp)){
					map.put(evaluacionTmp, actividades.substring(0, actividades.length()-1));
					
					actividades = "";
					evaluacionTmp = evaluacion;
				}
				
				actividades+=actividad+"@";
				
			}
			
			map.put(evaluacionTmp, actividades.substring(0, actividades.length()-1));
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.AlumCiclo|getMapActividadesPorEvaluacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

	
	public static HashMap<String,String> getMapNotaActividad(Connection conn, String cicloGrupoId, String cursoId ) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM KRDX_ALUM_ACTIV"
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "
					+ " AND CURSO_ID = '"+cursoId+"' ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("CODIGO_ID")+"@"+rs.getString("EVALUACION_ID")+"@"+rs.getString("ACTIVIDAD_ID"), rs.getString("NOTA") );
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.AlumCiclo|getMapNotaActividad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	
	public static HashMap<String,String> getMapNotaActividadCursos(Connection conn, String cicloGrupoId) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT * FROM KRDX_ALUM_ACTIV"
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("CURSO_ID")+"@"+rs.getString("CODIGO_ID")+"@"+rs.getString("EVALUACION_ID")+"@"+rs.getString("ACTIVIDAD_ID"), rs.getString("NOTA") );
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.AlumCiclo|getMapNotaActividad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<String> getEtiquetas(Connection conn, String cicloGrupoId, String evaluacionId ) throws SQLException{
		
		ArrayList<String> list 	= new ArrayList<String>();
		Statement st 			= conn.createStatement();
		ResultSet rs 			= null;
		String comando			= "";
		
		try{		
		/* *** MATERIA CON EL MAYOR NUMBERO DE ETIQUETAS *** */
			comando = " SELECT CURSO_ID, COUNT( DISTINCT(CURSO_ID||'@@'||ETIQUETA_ID) ) AS CANTIDAD FROM CICLO_GRUPO_ACTIVIDAD"
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "
					+ " AND EVALUACION_ID =  TO_NUMBER('"+evaluacionId+"', '99') "
					+ " AND ETIQUETA_ID != 0 "
					+ " AND ETIQUETA_ID IS NOT NULL "
					+ " GROUP BY CURSO_ID";			
			rs = st.executeQuery(comando);
			
			String materiaConMasEtiquetas = "";
			
			int cantidadTmp = 0;
			while (rs.next()){
				String materia 	= rs.getString("CURSO_ID");
				int cantidad 	= rs.getInt("CANTIDAD"); 
				
				if(cantidad>cantidadTmp){
					cantidadTmp = cantidad;
					materiaConMasEtiquetas = materia;
				}
			}
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		/* *** END MATERIA CON EL MAYOR NUMBERO DE ETIQUETAS *** */			
		
		/* *** ETIQUETAS DE LA MATERIA CON EL MAYOR NUMERO *** */	
			comando = " SELECT DISTINCT(ETIQUETA_ID) AS ETIQUETA_ID FROM CICLO_GRUPO_ACTIVIDAD"
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "
					+ " AND EVALUACION_ID =  TO_NUMBER('"+evaluacionId+"', '99') "
					+ " AND ETIQUETA_ID != 0 "
					+ " AND ETIQUETA_ID IS NOT NULL "
					+ " AND CURSO_ID = '"+materiaConMasEtiquetas+"' ";
			
			rs = st.executeQuery(comando);
			
			while (rs.next()){
				list.add(rs.getString("ETIQUETA_ID"));
			}
		/* *** END ETIQUETAS DE LA MATERIA CON EL MAYOR NUMERO *** */
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloGrupoActividadLista|getListTareas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	
	public static HashMap<String,String> getMapActividadesCiclo(Connection conn, String cicloId) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = "SELECT EVALUACION_ID, COUNT(*) AS CANTIDAD FROM CICLO_GRUPO_ACTIVIDAD"
					+ " WHERE CICLO_GRUPO_ID LIKE '"+cicloId+"%'"
					+ " GROUP BY EVALUACION_ID ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("EVALUACION_ID"), rs.getString("CANTIDAD") );
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.AlumCiclo|getMapActividadesCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public void promedioEval(){
		String comando = "select ke.ciclo_grupo_id "
				+ ", ke.codigo_id "
				+ ", ke.evaluacion_id  "
				+ "--, curso_id "
				+ ", sum(ke.nota) suma "
				+ ", count(ke.curso_id) materias "
				+ ", sum(ke.nota)/count(ke.nota) promedio  "
				+ "from krdx_alum_eval ke  "
				+ "where   ke.ciclo_grupo_id like 'H221717A%'    "
				+ "and ke.evaluacion_id=1   "
				+ "--and ke.codigo_id='H2216028'   "
				+ "and ke.curso_id not in (select curso_id from plan_curso where	 curso_base<>'-')  "
				+ "and ke.curso_id in (select curso_id from ciclo_grupo_eval where ciclo_grupo_id=ke.ciclo_grupo_id and estado='C' and evaluacion_id=ke.evaluacion_id )   group by   ke.ciclo_grupo_id  , ke.evaluacion_id  , ke.codigo_id  --, curso_id   order by ke.ciclo_grupo_id, promedio desc";
	}
	
}
