// Clase para la tabla de AlumPersonal
package aca.cond;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class CondTipoReporteLista{
		
	public ArrayList<CondTipoReporte> getListEscuela(Connection Conn, String escuelaId, String orden) throws SQLException{
		
		ArrayList<CondTipoReporte> lisCond 	= new ArrayList<CondTipoReporte>();
		Statement st 		= Conn.createStatement();
		ResultSet rs 		= null;
		String comando	= "";
		
		try{
			comando = "SELECT TIPO_ID, TIPO_NOMBRE, COMENTARIO, ESCUELA_ID" +
					" FROM COND_TIPOREPORTE" +
					" WHERE ESCUELA_ID = '"+escuelaId+"' "+orden;		
			rs = st.executeQuery(comando);
			while (rs.next()){
				
				CondTipoReporte conducta = new CondTipoReporte();
				conducta.mapeaReg(rs);
				lisCond.add(conducta);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cond.CondTipoReporteLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisCond;
	}	
}



