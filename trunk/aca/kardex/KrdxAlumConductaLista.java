
package aca.kardex;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.TreeMap;


public class KrdxAlumConductaLista {
	public ArrayList<KrdxAlumConducta> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<KrdxAlumConducta> lis 	= new ArrayList<KrdxAlumConducta>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " PROMEDIO_ID, EVALUACION_ID, CONDUCTA " +
                " FROM KRDX_ALUM_CONDUCTA "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumConducta obj = new KrdxAlumConducta();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumConductaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lis;
	}
	
	public TreeMap<String,KrdxAlumConducta> getTreeAlumMat(Connection conn, String codigoId, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		TreeMap<String,KrdxAlumConducta> tree 	= new TreeMap<String, KrdxAlumConducta>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID," +
                " PROMEDIO_ID, EVALUACION_ID, CONDUCTA " +
                " FROM KRDX_ALUM_EVAL" +
                " WHERE CODIGO_ID = '"+codigoId+"'" +
                " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"'" +
                " AND CURSO_ID = '"+cursoId+"' "+ orden;
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumConducta obj = new KrdxAlumConducta();		
				obj.mapeaReg(rs);
				tree.put(obj.getCodigoId()+obj.getCicloGrupoId()+obj.getCursoId()+obj.getEvaluacionId(), obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumConductaLista|getTreeAlumMat|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return tree;
	}
	
}
