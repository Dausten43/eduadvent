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
 * @author Elifo
 *
 */
public class KrdxAlumActivLista {
	
	public ArrayList<KrdxAlumActiv> getListEvaluacion(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String orden ) throws SQLException{
		ArrayList<KrdxAlumActiv> lisActiv 	= new ArrayList<KrdxAlumActiv>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, NOTA" +
                " FROM KRDX_ALUM_ACTIV" +
                " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"'" +
                " AND EVALUACION_ID = "+evaluacionId+" "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumActiv kaa = new KrdxAlumActiv();				
				kaa.mapeaReg(rs);
				lisActiv.add(kaa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActivLista|getListEvaluacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisActiv;
	}
	
	
	public ArrayList<KrdxAlumActiv> getEvaluacionesAlumno(Connection conn,String codigoId, String cicloGrupoId, String cursoId, String evaluacionId, String orden ) throws SQLException{
		ArrayList<KrdxAlumActiv> lisActiv 	= new ArrayList<KrdxAlumActiv>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, NOTA" +
                " FROM KRDX_ALUM_ACTIV" +
                " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"'" +
                " AND EVALUACION_ID = '"+evaluacionId+"'" +
                " AND CODIGO_ID = '"+codigoId+"'" +orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumActiv kaa = new KrdxAlumActiv();				
				kaa.mapeaReg(rs);
				lisActiv.add(kaa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActivLista|getListEvaluacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisActiv;
	}
	
	public TreeMap<String,KrdxAlumActiv> getTreeActividades(Connection conn, String cicloGrupoId, String cursoId, String evaluacionId, String orden ) throws SQLException{
		
		TreeMap<String,KrdxAlumActiv> treeActiv 	= new TreeMap<String,KrdxAlumActiv>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String llave	= "";
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, NOTA" +
                " FROM KRDX_ALUM_ACTIV" +
                " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"'" +
                " AND EVALUACION_ID = "+evaluacionId+" "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){				
				KrdxAlumActiv kaa = new KrdxAlumActiv();				
				kaa.mapeaReg(rs);
				llave = kaa.getCicloGrupoId()+kaa.getCursoId()+kaa.getEvaluacionId()+kaa.getActividadId()+kaa.getCodigoId();
				treeActiv.put(llave, kaa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActivLista|getTreeActividades|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return treeActiv;
	}
	
	
	public TreeMap<String,KrdxAlumActiv> getTreeAlumAct(Connection conn, String cicloGrupoId, String cursoId, String codigoId, String orden ) throws SQLException{
		
		TreeMap<String,KrdxAlumActiv> treeActiv 	= new TreeMap<String,KrdxAlumActiv>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String llave	= "";
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, EVALUACION_ID, ACTIVIDAD_ID, NOTA" +
                " FROM KRDX_ALUM_ACTIV" +
                " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"'" +
                " AND CODIGO_ID ='"+codigoId+"' " +orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){				
				KrdxAlumActiv kaa = new KrdxAlumActiv();				
				kaa.mapeaReg(rs);
				llave = kaa.getCodigoId()+kaa.getCicloGrupoId()+kaa.getCursoId()+kaa.getEvaluacionId()+kaa.getActividadId();
				treeActiv.put(llave, kaa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActivLista|getTreeAlumAct|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}

		return treeActiv;
	}
	
}
