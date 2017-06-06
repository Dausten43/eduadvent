package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.TreeMap;
import java.util.HashMap;

public class FinPolizaLista {
	
	public ArrayList<FinPoliza> getPolizas(Connection conn, String ejercicioId, String orden) throws SQLException{
		ArrayList<FinPoliza> lisPoliza 	= new ArrayList<FinPoliza>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, POLIZA_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, FECHA AS FECHASYS, DESCRIPCION, USUARIO, ESTADO, TIPO "
					+ " FROM FIN_POLIZA "
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinPoliza folio = new FinPoliza();
				folio.mapeaReg(rs);
				lisPoliza.add(folio);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPolizaLista|getPolizas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return lisPoliza;
	}
	
	/* Lista de polizas */
	public ArrayList<FinPoliza> getPolizas(Connection conn, String ejercicioId, String escuelaId, String estadoPoliza, String tipoPoliza, String fechaIni, String fechaFin, String orden) throws SQLException{
		ArrayList<FinPoliza> lisPoliza 	= new ArrayList<FinPoliza>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, POLIZA_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION, USUARIO, ESTADO, TIPO"
					+ " FROM FIN_POLIZA"
					+ " WHERE SUBSTR(POLIZA_ID,1,3) = '"+escuelaId+"'"
					+ " AND ESTADO IN ("+estadoPoliza+")"
					+ " AND TIPO IN ("+tipoPoliza+")"
					+ " AND FECHA BETWEEN TO_DATE('"+fechaIni+"','DD/MM/YYYY') AND TO_DATE('"+fechaFin+"','DD/MM/YYYY') "+ orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinPoliza poliza = new FinPoliza();
				poliza.mapeaReg(rs);
				lisPoliza.add(poliza);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPolizaLista|getPolizas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return lisPoliza;
	}
	
	/* Lista de polizas en una escuela */
	public ArrayList<FinPoliza> getPolizasEscuela(Connection conn, String escuelaId, String orden) throws SQLException{
		ArrayList<FinPoliza> lisPoliza 	= new ArrayList<FinPoliza>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, POLIZA_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION, USUARIO, ESTADO, TIPO "
					+ " FROM FIN_POLIZA "
					+ " WHERE SUBSTR(EJERCICIO_ID, 1, 3) = '"+escuelaId+"' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinPoliza folio = new FinPoliza();
				folio.mapeaReg(rs);
				lisPoliza.add(folio);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPolizaLista|getPolizasEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return lisPoliza;
	}
	
	public ArrayList<FinPoliza> getPolizaPorUsuarioDeIngreso(Connection conn, String usuario, String ejercicioId, String orden) throws SQLException{
		ArrayList<FinPoliza> lisPoliza 	= new ArrayList<FinPoliza>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, POLIZA_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION, FECHA AS FECHASYS, USUARIO, ESTADO, TIPO "
					+ " FROM FIN_POLIZA "
					+ " WHERE USUARIO = '"+usuario+"' "
					+ " AND EJERCICIO_ID = '"+ejercicioId+"' AND TIPO = 'I' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinPoliza folio = new FinPoliza();
				folio.mapeaReg(rs);
				lisPoliza.add(folio);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPolizaLista|getPolizaPorUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return lisPoliza;
	}
	
	
	public ArrayList<FinPoliza> getPolizaPorUsuarioDeCaja(Connection conn, String usuario, String ejercicioId, String orden) throws SQLException{
		ArrayList<FinPoliza> lisPoliza 	= new ArrayList<FinPoliza>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, POLIZA_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, FECHA AS FECHASYS, DESCRIPCION, USUARIO, ESTADO, TIPO "
					+ " FROM FIN_POLIZA "
					+ " WHERE USUARIO = '"+usuario+"' "
					+ " AND EJERCICIO_ID = '"+ejercicioId+"' AND TIPO = 'C' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinPoliza folio = new FinPoliza();
				folio.mapeaReg(rs);
				lisPoliza.add(folio);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPolizaLista|getPolizaPorUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return lisPoliza;
	}
	
	public ArrayList<FinPoliza> getPolizaPorUsuarioGenerales(Connection conn, String usuario, String ejercicioId, String orden) throws SQLException{
		ArrayList<FinPoliza> lisPoliza 	= new ArrayList<FinPoliza>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, POLIZA_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, FECHA AS FECHASYS, DESCRIPCION, USUARIO, ESTADO, TIPO "
					+ " FROM FIN_POLIZA "
					+ " WHERE USUARIO = '"+usuario+"' "
					+ " AND EJERCICIO_ID = '"+ejercicioId+"' AND TIPO = 'G' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinPoliza folio = new FinPoliza();
				folio.mapeaReg(rs);
				lisPoliza.add(folio);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPolizaLista|getPolizaPorUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return lisPoliza;
	}
	
	public TreeMap<String, FinPoliza> getHashPolizaPorUsuario(Connection conn, String usuario, String orden) throws SQLException{
		TreeMap<String, FinPoliza> lisPoliza = new TreeMap<String, FinPoliza>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT * FROM FIN_POLIZA WHERE USUARIO = '"+usuario+"' "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinPoliza poliza = new FinPoliza();
				poliza.mapeaReg(rs);
				lisPoliza.put(poliza.getPolizaId(), poliza);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinPolizaLista|getHashPolizaPorUsuario|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return lisPoliza;
	}
	
	
	public static HashMap<String, String> getCantidadPolizasAsociacion(Connection conn) throws SQLException{
		HashMap<String, String> map 	= new HashMap<String, String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{			
			comando = " SELECT ASOCIACION_ESCUELA(SUBSTR(POLIZA_ID, 1, 3)) AS ASOCIACION, TIPO, ESTADO, COUNT(POLIZA_ID) AS CANTIDAD"
					+ " FROM FIN_POLIZA"
					+ " GROUP BY ASOCIACION, TIPO, ESTADO ";
			
			rs = st.executeQuery(comando);
			
			while (rs.next()){
				map.put( rs.getString("ASOCIACION")+"-"+rs.getString("TIPO")+"-"+rs.getString("ESTADO"), rs.getString("CANTIDAD") );
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinPolizaLista|getCantidadPolizas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return map;
	}
	
	public HashMap<String, FinPoliza> getPolizasAsociacion(Connection conn, String asociaciones) throws SQLException{
		HashMap<String, FinPoliza> map 	= new HashMap<String, FinPoliza>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{			
			comando = " SELECT *"
					+ " FROM FIN_POLIZA"
					+ " WHERE ASOCIACION_ESCUELA(SUBSTR(POLIZA_ID, 1, 3)) IN ("+asociaciones+") ";
			
			rs = st.executeQuery(comando);
			
			while (rs.next()){
				FinPoliza poliza = new FinPoliza();
				poliza.mapeaReg(rs);
				map.put(poliza.getEjercicioId()+"@@"+poliza.getPolizaId(), poliza);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinPolizaLista|getPolizasAsociacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return map;
	}
	
	public static HashMap<String, String> getCantidadPolizasEscuela(Connection conn) throws SQLException{
		HashMap<String, String> map 	= new HashMap<String, String>();
		Statement st 					= conn.createStatement();
		ResultSet rs 					= null;
		String comando					= "";
		
		try{			
			comando = " SELECT SUBSTR(POLIZA_ID, 1, 3) AS ESCUELA, TIPO, ESTADO, COUNT(POLIZA_ID) AS CANTIDAD"
					+ " FROM FIN_POLIZA"
					+ " GROUP BY ESCUELA, TIPO, ESTADO ";
			
			rs = st.executeQuery(comando);
			
			while (rs.next()){
				map.put( rs.getString("ESCUELA")+"-"+rs.getString("TIPO")+"-"+rs.getString("ESTADO"), rs.getString("CANTIDAD") );
			}
		}catch(Exception ex){
			System.out.println("Error - aca.catalogo.FinPolizaLista|getCantidadPolizasEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return map;
	}
	
	
	public ArrayList<FinPoliza> getPolizasDescarga(Connection conn, String descargaId, String orden) throws SQLException{
		ArrayList<FinPoliza> lisPoliza 	= new ArrayList<FinPoliza>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{			
			comando = "SELECT EJERCICIO_ID, POLIZA_ID, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION, USUARIO, ESTADO, TIPO "
					+ " FROM FIN_POLIZA "
					+ " WHERE DESCARGA_ID = TO_NUMBER('"+descargaId+"', '9999') "+orden;
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinPoliza folio = new FinPoliza();
				folio.mapeaReg(rs);
				lisPoliza.add(folio);
			}
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinPolizaLista|getPolizasDescarga|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		return lisPoliza;
	}
	
	/**/
	public static HashMap<String, String> saldoPolizasPorCuentas( Connection conn, String escuela, String estado, String tipo, String fechaIni, String fechaFin, String naturaleza, String tipoMov) throws SQLException{
		
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