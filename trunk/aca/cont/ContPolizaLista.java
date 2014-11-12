package aca.cont;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class ContPolizaLista {
	public ArrayList<ContPoliza> getListAll(Connection conn, String orden ) throws SQLException{
		ArrayList<ContPoliza> lisContPoliza 	= new ArrayList<ContPoliza>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT EJERCICIO_ID,POLIZA_ID,LIBRO_ID,CCOSTO_ID,TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA," +
					"DESCRIPCION,ESTADO,US_ALTA,US_REVISION FROM CONT_POLIZA "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContPoliza poliza = new ContPoliza();				
				poliza.mapeaReg(rs);
				lisContPoliza.add(poliza);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContPolizaLista|getListAll|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lisContPoliza;
	}
	
	public ArrayList<ContPoliza> getListEjercicioLibroCcosto(Connection conn, String ejercicioId, String libroId, String ccostoId, String orden ) throws SQLException{
		ArrayList<ContPoliza> lisContPoliza 	= new ArrayList<ContPoliza>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT EJERCICIO_ID, POLIZA_ID, LIBRO_ID, CCOSTO_ID," +
					" TO_CHAR(FECHA,'DD/MM/YYYY') AS FECHA," +
					" DESCRIPCION, ESTADO, US_ALTA, US_REVISION" +
					" FROM CONT_POLIZA" +
					" WHERE EJERCICIO_ID = '"+ejercicioId+"'" +
					" AND LIBRO_ID = "+libroId+"" +
					" AND CCOSTO_ID = '"+ccostoId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				ContPoliza poliza = new ContPoliza();				
				poliza.mapeaReg(rs);
				lisContPoliza.add(poliza);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.cont.ContPolizaLista|getListEjercicioLibroCcosto|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}

		return lisContPoliza;
	}
}
