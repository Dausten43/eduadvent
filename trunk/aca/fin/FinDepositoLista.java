package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class FinDepositoLista {	
	
	public ArrayList<FinDeposito> getListAll(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<FinDeposito> lisRecibodet 	= new ArrayList<FinDeposito>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT ESCUELA_ID,FOLIO, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, TO_CHAR(FECHA_DEPOSITO,'DD/MM/YYYY') AS FECHA_DEPOSITO, IMPORTE, RESPONSABLE FROM FIN_DEPOSITO "
					+ "WHERE ESCUELA_ID="+escuelaId+orden;			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinDeposito recibo = new FinDeposito();				
				recibo.mapeaReg(rs);
				lisRecibodet.add(recibo);			
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.Finanzas.FinDeposito|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisRecibodet;
	}
	
	public ArrayList<FinDeposito> getListEntre(Connection conn, String fechaInicio, String fechaFinal, String escuelaId ) throws SQLException{
		ArrayList<FinDeposito> lisRecibodet 	= new ArrayList<FinDeposito>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = " SELECT ESCUELA_ID, FOLIO, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, TO_CHAR(FECHA_DEPOSITO,'DD/MM/YYYY') AS FECHA_DEPOSITO, IMPORTE, RESPONSABLE FROM FIN_DEPOSITO"
					+ " WHERE ESCUELA_ID ='"+escuelaId+"'"
					+ " AND FECHA_DEPOSITO BETWEEN TO_DATE('"+fechaInicio+"','DD/MM/YYYY') AND TO_DATE('"+fechaFinal+"','DD/MM/YYYY')";			
			rs = st.executeQuery(comando);			
			while (rs.next()){			
				FinDeposito recibo = new FinDeposito();	
				recibo.mapeaReg(rs);
				lisRecibodet.add(recibo);		
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.Finanzas.FinDeposito|getListEntre|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisRecibodet;
	}
	
	
}