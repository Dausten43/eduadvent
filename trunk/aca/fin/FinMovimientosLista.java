package aca.fin;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

import aca.alumno.AlumPersonal;

public class FinMovimientosLista {
	
	
	public ArrayList<FinMovimientos> getMovimientosAlumno(Connection conn, String auxiliar, String orden ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA,"
					+ " RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE AUXILIAR = '"+auxiliar+"' AND CUENTA_ID IN (SELECT CUENTA_ID FROM FIN_CUENTA) "
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE AUXILIAR IN ("+auxiliares+") AND CUENTA_ID IN (SELECT CUENTA_ID FROM FIN_CUENTA)"
					+ " AND ESTADO = 'R'  " + orden;
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID "
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
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
	
	public ArrayList<FinMovimientos> getAllMovimientosPoliza(Connection conn,  String condiciones ) throws SQLException{
		ArrayList<FinMovimientos> list			= new ArrayList<FinMovimientos>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = " SELECT EJERCICIO_ID, POLIZA_ID, MOVIMIENTO_ID, CUENTA_ID, AUXILIAR, DESCRIPCION, "
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
					+ " FROM FIN_MOVIMIENTOS "
					+ " WHERE EJERCICIO_ID is not null " + condiciones ;
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA,'DD/MM/YYYY HH24:MI:SS') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
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
					  " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"+
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
					  " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"+
					  " FROM FIN_MOVIMIENTOS" +
					  " WHERE AUXILIAR = '"+auxiliar+"' AND date(FECHA) <= to_date('"+fechaFinal+"', 'dd/mm/yyyy') AND date(FECHA) >= to_date('"+fechaInicio+"', 'dd/mm/yyyy') "+orden;
			
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
					+ " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"
					+ " FROM FIN_MOVIMIENTOS"
					+ " WHERE AUXILIAR = '"+auxiliar+"' AND CUENTA_ID IN (SELECT CUENTA_ID FROM FIN_CUENTA)"
					+ " AND date(FECHA) <= '"+fechaFinal+"' AND date(FECHA) >= '"+fechaInicio+"'"
					+ " AND ESTADO IN ("+ estado +" ) " + orden;
			System.out.println(comando);
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
	
	public ArrayList<AlumPersonal> getListDeudores(Connection conn, String cicloId, String escuelaId, String orden ) throws SQLException{
		ArrayList<AlumPersonal> list	= new ArrayList<AlumPersonal>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{
			comando = "SELECT CODIGO_ID, ESCUELA_ID, NOMBRE, APATERNO, AMATERNO, GENERO, CURP, TO_CHAR(F_NACIMIENTO,'DD/MM/YYYY') AS F_NACIMIENTO,"
					+ " PAIS_ID, ESTADO_ID, CIUDAD_ID, CLASFIN_ID, EMAIL, COLONIA, DIRECCION, TELEFONO, COTEJADO, ALUM_NIVEL_HISTORICO(CODIGO_ID, '"+cicloId+"', 1 ) AS NIVEL_ID,"
					+ " ALUM_GRADO_HISTORICO( CODIGO_ID, '"+cicloId+"', 1 ) AS GRADO, ALUM_GRUPO_HISTORICO( CODIGO_ID, '"+cicloId+"', 1 ) AS GRUPO,"
					+ " ESTADO, ACTA, CRIP, RELIGION, TRANSPORTE, CELULAR, TUTOR, MATRICULA, DISCAPACIDAD, ENFERMEDAD, CORREO, IGLESIA, TIPO_SANGRE, TUTOR_CEDULA, BARRIO_ID"
					+ " FROM ALUM_PERSONAL "
					+ " WHERE ESCUELA_ID = '"+escuelaId+"'"
					+ " AND CODIGO_ID IN (SELECT CODIGO_ID FROM ALUM_CICLO  WHERE CICLO_ID = '"+cicloId+"')"
					+ " AND CODIGO_ID IN (SELECT AUXILIAR AS CODIGO_ID FROM FIN_MOVIMIENTOS WHERE SUBSTRING (AUXILIAR,1,3) = '"+escuelaId+"'"
					+ " GROUP BY AUXILIAR having sum(CASE NATURALEZA WHEN 'C' THEN IMPORTE*1 ELSE IMPORTE*-1 END) < 0)"+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				AlumPersonal alumno = new AlumPersonal();
				alumno.mapeaReg(rs);
				list.add(alumno);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientoLista|getListDeudores|:"+ex);
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
	
	public HashMap<String,String> getMapSaldosFecha(Connection conn, String escuelaId, String fecha) throws SQLException{
		
		HashMap<String,String> map = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";

		try{//se cambio el query 
			comando = "  SELECT alum_personal.codigo_id, alum_personal.escuela_id, alum_personal.nivel_id, "
					+ "alum_personal.grado, alum_personal.grupo, "
					+ "( SELECT COALESCE(sum("
					+ "		CASE fin_movimientos.naturaleza "
					+ "		WHEN 'C' THEN fin_movimientos.importe * (-1) "
					+ "		ELSE fin_movimientos.importe * 1 END), 0) AS \"coalesce\" "
					+ "FROM fin_movimientos           "
					+ "WHERE fin_movimientos.auxiliar = alum_personal.codigo_id AND fin_movimientos.estado <> 'C' "
					+ "AND (fin_movimientos.cuenta_id IN ( SELECT fin_cuenta.cuenta_id                    "
					+ "FROM fin_cuenta                  "
					+ " WHERE fin_cuenta.cuenta_aislada = 'N')) and fecha::date <= to_date('"+fecha+"','dd-mm-yyyy') ) AS saldo    FROM alum_personal where escuela_id='"+escuelaId+"'  ";
			//System.out.println(comando);
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("codigo_id"), rs.getString("SALDO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovmientosLista|getMapSaldos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,String> getMapSaldos(Connection conn, String escuelaId) throws SQLException{
		
		HashMap<String,String> map = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";

		try{//se cambio el query 
			comando = "SELECT codigo_id, escuela_id, nivel_id, grado, grupo, saldo " +
					" FROM alumno_saldo WHERE escuela_id = '"+escuelaId+"' ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("codigo_id"), rs.getString("SALDO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovmientosLista|getMapSaldos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
public HashMap<String,FinSaldoAlumno> getMapSaldosCta(Connection conn, String cuenta, String escuela, String fechai, String fechaf) throws SQLException{
		
		HashMap<String,FinSaldoAlumno> map = new HashMap<String,FinSaldoAlumno>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";

		try{//se cambio el query 
			comando = "select auxiliar, ap.nombre, ap.apaterno, ap.amaterno,"
					+ "sum(	"
					+ "case mv.naturaleza 	"
					+ "when 'C' then mv.importe*(1)  "
					+ "else mv.importe*(-1) "
					+ "end) saldo "
					+ "from fin_movimientos mv "
					+ "join alum_personal ap on ap.codigo_id=mv.auxiliar "
					+ "where mv.ejercicio_id like '"+escuela+"%' and mv.estado <> 'C' and mv.cuenta_id='"+cuenta+"'  and fecha::date between to_date('"+fechai+"','dd-mm-yyyy')  and to_date('"+fechaf+"','dd-mm-yyyy')"
					+ "group by mv.auxiliar,ap.nombre, ap.apaterno, ap.amaterno";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				
				FinSaldoAlumno sa = new FinSaldoAlumno();
				sa.setAuxiliar(rs.getString("auxiliar"));
				sa.setNombre(rs.getString("nombre"));
				sa.setApaterno(rs.getString("apaterno"));
				sa.setAmaterno(rs.getString("amaterno"));
				sa.setSaldo(rs.getBigDecimal("saldo"));
				
				map.put(rs.getString("auxiliar"), sa);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovmientosLista|getMapSaldos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	

public HashMap<String,FinSaldoAlumno> getMapSaldosCtaAbono(Connection conn, String cuenta, String escuela) throws SQLException{
	
	HashMap<String,FinSaldoAlumno> map = new HashMap<String,FinSaldoAlumno>();
	Statement st 				= conn.createStatement();
	ResultSet rs 				= null;
	String comando				= "";

	try{//se cambio el query 
		comando = "select auxiliar, ap.nombre, ap.apaterno, ap.amaterno,"
				+ "sum(	"
				+ "case mv.naturaleza 	"
				+ "when 'C' then mv.importe*(1)  "
				+ "else mv.importe*(-1) "
				+ "end) saldo "
				+ "from fin_movimientos mv "
				+ "join alum_personal ap on ap.codigo_id=mv.auxiliar "
				+ "where mv.ejercicio_id like '"+escuela+"%' and mv.estado <> 'C' and mv.cuenta_id='"+cuenta+"' "
				+ "group by mv.auxiliar,ap.nombre, ap.apaterno, ap.amaterno";
		
		rs = st.executeQuery(comando);
		while (rs.next()){				
			
			FinSaldoAlumno sa = new FinSaldoAlumno();
			sa.setAuxiliar(rs.getString("auxiliar"));
			sa.setNombre(rs.getString("nombre"));
			sa.setApaterno(rs.getString("apaterno"));
			sa.setAmaterno(rs.getString("amaterno"));
			sa.setSaldo(rs.getBigDecimal("saldo"));
			
			map.put(rs.getString("auxiliar"), sa);
		}
		
	}catch(Exception ex){
		System.out.println("Error - aca.fin.FinMovmientosLista|getMapSaldos|:"+ex);
	}finally{
		if (rs!=null) rs.close();
		if (st!=null) st.close();
	}
	
	return map;
}
	
	public HashMap<String,String> getMapSaldosAlumDeudores(Connection conn, String codigoId) throws SQLException{
		
		HashMap<String,String> map = new HashMap<String,String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";

		try{
			comando = "	SELECT AUXILIAR, SUM(CASE NATURALEZA WHEN 'C' THEN IMPORTE*1 ELSE IMPORTE*-1 END) AS SALDO "
					+ " FROM FIN_MOVIMIENTOS WHERE SUBSTRING (AUXILIAR,1,3) = '"+codigoId+"' GROUP BY AUXILIAR"
					+ " HAVING SUM(CASE NATURALEZA WHEN 'C' THEN IMPORTE*1 ELSE IMPORTE*-1 END) < 0 ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				map.put(rs.getString("AUXILIAR"), rs.getString("SALDO"));
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovmientosLista|getMapSaldosAlumDeudores|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	
	public static HashMap<String, String> saldoPolizasPorCuentas( Connection conn, String escuela, String estado, 
			String tipo, String fechaIni, String fechaFin, String naturaleza, String tipoMov) throws SQLException{
		
		Statement st			= conn.createStatement();
		ResultSet rs 			= null;
		String comando 			= "";
		HashMap<String,String> map 	= new HashMap<String,String>();
		
		try{
			comando = "SELECT CUENTA_ID, COALESCE(SUM(IMPORTE),0) AS SALDO FROM FIN_MOVIMIENTOS"
					+ " WHERE EJERCICIO_ID || '-' ||POLIZA_ID  IN "
					+ " 	(SELECT EJERCICIO_ID || '-' ||POLIZA_ID  FROM FIN_POLIZA WHERE SUBSTR(POLIZA_ID,1,3) = '"+escuela+"' AND ESTADO IN ("+estado+") AND TIPO IN ("+tipo+") "
					+ "		AND FECHA BETWEEN TO_DATE('"+fechaIni+"','DD/MM/YYYY') AND TO_DATE('"+fechaFin+"','DD/MM/YYYY'))"
					+ " AND NATURALEZA = '"+naturaleza+"'"
					+ " AND ESTADO = '"+tipoMov+"'"
					+ " GROUP BY CUENTA_ID";	
			//System.out.println(comando);
			rs= st.executeQuery(comando);		
			while(rs.next()){
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
					  " IMPORTE, NATURALEZA, REFERENCIA, ESTADO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, RECIBO_ID, CICLO_ID, PERIODO_ID, TIPOMOV_ID"+
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
	
	/* SALDO DE UNA POLIZA */
	public static HashMap<String, String> saldoEnPolizas( Connection conn, String escuela, String estado, String tipo, String fechaIni, String fechaFin, String naturaleza, String tipoMov) throws SQLException{
		
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
					+ " AND ESTADO = '"+tipoMov+"'"
					+ " GROUP BY CUENTA_ID";		
			rs= st.executeQuery(comando);		
			while(rs.next()){
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
	
}
