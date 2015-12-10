package aca.financiero.copy;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinCalculoDetLista {
	
	public ArrayList<FinCalculoDet> getListCalDet(Connection conn, String cicloId, String periodoId, String codigoId, String orden ) throws SQLException{
		ArrayList<FinCalculoDet> lisCalculoDet 	= new ArrayList<FinCalculoDet>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, CUENTA_ID, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, IMPORTE, BECA" +
					" FROM FIN_CALCULO_DET" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')" +
					" AND CODIGO_ID = '"+codigoId+"' "+orden;			
			rs = st.executeQuery(comando);
			while (rs.next()){
				FinCalculoDet fc = new FinCalculoDet();
				fc.mapeaReg(rs);
				lisCalculoDet.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.financiero.FinCostoLista|getListCalDet|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculoDet;
	}	
}
