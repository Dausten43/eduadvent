package aca.kardex;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class KrdxAlumActitudLista {
	
	public ArrayList<KrdxAlumActitud> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<KrdxAlumActitud> lis 	= new ArrayList<KrdxAlumActitud>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID,"
					+ " PROMEDIO_ID, EVALUACION_ID, ASPECTOS_ID, NOTA"
					+ " FROM KRDX_ALUM_ACTITUD "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumActitud obj = new KrdxAlumActitud();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActitudLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lis;
	}
	
	public HashMap<String,KrdxAlumActitud> mapAspectosGrupo(Connection conn, String cicloGrupoId, String cursoId) throws SQLException{
		
		HashMap<String,KrdxAlumActitud> map = new HashMap<String,KrdxAlumActitud>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID,"
					+ " PROMEDIO_ID, EVALUACION_ID, ASPECTOS_ID, NOTA"
					+ " FROM KRDX_ALUM_ACTITUD"
					+ " WHERE CICLO_GRUPO_ID = '"+cicloGrupoId+"'"
					+ " AND CURSO_ID = '"+cursoId+"' ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				KrdxAlumActitud objeto = new KrdxAlumActitud();				
				objeto.mapeaReg(rs);
				llave = objeto.getCodigoId()+objeto.getPromedioId()+objeto.getEvaluacionId()+objeto.getAspectosId();
				map.put(llave,objeto);	
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatRegionLista|getTotalSeccionPorPais|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<KrdxAlumActitud> getListAspectosAlumno(Connection conn, String codigoId, String cicloGrupoId, String orden ) throws SQLException{
		ArrayList<KrdxAlumActitud> list 	= new ArrayList<KrdxAlumActitud>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CODIGO_ID, CICLO_GRUPO_ID, CURSO_ID,"
					+ " PROMEDIO_ID, EVALUACION_ID, ASPECTOS_ID, NOTA"
					+ " FROM KRDX_ALUM_ACTITUD"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " AND CICLO_GRUPO_ID = '"+cicloGrupoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				KrdxAlumActitud obj = new KrdxAlumActitud();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.kardex.KrdxAlumActitudLista|getListAspectosAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return list;
	}
}
