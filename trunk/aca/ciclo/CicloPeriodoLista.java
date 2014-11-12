/**
 * 
 */
package aca.ciclo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * @author elifo
 *
 */
public class CicloPeriodoLista {
	public ArrayList<CicloPeriodo> getListCiclo(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloPeriodo> lisCicloPeriodo 	= new ArrayList<CicloPeriodo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PERIODO_ID, PERIODO_NOMBRE," +
					" TO_CHAR(F_INICIO,'DD/MM/YYYY') AS F_INICIO," +
					" TO_CHAR(F_FINAL,'DD/MM/YYYY') AS F_FINAL" +
					" FROM CICLO_PERIODO" +
					" WHERE CICLO_ID = '"+cicloId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				CicloPeriodo cp = new CicloPeriodo();				
				cp.mapeaReg(rs);
				lisCicloPeriodo.add(cp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloPeriodoLista|getListCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCicloPeriodo;
	}
}
