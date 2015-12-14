/**
 * 
 */
package aca.financiero.copy;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * @author elifo
 *
 */
public class FinPagoLista {
	public ArrayList<FinPago> getListCicloPeriodo(Connection conn, String cicloId, String periodoId, String orden ) throws SQLException{
		ArrayList<FinPago> lisFinPago 	= new ArrayList<FinPago>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT PAGO_ID, CICLO_ID, PERIODO_ID," +
					" TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION" +
					" FROM FIN_PAGO" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinPago fp = new FinPago();				
				fp.mapeaReg(rs);
				lisFinPago.add(fp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.financiero.FinPagoLista|getListCicloPeriodo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinPago;
	}
}
