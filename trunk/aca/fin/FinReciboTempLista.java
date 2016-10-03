package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class FinReciboTempLista {

	public ArrayList<aca.fin.FinReciboTemp> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<aca.fin.FinReciboTemp> lisFinReciboTemp 	= new ArrayList<aca.fin.FinReciboTemp>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT RECIBO_ID, FECHA, CLIENTE, CUENTA_ID, AUXILIAR, DESCRIPCION, IMPORTE, REFERENCIA," +
                    " ESCUELA_ID, FOLIO, FORMA_PAGO, FORMA_PAGO, BENEFICIARIO" +
					" FROM FIN_RECIBO_TEMP WHERE ESCUELA_ID='"+escuelaId+"'"+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinReciboTemp frt = new FinReciboTemp();				
				frt.mapeaReg(rs);
				lisFinReciboTemp.add(frt);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinReciboTempLista|getListClientes|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinReciboTemp;
	}
}
