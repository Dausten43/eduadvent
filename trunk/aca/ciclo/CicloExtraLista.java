package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class CicloExtraLista {
	
	public ArrayList<CicloBloqueActividad> getListAll(Connection conn, String cicloId, String oportunidad, String orden ) throws SQLException{
		ArrayList<CicloBloqueActividad> lis 	= new ArrayList<CicloBloqueActividad>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT CICLO_ID, OPORTUNIDAD, VALOR_ANTERIOR," +
					" VALOR_EXTRA, " +
					" OPORTUNIDAD_NOMBRE" +
					" FROM CICLO_EXTRA " +
					" WHERE CICLO_ID = '"+cicloId+"' AND OPORTUNIDAD = '"+oportunidad+"' "+orden;
			
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
	
	
}
