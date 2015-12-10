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
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') "+orden;
			
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
	
	public ArrayList<FinCalculoPago> getListPagos(Connection conn, String cicloId, String periodoId, String pagoId, String estados, String orden ) throws SQLException{
		ArrayList<FinCalculoPago> lisCalculo 	= new ArrayList<FinCalculoPago>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, CUENTA_ID, BECA, PAGADO"
					+ " FROM FIN_CALCULO_PAGO"
					+ " WHERE CICLO_ID = '"+cicloId+"'"
					+ " AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')"
					+ " AND PAGO_ID = TO_NUMBER('"+pagoId+"', '99')"
					+ "	AND ESTADO IN ("+estados+") "+orden;
			
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
					" AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99') " +
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
	
	public ArrayList<FinCalculoPago> listPagosAlumnoPorFecha(Connection conn,String codigoId, String fecha, String orden ) throws SQLException{
		ArrayList<FinCalculoPago> lisCalculo 	= new ArrayList<FinCalculoPago>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, CUENTA_ID, BECA, PAGADO" +
					" FROM FIN_CALCULO_PAGO" +
					" WHERE CODIGO_ID = '"+codigoId+"'" +
					" AND FECHA = TO_DATE('"+fecha+"','YYYY/MM/DD') "+ orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCalculoPago fcp = new FinCalculoPago();				
				fcp.mapeaReg(rs);
				lisCalculo.add(fcp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|listPagosAlumnoPorFecha|:"+ex);
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
					+ " AND PERIODO_ID = TO_NUMBER('"+periodoId+"', '99')"
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
	 * Lista detallada de pagos pendientes
	 * */
	public ArrayList<FinCalculoPago> lisPagos(Connection conn, String codigoId, String pagado, String estado, String orden ) throws SQLException{
		ArrayList<FinCalculoPago> lisCalculo 	= new ArrayList<FinCalculoPago>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CICLO_ID, PERIODO_ID, CODIGO_ID, PAGO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, ESTADO, CUENTA_ID AS CUENTA_ID, BECA, PAGADO"
					+ " FROM FIN_CALCULO_PAGO"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " AND IMPORTE > 0"
					+ " AND PAGADO IN("+pagado+")"
					+ " AND ESTADO IN ("+estado+") "+orden;
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				FinCalculoPago fcp = new FinCalculoPago();				
				fcp.mapeaReg(rs);
				lisCalculo.add(fcp);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCostoLista|lisPagos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisCalculo;
	}
	
	/*
	 * Lista de Fechas de pagos
	 * */
	public ArrayList<String> lisFechasPagos(Connection conn, String codigoId, String pagado, String estado ) throws SQLException{
		ArrayList<String> lista 	= new ArrayList<String>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT DISTINCT(TO_CHAR(FECHA,'YYYY/MM/DD')) AS FECHA FROM FIN_CALCULO_PAGO"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " AND PAGADO IN ("+pagado+")"
					+ " AND ESTADO IN ("+estado+")"							
					+ " AND IMPORTE > 0"
					+ " ORDER BY TO_CHAR(FECHA,'YYYY/MM/DD')";
			
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
	
	
	public HashMap<String,String> mapPagoFecha(Connection conn, String codigoId, String pagado ) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = " SELECT TO_CHAR(FECHA,'YYYY/MM/DD') AS FECHA, SUM (IMPORTE-BECA) AS PAGO FROM FIN_CALCULO_PAGO"
					+ " WHERE CODIGO_ID = '"+codigoId+"'"
					+ " AND PAGADO IN("+pagado+")"
					+ " GROUP BY TO_CHAR(FECHA,'YYYY/MM/DD')";
			
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
	
	public HashMap<String,String> mapNivelPago(Connection conn, String escuelaId, String fechaInicio, String fechaFinal ) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = " SELECT AC.NIVEL AS NIVEL, SUM(FCP.IMPORTE) AS TOTAL FROM FIN_CALCULO_PAGO AS FCP, ALUM_CICLO AS AC"
					+ " WHERE SUBSTR( FCP.CICLO_ID,1,3) = '"+escuelaId+"' AND FCP.FECHA BETWEEN TO_DATE('"+fechaInicio+"','DD/MM/YYYY') AND TO_DATE('"+fechaFinal+"','DD/MM/YYYY')"
					+ " AND AC.CICLO_ID = FCP.CICLO_ID"
					+ " AND AC.CODIGO_ID = FCP.CODIGO_ID"
					+ " AND AC.PERIODO_ID = FCP.PERIODO_ID"
					+ " GROUP BY AC.NIVEL";
			
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				map.put(rs.getString("NIVEL"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCalculoPagoLista|mapNivelPago|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> mapNivelPagoCaja(Connection conn, String escuelaId, String fechaInicio, String fechaFinal, String tipoMovimiento ) throws SQLException{
		
		HashMap<String,String> map 	= new HashMap<String,String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";		
		
		try{
			comando = "SELECT AC.NIVEL AS NIVEL, SUM(FM.IMPORTE) FROM FIN_MOVIMIENTOS AS FM, ALUM_CICLO AS AC" 
					+ " WHERE  SUBSTR( FM.CICLO_ID,1,3) = '"+escuelaId+"' AND FM.FECHA BETWEEN TO_DATE('"+fechaInicio+"','DD/MM/YYYY') AND TO_DATE('"+fechaInicio+"','DD/MM/YYYY')"
					+ " AND AC.CICLO_ID = FM.CICLO_ID"
					+ " AND AC.CODIGO_ID = FM.AUXILIAR"
					+ " AND AC.PERIODO_ID = FM.PERIODO_ID"
					+ " AND NATURALEZA = '"+tipoMovimiento+"'"
					+ " GROUP BY AC.NIVEL";
			
			
			rs = st.executeQuery(comando);
			while (rs.next()){
				map.put(rs.getString("NIVEL"), rs.getString("TOTAL"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCalculoPagoLista|mapNivelPago|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}



}
