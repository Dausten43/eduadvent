package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

public class FinCuentaLista {
	
	public ArrayList<FinCuenta> getListCuentas(Connection conn, String escuelaId, String order) throws SQLException{
		ArrayList<FinCuenta> lisFinCuenta 	= new ArrayList<FinCuenta>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ESCUELA_ID, CUENTA_ID, CUENTA_NOMBRE, CUENTA_SUNPLUS, BECA," +
					" COALESCE(TIPO,'-') AS TIPO, PAGO_INICIAL, MUESTRA_SALDO_RECIBO, CUENTA_AISLADA " +
					" FROM FIN_CUENTA WHERE ESCUELA_ID = '"+escuelaId+"' "+order;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCuenta fc = new FinCuenta();				
				fc.mapeaReg(rs);
				lisFinCuenta.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCuentaLista|getListCuentas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinCuenta;
	}
	
	public ArrayList<FinCuenta> getListBecas(Connection conn, String escuelaId, String order) throws SQLException{
		ArrayList<FinCuenta> lisFinCuenta 	= new ArrayList<FinCuenta>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ESCUELA_ID, CUENTA_ID, CUENTA_NOMBRE, CUENTA_SUNPLUS, BECA," +
					" COALESCE(TIPO,'-') AS TIPO, PAGO_INICIAL, MUESTRA_SALDO_RECIBO, CUENTA_AISLADA " +
					" FROM FIN_CUENTA WHERE ESCUELA_ID = '"+escuelaId+"' AND BECA = 'S' "+order;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCuenta fc = new FinCuenta();				
				fc.mapeaReg(rs);
				lisFinCuenta.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCuentaLista|getListBecas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinCuenta;
	}
	
	public ArrayList<FinCuenta> getListCuentasPorTipo(Connection conn, String escuelaId, String tipo, String order) throws SQLException{
		ArrayList<FinCuenta> lisFinCuenta 	= new ArrayList<FinCuenta>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT ESCUELA_ID, CUENTA_ID, CUENTA_NOMBRE, CUENTA_SUNPLUS, BECA," +
					" COALESCE(TIPO,'-') AS TIPO, PAGO_INICIAL, MUESTRA_SALDO_RECIBO, CUENTA_AISLADA" +
					" FROM FIN_CUENTA" +
					" WHERE ESCUELA_ID = '"+escuelaId+"'" +
					" AND TIPO LIKE '%"+tipo+"%' "+order;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinCuenta fc = new FinCuenta();				
				fc.mapeaReg(rs);
				lisFinCuenta.add(fc);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCuentaLista|getListCuentas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinCuenta;
	}
	
	public HashMap<String,FinCuenta> mapCuentasEscuela(Connection conn, String escuelaId) throws SQLException{
		
		HashMap<String,FinCuenta> map = new HashMap<String,FinCuenta>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT ESCUELA_ID, CUENTA_ID, CUENTA_NOMBRE, CUENTA_SUNPLUS, BECA," +
					" COALESCE(TIPO,'-') AS TIPO, PAGO_INICIAL, MUESTRA_SALDO_RECIBO, CUENTA_AISLADA" +
					" FROM FIN_CUENTA WHERE ESCUELA_ID = '"+escuelaId+"'";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				FinCuenta obj = new FinCuenta();
				obj.mapeaReg(rs);
				llave = obj.getCuentaId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCuentaLista|mapCuentasEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}
	
	public HashMap<String,FinCuenta> mapCuentasAsociacion(Connection conn, String asociaciones) throws SQLException{
		
		HashMap<String,FinCuenta> map = new HashMap<String,FinCuenta>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		String llave				= "";
		
		try{
			comando = "SELECT ESCUELA_ID, CUENTA_ID, CUENTA_NOMBRE, CUENTA_SUNPLUS, BECA," +
					" COALESCE(TIPO,'-') AS TIPO, PAGO_INICIAL, MUESTRA_SALDO_RECIBO, CUENTA_AISLADA" +
					" FROM FIN_CUENTA WHERE ASOCIACION_ESCUELA(ESCUELA_ID) IN ("+asociaciones+") ";
			
			rs = st.executeQuery(comando);
			while (rs.next()){				
				FinCuenta obj = new FinCuenta();
				obj.mapeaReg(rs);
				llave = obj.getCuentaId();
				map.put(llave, obj);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinCuentaLista|mapCuentasAsociacion|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return map;
	}

}
