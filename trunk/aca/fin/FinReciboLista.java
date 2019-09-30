/**
 * 
 */
package aca.fin;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

/**
 * @author elifo
 *
 */
public class FinReciboLista {	
	
	public ArrayList<FinRecibo> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<FinRecibo> lisFinRecibo 	= new ArrayList<FinRecibo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CLIENTE, RECIBO_ID, EJERCICIO_ID, IMPORTE, FECHA," +
                    " DOMICILIO, CHEQUE, BANCO, OBSERVACIONES, USUARIO, RFC, TIPO, ESTADO, TIPOPAGO" +
					" FROM FIN_RECIBO "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinRecibo fr = new FinRecibo();				
				fr.mapeaReg(rs);
				lisFinRecibo.add(fr);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinReciboLista|getListClientes|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinRecibo;
	}
	
	public ArrayList<FinRecibo> getRecibosSolicitandoCancelacion(Connection conn, String ejercicioId, String orden ) throws SQLException{
		ArrayList<FinRecibo> lisFinRecibo 	= new ArrayList<FinRecibo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CLIENTE, RECIBO_ID, EJERCICIO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, DOMICILIO, CHEQUE, BANCO," +
					" OBSERVACIONES, USUARIO, RFC, TIPO, ESTADO, TIPOPAGO"
					+ " FROM FIN_RECIBO "
					+ " WHERE EJERCICIO_ID = '"+ejercicioId+"' "
					+ " AND ESTADO = 'S' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinRecibo fr = new FinRecibo();				
				fr.mapeaReg(rs);
				lisFinRecibo.add(fr);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinReciboLista|getListPoliza|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinRecibo;
	}
	
	public ArrayList<FinRecibo> getListPoliza(Connection conn, String polizaId, String ejercicioId, String orden ) throws SQLException{
		ArrayList<FinRecibo> lisFinRecibo 	= new ArrayList<FinRecibo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CLIENTE, RECIBO_ID, EJERCICIO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, DOMICILIO, CHEQUE, BANCO," +
					" OBSERVACIONES, USUARIO, RFC, TIPO, ESTADO, TIPOPAGO"
					+ " FROM FIN_RECIBO "
					+ " WHERE RECIBO_ID IN( SELECT RECIBO_ID FROM FIN_MOVIMIENTOS WHERE POLIZA_ID = '"+polizaId+"' AND EJERCICIO_ID = '"+ejercicioId+"') AND EJERCICIO_ID = '"+ejercicioId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinRecibo fr = new FinRecibo();				
				fr.mapeaReg(rs);
				lisFinRecibo.add(fr);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinReciboLista|getListPoliza|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisFinRecibo;
	}
	
	public ArrayList<FinRecibo> getListRecibos(Connection conn, String usuario, String tipo, String fecha, String orden ) throws SQLException{
		ArrayList<FinRecibo> lisFinRecibo 	= new ArrayList<FinRecibo>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CLIENTE, RECIBO_ID, EJERCICIO_ID, IMPORTE, TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA, DOMICILIO, CHEQUE, BANCO," +
					" OBSERVACIONES, USUARIO, RFC, TIPO, ESTADO, TIPOPAGO" +
					" FROM FIN_RECIBO" +
					" WHERE USUARIO = '"+usuario+"'" +
					" AND TIPO = '"+tipo+"'" +
					" AND FECHA = TO_DATE('"+fecha+"','DD/MM/YYYY') "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				FinRecibo fr = new FinRecibo();		
				fr.mapeaReg(rs);
				lisFinRecibo.add(fr);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.fin.FinReciboLista|getListRecibos|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisFinRecibo;
	}
	
	
}
