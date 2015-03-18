
package aca.kardex;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class KrdxAlumPromLista {
	public ArrayList<KrdxAlumProm> getListCurso(Connection conn, String cicloGrupoId, String cursoId, String orden ) throws SQLException{
		ArrayList<KrdxAlumProm> lis 	= new ArrayList<KrdxAlumProm>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO_ID, NOTA, VALOR"
					+ " FROM KRDX_ALUM_PROM"
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'"
					+ " AND CURSO_ID = '"+cursoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumProm obj = new KrdxAlumProm();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumPromLista|getListCurso|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lis;
	}
	
	public static HashMap<String,KrdxAlumProm> mapPromAlumno(Connection conn, String codigoId) throws SQLException{
		HashMap<String,KrdxAlumProm> map 	= new HashMap<String, KrdxAlumProm>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO_ID, NOTA, VALOR"
					+ " FROM KRDX_ALUM_PROM"
					+ " WHERE CODIGO_ID = '"+codigoId+"'";
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumProm obj = new KrdxAlumProm();		
				obj.mapeaReg(rs);
				map.put(obj.getCicloGrupoId()+obj.getCursoId()+obj.getPromedioId(), obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumPromLista|mapPromAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return map;
	}
	
	public static HashMap<String,KrdxAlumProm> mapPromGrupo(Connection conn, String cicloGrupoId) throws SQLException{
		HashMap<String,KrdxAlumProm> map 	= new HashMap<String, KrdxAlumProm>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID, PROMEDIO_ID, NOTA, VALOR"
					+ " FROM KRDX_ALUM_PROM"
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'";
			
			rs = st.executeQuery(comando);		
			while (rs.next()){
				
				KrdxAlumProm obj = new KrdxAlumProm();		
				obj.mapeaReg(rs);
				map.put(obj.getCodigoId()+obj.getCursoId()+obj.getPromedioId(), obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumPromLista|mapPromGrupo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return map;
	}
	
}
