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
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, CUENTA_ID, BECA, PAGADO" +
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
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, CUENTA_ID, BECA, PAGADO" +
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
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, SUM(IMPORTE) AS IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, COUNT(CUENTA_ID) AS CUENTA_ID, SUM(BECA) AS BECA, PAGADO "
					+ " FROM FIN_CALCULO_PAGO"
					+ " WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND PERIODO_ID = '"+periodoId+"'"
					+ " AND CODIGO_ID = '"+codigoId+"'"
					+ " GROUP BY CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, FECHA, ESTADO, PAGADO "+orden;
			
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
	 * Lista de pagos pendientes
	 * */
	public ArrayList<FinCalculoPago> listPagosPendientes(Connection conn, String codigoId, String orden ) throws SQLException{
		ArrayList<FinCalculoPago> lisCalculo 	= new ArrayList<FinCalculoPago>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, SUM(IMPORTE) AS IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, COUNT(CUENTA_ID) AS CUENTA_ID, SUM(BECA) AS BECA, PAGADO"
					+ " FROM FIN_CALCULO_PAGO"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " AND PAGADO = 'N'"
					+ " GROUP BY CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, FECHA, ESTADO, PAGADO "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				FinCalculoPago fcp = new FinCalculoPago();				
				fcp.mapeaReg(rs);
				lisCalculo.add(fcp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|listPagosPendientes|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}
	
	/*
	 * Lista de Fechas de pagos
	 * */
	public ArrayList<String> lisFechasPagos(Connection conn, String codigoId ) throws SQLException{
		ArrayList<String> lista 	= new ArrayList<String>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT DISTINCT(TO_CHAR(FECHA,'YYYY/MM/DD')) AS FECHA FROM FIN_CALCULO_PAGO WHERE CODIGO_ID = '"+codigoId+"' ORDER BY TO_CHAR(FECHA,'YYYY/MM/DD')";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				lista.add(rs.getString("FECHA"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|lisFechasPagos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lista;
	}
	
	
	public HashMap<String,String> mapPagoFecha(Connection conn, String codigoId ) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT TO_CHAR(FECHA,'YYYY/MM/DD') AS FECHA, SUM (IMPORTE-BECA) AS PAGO FROM FIN_CALCULO_PAGO WHERE CODIGO_ID = '"+codigoId+"' GROUP BY TO_CHAR(FECHA,'YYYY/MM/DD')";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("FECHA"), rs.getString("PAGO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCalculoPagoLista|mapPagoFecha|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
}
