package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author Jose Torres
 *
 */
public class FinCalculoPagoLista {
	
	public ArrayList<FinCalculoPago> getListPagosTodos(Connection conn, String cicloId, String periodoId, String orden ) throws SQLException{
		ArrayList<FinCalculoPago> lisCalculo 	= new ArrayList<FinCalculoPago>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, CUENTA_ID, BECA" +
					" FROM FIN_CALCULO_PAGO" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = '"+periodoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCalculoPago fcp = new FinCalculoPago();				
				fcp.mapeaReg(rs);
				lisCalculo.add(fcp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListPagosTodos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}
	
	public ArrayList<FinCalculoPago> getListPagosAlumno(Connection conn, String cicloId, String periodoId, String codigoId, String orden ) throws SQLException{
		ArrayList<FinCalculoPago> lisCalculo 	= new ArrayList<FinCalculoPago>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, CUENTA_ID, BECA" +
					" FROM FIN_CALCULO_PAGO" +
					" WHERE CICLO_ID = '"+cicloId+"'" +
					" AND PERIODO_ID = '"+periodoId+"' " +
					" AND CODIGO_ID = '"+codigoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCalculoPago fcp = new FinCalculoPago();				
				fcp.mapeaReg(rs);
				lisCalculo.add(fcp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListPagosAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}
	
	public ArrayList<FinCalculoPago> getListPagosAlumnoCuentas(Connection conn, String cicloId, String periodoId, String codigoId, String orden ) throws SQLException{
		ArrayList<FinCalculoPago> lisCalculo 	= new ArrayList<FinCalculoPago>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, SUM(IMPORTE) AS IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, COUNT(CUENTA_ID) AS CUENTA_ID, SUM(BECA) AS BECA "
					+ " FROM FIN_CALCULO_PAGO"
					+ " WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND PERIODO_ID = '"+periodoId+"'"
					+ " AND CODIGO_ID = '"+codigoId+"'"
					+ " GROUP BY CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, FECHA, ESTADO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCalculoPago fcp = new FinCalculoPago();				
				fcp.mapeaReg(rs);
				lisCalculo.add(fcp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|getListPagosAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}
	
	/*
	public HashMap<String,String> mapCantidadPagos(Connection conn, String cicloId, String periodoId) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT CODIGO_ID, COUNT(*) AS CANTIDAD FROM FIN_CALCULO_PAGO A "
        			+ " WHERE CICLO_ID = '"+cicloId+"' "
        			+ " AND PERIODO_ID = '"+periodoId+"' "
        			+ " AND ESTADO = 'A' " // Que no se hayan tomado en cuenta en alguna poliza (que no hayan sido Contabilizado)
        			+ " AND ( SELECT INSCRITO FROM FIN_CALCULO WHERE CICLO_ID = A.CICLO_ID AND PERIODO_ID = A.PERIODO_ID AND CODIGO_ID = A.CODIGO_ID ) = 'P' "
        			+ " GROUP BY CODIGO_ID ";
			
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("CODIGO_ID"), rs.getString("CANTIDAD"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCalculoPagoLista|mapaEmpleados|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}*/
}
