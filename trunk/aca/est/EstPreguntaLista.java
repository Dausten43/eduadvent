package aca.est;

import java.sql.*;
import java.util.ArrayList;

public class EstPreguntaLista{
	
	public ArrayList<EstPregunta> getListAll(Connection conn, String orden) throws SQLException{
		
		ArrayList<EstPregunta> lis		= new ArrayList<EstPregunta>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT ENCUESTA_ID, PREGUNTA_NOMBRE, PREGUNTA_ID, "+
					  " TIPO FROM EST_PREGUNTA "+orden;	 
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EstPregunta obj = new EstPregunta();
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cultural.EstPreguntaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public ArrayList<EstPregunta> getListEncuesta(Connection conn, String encuestaId, String orden) throws SQLException{
		
		ArrayList<EstPregunta> lis		= new ArrayList<EstPregunta>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT ENCUESTA_ID, PREGUNTA_NOMBRE, PREGUNTA_ID, "+
					  " TIPO FROM EST_PREGUNTA WHERE ENCUESTA_ID = TO_NUMBER('"+encuestaId+"', '99999') "+orden;	 
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EstPregunta obj = new EstPregunta();
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cultural.EstPreguntaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
		
}