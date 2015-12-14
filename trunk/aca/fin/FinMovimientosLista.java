package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class FinMovimientosLista {
	
	
	public ArrayList<FinMovimientos> getMovimientosAlumno(Connection conn, String auxiliar, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE AUXILIAR = '"+auxiliar+"' AND CUENTA_ID IN (SELECT CUENTA_ID FROM FIN_CUENTA WHERE TIPO LIKE '%-ALUMNO%') "
					+ " AND ESTADO = 'R' " + orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();				
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getMovimientosAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<FinMovimientos> getMovimientosHijos(Connection conn, String auxiliares, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID "
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE AUXILIAR IN ("+auxiliares+") AND CUENTA_ID IN (SELECT CUENTA_ID FROM FIN_CUENTA WHERE TIPO LIKE '%-ALUMNO%')"
					+ " AND ESTADO = 'R' " + orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();				
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getMovimientosHijos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}

	public ArrayList<FinMovimientos> getMovimientos(Connection conn, String ejercicioId, String polizaId, String reciboId, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID "
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"' "
					+ " AND POLIZA_ID = '"+polizaId+"'"
					+ " AND RECIBO_ID = TO_NUMBER('"+reciboId+"', '9999999') "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getMovimientos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<FinMovimientos> getMovimientosRecibo(Connection conn, String ejercicioId, String reciboId, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"' "
					+ " AND RECIBO_ID = TO_NUMBER('"+reciboId+"', '9999999') "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();				
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getMovimientosRecibo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<FinMovimientos> getMovimientosAsociaciones(Connection conn, String asociaciones, String tipoPoliza, String naturaleza, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION,"
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE ESTADO IN ('R') " /* QUE EL ESTADO SEA 'RECIBO', OSEA QUE NO SEA CREADO O CANCELADO */
					+ " AND NATURALEZA = '"+naturaleza+"' "
					+ " AND (SELECT ESTADO FROM FIN_POLIZA WHERE POLIZA_ID = FIN_MOVIMIENTOS.POLIZA_ID AND EJERCICIO_ID = FIN_MOVIMIENTOS.EJERCICIO_ID) = 'T' "
					+ " AND (SELECT TIPO FROM FIN_POLIZA WHERE POLIZA_ID = FIN_MOVIMIENTOS.POLIZA_ID AND EJERCICIO_ID = FIN_MOVIMIENTOS.EJERCICIO_ID) = '"+tipoPoliza+"' "
					+ " AND ASOCIACION_ESCUELA(SUBSTR(POLIZA_ID, 1, 3)) IN ("+asociaciones+") "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();				
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getMovimientosAsociaciones|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<FinMovimientos> getMovimientosPoliza(Connection conn, String ejercicioId, String polizaId, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"' "
					+ " AND POLIZA_ID = '"+polizaId+"'"
					+ " AND ESTADO NOT IN ('A') AND NATURALEZA = 'C' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();				
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getMovimientos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<FinMovimientos> getAllMovimientosPolizaEstado(Connection conn, String ejercicioId, String polizaId, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"' "
					+ " AND POLIZA_ID = '"+polizaId+"'"
					+ " AND ESTADO NOT IN ('A') "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();				
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getAllMovimientosPolizaEstado|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<FinMovimientos> getAllMovimientosPolizaEstadoEscuela(Connection conn, String escuelaId, String polizaId, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE SUBSTR(EJERCICIO_ID, 1, 3) = '"+escuelaId+"' "
					+ " AND POLIZA_ID = '"+polizaId+"'"
					+ " AND ESTADO NOT IN ('A') "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();				
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getAllMovimientosPolizaEstadoEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<FinMovimientos> getMovimientosPolizaIngreso(Connection conn, String ejercicioId, String polizaId, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"' "
					+ " AND POLIZA_ID = '"+polizaId+"'"
					+ " AND NATURALEZA = 'D' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();				
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getMovimientos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<FinMovimientos> getMovimientosPolizaIngresoAll(Connection conn, String ejercicioId, String polizaId, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"' "
					+ " AND POLIZA_ID = '"+polizaId+"'"
					+ " "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();				
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getMovimientos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<FinMovimientos> getAllMovimientosPoliza(Connection conn, String ejercicioId, String polizaId, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"' "
					+ " AND POLIZA_ID = '"+polizaId+"' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();				
				fm.mapeaReg(rs);
				list.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getMovimientos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return list;
	}
	
	public ArrayList<FinMovimientos> getListAlumno(Connection conn, String auxiliar,String ejercicioId, String fechaInicio, String fechaFinal, String orden ) throws SQLException{
		ArrayList<FinMovimientos> lisFinMovimientos	= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION," +
					  " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"+
					  " FROM FIN_MOVIMIENTOS" +
					  " WHERE AUXILIAR = '"+auxiliar+"' AND EJERCICIO_ID = '"+ejercicioId+"' AND FECHA <= '"+fechaFinal+"' AND FECHA >= '"+fechaInicio+"' "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();
				fm.mapeaReg(rs);
				lisFinMovimientos.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getListAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinMovimientos;
	}
	
	
	public ArrayList<FinMovimientos> getListAlumnoAll(Connection conn, String auxiliar, String fechaInicio, String fechaFinal, String orden ) throws SQLException{
		ArrayList<FinMovimientos> lisFinMovimientos	= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION," +
					  " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"+
					  " FROM FIN_MOVIMIENTOS" +
					  " WHERE AUXILIAR = '"+auxiliar+"' AND FECHA <= '"+fechaFinal+"' AND FECHA >= '"+fechaInicio+"' "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();
				fm.mapeaReg(rs);
				lisFinMovimientos.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getListAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinMovimientos;
	}
	
	public ArrayList<FinMovimientos> getListAlumnoAll(Connection conn, String auxiliar, String fechaInicio, String fechaFinal, String estado, String orden ) throws SQLException{
		ArrayList<FinMovimientos> lisFinMovimientos	= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION,"
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"
					+ " FROM FIN_MOVIMIENTOS"
					+ " WHERE AUXILIAR = '"+auxiliar+"'"
					+ " AND FECHA <= '"+fechaFinal+"' AND FECHA >= '"+fechaInicio+"'"
					+ " AND ESTADO IN ("+ estado +" ) " + orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();
				fm.mapeaReg(rs);
				lisFinMovimientos.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getListAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinMovimientos;
	}
	
	public ArrayList<String> getListCuentas(Connection conn, String polizaId, String ejercicioId, String orden ) throws SQLException{
		ArrayList<String> list		= new ArrayList<String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = " SELECT DISTINCT(CUENTA_ID) AS CUENTA_ID FROM FIN_MOVIMIENTOS"
					+ " WHERE POLIZA_ID = '"+polizaId+"'  AND EJERCICIO_ID = '"+ejercicioId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				list.add(rs.getString("CUENTA_ID"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientoLista|getListCuentas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return list;
	}
	
	public HashMap<String,String> getMapSaldos(Connection conn, String ejercicioId, String codigoId) throws SQLException{
		
		HashMap<String,String> map = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";

		try{
			comando = "	SELECT AUXILIAR, SUM(CASE NATURALEZA WHEN 'C' THEN IMPORTE*1 ELSE IMPORTE*-1 END) AS SALDO" +
					  " FROM FIN_MOVIMIENTOS WHERE EJERCICIO_ID = '"+ejercicioId+"' " +
					  " AND SUBSTRING (AUXILIAR,1,3) = '"+codigoId+"' GROUP BY AUXILIAR";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("AUXILIAR"), rs.getString("SALDO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovmientosLista|getMapSaldos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public static HashMap<String, String> saldoPolizasPorCuentas( Connection conn, String escuela, String estado, String tipo,  String fechaIni, String fechaFin, String naturaleza ) throws SQLException{
		
		Statement st			= conn.createStatement();
		ResultSet rs 			= null;
		String comando 			= "";
		HashMap<String,String> map 	= new HashMap<String,String>();
		
		try{
			comando = "SELECT CUENTA_ID, COALESCE(SUM(IMPORTE),0) AS SALDO FROM FIN_MOVIMIENTOS"
					+ " WHERE POLIZA_ID IN "
					+ " 	(SELECT POLIZA_ID FROM FIN_POLIZA WHERE SUBSTR(POLIZA_ID,1,3) = '"+escuela+"' AND ESTADO IN ("+estado+") AND TIPO IN ("+tipo+") "
					+ "		AND FECHA BETWEEN TO_DATE('"+fechaIni+"','DD/MM/YYYY') AND TO_DATE('"+fechaFin+"','DD/MM/YYYY'))"
					+ " AND NATURALEZA = '"+naturaleza+"'"
					+ " GROUP BY CUENTA_ID";		
			rs= st.executeQuery(comando);		
			if(rs.next()){
				map.put(rs.getString("CUENTA_ID"), rs.getString("SALDO"));
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientoLista|saldoPolizasPorCuentas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public ArrayList<FinMovimientos> getMovimientosBecaFecha(Connection conn, String ejercicioId, String fechaInicio, String fechaFinal, String orden ) throws SQLException{
		ArrayList<FinMovimientos> lisFinMovimientos	= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION," +
					  " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID"+
					  " FROM FIN_MOVIMIENTOS" +
					  " WHERE EJERCICIO_ID = '"+ejercicioId+"' AND FECHA <= '"+fechaFinal+"' AND FECHA >= '"+fechaInicio+"' "+orden;
			rs = st.executeQuery(comando);
			while (rs.next()){
				FinMovimientos fm = new FinMovimientos();
				fm.mapeaReg(rs);
				lisFinMovimientos.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientosLista|getMovimientosBecaFecha|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinMovimientos;
	}
	
}
