//Clase  para la tabla Ciclo_Promedio
package aca.ciclo;

import java.sql.*;
import java.util.ArrayList;

public class CicloPromedioLista {
	
	public ArrayList<CicloPromedio> getListEscuela(Connection conn, String escuelaId, String orden ) throws SQLException{
		ArrayList<CicloPromedio> lista 	= new ArrayList<CicloPromedio>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PROMEDIO_ID, NOMBRE, CORTO, CALCULO, ORDEN, DECIMALES, VALOR, REDONDEO" +
					"FROM CICLO_PROMEDIO " +
					"WHERE SUBSTR(CICLO_ID,1,3)= '"+escuelaId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloPromedio ciclo = new CicloPromedio();				
				ciclo.mapeaReg(rs);
				lista.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloPromedioLista|getListEscuela|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}
		
		return lista;
	}
	
	public ArrayList<CicloPromedio> getListCiclo(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloPromedio> lista 	= new ArrayList<CicloPromedio>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = " SELECT CICLO_ID, PROMEDIO_ID, NOMBRE, CORTO, CALCULO, ORDEN, DECIMALES, VALOR, REDONDEO"
					+ " FROM CICLO_PROMEDIO"
					+ " WHERE CICLO_ID = '"+cicloId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloPromedio ciclo = new CicloPromedio();
				ciclo.mapeaReg(rs);
				lista.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloPromedioLista|getListCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	

		return lista;
	}
	
	public ArrayList<CicloPromedio> getListPromedioCiclo(Connection conn, String cicloId, String orden ) throws SQLException{
		ArrayList<CicloPromedio> lista 	= new ArrayList<CicloPromedio>();
		Statement st 	= conn.createStatement();
		ResultSet rs 	= null;
		String comando	= "";
		
		try{
			comando = "SELECT CICLO_ID, PROMEDIO_ID, NOMBRE, CORTO, CALCULO, ORDEN, DECIMALES, VALOR, REDONDEO"
					+ " FROM CICLO_PROMEDIO"
					+ " WHERE CICLO_ID = '"+cicloId+"' "+orden;
			
			rs = st.executeQuery(comando);			
			while (rs.next()){
				
				CicloPromedio ciclo = new CicloPromedio();				
				ciclo.mapeaReg(rs);
				lista.add(ciclo);
			}
			
		}catch(Exception ex){
			System.out.println("Error - aca.ciclo.cicloPromedioLista|getListPromedioCiclo|:"+ex);
		}finally{
			if (rs!=null) rs.close();
			if (st!=null) st.close();
		}	

		return lista;
	}
	
}