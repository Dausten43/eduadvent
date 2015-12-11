package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class CicloBloqueActividadLista {
	
	public ArrayList<CicloBloqueActividad> getListAll(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloBloqueActividad> lis 	= new ArrayList<CicloBloqueActividad>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT CICLO_ID, BLOQUE_ID, ACTIVIDAD_ID," +
					" ACTIVIDAD_NOMBRE, " +
					" TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID " +
					" FROM CICLO_BLOQUE_ACTIVIDAD " +
					" WHERE CICLO_ID = '"+cicloId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloBloqueActividad obj = new CicloBloqueActividad();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueActividadLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	
	public ArrayList<CicloBloqueActividad> getListBloque(Connection conn, String cicloId, String bloqueId, String orden ) throws SQLException{
		ArrayList<CicloBloqueActividad> lis 	= new ArrayList<CicloBloqueActividad>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT CICLO_ID, BLOQUE_ID, ACTIVIDAD_ID," +
					" ACTIVIDAD_NOMBRE, " +
					" TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID " +
					" FROM CICLO_BLOQUE_ACTIVIDAD " +
					" WHERE CICLO_ID = '"+cicloId+"' AND BLOQUE_ID = TO_NUMBER('"+bloqueId+"', '99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloBloqueActividad obj = new CicloBloqueActividad();				
				obj.mapeaReg(rs);
				lis.add(obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloBloqueActividadLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lis;
	}
	

	public static HashMap<String, String> getMapEtiquetas(Connection conn, String cicloId ) throws SQLException{
		
		HashMap<String,String> map 		= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{
			comando = " SELECT CICLO_ID, BLOQUE_ID, ACTIVIDAD_ID," +
					" ACTIVIDAD_NOMBRE, " +
					" TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, VALOR, TIPOACT_ID, ETIQUETA_ID " +
					" FROM CICLO_BLOQUE_ACTIVIDAD " +
					" WHERE CICLO_ID = '"+cicloId+"'  ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put( rs.getString("BLOQUE_ID")+"@@"+rs.getString("ACTIVIDAD_ID"), rs.getString("ETIQUETA_ID"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.CicloBloqueActividad|getMapEtiquetas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
}
