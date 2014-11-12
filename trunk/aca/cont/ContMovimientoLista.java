package aca.cont;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class ContMovimientoLista {
	public ArrayList<ContMovimiento> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ContMovimiento> lisContMovimiento 	= new ArrayList<ContMovimiento>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT EJERCICIO_ID,LIBRO_ID,POLIZA_ID,NUM_MOVTO,FECHA,DESCRIPCION,IMPORTE," +
					"ESTADO,REFERENCIA,MAYOR_ID,CCOSTO_ID,AUXILIAR_ID," +
					"TIPO_CTA,NATURALEZA FROM CONT_MOVIMIENTO "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContMovimiento mov = new ContMovimiento();
				mov.mapeaReg(rs);
				lisContMovimiento.add(mov);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContMovimientoLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	
		
		return lisContMovimiento;
	}
	
	public ArrayList<ContMovimiento> getListPoliza(Connection conn, String ejercicioId, String libroId, String polizaId, String orden ) throws SQLException{
		ArrayList<ContMovimiento> lisContMovimiento 	= new ArrayList<ContMovimiento>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT EJERCICIO_ID, LIBRO_ID, POLIZA_ID, NUM_MOVTO, FECHA, DESCRIPCION, TO_CHAR(IMPORTE, '9999999.00') AS IMPORTE," +
					" ESTADO, REFERENCIA, MAYOR_ID, CCOSTO_ID, AUXILIAR_ID," +
					" TIPO_CTA, NATURALEZA" +
					" FROM CONT_MOVIMIENTO" +
					" WHERE EJERCICIO_ID = '"+ejercicioId+"'" +
					" AND LIBRO_ID = "+libroId+
					" AND POLIZA_ID = '"+polizaId+"' "+orden;	
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContMovimiento mov = new ContMovimiento();
				mov.mapeaReg(rs);
				lisContMovimiento.add(mov);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContMovimientoLista|getListPoliza|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}		
		
		return lisContMovimiento;
	}
}
