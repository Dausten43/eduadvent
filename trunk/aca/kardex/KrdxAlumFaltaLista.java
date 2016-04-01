
package aca.kardex;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.TreeMap;

public class KrdxAlumFaltaLista {
	public ArrayList<KrdxAlumFalta> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<KrdxAlumFalta> lis 	= new ArrayList<KrdxAlumFalta>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
				" PROMEDIO_ID, EVALUACION_ID, FALTA, TARDANZA " +
                " FROM KRDX_ALUM_FALTA "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumFalta obj = new KrdxAlumFalta();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFaltaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lis;
	}
	
	public TreeMap<String,KrdxAlumFalta> getTreeAlumMat(Connection conn, String codigoId, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		TreeMap<String,KrdxAlumFalta> tree 	= new TreeMap<String, KrdxAlumFalta>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
				" PROMEDIO_ID, EVALUACION_ID, FALTA, TARDANZA" +
                " FROM KRDX_ALUM_FALTA" +
                " WHERE CODIGO_ID = '"+codigoId+"'" +
                " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"' "+ orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumFalta obj = new KrdxAlumFalta();		
				obj.mapeaReg(rs);
				tree.put(obj.getCodigoId()+obj.getCicloGrupoId()+obj.getCursoId()+obj.getEvaluacionId(), obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFaltaLista|getTreeAlumMat|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return tree;
	}
	
	public TreeMap<String,KrdxAlumFalta> getTreeFalta( Connection conn, String cicloGrupoId, String orden ) throws SQLException{
		TreeMap<String,KrdxAlumFalta> treemap 	= new TreeMap<String, KrdxAlumFalta>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
				" PROMEDIO_ID, EVALUACION_ID, FALTA, TARDANZA" +
                " FROM KRDX_ALUM_FALTA " +
                " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+ orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				KrdxAlumFalta obj = new KrdxAlumFalta();		
				obj.mapeaReg(rs);
				treemap.put(obj.getCicloGrupoId()+obj.getCursoId()+obj.getEvaluacionId()+obj.getCodigoId(), obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumFaltaLista|getTreeFalta|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return treemap;
	}
	
}
