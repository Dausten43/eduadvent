package aca.est;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class EstRespuestaLista{
	
	public ArrayList<EstRespuesta> getListAll(Connection conn, String orden) throws SQLException{
		
		ArrayList<EstRespuesta> lis		= new ArrayList<EstRespuesta>();
		Statement st 		= conn.createStatement();
		ResultSet rs 		= null;
		String comando		= "";
		
		try{
			comando = "SELECT ENCUESTA_ID, ESCUELA_ID, PREGUNTA_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA"+
					  " TIPO FROM EST_RESPUESTA "+orden;	 
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				EstRespuesta obj = new EstRespuesta();
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstRespuestaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public HashMap<String,EstRespuesta> getMapEscuela(Connection conn) throws SQLException{
		
		HashMap<String,EstRespuesta> map = new HashMap<String,EstRespuesta>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = " SELECT ENCUESTA_ID, ESCUELA_ID, PREGUNTA_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA,"+
					  " RESPUESTA FROM EST_RESPUESTA ";	 
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				EstRespuesta obj = new EstRespuesta();
				obj.mapeaReg(rs);
				llave = obj.getEscuelaId()+","+obj.getEncuestaId()+","+obj.getPreguntaId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.est.EstRespuestaLista|getMapEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
		
}