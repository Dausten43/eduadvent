/**
 * 
 */
package aca.kardex;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.TreeMap;

/**
 * @author Jose Torres
 *
 */
public class KrdxAlumArchivoLista {
	public ArrayList<KrdxAlumArchivo> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<KrdxAlumArchivo> lisArchivo 	= new ArrayList<KrdxAlumArchivo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, FOLIO, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, ARCHIVO, FECHA" +
				" FROM KRDX_ALUM_ARCHIVO " +orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumArchivo kaa = new KrdxAlumArchivo();				
				kaa.mapeaReg(rs);
				lisArchivo.add(kaa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisArchivo;
	}
	
	
	public ArrayList<KrdxAlumArchivo> getListEvaluacion(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String orden ) throws SQLException{
		ArrayList<KrdxAlumArchivo> lisArchivo 	= new ArrayList<KrdxAlumArchivo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, FOLIO, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, ARCHIVO, FECHA" +
				" FROM KRDX_ALUM_ARCHIVO "+ 
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
				" AND CURSO_ID = '"+cursoId+"'" +
				" AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99')" + orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumArchivo kaa = new KrdxAlumArchivo();		
				kaa.mapeaReg(rs);
				lisArchivo.add(kaa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivoLista|getListEvaluacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisArchivo;
	}
	
	public ArrayList<KrdxAlumArchivo> getListArchivosEnviados(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId, String orden ) throws SQLException{
		ArrayList<KrdxAlumArchivo> lisArchivo 	= new ArrayList<KrdxAlumArchivo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, FOLIO, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, ARCHIVO, TO_CHAR(FECHA, 'DD/MM/YYYY HH:MI:SS AM') AS FECHA" +
				" FROM KRDX_ALUM_ARCHIVO "+ 
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
				" AND CURSO_ID = '"+cursoId+"'" +
				" AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99')" +
				" AND ACTIVIDAD_ID = TO_NUMBER('"+actividadId+"', '99') " + orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){				
				KrdxAlumArchivo kaa = new KrdxAlumArchivo();		
				kaa.mapeaReg(rs);
				lisArchivo.add(kaa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivoLista|getListEvaluacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisArchivo;
	}
	
	public ArrayList<String> getListCodigoSinRepetir(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId, String orden ) throws SQLException{
		ArrayList<String> lisArchivo 	= new ArrayList<String>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT DISTINCT(CODIGO_ID) AS CODIGO" +
				" FROM KRDX_ALUM_ARCHIVO "+ 
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
				" AND CURSO_ID = '"+cursoId+"'" +
				" AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99')" +
				" AND ACTIVIDAD_ID = TO_NUMBER('"+actividadId+"', '99') " + orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				lisArchivo.add(rs.getString("CODIGO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivoLista|getListCodigoSinRepetir|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisArchivo;
	}
	
	public ArrayList<KrdxAlumArchivo> getListEvaluacionAlumno(Connection conn, String codigoId, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId, String orden ) throws SQLException{
		ArrayList<KrdxAlumArchivo> lisArchivo 	= new ArrayList<KrdxAlumArchivo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, FOLIO, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, ARCHIVO, TO_CHAR(FECHA, 'DD/MM/YYYY HH:MI:SS AM') AS FECHA" +
				" FROM KRDX_ALUM_ARCHIVO "+ 
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
				" AND CURSO_ID = '"+cursoId+"'" +
				" AND CODIGO_ID = '"+codigoId+"'" +
				" AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99')" +
				" AND ACTIVIDAD_ID = TO_NUMBER('"+actividadId+"', '99') " + orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumArchivo kaa = new KrdxAlumArchivo();		
				kaa.mapeaReg(rs);
				lisArchivo.add(kaa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivoLista|getListEvaluacionAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisArchivo;
	}	
	
	public ArrayList<KrdxAlumArchivo> getListActividad(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String actividadId, String orden ) throws SQLException{
		ArrayList<KrdxAlumArchivo> lisArchivo 	= new ArrayList<KrdxAlumArchivo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, FOLIO, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, ARCHIVO, FECHA" +
				" FROM KRDX_ALUM_ARCHIVO "+ 
				" WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
				" AND CURSO_ID = '"+cursoId+"'" +
				" AND EVALUACION_ID = TO_NUMBER('"+evaluacionId+"', '99')" +
				" AND ACTIVIDAD_ID = TO_NUMBER('"+actividadId+"', '99') " + orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumArchivo kaa = new KrdxAlumArchivo();		
				kaa.mapeaReg(rs);
				lisArchivo.add(kaa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivoLista|getListActividad|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisArchivo;
	}
	
	public TreeMap<String,KrdxAlumArchivo> getTreeMateria(Connection conn, String codigoId, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		TreeMap<String,KrdxAlumArchivo> treeArchivo	= new TreeMap<String, KrdxAlumArchivo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, FOLIO, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, ARCHIVO, FECHA" +
				" FROM KRDX_ALUM_ARCHIVO "+
				" WHERE CODIGO_ID = '"+codigoId+"'" +
                " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"' "+ orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumArchivo kaa = new KrdxAlumArchivo();		
				kaa.mapeaReg(rs);
				treeArchivo.put(kaa.getCicloGrupoId()+kaa.getCursoId()+kaa.getEvaluacionId()+kaa.getActividadId()+kaa.getCodigoId()+kaa.getFolio(), kaa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumArchivoLista|getTreeMateria|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return treeArchivo;
	}
	
}
