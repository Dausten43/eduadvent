package aca.vista;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class AlumEstadisticaLista {
	public ArrayList<AlumEstadistica> getListaEstadistica(Connection conn,  String ciclo_id, String periodo_id, String orden) throws SQLException{
		ArrayList<AlumEstadistica> lisInscritos 	= new ArrayList<AlumEstadistica>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT * FROM ALUM_ESTADISTICA WHERE CICLO_ID = ? AND PERIODO_ID = ? ORDER BY "+orden;			
			
			rs = st.executeQuery(comando);			
			while (rs.next()){				
				AlumEstadistica estadistica = new AlumEstadistica();				
				estadistica.mapeaReg(rs);
				lisInscritos.add(estadistica);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.vista.AlumEstadisticaLista|getListaEstadistica|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisInscritos;
	}
}