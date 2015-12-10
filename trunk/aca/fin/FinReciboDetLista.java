package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinReciboDetLista {	
	
	public ArrayList<FinReciboDet> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<FinReciboDet> lisRecibodet 	= new ArrayList<FinReciboDet>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT RECIBO_ID,FOLIO, CODIGO_ID, NOMBRE, CONCEPTO, IMPORTE FROM FIN_RECIBODET "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinReciboDet recibo = new FinReciboDet();				
				recibo.mapeaReg(rs);
				lisRecibodet.add(recibo);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.Finanzas.FinReciboDet|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisRecibodet;
	}
	
	public ArrayList<FinReciboDet> getListRecibo(Connection conn, String reciboId, String orden ) throws SQLException{
		ArrayList<FinReciboDet> lisRecibodet 	= new ArrayList<FinReciboDet>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT RECIBO_ID, FOLIO, CODIGO_ID, NOMBRE, CONCEPTO, IMPORTE FROM FIN_RECIBODET WHERE RECIBO_ID = TO_NUMBER('"+reciboId+"', '9999999') "+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinReciboDet recibo = new FinReciboDet();	
				recibo.mapeaReg(rs);
				lisRecibodet.add(recibo);		
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.Finanzas.FinReciboDet|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisRecibodet;
	}
	
	
}