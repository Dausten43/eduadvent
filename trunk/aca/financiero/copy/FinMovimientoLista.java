/**
 * 
 */
package aca.financiero.copy;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

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
			//System.out.println("comando:"+comando);
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimiento fm = new FinMovimiento();				
				fm.mapeaReg(rs);
				lisFinMovimiento.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.financiero.FinMovimientoLista|getListAlumno|:"+ex);
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
			//System.out.println("comando:"+comando);
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinMovimiento fm = new FinMovimiento();				
				fm.mapeaReg(rs);
				lisFinMovimiento.add(fm);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.financiero.FinMovimientoLista|getListAlumno|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinMovimiento;
	}
}
