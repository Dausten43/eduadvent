/**
 * 
 */
package aca.fin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author elifo
 *
 */
public class FinMovimientoLista {
	public ArrayList<FinMovimiento> getListAlumno(Connection conn, String codigoId, String orden ) throws SQLException{
		ArrayList<FinMovimiento> lisFinMovimiento	= new ArrayList<FinMovimiento>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT CODIGO_ID, FOLIO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION," +
				" IMPORTE, NATURALEZA, REFERENCIA" +
				" FROM FIN_MOVIMIENTO" +
				" WHERE CODIGO_ID = '"+codigoId+"' "+orden;

			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimiento fm = new FinMovimiento();				
				fm.mapeaReg(rs);
				lisFinMovimiento.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientoLista|getListAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinMovimiento;
	}
	
	public ArrayList<FinMovimiento> getListAlumno(Connection conn, String codigoId, String fecha, String orden ) throws SQLException{
		ArrayList<FinMovimiento> lisFinMovimiento	= new ArrayList<FinMovimiento>();
		Statement st 							= conn.createStatement();
		ResultSet rs 							= null;
		String comando							= "";
		
		try{
			comando = "SELECT CODIGO_ID, FOLIO, TO_CHAR(FECHA, 'DD/MM/YYYY') AS FECHA, DESCRIPCION," +
				" IMPORTE, NATURALEZA, REFERENCIA" +
				" FROM FIN_MOVIMIENTO" +
				" WHERE CODIGO_ID = '"+codigoId+"' " +
				" AND FECHA <= TO_DATE('"+fecha+"','DD/MM/YYYY') "+orden;

			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimiento fm = new FinMovimiento();				
				fm.mapeaReg(rs);
				lisFinMovimiento.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientoLista|getListAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinMovimiento;
	}
	
	public ArrayList<String> getListCuentas(Connection conn, String polizaId, String orden ) throws SQLException{
		ArrayList<String> list		= new ArrayList<String>();
		Statement st 				= conn.createStatement();
		ResultSet rs 				= null;
		String comando				= "";
		
		try{
			comando = " SELECT DISTINCT(CUENTA_ID) AS CUENTA_ID FROM FIN_MOVIMIENTOS"
					+ " WHERE POLIZA_ID = '"+polizaId+"' "+orden;
			
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
	
	public static HashMap<String, String> saldoPolizasPorCuentas( Connection conn, String escuela,  String estado, String tipo, String fechaIni, String fechaFin, String naturaleza ) throws SQLException{
		
		PreparedStatement ps	= null;
		ResultSet rs 			= null;		
		HashMap<String,String> map 	= new HashMap<String,String>();
		
		try{
			ps = conn.prepareStatement("SELECT CUENTA_ID, SUM(IMPORTE) AS SALDO FROM FIN_MOVIMIENTOS"
				+ " WHERE POLIZA_ID IN "
				+ " 	(SELECT POLIZA_ID FROM FIN_POLIZA WHERE SUBSTR(POLIZA_ID,1,3) = ? AND ESTADO IN (?) AND TIPO IN (?) "
				+ "		AND FECHA BETWEEN TO_DATE('"+fechaIni+"','DD/MM/YYYY') AND TO_DATE('"+fechaFin+"','DD/MM/YYYY'))"
				+ " AND NATURALEZA = ?"
				+ " GROUP BY CUENTA_ID");
			
			ps.setString(1, escuela);
			ps.setString(2, estado);
			ps.setString(3, tipo);
			ps.setString(4, fechaIni);
			ps.setString(5, fechaFin);
			ps.setString(6, naturaleza);
			
			rs= ps.executeQuery();		
			if(rs.next()){
				map.put(rs.getString("CUENTA_ID"), rs.getString("SALDO"));
			}			
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinMovimientoLista|saldoPolizasPorCuentas|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (ps!=null) ps.close();
		}
		
		return map;
	}
}
