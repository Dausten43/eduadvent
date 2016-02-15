package aca.catalogo;

import java.sql.*;
import java.util.ArrayList;

public class CatEsquemaLista {
	public ArrayList<CatEsquema> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<CatEsquema> list 	= new ArrayList<CatEsquema>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = 	" SELECT " +
						" ESCUELA_ID, NIVEL_ID, GRADO, ESQUEMA_EVALUACION, SUB_NIVEL, GRADO_NOMBRE, SEMESTRE_NOMBRE  " +
						" FROM CAT_ESQUEMA "+orden;		
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CatEsquema obj = new CatEsquema();				
				obj.mapeaReg(rs);
				list.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquemaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	
	public static String getEsquemaEvaluacion(Connection conn, String escuelaId, String grado, String cursoId) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String minima			= "N";
		
		try{
			ps = conn.prepareStatement("SELECT ESQUEMA_EVALUACION "
					+ " FROM CAT_ESQUEMA "
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' "
					+ " AND NIVEL_ID = (SELECT DISTINCT(NIVEL_ID) FROM PLAN "
					+ " WHERE PLAN_ID = (SELECT DISTINCT(PLAN_ID) FROM PLAN_CURSO WHERE CURSO_ID = '"+cursoId+"')) "
					+ " AND GRADO = TO_NUMBER('"+grado+"', '99')");	
			
			rs = ps.executeQuery();
			if (rs.next()){
				minima = rs.getString("ESQUEMA_EVALUACION");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquemaLista|getEsquemaEvaluacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return minima;
	}
	
	public static String getEsquemaEvaluacionNivel(Connection conn, String escuelaId, String nivelId, String gradoId) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String minima			= "N";
		
		try{
			ps = conn.prepareStatement("SELECT ESQUEMA_EVALUACION "
					+ " FROM CAT_ESQUEMA "
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' "
					+ " AND NIVEL_ID =  TO_NUMBER('"+nivelId+"', '99') "
					+ " AND GRADO = TO_NUMBER('"+gradoId+"', '99') ");	
			
			rs = ps.executeQuery();
			if (rs.next()){
				minima = rs.getString("ESQUEMA_EVALUACION");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquemaLista|getEsquemaEvaluacionNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return minima;
	}
	
	
	public static String getSubNivel(Connection conn, String escuelaId, String nivelId, String gradoId) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String subnivel			= "";
		
		try{
			ps = conn.prepareStatement("SELECT SUB_NIVEL "
					+ " FROM CAT_ESQUEMA "
					+ " WHERE ESCUELA_ID = '"+escuelaId+"' "
					+ " AND NIVEL_ID =  TO_NUMBER('"+nivelId+"', '99') "
					+ " AND GRADO = TO_NUMBER('"+gradoId+"', '99') ");	
			
			rs = ps.executeQuery();
			if (rs.next()){
				subnivel = rs.getString("SUB_NIVEL");
				if(subnivel==null || subnivel.equals("null") || subnivel.equals("-1")){
					subnivel = "";
				}
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquemaLista|getSubNivel|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return subnivel;
	}
	
	
	public static String getNombreGrado(Connection conn, String escuelaId, String nivelId, String gradoId, boolean mostrarDefault) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String grado			= "";
		
		try{
			ps = conn.prepareStatement("SELECT GRADO_NOMBRE FROM CAT_ESQUEMA"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND NIVEL_ID =  TO_NUMBER('"+nivelId+"','99')"
					+ " AND GRADO = TO_NUMBER('"+gradoId+"', '99')");	
			
			rs = ps.executeQuery();
			if (rs.next()){
				grado = rs.getString("GRADO_NOMBRE");
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquemaLista|getNombreGrado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		if(grado==null || grado.equals("null") || grado.equals("-1")){
			grado = "";
		}
		if(mostrarDefault && grado.equals("")){
			grado = gradoId;
		}
		
		return grado;
	}
	
	
	public static String getNombreSemestre(Connection conn, String escuelaId, String nivelId, String gradoId) throws SQLException{
		
		ResultSet 		rs		= null;
		PreparedStatement ps	= null;
		String semestre			= "";
		
		try{
			ps = conn.prepareStatement("SELECT SEMESTRE_NOMBRE FROM CAT_ESQUEMA"
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND NIVEL_ID =  TO_NUMBER('"+nivelId+"', '99')"
					+ " AND GRADO = TO_NUMBER('"+gradoId+"', '99')");	
			
			rs = ps.executeQuery();
			if (rs.next()){
				semestre = rs.getString("SEMESTRE_NOMBRE");
				if(semestre==null || semestre.equals("null") || semestre.equals("-1")){
					semestre = "";
				}
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquemaLista|getNombreSemestre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		
		return semestre;
	}
	
	public static String getGradoYGrupo(Connection conn, String escuelaId, String nivelId, String gradoId){
		
		String grado 	= "";
		String sem 		= "";
		
		try{
			sem 	= getNombreSemestre(conn, escuelaId, nivelId, gradoId);
			grado 	= getNombreGrado(conn, escuelaId, nivelId, gradoId, sem.equals("")?true:false);
			
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.CatEsquemaLista|getNombreSemestre|:"+ex);
		}finally{
		}
		
		String rs = "";
		
		if(!grado.equals("") && !sem.equals("")){
			rs = grado + " | " + sem;
		}else{
			rs = grado + " " + sem;
		}
		
		
		return rs.trim();
	}
	
}